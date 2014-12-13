define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  'cs!threenodes/utils/Utils',
  'cs!threenodes/nodes/views/NodeWithCenterTextfield',
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.views",
    Random: class Random extends ThreeNodes.nodes.views.NodeWithCenterTextfield
      getCenterField: () => @model.fields.getField("out", true)

    LFO: class LFO extends ThreeNodes.nodes.views.NodeWithCenterTextfield
      getCenterField: () => @model.fields.getField("out", true)

    Timer: class Timer extends ThreeNodes.nodes.views.NodeWithCenterTextfield
      getCenterField: () => @model.fields.getField("out", true)

  namespace "ThreeNodes.nodes.models",
    PasswordDialog: class PasswordDialog extends ThreeNodes.NodeBase
      @node_name = 'PasswordDialog'
      @group_name = 'Dialogs'

      initialize: (options) =>
        super
        @auto_evaluate = true

      getFields: =>
        base_fields = super
        fields =
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)


    PromptlsOkay: class PromptlsOkay extends ThreeNodes.NodeBase
      @node_name = 'PromptlsOkay'
      @group_name = 'Dialogs'

      initialize: (options) =>
        super
        @auto_evaluate = true

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", value)


    TextDialog: class TextDialog extends ThreeNodes.NodeBase
      @node_name = 'TextDialog'
      @group_name = 'Dialogs'

      initialize: (options) =>
        super
        @auto_evaluate = true

      getFields: =>
        base_fields = super
        fields =
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", value)
        

    YesNoDialog: class YesNoDialog extends ThreeNodes.NodeBase
      @node_name = 'YesNoDialog'
      @group_name = 'Dialogs'

      initialize: (options) =>
        super
        @auto_evaluate = true

      getFields: =>
        base_fields = super
        fields =
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", value)
        

