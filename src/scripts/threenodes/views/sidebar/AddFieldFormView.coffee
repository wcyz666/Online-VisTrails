define [
  'jquery',
  'Underscore',
  'Backbone',
  'text!templates/sidebar_add_field_form.tmpl.html'
], ($, _, Backbone, _template) ->
  #"use strict"

  ### AddFieldFormView ###
  namespace "ThreeNodes",
    AddFieldFormView: class AddFieldFormView extends Backbone.View
      tagName: "form"
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
        $form = @.$el
        $key = $form.find('[name="key"]')
        $type = $form.find('[name="type"]')
        key = $.trim($key.val())
        type = $.trim($type.val())
        @.trigger("addField", {
          key: key
          ,type: type
          })