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
        @$el.find("[type='submit']").blur()
        $form = @.$el.find("form")
        $key = $form.find('[name="name"]')
        $type = $form.find('[name="type"]')
        $portType = $form.find('[name="portType"]:checked')
        key = $.trim($key.val())
        type = $.trim($type.val())
        portType = $.trim($portType.val())
        @.trigger("addField", {
          key: key
          ,type: type
          ,portType: portType
        })


        