define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  #"libs/Three",
  'cs!threenodes/utils/Utils',
  'cs!threenodes/views/NodeView'
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.views",
    Subworkflow: class Subworkflow extends ThreeNodes.NodeView
      events: ->
        'dblclick': 'openSubworkflow'

      openSubworkflow: (e)->
        if e.target is @el
          Backbone.Events.trigger 'openSubworkflow', @model

  namespace "ThreeNodes.nodes.models",
    AbstractTask: class AbstractTask extends ThreeNodes.NodeCustom
      @node_name = 'AbstractTask'
      @group_name = 'Abstract'

      initialize: (options) =>
        options = options || {}
        @value = ""
        super
        # nested model, inherit initial context from the workflow
        # the same model instance for contextFormView
        @context = new ThreeNodes.Context options.context || null
        @set {implementation: options.implementation || null}


      # backbone model's toJSON method has been completely overriden in node model,
      # so you have to add each prop you want it to have to your own toJSON
      # Everything should be a copy, make sure there is no direct nested obj assigned
      # No, the constraints inside of context would be direct nested array. Would that
      # be a problem? As long as it's atomic, I think it's safe here: any
      # destroy process is not likely to go inside the array and set each of them to
      # undefiend. It is supposed to just set the pointer to null to abandon the array.
      toJSON: ()=>
        res = super
        res.context = @context.toJSON()
        res.implementation = @get 'implementation'
        return res

    Subworkflow: class Subworkflow extends AbstractTask
      @node_name = 'Subworkflow'


