define [
  'Underscore',
  'Backbone',
  'cs!threenodes/utils/Indexer',
  'cs!threenodes/models/Node',
  'cs!threenodes/nodes/Base',
  'cs!threenodes/nodes/Code',
  'cs!threenodes/nodes/Data',
  'cs!threenodes/nodes/Abstract'
  'cs!threenodes/nodes/Conditional',
  'cs!threenodes/nodes/Geometry',
  'cs!threenodes/nodes/Lights',
  'cs!threenodes/nodes/Materials',
  'cs!threenodes/nodes/Math',
  'cs!threenodes/nodes/PostProcessing',
  'cs!threenodes/nodes/Three',
  'cs!threenodes/nodes/ConstructiveSolidGeometry',
  'cs!threenodes/nodes/Utils',
  'cs!threenodes/nodes/Spread',
  'cs!threenodes/nodes/Particle',
  'cs!threenodes/nodes/Group',
  'cs!threenodes/collections/Connections',
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes",
    NodesCollection: class NodesCollection extends Backbone.Collection

      initialize: (models, options) =>
        @settings = options.settings
        self = this
        # save material nodes in an array so they can be quickly rebuild
        @materials = []

        # Each node collections has it's own indexer, used to get unique id
        @indexer = new ThreeNodes.Indexer()

        # Create the connections collection
        @connections = new ThreeNodes.ConnectionsCollection([], {indexer: @indexer})

        # Parent node, used for groups
        @parent = options.parent

        @connections.bind "add", (connection) ->
          self.trigger "nodeslist:rebuild", self

        @bind "remove", (node) =>
          indx = @materials.indexOf(node)
          if indx != -1
            @materials.splice(indx, 1)
          self.trigger "nodeslist:rebuild", self

        @bind "RebuildAllShaders", () =>
          for node in @materials
            node.rebuildShader()

        @connections.bind "remove", (connection) ->
          self.trigger "nodeslist:rebuild", self

        @bind "add", (node) ->
          if node.is_material && node.is_material == true
            @materials.push(node)

          self.trigger "nodeslist:rebuild", self

        @bind "createConnection", (field1, field2) =>
          @connections.create
            from_field: field1
            to_field: field2

      # @return: [] of start node models
      # mark the nodes as ready to run
      findStartNodesAndMarkReady: ()=>
        startNodes = []
        #j find the first one and stop, for now
        @.each (node)=>
          if node.isStartNode()
            startNodes.push node
            node.ready = true
        startNodes

      clearWorkspace: () =>
        @removeConnections()
        @removeAll()
        $("#webgl-window canvas").remove()
        @materials = []
        @indexer.reset()
        return this

      destroy: () =>
        @removeConnections()
        @removeAll()
        delete @materials
        delete @indexer
        delete @connections

      bindTimelineEvents: (timeline) =>
        if @timeline
          @timeline.off("tfieldsRebuild", @showNodesAnimation)
          @timeline.off("startSound", @startSound)
          @timeline.off("stopSound", @stopSound)

        @timeline = timeline
        @timeline.on("tfieldsRebuild", @showNodesAnimation)
        @timeline.on("startSound", @startSound)
        @timeline.on("stopSound", @stopSound)

      createNode: (options) =>
        # If not is a string instead of an object then take the option as the node type
        if $.type(options) == "string"
          options = {type: options}

        # Save references of the application settings and timeline in the node model
        options.timeline = @timeline
        options.settings = @settings

        # Save a reference of the nodes indexer
        options.indexer = @indexer

        options.parent = @parent

        # Print error if the node type is not found and return false
        if !ThreeNodes.nodes.models[options.type]
          console.error("Node type doesn't exists: " + options.type)
          return false

        # Create the node and pass the options
        n = new ThreeNodes.nodes.models[options.type](options)

        # Add the node to the collection
        @add(n)
        n

      render: () =>
        # Define temporary objects to index the nodes
        invalidNodes = {}
        terminalNodes = {}

        # Flatten the array of nodes.
        # Nodes from groups will appear in the invalidNodes and/or terminalNodes too
        # Get all root nodes and nodes requiring an update
        buildNodeArrays = (nodes) ->
          for node in nodes
            if node.hasOutConnection() == false || node.auto_evaluate || node.delays_output
              terminalNodes[node.attributes["nid"]] = node
            invalidNodes[node.attributes["nid"]] = node
            if node.nodes
              buildNodeArrays(node.nodes.models)
        buildNodeArrays(@models)

        # Update a node and his parents
        evaluateSubGraph = (node) ->
          upstreamNodes = node.getUpstreamNodes()
          for upnode in upstreamNodes
            if invalidNodes[upnode.attributes["nid"]] && !upnode.delays_output
              evaluateSubGraph(upnode)
          if node.dirty || node.auto_evaluate
            node.compute&&node.compute()
            node.dirty = false
            node.fields.setFieldInputUnchanged()

          delete invalidNodes[node.attributes["nid"]]
          true

        # Process all root nodes which require an update
        for nid of terminalNodes
          if invalidNodes[nid]
            evaluateSubGraph(terminalNodes[nid])
        true

      createConnectionFromObject: (connection) =>
        # Get variables from their id
        from_node = @getNodeByNid(connection.from_node.toString())
        from = from_node.fields.outputs[connection.from.toString()]
        to_node = @getNodeByNid(connection.to_node.toString())
        to = to_node.fields.inputs[connection.to.toString()]

        # If a field is missing try to switch from/to
        if !from || !to
          tmp = from_node
          from_node = to_node
          to_node = tmp
          from = from_node.fields.outputs[connection.to.toString()]
          to = to_node.fields.inputs[connection.from.toString()]

        c = @connections.create
            from_field: from
            to_field: to
            cid: connection.id

        c

      createGroup: (model, external_objects = []) =>
        # create the group node
        grp = @createNode(model)

        # Recreate the external connections
        for connection in external_objects
          from = false
          to = false
          if connection.to_subfield
            from = @getNodeByNid(connection.from_node).fields.getField(connection.from, true)
            target_node = @getNodeByNid(connection.to_node)
            if target_node
              to = target_node.fields.getField(connection.to, false)
          else
            target_node = @getNodeByNid(connection.from_node)
            if target_node
              from = target_node.fields.getField(connection.from, true)
            to = @getNodeByNid(connection.to_node).fields.getField(connection.to)

          c = @connections.create
            from_field: from
            to_field: to

        return grp

      removeGroupsByDefinition: (def) =>
        _nodes = @models.concat()
        _.each _nodes, (node) -> if node.definition && node.definition.gid == def.gid then node.remove()

      renderAllConnections: () =>
        @connections.render()

      removeConnection: (c) ->
        @connections.remove(c)

      getNodeByNid: (nid) =>
        for node in @models
          if node.get("nid").toString() == nid.toString()
            return node
          # special case for group
          if node.nodes
            res = node.nodes.getNodeByNid(nid)
            if res then return res

        return false

      showNodesAnimation: () =>
        @invoke "showNodeAnimation"

      startSound: (time) =>
        @each (node) -> if node.playSound instanceof Function then node.playSound(time)

      stopSound: () =>
        @each (node) -> if node.stopSound instanceof Function then node.stopSound()

      removeSelectedNodes: () ->
        for node in $(".node.ui-selected")
          $(node).data("object").remove()

      removeAll: () ->
        $("#tab-attribute").html("")
        models = @models.concat()
        _.invoke models, "remove"
        @reset([])
        true

      removeConnections: () ->
        @connections.removeAll()

