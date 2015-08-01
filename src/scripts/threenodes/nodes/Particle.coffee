define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  'cs!threenodes/utils/Utils',
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.models",
    HTTPDirectory: class HTTPDirectory extends ThreeNodes.NodeBase
      @node_name = 'HTTPDirectory'
      @group_name = 'HTTP'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val0" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)


  namespace "ThreeNodes.nodes.models",
    HTTPFile: class HTTPFile extends ThreeNodes.NodeBase
      @node_name = 'HTTPFile'
      @group_name = 'HTTP'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val0" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)


  namespace "ThreeNodes.nodes.models",
    RepoSynch: class RepoSynch extends ThreeNodes.NodeBase
      @node_name = 'RepoSynch'
      @group_name = 'HTTP'

      getFields: =>
        base_fields = super
        fields =
          inputs:
            "val0" : ""
          outputs:
            "out" : {type: "Any", val: @value}
        return $.extend(true, base_fields, fields)
