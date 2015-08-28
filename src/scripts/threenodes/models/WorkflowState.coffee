define [
  'Underscore',
  'Backbone',
  'cs!threenodes/utils/Utils',
  'cs!threenodes/models/Context',
  'cs!threenodes/collections/Fields',
], (_, Backbone, Utils) ->
  #"use strict"

  ### workflowState model ###

  namespace "ThreeNodes",
    WorkflowState: class WorkflowState extends Backbone.Model
      initialize: (options)->
        options = options || {}
        # helper states, will not save to the server side, nor are they data attrs
        # or bound to the representation
        @workflow_state = false
        @running_nodes = []
        @waiting_nodes = []

        # nested model
        context = new ThreeNodes.Context(options.context)
        @set {context: context}

