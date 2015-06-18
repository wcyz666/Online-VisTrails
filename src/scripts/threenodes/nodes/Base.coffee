define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  #"libs/Three",
  'cs!threenodes/utils/Utils',
  'cs!threenodes/nodes/views/NodeWithCenterTextfield',
  'cs!threenodes/nodes/views/NodeWithCenterTextarea',
  'cs!threenodes/nodes/views/NodeWithUpload'
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.views",
    Integer: class Integer extends ThreeNodes.nodes.views.NodeWithCenterTextfield
      getCenterField: () => @model.fields.getField("in")

    # PythonSource: class PythonSource extends ThreeNodes.nodes.views.NodeWithCenterTextarea
    #   getCenterField: () => @model.fields.getField("in")


    String: class String extends ThreeNodes.nodes.views.NodeWithCenterTextfield
      getCenterField: () => @model.fields.getField("string")
      
    Service: class Service extends ThreeNodes.nodes.views.NodeWithCenterTextfield
      getCenterField: () => @model.fields.getField("in")

    # File: class File extends ThreeNodes.nodes.views.NodeWithCenterTextfield
    #   getCenterField: () => @model.fields.getField("in")

    File: class File extends ThreeNodes.nodes.views.NodeWithUpload

    # getField accepts the name of the port as param
    Abstract: class Abstract extends ThreeNodes.nodes.views.NodeWithCenterTextarea
      getCenterField: ()=> @model.fields.getField("author")
   
  namespace "ThreeNodes.nodes.models",
    Integer: class Integer extends ThreeNodes.NodeNumberSimple
      @node_name = 'Integer'
      @group_name = 'BasicModules'
      
      initialize: (options) =>
        super

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "in": ""
          outputs:
            "out0": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
    Abstract: class Abstract extends ThreeNodes.NodeCustom
      @node_name = 'Abstract'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        #j it's an object, not primitive; so we don't put it in
        # defaults. Should fire events for each of them mannually
        # @todo: inherit context from workflow context
        @context = 
          author: ""
          affiliation: ""
          purpose: ""
          description: ""
          keywords: ""

        @value = ""

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "author": {type:"LongText", val: @value}
        return $.extend(true, base_fields, fields)

      setContext: (obj)=>
        @context = obj
        console.log @context
        # fire change events mannually if needed

      toJSON: ()=>
        res = super
        res.context = @context
        return res



    Service: class Service extends ThreeNodes.NodeBase
      @node_name = 'Service'
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

    Aggregation: class Aggregation extends ThreeNodes.NodeBase
      @node_name = 'Aggregation'
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
            "in2": ""
          outputs:
            "out": ""
        return $.extend(true, base_fields, fields)

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
            "out0": {type: "Bool", val: @value}
            "out1": {type: "Bool", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out0", @fields.getField("bool").getValue())
        @fields.setField("out1", @fields.getField("bool").getValue())
        
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
        return $.extend(true, base_fields, fields)

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
            "val0": ""
            "val1": ""
        return $.extend(true, base_fields, fields)


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
            "in0": ""
            "in1": ""
            "in2": ""
          outputs:
            "out0": {type: "Any", val: @value}
            "out1": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

      compute: =>
        @fields.setField("out0", @fields.getField("in0").getValue())
        @fields.setField("out1", @fields.getField("in1").getValue())

        
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
            "out0": {type: "Any", val: @value}
            "out1": {type: "Any", val: @value}
            "out2": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)


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
            "in0": ""
            "in1": ""
        return $.extend(true, base_fields, fields)


    File: class File extends ThreeNodes.NodeBase
      @node_name = 'File'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        fields =
          inputs: {}
          outputs:
            "fileName": {type: "String", val: @value}
        return $.extend(true, base_fields, fields)


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
            "out0": {type: "Any", val: @value}
            "out1": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
        
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
            "in0": ""
            "in1": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        

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
            "in0": ""
            "in1": ""
        return $.extend(true, base_fields, fields)


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
            "out0": {type: "Any", val: @value}
            "out1": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)


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
            "in2": ""
          outputs:
            "out": {type: "Any", val: @value}
            "out0": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)



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
            "0" : 0
            "1" : 0
            "2" : 0
            "3" : 0
          outputs:
            "out" : {type: "StringConcatenate", val: false}
        return $.extend(true, base_fields, fields)

      compute: =>
        res = []
        res0 = []
        res1 = []
        res2 = []
        res3 = []
        numItems = @fields.getMaxInputSliceCount()

        for i in [0..numItems]
          res0[i] = @fields.getField("0").getValue(i)
          res1[i] = @fields.getField("1").getValue(i)
          res2[i] = @fields.getField("2").getValue(i)
          res3[i] = @fields.getField("3").getValue(i)
          res[i] = res0[i] + res1[i] + res2[i] + res3[i]

        @fields.setField("out", res)
        
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
            "in0" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        

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
            "out0": {type: "Any", val: @value}
            "out1": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)

        
    # PythonSource: class PythonSource extends ThreeNodes.NodeBase
    #   @node_name = 'PythonSource'
    #   @group_name = 'BasicModules'

    #   initialize: (options) =>
    #     super
    #     @value = ""
		
      # getFields: =>
      #   base_fields = super
      #   fields =
      #     inputs:
      #       "in": {type: "Code", val:@value}
      #     outputs:
      #       "out": {type: "Any", val: @value}
      #       "self": {type: "Any", val: @value}
      #   return $.extend(true, base_fields, fields)


    SmartSource: class SmartSource extends ThreeNodes.NodeBase
      @node_name = 'SmartSource'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        return $.extend(true, base_fields, fields)

        

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
        return $.extend(true, base_fields, fields)


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
        return $.extend(true, base_fields, fields)


    Untuple: class Untuple extends ThreeNodes.NodeBase
      @node_name = 'Untuple'
      @group_name = 'BasicModules'

      initialize: (options) =>
        super
        @value = ""
		
      getFields: =>
        base_fields = super
        return $.extend(true, base_fields, fields)



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
            "in0": ""
            "in1": ""
          outputs:
            "out": {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
        
        
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