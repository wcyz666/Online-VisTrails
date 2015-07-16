define [
  'Underscore',
  'Backbone',
], (_, Backbone) ->
  #"use strict"

  ### Context Model ###


  namespace "ThreeNodes",
    Context: class Context extends Backbone.Model
      