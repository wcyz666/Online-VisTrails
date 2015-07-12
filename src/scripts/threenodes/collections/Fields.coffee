define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Field',
], (_, Backbone) ->
  #"use strict"
  ### Fields Collection ###

  namespace "ThreeNodes",
    FieldsCollection: class FieldsCollection extends Backbone.Collection
      initialize: (models, options) =>
        super
        @node = options.node
        @indexer = options.indexer
        @inputs = {}
        @outputs = {}
        @special_elements = {left: [], center: [], right: []}


        @addFields(@node.getFields())


      # Remove connections, fields and delete variables
      destroy: () =>
        @removeConnections()
        while @models.length > 0
          @models[0].remove()
        delete @node
        delete @inputs
        delete @outputs
        delete @indexer
        delete @special_elements

      # Load saved fields values
      load: (data) =>
        if !data || !data.in
          return false

        for f in data.in
          if !f.nid
            # Simple node field
            node_field = @inputs[f.name]
          else
            # Group node field
            node_field = @inputs[f.name + "-" + f.nid]
          if node_field then node_field.load(f.val)
        true

      toJSON: =>
        data =
          in: jQuery.map(@inputs, (f, i) -> f.toJSON())
          out: jQuery.map(@outputs, (f, i) -> f.toJSON())
        return data

      getField: (key, is_out = false) =>
        target = if is_out == true then "outputs" else "inputs"
        return @[target][key]

      setField: (key, value) =>
        if @outputs[key]
          @outputs[key].setValue(value)

      getMaxInputSliceCount: () =>
        result = 1
        for fname, f of @inputs
          val = f.attributes.value
          if val && $.type(val) == "array"
            if val.length > result
              result = val.length
        # start with 0
        return result - 1

      getUpstreamNodes: () =>
        res = []
        for fname, f of @inputs
          for c in f.connections
            res[res.length] = c.from_field.node
        res

      getDownstreamNodes: () =>
        res = []
        for fname, f in @outputs
          f = @inputs[fname]
          for c in f.connections
            res[res.length] = c.to_field.node
        res

      hasToFields: =>
        @.find (field)=>
          return field.isToField()


      hasUnconnectedInputs: () =>
        for fname, f of @inputs
          if f.connections.length == 0
            return true
        return false

      hasUnconnectedOutputs: () =>
        for fname, f of @outputs
          if f.connections.length == 0
            return true
        return false

      hasUnconnectedFields: () =>
        return hasUnconnectedInputs() || hasUnconnectedOutputs()

      setFieldInputUnchanged: () =>
        for fname in @inputs
          f = @inputs[fname]
          f.changed = false

      renderConnections: =>
        @invoke "renderConnections"

      removeConnections: =>
        @invoke "removeConnections"


      #j props is optional
      addField: (name, value, direction = "inputs", props) =>
        #j out0, {type: "Any", val: 0}, "inputs"
        f = false
        field_is_out = (direction != "inputs")
        #j if primitives: number, string, boolean
        #  change to   Float,  String, Bool
        if $.type(value) != "object"
          value = @getFieldValueObject(value)
        #j declare variable
        field = {}
        #j create field model and add it to the collection
        if ThreeNodes.fields[value.type]
          field = new ThreeNodes.fields[value.type]
            #j pass initial values of attrs, which will be called set on
            name: name
            value: value.val
            # props: props
            possibilities: value.values
            node: @node
            is_output: field_is_out
            default: value.default
            subfield: value.subfield
            indexer: @indexer
          #j props is optional; keep models flat!
          if props then field.set(props)

          target = if field.get("is_output") == false then "inputs" else "outputs"
          field_index = field.get("name")
          if field.subfield
            # In group nodes we want to have a unique field index
            field_index += "-" + field.subfield.node.get("nid")
          #j keep a shallow copy of the fields in this collection
          @[target][field_index] = field
          #j backbone add
          @add(field)


        return field

      addFields: (fields_array) =>
        #j dir is short for directory
        for dir of fields_array
          # dir = inputs / outputs
          for fname of fields_array[dir]
            value = fields_array[dir][fname]
            @addField(fname, value, dir)
        @

      renderSidebar: () =>
        @trigger("renderSidebar")
        @

      getFieldValueObject: (default_value) ->
        ftype = switch $.type(default_value)
          when "number" then "Float"
          when "boolean" then "Bool"
          else "String"
        res =
          type: ftype
          val: default_value
        return res
