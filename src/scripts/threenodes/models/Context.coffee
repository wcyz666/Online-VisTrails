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
        # note that constraints is treated atomically. when you change it,
        # you always create a new array, like any primitive values. You never
        # change the inner memebers of it and keep the same reference; in that
        # case, you would define another constraint model and a constraints
        # collection. So it's ok that initially all nodes share the same
        # constraints array from the workflow itself. It's the same as you get
        # a default primitive value from the prototype chain in javascript: initially
        # you get it from the prototype chain; and when you first set it, you create
        # your own local one and the next time you get it, you get your local one
        # instead of the one from the prototype chain.
        constraints: []
