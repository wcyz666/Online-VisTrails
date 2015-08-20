define [
  'Underscore',
  'Backbone',
  'jquery',
  'libs/namespace',
  "cs!threenodes/utils/Utils",
  'cs!threenodes/models/WorkflowState',
  'cs!threenodes/collections/Nodes',
  'cs!threenodes/collections/GroupDefinitions',
  'cs!threenodes/views/UI',
  'cs!threenodes/views/Timeline',
  'cs!threenodes/views/GroupDefinitionView',
  'cs!threenodes/views/Workspace',
  'cs!threenodes/utils/AppWebsocket',
  'cs!threenodes/utils/FileHandler',
  'cs!threenodes/utils/UrlHandler',
  "cs!threenodes/utils/WebglBase",
], (_, Backbone) ->
  #### App

  #"use strict"
  namespace "ThreeNodes",
    App: class App
      constructor: (options) ->
        # Default settings
        settings =
          test: false
          player_mode: false
        @settings = $.extend(settings, options)

        _.extend(@, Backbone.Events)

        @workflowState = new ThreeNodes.WorkflowState()
        # a stack to store super workflow strs
        @superworkflows = []
        # a stack to store the plain JSON representation of subworkflow instance
        @enteredSubworkflows = []

        # Define renderer mouseX/Y for use in utils.Mouse node for instance
        ThreeNodes.renderer =
          mouseX: 0
          mouseY: 0

        # Disable websocket by default since this makes firefox sometimes throw an exception if the server isn't available
        # this makes the soundinput node not working
        websocket_enabled = false

        # Initialize some core classes
        @url_handler = new ThreeNodes.UrlHandler()
        @group_definitions = new ThreeNodes.GroupDefinitions([])
        @nodes = new ThreeNodes.NodesCollection([], {settings: settings})
        @socket = new ThreeNodes.AppWebsocket(websocket_enabled)
        @webgl = new ThreeNodes.WebglBase()
        @file_handler = new ThreeNodes.FileHandler(@, @nodes, @group_definitions)

        # Create a group node when selected nodes are grouped
        @group_definitions.bind "definition:created", @nodes.createGroup

        # When a group definition is removed delete all goup nodes using this definition
        @group_definitions.bind "remove", @nodes.removeGroupsByDefinition

        # Create views if the application is not in test mode
        if @settings.test == false
          # Create group definition views when a new one is created
          @group_definitions.bind "add", (definition) =>
            template = ThreeNodes.GroupDefinitionView.template
            tmpl = _.template(template, definition)
            $tmpl = $(tmpl).appendTo("#library")

            view = new ThreeNodes.GroupDefinitionView
              model: definition
              el: $tmpl
            view.bind "edit", @setWorkspaceFromDefinition
            view.render()

        # File and url events
        @file_handler.on("ClearWorkspace", () => @clearWorkspace())
        @url_handler.on("ClearWorkspace", () => @clearWorkspace())
        @url_handler.on("LoadJSON", @file_handler.loadFromJsonData)

        Backbone.Events.on 'openSubworkflow', @openSubworkflow, @

        # Initialize the user interface and timeline
        @initUI()
        @initTimeline()

        # Initialize the workspace view
        @workspace = new ThreeNodes.Workspace
          el: "#container"
          settings: @settings
        # Make the workspace display the global nodes and connections
        @workspace.render(@nodes)

        # Start the url handling
        #
        # Enabling the pushState method would require to redirect path
        # for the node.js server and github page (if possible)
        # for simplicity we disable it
        Backbone.history.start
          pushState: false

        return true

      openSubworkflow: (subworkflow)->
        # inputNames: [], outputNames: []
        # key is field name
        inputNames = (key for key of subworkflow.fields.inputs)
        outputNames = (key for key of subworkflow.fields.outputs)
        @superworkflows.push @file_handler.getLocalJson(true)
        # @note: here run some risks in using the toJSON() method directly
        @enteredSubworkflows.push subworkflow.toJSON()
        # create a new workflow and drop the old one and related ui
        if subworkflow.get 'implementation'
          @loadNewSceneFromJSONString(subworkflow.get 'implementation')
        else
          @createNewWorkflow(null)
        @ui.showBackButton()
        # create input and output ports
        count = 0
        for inputName in inputNames
          @nodes.createNode({type:'InputPort', x: 3, y: 5 + 50 * count, name: inputName, definition: null, context: null})
          count++
        count = 0
        for outputName in outputNames
          @nodes.createNode({type:'OutputPort', x: 803, y: 5 + 50 * count, name: outputName, definition: null, context: null})
          count++

      setWorkspaceFromDefinition: (definition) =>
        # always remove current edit node if it exists
        if @edit_node
          @edit_node.remove()
          delete @edit_node
          # maybe sync new modifications...

        if definition == "global"
          @workspace.render(@nodes)
          @ui.breadcrumb.reset()
        else
          # create a hidden temporary group node from this definition
          @edit_node = @nodes.createGroup
            type: "Group"
            definition: definition
            x: -9999
          @workspace.render(@edit_node.nodes)
          @ui.breadcrumb.set([definition])

      initUI: () =>
        if @settings.test == false
          # Create the main user interface view
          @ui = new ThreeNodes.UI
            el: $("body")
            settings: @settings
            workflowState: @workflowState


          # Link UI to render events
          @ui.on("render", @nodes.render)
          @ui.on("renderConnections", @nodes.renderAllConnections)

          # Setup the main menu events
          @ui.menubar.on("RemoveSelectedNodes", @nodes.removeSelectedNodes)
          @ui.menubar.on("CreateNewWorkflow", @createNewWorkflow)
          @ui.menubar.on("SaveFile", @file_handler.saveLocalFile)
          @ui.menubar.on("ExportCode", @file_handler.exportCode)
          @ui.menubar.on("LoadJSON", @file_handler.loadFromJsonData)
          @ui.menubar.on("LoadFile", @file_handler.loadLocalFile)
          @ui.menubar.on("ExportImage", @webgl.exportImage)
          @ui.menubar.on("GroupSelectedNodes", @group_definitions.groupSelectedNodes)
          # Added by Gautam
          @ui.menubar.on("Execute", @file_handler.executeAndSave)

          # Special events
          @ui.on("CreateNode", @nodes.createNode)
          @nodes.on("nodeslist:rebuild", @ui.onNodeListRebuild)

          #breadcrumb
          @ui.breadcrumb.on("click", @setWorkspaceFromDefinition)

          @ui.on 'back', @backToSuperworkflow, @


        else
          # If the application is in test mode add a css class to the body
          $("body").addClass "test-mode"


        return this

      backToSuperworkflow: ()->
        # pop from stack the saved superworkflow
        if @superworkflows.length != 0
          cur = @file_handler.getLocalJson(true)
          superworkflow = @superworkflows.pop()
          @loadNewSceneFromJSONString(superworkflow)
          # find the subworkflow module by nid and set the implementation attr
          # @note: the cid will change each time a new model is created.
          enteredSubworkflow = @enteredSubworkflows.pop()
          @nodes.get(enteredSubworkflow.nid).set({implementation: cur})

      loadNewSceneFromJSONString: (wf)->
        @clearWorkspace()
        @file_handler.loadFromJsonData(wf)

      initTimeline: () =>
        # Remove old timeline DOM elements
        $("#timeline-container, #keyEditDialog").remove()

        # Cleanup the old timeline if there was one
        if @timelineView
          @nodes.off("remove", @timelineView.onNodeRemove)
          @timelineView.remove()
          if @ui
            @timelineView.off("TimelineCreated", @ui.onUiWindowResize)

        # Create a new timeline
        @timelineView = new ThreeNodes.AppTimeline
          el: $("#timeline")
          ui: @ui

        # Bind events to it
        @nodes.bindTimelineEvents(@timelineView)
        @nodes.on("remove", @timelineView.onNodeRemove)
        @timelineView.on("runWorkflow", @runWorkflow)
        if @ui then @ui.onUiWindowResize()

        #j this is App, not timelineview, why return this?
        return this

      #j start running the workflow if it is not running,
      # run next node if it is
      runWorkflow: =>
        if !@workflowState.workflow_state
          @startRunningWorkflow()
        else
          @runNext()
        null


      startRunningWorkflow: =>
        # start_nodes: [] of node models
        start_nodes = @nodes.findStartNodesAndMarkReady()
        for node in start_nodes
          node.run()
        @workflowState.workflow_state = true
        @workflowState.running_nodes = start_nodes
        null

      runNext: =>
        # get nodes to run
        nodes_to_run = [].concat @workflowState.waiting_nodes
        @workflowState.waiting_nodes = []
        for node in @workflowState.running_nodes
          # get nodes to run next
          nodes_to_run = nodes_to_run.concat node.next()
          # stop current running
          node.stop()
        @workflowState.running_nodes = []

        # if the end of workflow, change the workflow_state
        if !nodes_to_run.length
          @workflowState.workflow_state = false
        # else continue running
        else
          # run nodes_to_run
          for node in nodes_to_run
            if node.ready
              node.run()
              @workflowState.running_nodes.push node
            else
              @workflowState.waiting_nodes.push node
        null


      # replace old one with the new one, deal with all dependencies
      replaceWorkflowState: (workflowState)->
        @workflowState = workflowState
        # we don't have events on @workflow
        @ui.replaceWorkflowState(@workflowState)


      # create a new workflow or use the provided workflow to replace the old one
      createNewWorkflow: (workflowState)=>
        workflowState = workflowState || new ThreeNodes.WorkflowState()
        @clearWorkspace()
        @replaceWorkflowState(workflowState)
        @setWorkflowContext()

      setWorkflowContext: =>
        @ui.dialogView.openDialog()

      clearWorkspace: () =>
        @nodes.clearWorkspace()
        @group_definitions.removeAll()
        if @ui then @ui.clearWorkspace()
        @initTimeline()

