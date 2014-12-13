define [
  'jquery',
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  'cs!threenodes/utils/Utils',
], (jQuery, _, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.models",
    And: class And extends ThreeNodes.NodeBase
      @node_name = 'And'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val1" : false
          outputs:
            "out" : false
        return $.extend(true, base_fields, fields)

	
    CartesianProduct: class CartesianProduct extends ThreeNodes.NodeBase
      @node_name = 'CartesianProduct'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
            "in1": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)


    Cross: class Cross extends ThreeNodes.NodeBase
      @node_name = 'Cross'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
            "in1": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)


    Default: class Default extends ThreeNodes.NodeBase
      @node_name = 'Default'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
            "in1": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)



    Dot: class Dot extends ThreeNodes.NodeBase
      @node_name = 'Dot'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
            "in1": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

    ElementwiseProduct: class ElementwiseProduct extends ThreeNodes.NodeBase
      @node_name = 'ElementwiseProduct'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
            "in1": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

    ExecuteInOrder: class ExecuteInOrder extends ThreeNodes.NodeBase
      @node_name = 'ExecuteInOrder'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
            "in1": ""
        return $.extend(true, base_fields, fields)


    Filter: class Filter extends ThreeNodes.NodeBase
      @node_name = 'Filter'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
            "in1": ""
            "in2": ""
            "in3": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

    For: class For extends ThreeNodes.NodeBase
      @node_name = 'For'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
            "in1": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
    If: class If extends ThreeNodes.NodeBase
      @node_name = 'If'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "condition" : false
            "true" : {type: "Any", val: 1.0}
            "false" : {type: "Any", val: 0.0}
          outputs:
            "out" : {type: "Any", val: false}
        return $.extend(true, base_fields, fields)

      compute: =>
        cond = @fields.getField("condition").getValue()
        if cond == false
          res = @fields.getField("false").attributes.value
        else
          res = @fields.getField("true").attributes.value
        @fields.setField("out", res)
        

    Map: class Map extends ThreeNodes.NodeBase
      @node_name = 'Map'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
            "in1": ""
            "in2": ""
            "in3": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)


    Or: class Or extends ThreeNodes.NodeBase
      @node_name = 'Or'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val" : false
          outputs:
            "out" : false
        return $.extend(true, base_fields, fields)


    Sum: class Sum extends ThreeNodes.NodeBase
      @node_name = 'Sum'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)


    While: class While extends ThreeNodes.NodeBase
      @node_name = 'While'
      @group_name = 'ControlFlow'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val0" : ""
            "val1" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

#    Equal: class Equal extends ThreeNodes.NodeBase
#      @node_name = 'Equal'
#      @group_name = 'ControlFlow'

#      getFields: =>
#        base_fields = super
#        fields =
#          inputs:
#            "val1" : {type: "Any", val: 0.0}
#            "val2" : {type: "Any", val: 1.0}
#          outputs:
#            "out" : false
#        return $.extend(true, base_fields, fields)

#      compute: =>
#        res = @fields.getField("val1").getValue(0) == @fields.getField("val2").getValue(0)
#        @fields.setField("out", res)

#    Smaller: class Smaller extends ThreeNodes.NodeBase
#      @node_name = 'Smaller'
#      @group_name = 'ControlFlow'

#      getFields: =>
#        base_fields = super
#        fields =
#          inputs:
#            "val1" : {type: "Float", val: 0.0}
#            "val2" : {type: "Float", val: 1.0}
#          outputs:
#            "out" : false
#        return $.extend(true, base_fields, fields)

#      compute: =>
#        res = @fields.getField("val1").getValue(0) < @fields.getField("val2").getValue(0)
#        @fields.setField("out", res)

#    Greater: class Greater extends ThreeNodes.NodeBase
#      @node_name = 'Greater'
#      @group_name = 'ControlFlow'

#      getFields: =>
#        base_fields = super
#        fields =
#          inputs:
#            "val1" : {type: "Float", val: 0.0}
#            "val2" : {type: "Float", val: 1.0}
#          outputs:
#            "out" : false
#        return $.extend(true, base_fields, fields)

#      compute: =>
#        res = @fields.getField("val1").getValue(0) > @fields.getField("val2").getValue(0)
#        @fields.setField("out", res)
