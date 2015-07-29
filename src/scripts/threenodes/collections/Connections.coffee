
define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Connection',
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes",
    ConnectionsCollection: class ConnectionsCollection extends Backbone.Collection
      model: ThreeNodes.Connection

      initialize: (models, options) =>
        @indexer = options.indexer
        @bind "connection:removed", (c) => @remove(c)
        super

      render: () =>
        @each (c) -> c.render()

      # @override the backbone's collection.create
      # model is not an actual model, it's just an object. It's better to name it 
      # attrs, like the way backbone exposes the api
      # 
      # notes: Similar to the backbone source code:
      # model is the attrs, but you can actually take a model. 
      # it will call _prepareModel(), the internal funciton of backbone, which will
      # turn the object into a model if it isn't(it calls _isModel() internally to 
      # decide if this is a model)

      #j it might call the connection model constructor to construct the model 

      create: (model, options) =>
        if !options then options = {}
        model.indexer = @indexer
        model = @_prepareModel(model, options)
        if !model
          return false
        @add(model, options)
        return model

      removeAll: () =>
        @remove(@models)
