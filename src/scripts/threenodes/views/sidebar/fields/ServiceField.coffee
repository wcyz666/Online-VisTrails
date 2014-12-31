define [
  'Underscore',
  'Backbone',
  'cs!threenodes/views/sidebar/fields/BaseField',
], (_, Backbone) ->
  #"use strict"

  ### ServiceField View ###
  namespace "ThreeNodes.views.fields",
    ServiceField: class ServiceField extends ThreeNodes.views.fields.BaseField
      render: () =>
        $target = @createSidebarContainer()
        @textfield = @createTextfield($target, "in")
        @textfield.linkTextfieldToVal(@textfield.$input, "in")
        return this