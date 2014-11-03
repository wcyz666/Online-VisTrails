define [
  'Underscore',
  'Backbone',
  'cs!threenodes/views/sidebar/fields/BaseField',
], (_, Backbone) ->
  #"use strict"

  ### WriteFile View ###
  namespace "ThreeNodes.views.fields",
    WriteFileField: class WriteFileField extends ThreeNodes.views.fields.BaseField
      render: () =>
        $target = @createSidebarFieldTitle()
        @createSubvalTextinput("x")
        return @