define [
  'Underscore',
  'Backbone',
  'cs!threenodes/views/sidebar/fields/BaseField',
], (_, Backbone) ->
  #"use strict"

  ### FileSink View ###
  namespace "ThreeNodes.views.fields",
    FileSinkField: class FileSinkField extends ThreeNodes.views.fields.BaseField
      render: () =>
        $target = @createSidebarFieldTitle()
        @textfield = @createTextfield($target, "saveLoc")
        @textfield.linkTextfieldToVal(@textfield.$output, "saveLoc")
        #@createSubvalTextinput("x")
        return @
