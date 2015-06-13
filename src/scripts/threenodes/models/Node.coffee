define [
  'Underscore',
  'Backbone',
  'cs!threenodes/utils/Utils',
  'cs!threenodes/collections/Fields',
], (_, Backbone, Utils) ->
  #"use strict"

  ### Node model ###

  # Common base for all nodes.

  namespace "ThreeNodes",
    NodeBase: class NodeBase extends Backbone.Model
      @node_name = ''
      @group_name = ''

      defaults:
        nid: -1
        x: 0
        y: 0
        name: ""

      initialize: (options) =>
        super

        # Define common node properties defining how the node should be updated
        @auto_evaluate = false
        @delays_output = false
        @dirty = true

        # Define some utility variables, used internally
        @is_animated = false
        # connections starting out from this node
        @out_connections = []

        # Keep reference of some variables
        @apptimeline = options.timeline
        @settings = options.settings
        @indexer = options.indexer
        @options = options

        # Parent node, used to detect if a node is part of a group
        @parent = options.parent

        # Set a default node name if none is provided
        if @get('name') == '' then @set('name', @typename())

        if @get('nid') == -1
          # If this a new node assign a unique id to it
          @set('nid', @indexer.getUID())
        else
          # If the node is loaded set the indexer uid to the node.nid.
          # With this, the following created nodes will have a unique nid
          @indexer.uid = @get('nid')

        # Create the fields collections
        @fields = new ThreeNodes.FieldsCollection(false, {node: this, indexer: @indexer})

        # Call onFieldsCreated so that nodes can alias fields
        @onFieldsCreated()

        # Load saved data after the fields have been set
        @fields.load(@options.fields)

        # Init animation for current fields
        @anim = @createAnimContainer()

        # Load saved animation data if it exists
        if @options.anim != false
          @loadAnimation()

        @showNodeAnimation()
        return this

      # there is a problem though, nodes like code do have input fields, but can be the start
      # should check if the node has field that is the from_field, or the node is a from_node
      # might consider add a is_from_field: boolean to each field model
      isStartNode: =>
        !@fields.hasToFields()
 
      typename: => String(@constructor.name)

      onFieldsCreated: () =>
        # This is where fields can get aliased ex:
        # @v_in = @fields.getField("in")

      # Cleanup the variables and destroy internal anims and fields for garbage collection
      remove: () =>
        if @anim
          @anim.destroy()
        @fields.destroy()
        delete @fields
        delete @apptimeline
        delete @anim
        delete @options
        delete @settings
        delete @indexer

        # todo : remove when @model.postInit is removed in NodeView
        delete @fully_inited

        @destroy()

      # Load the animation from json data
      loadAnimation: () =>
        for propLabel, anims of @options.anim
          track = @anim.getPropertyTrack(propLabel)
          for propKey in anims
            track.keys.push
              time: propKey.time,
              value: propKey.value,
              easing: Timeline.stringToEasingFunction(propKey.easing),
              track: track
          @anim.timeline.rebuildTrackAnimsFromKeys(track)
        true

      createConnection: (field1, field2) =>
        @trigger("createConnection", field1, field2)

      showNodeAnimation: () =>
        @trigger("node:showAnimations")

      addCountInput : () =>
        @fields.addFields
          inputs:
            "count" : 1

      createCacheObject: (values) =>
        res = {}
        for v in values
          field = @fields.getField(v)
          res[v] = if !field then false else field.attributes["value"]
        res

      inputValueHasChanged: (values, cache = @material_cache) =>
        for v in values
          field = @fields.getField(v)
          if !field
            return false
          else
            v2 = field.attributes["value"]
            if v2 != cache[v]
              return true
        false

      getFields: =>
        # to implement
        return {}

      hasOutConnection: () =>
        @out_connections.length != 0

      getUpstreamNodes: () => @fields.getUpstreamNodes()
      getDownstreamNodes: () => @fields.getDownstreamNodes()

      hasPropertyTrackAnim: () =>
        for propTrack in @anim.objectTrack.propertyTracks
          if propTrack.anims.length > 0
            return true
        false

      getAnimationData: () =>
        if !@anim || !@anim.objectTrack || !@anim.objectTrack.propertyTracks || @hasPropertyTrackAnim() == false
          return false
        if @anim != false
          res = {}
          for propTrack in @anim.objectTrack.propertyTracks
            res[propTrack.propertyName] = []
            for anim in propTrack.keys
              k =
                time: anim.time
                value: anim.value
                easing: Timeline.easingFunctionToString(anim.easing)
              res[propTrack.propertyName].push(k)

        res

      toJSON: () =>
        res =
          nid: @get('nid')
          name: @get('name')
          type: @typename()
          anim: @getAnimationData()
          x: @get('x')
          y: @get('y')
          fields: @fields.toJSON()
        #@del
        console.log @constructor
        console.log @out_connections
        res

      applyFieldsToVal: (afields, target, exceptions = [], index) =>
        for f of afields
          nf = afields[f]
          field_name = nf.get("name")
          # Only apply value from fields that are not in the exclude list
          if exceptions.indexOf(field_name) == -1
            # Apply the field's value to the object property
            target[field_name] = @fields.getField(field_name).getValue(index)

      addOutConnection: (c, field) =>
        if @out_connections.indexOf(c) == -1 then @out_connections.push(c)
        c

      removeConnection: (c) =>
        c_index = @out_connections.indexOf(c)
        if c_index != -1
          @out_connections.splice(c_index, 1)
        c

      disablePropertyAnim: (field) =>
        # We only want to animate inputs so we deactivate timeline's animation for outputs fields
        if @anim && field.get("is_output") == false
          @anim.disableProperty(field.get("name"))

      enablePropertyAnim: (field) =>
        # Make sure we don't enable animation on output fields
        if field.get("is_output") == true || !@anim
          return false

        # If the field can be animated enabale property animation
        if field.isAnimationProperty() then @anim.enableProperty(field.get("name"))

      createAnimContainer: () =>
        res = anim("nid-" + @get("nid"), @fields.inputs)
        # enable track animation only for number/boolean
        for f of @fields.inputs
          field = @fields.inputs[f]
          if field.isAnimationProperty() == false then @disablePropertyAnim(field)
        return res

    NodeNumberSimple: class NodeNumberSimple extends NodeBase
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": {type: "Float", val: 0}
          outputs:
            "out": {type: "Float", val: 0}
        return $.extend(true, base_fields, fields)

      onFieldsCreated: () =>
        @v_in = @fields.getField("in")
        @v_out = @fields.getField("out", true)

      process_val: (num, i) => num

      remove: () =>
        delete @v_in
        delete @v_out
        super

      compute: =>
        res = []
        numItems = @fields.getMaxInputSliceCount()
        for i in [0..numItems]
          ref = @v_in.getValue(i)
          switch $.type(ref)
            when "number" then res[i] = @process_val(ref, i)
            when "object"
              switch ref.constructor
              # change the class name from Vector 2
                when THREE.StringConcatenate
                  res[i].x = @process_val(ref.x, i)
                  res[i].y = @process_val(ref.y, i)
                when THREE.Vector3
                  res[i].x = @process_val(ref.x, i)
                  res[i].y = @process_val(ref.y, i)
                  res[i].z = @process_val(ref.z, i)
        @v_out.setValue res
        true

    NodeCustom: class NodeCustom extends NodeBase
      initialize: (options) =>
        @custom_fields = {inputs: {}, outputs: {}}
        @loadCustomFields(options)
        #flag for the sidebar to load the add_field form
        @add_field = true
        super
        @value = ""


      loadCustomFields: (options) =>
        if !options.custom_fields then return
        @custom_fields = $.extend(true, @custom_fields, options.custom_fields)


      addCustomField: (key, type, direction = 'inputs') =>
        field = {key: key, type: type}
        # Add the field to the a variable for saving.
        @custom_fields[direction][key] = field

        value = false
        @fields.addField(key, {value: value, type: type, default: false}, direction)

      toJSON: () =>
        res = super
        res.custom_fields = @custom_fields
        return res

      getFields: =>
        base_fields = super
        # to override based on this
        fields = {}
        # merge with custom fields
        fields = $.extend(true, fields, @custom_fields)
        return $.extend(true, base_fields, fields)





      

