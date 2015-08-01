define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  'cs!threenodes/utils/Utils',
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.models",
    ExtractColumn: class ExtractColumn extends ThreeNodes.NodeBase
      @node_name = 'ExtractColumn'
      @group_name = 'Tabledata'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)


    TableCell: class TableCell extends ThreeNodes.NodeBase
      @node_name = 'TableCell'
      @group_name = 'Tabledata'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val0" : ""
            "val1" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
