define [
  'Underscore',
  'Backbone',
  "text!templates/field_generic.tmpl.html",
  'cs!threenodes/views/sidebar/fields/BaseField',
], (_, Backbone, _template) ->
  #"use strict"

  ### SidebarField View ###
  namespace "ThreeNodes.views.fields",
    AnyField: class AnyField extends ThreeNodes.views.fields.BaseField
      template: _.template _template
      render: =>
        @$el.html ''
        #j super will create the container and append it to el
        super
        @container.append @template(@.model.toJSON())
        @

      events:
        'submit': 'onSubmit'

      onSubmit: (e)->
        e.preventDefault()
        formData = {}
        @$('[name]').each ->
          formData[@name] = @value
        @model.set formData
        @render()

