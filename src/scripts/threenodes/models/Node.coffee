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

      #j run this node module, which is part of the whole workflow
      run: =>
        @trigger("run")

      #j stop running
      stop: =>
        @trigger("stop")


      #j @return: true if is start node
      isStartNode: =>
        !@fields.hasToFields()

      #j return: [] of nodes to run next
      next: =>
        # local []
        to_nodes = []
        for c in @out_connections
          to_nodes.push c.to_field.node
        return to_nodes





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

      # Compare with @loadFields, this serves as the default value
      getFields: =>
        fields = @loadFields()
        fields

      # **Purpose:** Compare with @getFields, this serves as the passed in options
      #
      # **Description:** If node is loaded from JSON, fields will be set on each node
      # instance, so we can get it. This is dirty, but... a way to
      # walk around the strange design decision of legacy code: the fields
      # are boud to each node and dynamically, created by a method of the
      # node instead of passing as options to the node(we create default
      # collections of fields for this node and call set if we were passed
      # new collections in the options).
      # Be sure to use recursive merge: $.extend(true, dest, src), instead
      # of shallow merge: _.extend(dest, src), if you use this method
      #
      # **The main problem here** is the load and save process are not reversible
      # or symmetrical if you will. They don't load fields from the saved JSON,
      # but generate them dynamically based on the module type. So when the
      # fields and the node type are not directly coupled, problem occurs.
      #
      # **The author also got bitten** by the problem when adding the 'add custom field'
      # feature, which removes the coupling between node type and fields. How to set
      # the user configured input fields values is alse a similar problem to our problem.
      #
      # **How he walked around this:**
      # *For 'add custom fields': he created another attr system, the
      # custom_fields attr, and the save and load process of custom_fields attr are
      # symmetrical/ reversible; the attrs set on the node has the exact same format
      # as the saved data in JSON file. So the toJSON and loadFromJSON process are
      # not complex: no extra transfomration of data needed.
      # And then in the normal fields attr system, he again gets the custome fields
      # from the custom_fields attr system and add all them in the normal fields attr
      # system, hence a lot of repeated work and data, on the node or in local file.
      # *For 'set user configured input fields values from saved file': after all fields
      # are loaded, extract the input values from file, and set them on the already
      # loaded input ports. Since the ports are stored as attrs of obj, getting them would
      # be getting values from a hashtable using key, which is efficient.
      #
      #
      # Since all data we need is already in the file, and we don't want to spend
      # extra space just to store the repeated data in the right format, we then have
      # to do some ETL(extract, transform and load) work. Not the first solutin.
      # For the second solution, it's two passes: one for setting the fields, and one for
      # setting values of fields if they have any. Wouldn't it be better if we can
      # first prepare all data in the right format and set them all in one pass? So our
      # plan is to ETL new data we need and merge them with the fields and still utilze
      # the normal fields loading process. ~~Then we need to change all the getFields
      # function to return the merged fields when needed(when the node has a 'Any'
      # field)~~
      # UPDATE: we don't actually need to change all of the getFields method, since
      # $.extend(true, ...) is used, which does a deep merge, to merge old and new
      # fields, we can actually prepare the fields we need in the super class getFields
      # method. Thanks to the deep merge, the inner attrs of the fields won't be
      # overridden.

      loadFields: ->
        fields = {}
        # if we are loading from saved json file, we would have the
        # fields attr already set
        if @has 'fields'
          options = @get 'fields'
          # fields =
          #   in: [
          #     {
          #       name: 'name'
          #       type: 'type'
          #       val: 'val'
          #     }
          #     {...}
          #   ]
          #   out: [{...}, {...}, {...}]
          # here we only deal with one type: any, and add suppor for
          # other types later if needed

          # filter: only translate field of type 'Any'
          # inputs and outputs are []
          inputs = (port for port in options.in when port.type == 'Any')
          outputs = (port for port in options.out when port.type == 'Any')
          # reduce:
          reduce = (memo, cur) ->
            memo[cur.name] =
              type: cur.type
              val: cur.val
              data: cur.data
              dataset: cur.dataset
              datatype: cur.datatype
            return memo

          if inputs.length > 0
            inputs = _.reduce inputs, reduce, {}
            fields.inputs = inputs
          if outputs.length > 0
            outputs = _.reduce outputs, reduce, {}
            fields.outputs = outputs
        return fields

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


      addCustomField: (name, type, direction = 'inputs', props) =>
        field = {name: name, type: type}
        # Add the field to a variable for saving.
        @custom_fields[direction][name] = field

        value = null
        @fields.addField(name, {type: type, val: value, default: false}, direction, props)

      #j convert to JSON object, not json string
      toJSON: () =>
        res = super
        res.custom_fields = @custom_fields
        return res

      # return JSON info of fields, not real field model
      # 1. default from super node class
      # 2. default from this node
      # 3. custom added fields from this node
      getFields: =>
        base_fields = super
        # to override based on this
        fields = {}
        # merge with custom fields
        fields = $.extend(true, fields, @custom_fields)
        return $.extend(true, base_fields, fields)







