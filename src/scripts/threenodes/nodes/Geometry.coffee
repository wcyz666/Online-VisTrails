define [
  'Underscore',
  'Backbone',
  'cs!threenodes/utils/Utils',
  'cs!threenodes/models/Node',
], (_, Backbone, Utils) ->
  #"use strict"

  namespace "ThreeNodes.nodes.models",
    PythonCalc: class PythonCalc extends ThreeNodes.NodeBase
      @node_name = 'PythonCalc'
      @group_name = 'PythonCalc'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val0": "",
            "val1": "",
            "val2": "",
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @value)