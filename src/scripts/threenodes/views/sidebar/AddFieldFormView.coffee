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
        "change select": "onSelectChange"

      render: () =>
        @$el.html(@template())
        return @
        
      onSubmit: (e) =>
        e.preventDefault()
        @$el.find("[type='submit']").blur()
        $form = @.$el.find("form")
        formData = {}
        # radio button:
        $portType = $form.find("[name = 'portType']:checked")
        formData.portType = $portType.val()
        # other elements:
        $formEls = $form.find("[id]")
        $formEls.each ()->
          formData[this.name] = this.value
        @trigger("addField", formData)
        

      onSelectChange: (e) =>
        $generics = @.$el.find(".generic")
        #j 'generic' is the alias of 'Any'
        if e.target.value isnt "Any"
          $generics.hide()
        else
          $generics.show()

      remove: =>
        super
        @off()
        if @model
          @model.off null, null, @



        