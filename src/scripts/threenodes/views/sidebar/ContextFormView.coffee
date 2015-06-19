define [
  'jquery',
  'Underscore',
  'Backbone',
  'text!templates/sidebar_node_context.tmpl.html'
], ($, _, Backbone, _template) ->
  #"use strict"

  namespace "ThreeNodes",
    ContextFormView: class ContextFormView extends Backbone.View
      tagName: "fieldset"
      template: _.template(_template)
      initialize: (options) ->
        super
        @render()

      events: 
        "submit": "onSubmit"

      render: () =>
        @$el.html(@template())
        return @
        
      onSubmit: (e) =>
        e.preventDefault()
        @$el.find("button").blur()
        # gather form data
        $form = @.$el.find("form")
        $inputs = $form.find('input')
        formData = {}
        $inputs.each ()->
          formData[this.name] = this.value
        # trigger event and send form data
        @.trigger("setContext", formData);

