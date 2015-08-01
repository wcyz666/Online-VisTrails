define [
  'Underscore',
  'Backbone',
], (_, Backbone) ->
  #"use strict"

  ### Context Model ###


  namespace "ThreeNodes",
    Context: class Context extends Backbone.Model
      # define defaults as function because we have an array attr
      defaults: ->
        author: ""
        affiliation: ""
        keywords: ""
        purpose: ""
        description: ""
        constraints: []
