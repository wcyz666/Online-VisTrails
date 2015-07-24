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
        super
        # @todo: del
        @model.set "data", "aya"
        @container.append @template(@.model.toJSON())
        @
