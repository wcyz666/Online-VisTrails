define [
  'Underscore',
  'Backbone',
  'cs!threenodes/views/sidebar/fields/StringField',
], (_, Backbone) ->
  #"use strict"

  ### StringField View ###
  namespace "ThreeNodes.views.fields",
    LongTextField: class LongTextField extends ThreeNodes.views.fields.StringField
      render: () =>
        $target = @createSidebarContainer()
        @textfield = @createTextareaField($target, "string")
        @textfield.linkTextfieldToVal(@textfield.$input, @textfield.$save, "string")
        return this
