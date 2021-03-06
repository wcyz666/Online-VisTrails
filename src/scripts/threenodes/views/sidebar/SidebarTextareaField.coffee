define [
  'Underscore',
  'Backbone',
  'text!templates/field_textareaField.tmpl.html'
], (_, Backbone, _view_field_textfield) ->
  #"use strict"

  ### SidebarTextfield View ###
  namespace "ThreeNodes",
    SidebarTextareaField: class SidebarTextareaField extends Backbone.View
      initialize: (options) ->
        super
        @render()

      render: () =>
        # Compile the template file
        @container = $(_.template(_view_field_textfield, @options))
        @$el.append(@container)
        @$input = $("textarea", @container)
        @$save = $("button",@container)

        if @options.type == "float" && @options.link_to_val == true
          @$input.val(@model.getValue())
          @addTextfieldSlider()
        return @

      linkTextfieldToVal: (f_input, f_save, type = "float") =>
        on_value_changed = (v) ->
          f_input.val(v)
        @model.on "value_updated", on_value_changed

        f_input.val(@model.getValue())

        f_save.click (e) =>
          @model.setValue(f_input.val())
          f_save.blur()
        ###  change this part
        f_input.keypress (e) =>
          if e.which == 13
            if type == "float"
              @model.setValue(parseFloat(f_input.val()))
            else
              @model.setValue(f_input.val())
            f_input.blur()
        ###

        return f_input




      # TODO: maybe remove f_input param
      linkTextfieldToSubval: (f_input, subval, type = "float") =>
        # TODO: use the event instead of the hook
        @model.on_value_update_hooks["update_sidebar_textfield_" + subval] = (v) ->
          f_input.val(v[subval])

        f_input.val(@model.getValue()[subval])
        f_input.keypress (e) =>
          if e.which == 13
            dval = f_input.val()
            if type == "float" then dval = parseFloat(dval)
            if $.type(@model.attributes.value) == "array"
              @model.attributes.value[0][subval] = dval
            else
              @model.attributes.value[subval] = dval
            f_input.blur()
        f_input

      addTextfieldSlider: () =>
        $parent = @$input.parent()

        on_slider_change = (e, ui) =>
          @$input.val(ui.value)
          # simulate a keypress to apply value
          press = jQuery.Event("keypress")
          press.which = 13
          @$input.trigger(press)

        remove_slider = () =>
          $(".slider-container", $parent).remove()

        create_slider = () =>
          remove_slider()
          $parent.append('<div class="slider-container"><div class="slider"></div></div>')
          current_val = parseFloat(@$input.val())
          min_diff = 0.5
          diff = Math.max(min_diff, Math.abs(current_val * 4))
          $(".slider-container", $parent).append("<span class='min'>#{(current_val - diff).toFixed(2)}</span>")
          $(".slider-container", $parent).append("<span class='max'>#{(current_val + diff).toFixed(2)}</span>")

          $(".slider", $parent).slider
            min: current_val - diff
            max: current_val + diff
            value: current_val
            step: 0.01
            change: on_slider_change
            slide: on_slider_change

        # recreate slider on focus
        @$input.focus (e) =>
          create_slider()
        # create first slider
        create_slider()

      remove: =>
        super
        @off
        @model null, null, @
