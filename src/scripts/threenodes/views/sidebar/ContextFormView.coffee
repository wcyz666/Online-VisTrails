define [
  'jquery',
  'Underscore',
  'Backbone',
  'text!templates/sidebar_node_context.tmpl.html'
], ($, _, Backbone, _template) ->
  #"use strict"

  ### Context form for each individual node ###
  namespace "ThreeNodes",
    ContextFormView: class ContextFormView extends Backbone.View
      tagName: "fieldset"
      template: _.template(_template)
      initialize: (options) ->
        super

        #j A.listenTo(B, event, callback), will bind this to A, but here 0.9.2 no 
        # listenTo
        # on: default context is the object on is called on. But we pass @ as the context
        # so we can call off all at once when removing the view. The fat arrow => will not
        # give us the same benefit
        @model.on("change", @render, @)
        @render()

      events: 
        "submit": "onSubmit"

      render: () =>
        @$el.html(@template(@model.toJSON()))
        return @
        
      onSubmit: (e) =>
        e.preventDefault()
        @$el.find("button").blur()
        # gather form data
        $form = @.$el.find("form")
        $inputs = $form.find('input')
        $textareas = $form.find('textarea')
        formData = {}
        $inputs.each ()->
          formData[this.name] = this.value
        $textareas.each ()->
          formData[this.name] = this.value
        @model.set formData

      remove: =>
        super
        @off()
        @model.off null, null, @ 











