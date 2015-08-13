define [
  'Underscore',
  'Backbone',
  'cs!threenodes/utils/Utils',
  'cs!threenodes/models/Context',
  'cs!threenodes/collections/Fields',
], (_, Backbone, Utils) ->
  #"use strict"

  ### workflow model ###

  namespace "ThreeNodes",
    Workflow: class Workflow extends Backbone.Model
      initialize: ->
        # helper states, will not save to the server side, nor are they data attrs
        # or bound to the representation
        @workflow_state = false
        @running_nodes = []
        @waiting_ndoes = []

        # nested model
        @context = new ThreeNodes.Context()

