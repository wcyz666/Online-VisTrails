define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  'cs!threenodes/utils/Utils',
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.models",
    CellLocation: class CellLocation extends ThreeNodes.NodeBase
      @node_name = 'CellLocation'
      @group_name = 'VisTrailsSpreadsheet'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val1" : ""
            "val2" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
        
    ImageViewerCell: class ImageViewerCell extends ThreeNodes.NodeBase
      @node_name = 'ImageVieweCell'
      @group_name = 'VisTrailsSpreadsheet'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val1" : ""
            "val2" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
        
    RichTextCell: class RichTextCell extends ThreeNodes.NodeBase
      @node_name = 'RichTextCell'
      @group_name = 'VisTrailsSpreadsheet'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val1" : ""
            "val2" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
        
    SheetReference: class SheetReference extends ThreeNodes.NodeBase
      @node_name = 'SheetReference'
      @group_name = 'VisTrailsSpreadsheet'

      getFields: =>
        base_fields = super
        fields =
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
        
    SingleCellSheetReference: class SingleCellSheetReference extends ThreeNodes.NodeBase
      @node_name = 'SingleCellSheetReference'
      @group_name = 'VisTrailsSpreadsheet'

      getFields: =>
        base_fields = super
        fields =
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)      
        
        
    SpreadSheetCell: class SpreadSheetCell extends ThreeNodes.NodeBase
      @node_name = 'SpreadSheetCell'
      @group_name = 'VisTrailsSpreadsheet'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val1" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
        
    SVGCell: class SVGCell extends ThreeNodes.NodeBase
      @node_name = 'SVGCell'
      @group_name = 'VisTrailsSpreadsheet'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val1" : ""
            "val2" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
        
    SVGSplitter: class SVGSplitter extends ThreeNodes.NodeBase
      @node_name = 'SVGSplitter'
      @group_name = 'VisTrailsSpreadsheet'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val1" : ""
        return $.extend(true, base_fields, fields)
        
        
    WebViewCell: class WebViewCell extends ThreeNodes.NodeBase
      @node_name = 'WebViewCell'
      @group_name = 'VisTrailsSpreadsheet'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val1" : ""
            "val2" : ""
            "val3" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
        
    XSLCell: class XSLCell extends ThreeNodes.NodeBase
      @node_name = 'XSLCell'
      @group_name = 'VisTrailsSpreadsheet'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val1" : ""
            "val2" : ""
            "val3" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)	