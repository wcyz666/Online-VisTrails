define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  #"libs/Three",
  'cs!threenodes/utils/Utils',
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.models",
    Data: class Data extends ThreeNodes.NodeBase
      @node_name = ''
      @group_name = 'Data'

      defaults: ->
        _.extend super,
          # format is __atomic__
          format: []

      toJSON: ->
        _.extend super,
          format: @.get 'format'

    DataSource: class DataSource extends Data
      @node_name = 'DataSource'

      initialize: ->
        @value = ''
        super

      getFields: ->
        base_fields = super
        fields =
          outputs:
            'out': {type: 'Any', val: @value}
        $.extend(true, base_fields, fields)

    ModelStorage: class ModelStorage extends Data
      @node_name = 'ModelStorage'

      initialize: ->
        @value = ''
        super

      getFields: ->
        base_fields = super
        fields =
          inputs:
            'in': {type: 'Any', val: @value}
        $.extend(true, base_fields, fields)


