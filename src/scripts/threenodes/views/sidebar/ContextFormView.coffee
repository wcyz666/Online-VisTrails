define [
  'jquery',
  'Underscore',
  'Backbone',
  'text!templates/sidebar_node_context.tmpl.html'
  'text!templates/constraint_input.tmpl.html'
], ($, _, Backbone, _template, _constraint_template) ->
  #"use strict"

  ### Context form for each individual node ###
  namespace "ThreeNodes",
    ContextFormView: class ContextFormView extends Backbone.View
      tagName: "fieldset"
      template: _.template(_template)
      constraintTemplate: _.template(_constraint_template)
      initialize: (options) ->
        super

        #j A.listenTo(B, event, callback), will bind this to A, but here 0.9.2 no
        # listenTo
        # on: default context is the object on is called on. But we pass @ as the context
        # so we can call off all at once when removing the view. The fat arrow => will not
        # give us the same benefit
        @model.on("change", @render, @)
        @render()

      events:
        "submit": "onSubmit"
        'click #addConstraint': 'addConstraint'

      render: () =>
        @$el.html(@template(@model.toJSON()))
        # add constraints
        $constraints = @.$('#constraints')
        # add each constraint to the page
        for constraint in @model.get 'constraints'
          constraint_html = @constraintTemplate {constraint: constraint}
          $constraints.append constraint_html
        # if no constraint, show an empty input
        if @model.get('constraints').length is 0
          $constraints.append @constraintTemplate {constraint: ''}

        return @

      # add an empty input for new constraint
      addConstraint: (e)->
        $(e.target).blur()
        $constraints = @.$('#constraints')
        $constraints.append @constraintTemplate {constraint: ''}

      onSubmit: (e) =>
        e.preventDefault()
        @$el.find("button").blur()
        # gather form data
        $form = @.$el.find("form")
        # other inputs except constraint
        $inputs = $form.find('input').not('[name="constraint"]')
        $textareas = $form.find('textarea')
        formData = {}
        $inputs.each ()->
          formData[this.name] = this.value
        $textareas.each ()->
          formData[this.name] = this.value
        # handle constraints array separately
        $constraints = $form.find '[name = "constraint"]'
        constraints = []
        $constraints.each ->
          constraints.push this.value if this.value
        formData.constraints = constraints
        @model.set formData

      remove: =>
        super
        @off()
        @model.off null, null, @











