define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  #"libs/Three",
  'cs!threenodes/utils/Utils',
  'cs!threenodes/nodes/views/NodeWithCenterTextfield',
  'cs!threenodes/nodes/views/NodeWithCenterTextarea'
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.views",
    CodeBase: class CodeBase extends ThreeNodes.nodes.views.NodeWithCenterTextarea
      getCenterField: () => @model.fields.getField("code")

    PythonSource: class PythonSource extends CodeBase

    MatlabSource: class MatlabSource extends CodeBase

  namespace "ThreeNodes.nodes.models",
    CodeBase: class CodeBase extends ThreeNodes.NodeBase
      @node_name = ''
      @group_name = ''

      initialize: (options) =>
        @custom_fields = {inputs: {}, outputs: {}}
        @loadCustomFields(options)
        # flag for the side bar to render the add_field form
        @add_field= true

        super
        @value = ""

        @onCodeUpdate()
        field = @fields.getField("code")
        field.on "value_updated", @onCodeUpdate

      loadCustomFields: (options) =>
        if !options.custom_fields then return
        @custom_fields = $.extend(true, @custom_fields, options.custom_fields)

      onCodeUpdate: (code = "") =>
        console.log code
        # try
        #   @function = new Function(code)
        # catch error
        #   console.warn error
        #   @function = false

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
        fields =
          inputs:
            "code" : {type: "Code", val:@value}
          outputs:
            "out" : {type: "Any", val:@value}
        # merge with custom fields
        fields = $.extend(true, fields, @custom_fields)
        return $.extend(true, base_fields, fields)

    PythonSource: class PythonSource extends CodeBase
      @node_name = 'PythonSource'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super


    MatlabSource: class MatlabSource extends CodeBase
      @node_name = 'MatlabSource'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super


      