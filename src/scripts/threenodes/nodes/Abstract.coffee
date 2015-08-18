define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  #"libs/Three",
  'cs!threenodes/utils/Utils',
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.models",
    AbstractTask: class AbstractTask extends ThreeNodes.NodeCustom
      @node_name = 'AbstractTask'
      @group_name = 'Abstract'

      initialize: (options) =>
        @value = ""
        super
        # nested model, inherit initial context from the workflow
        # the same model instance for contextFormView
        @context = new ThreeNodes.Context options.context


      toJSON: ()=>
        res = super
        res.context = @context.toJSON()
        return res

    Subworkflow: class Subworkflow extends AbstractTask
      @node_name = 'Subworkflow'




# @todo: the require thing
