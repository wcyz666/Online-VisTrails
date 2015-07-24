define [
  'Underscore',
  'Backbone',
  "text!templates/field_sidebar_container.tmpl.html",
  'cs!threenodes/views/sidebar/SidebarTextfield',
  'cs!threenodes/views/sidebar/SidebarTextareaField'
], (_, Backbone, _view_field_sidebar_container) ->
  #"use strict"

  ### BaseField View ###
  namespace "ThreeNodes.views.fields",
    BaseField: class BaseField extends Backbone.View
      #j the el would be an empty div, and not connected to the page yet
      initialize: (options) ->
        @subviews = []
        super
        # source of memory leak， should explicitly pass @ as the context
        # if you want to unbind all events from this view to the model, even
        # if the event handler uses fat arrow
        @model.on "value_updated", @on_value_updated, @
        @render()

      on_value_updated: (new_val) => return @

      render: () =>
        $target = @createSidebarContainer()
        return @

      createSidebarContainer: (name = @model.get("name")) =>
        options =
          fid: @model.get("fid")
          model: @
          name: name
        @container = $(_.template(_view_field_sidebar_container, options))
        @$el.append(@container)

        return @container

      createTextfield: ($target, type = "float", link_to_val = true) =>
        textField = new ThreeNodes.SidebarTextfield
          model: @model
          el: $target
          type: type
          link_to_val: link_to_val

        @subviews.push textField
        return textField

      createTextareaField: ($target, type = "float", link_to_val = true) =>
        textareaField = new ThreeNodes.SidebarTextareaField
          model: @model
          el: $target
          type: type
          link_to_val: link_to_val

        @subviews.push textareaField
        return textareaField

      createSubvalTextinput: (subval, type = "float") =>
        $target = @createSidebarContainer(subval)
        textfield = @createTextfield($target, type, false)
        textfield.linkTextfieldToSubval(textfield.$input, subval, type)
        if type == "float"
          textfield.addTextfieldSlider(textfield.$input)
        return false

      createSidebarFieldTitle: (name = @model.get("name")) =>
        @$el.append("<h3>#{name}</h3>")
        return @$el

      remove: =>
        for view in @subviews
          view.remove()
          view.off()
        @subViews =[]
        super
        @off()
        @model.off null, null, @
