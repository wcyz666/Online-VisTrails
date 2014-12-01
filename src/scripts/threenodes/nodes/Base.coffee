define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  #"libs/Three",
  'cs!threenodes/utils/Utils',
  'cs!threenodes/nodes/views/NodeWithCenterTextfield',
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.views",
    Number: class Number extends ThreeNodes.nodes.views.NodeWithCenterTextfield

    String: class String extends ThreeNodes.nodes.views.NodeWithCenterTextfield
      getCenterField: () => @model.fields.getField("string")

  namespace "ThreeNodes.nodes.models",
    Integer: class Integer extends ThreeNodes.NodeNumberSimple
      @node_name = 'Integer'
      @group_name = 'BasicModules'

    Boolean: class Boolean extends ThreeNodes.NodeBase
      @node_name = 'Boolean'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = true

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "bool": true
          outputs:
            "out": {type: "Bool", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("bool").getValue())
        
    Assert: class Assert extends ThreeNodes.NodeBase
      @node_name = 'Assert'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())

    AssertEqual: class AssertEqual extends ThreeNodes.NodeBase
      @node_name = 'AsserEqual'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())

    Dictionary: class Dictionary extends ThreeNodes.NodeBase
      @node_name = 'Dictionary'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())

        
    Directory: class Directory extends ThreeNodes.NodeBase
      @node_name = 'Directory'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())


    DirectorySink: class DirectorySink extends ThreeNodes.NodeBase
      @node_name = 'DirectorySink'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())

    File: class File extends ThreeNodes.NodeBase
      @node_name = 'File'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())


    Float: class Float extends ThreeNodes.NodeBase
      @node_name = 'Float'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())
        
        
    InputPort: class InputPort extends ThreeNodes.NodeBase
      @node_name = 'InputPort'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())
        

    OutputPort: class OutputPort extends ThreeNodes.NodeBase
      @node_name = 'OutputPort'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())


    OutputPath: class OutputPath extends ThreeNodes.NodeBase
      @node_name = 'OutputPath'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())


    Not: class Not extends ThreeNodes.NodeBase
      @node_name = 'Not'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())


    List: class List extends ThreeNodes.NodeBase
      @node_name = 'List'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in0": ""
            "in1": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())


    String: class String extends ThreeNodes.NodeBase
      @node_name = 'String'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "string": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("string").getValue())

    StringConcatenate: class StringConcatenate extends ThreeNodes.NodeBase
      @node_name = 'StringConcatenate'
      @group_name = 'BasicModules'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "x" : 0
            "y" : 0
          outputs:
            "xy" : {type: "StringConcatenate", val: false}
            #"x" : 0
            #"y" : 0
        return $.extend(true, base_fields, fields)

      compute: =>
        res = []
        resx = []
        resy = []
        numItems = @fields.getMaxInputSliceCount()

        for i in [0..numItems]
          resx[i] = @fields.getField("x").getValue(i)
          resy[i] = @fields.getField("y").getValue(i)
          res[i] = resx[i] + resy[i]
          #res[i] = new THREE.Vector3(resx[i], resy[i])

        @fields.setField("xy", res)
        #@fields.setField("x", resx)
        #@fields.setField("y", resy)
        
    WriteFile: class WriteFile extends ThreeNodes.NodeBase
      @node_name = 'WriteFile'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in" : {type: "Any", val: @value}
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())

    FileSink: class FileSink extends ThreeNodes.NodeBase
      @node_name = 'FileSink'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in" : {type: "Any", val: @value}
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())
        

    Vector3: class Vector3 extends ThreeNodes.NodeBase
      @node_name = 'Vector3'
      @group_name = 'BasicModules'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "x" : 0
            "y" : 0
            "z" : 0
          outputs:
            "xyz" : {type: "Vector3", val: false}
            "x" : 0
            "y" : 0
            "z" : 0
        return $.extend(true, base_fields, fields)

      compute: =>
        res = []
        resx = []
        resy = []
        resz = []
        numItems = @fields.getMaxInputSliceCount()

        for i in [0..numItems]
          resx[i] = @fields.getField("x").getValue(i)
          resy[i] = @fields.getField("y").getValue(i)
          resz[i] = @fields.getField("z").getValue(i)
          res[i] = new THREE.Vector3(resx[i], resy[i], resz[i])

        @fields.setField("xyz", res)
        @fields.setField("x", resx)
        @fields.setField("y", resy)
        @fields.setField("z", resz)
        
        

    Color: class Color extends ThreeNodes.NodeBase
      @node_name = 'Color'
      @group_name = 'BasicModules'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "r": 0
            "g": 0
            "b": 0
          outputs:
            "rgb": {type: "Color", val: false}
            "r": 0
            "g": 0
            "b": 0
        return $.extend(true, base_fields, fields)

      compute: =>
        res = []
        resr = []
        resg = []
        resb = []
        numItems = @fields.getMaxInputSliceCount()

        for i in [0..numItems]
          resr[i] = @fields.getField("r").getValue(i)
          resg[i] = @fields.getField("g").getValue(i)
          resb[i] = @fields.getField("b").getValue(i)
          res[i] = new THREE.Color().setRGB(resr[i], resg[i], resb[i])

        @fields.setField("rgb", res)
        @fields.setField("r", resr)
        @fields.setField("g", resg)
        @fields.setField("b", resb)
        
    Path: class Path extends ThreeNodes.NodeBase
      @node_name = 'Path'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())
        
    PythonSource: class PythonSource extends ThreeNodes.NodeBase
      @node_name = 'PythonSource'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())
        

    SmartSource: class SmartSource extends ThreeNodes.NodeBase
      @node_name = 'SmartSource'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())
        

    StandardOutput: class StandardOutput extends ThreeNodes.NodeBase
      @node_name = 'StandardOutput'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())


    StringFormat: class StringFormat extends ThreeNodes.NodeBase
      @node_name = 'StringFormat'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())
        

    Tuple: class Tuple extends ThreeNodes.NodeBase
      @node_name = 'Tuple'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())
        

    Untuple: class Untuple extends ThreeNodes.NodeBase
      @node_name = 'Untuple'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())


    Unzip: class Unzip extends ThreeNodes.NodeBase
      @node_name = 'Unzip'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())
        
        
    UnzipDirectory: class UnzipDirectory extends ThreeNodes.NodeBase
      @node_name = 'UnzipDirectory'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out", @fields.getField("in").getValue())