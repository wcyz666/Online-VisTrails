define [
  'Underscore',
  'Backbone',
  'cs!threenodes/views/sidebar/fields/BoolField',
  'cs!threenodes/views/sidebar/fields/StringField',
  'cs!threenodes/views/sidebar/fields/FloatField',
  'cs!threenodes/views/sidebar/fields/Vector2Field',
  'cs!threenodes/views/sidebar/fields/Vector3Field',
  'cs!threenodes/views/sidebar/fields/Vector4Field',
  'cs!threenodes/views/sidebar/fields/StringConcatenateField',
  'cs!threenodes/views/sidebar/fields/FileSinkField',
  'cs!threenodes/views/sidebar/fields/WriteFileField',
  'cs!threenodes/views/sidebar/fields/CodeField'
], (_, Backbone) ->
  #"use strict"

  ### NodeSidebarView ###
  namespace "ThreeNodes",
    NodeSidebarView: class NodeSidebarView extends Backbone.View
      initialize: (options) ->
        super
        console.log @model
        @render()

      displayFields: (fields) =>
        console.log "see the fields"
        console.log fields
        console.log "over"
        for f of fields
          field = fields[f]
          console.log "before that"
          console.log field.constructor
          console.log "after that"
          view_class = switch field.constructor
            when ThreeNodes.fields.Bool then ThreeNodes.views.fields.BoolField
            when ThreeNodes.fields.String then ThreeNodes.views.fields.StringField
            when ThreeNodes.fields.Float then ThreeNodes.views.fields.FloatField
            when ThreeNodes.fields.Code then ThreeNodes.views.fields.CodeField
            # Add concatenation, Write File, File,
            when ThreeNodes.fields.WriteFile then ThreeNodes.views.fields.WriteFileField
            when ThreeNodes.fields.StringConcatenate then ThreeNodes.views.fields.StringConcatenateField
            when ThreeNodes.fields.FileSink then ThreeNodes.views.fields.FileSinkField
            #Add ServiceField input text 
            #when ThreeNodes.fields.Service then ThreeNodes.views.fields.ServiceField
            when ThreeNodes.fields.Vector2 then ThreeNodes.views.fields.Vector2Field
            when ThreeNodes.fields.Vector3 then ThreeNodes.views.fields.Vector3Field
            when ThreeNodes.fields.Vector4 then ThreeNodes.views.fields.Vector4Field
            else false

          if view_class != false
            view = new view_class
              model: field
            @$el.append(view.el)
      render: () =>
        # Compile the template file
        @$el.html("<h2>#{@model.get('name')}</h2>")
        @displayFields(@model.fields.inputs)

        console.log @model.custom_fields
        # Display custom fields if needed.
        if @model.custom_fields then @displayFields(@model.custom_fields.inputs)

        # Special case for code nodes, add buttons to add inputs/outputs.
        # Todo: find a way to define a sidebarview class by nodetypes and
        # refactor this (CodeSidebarView extends NodeSidebarView)
        if @model.onCodeUpdate
          self = this
          @$el.append("<h2>Add custom fields</h2>")
          $inputs_form = $('<form class="dynamic-fields__form"></form>')
          $inputs_form.append('<input type="text" name="key" placeholder="key" />')
          $inputs_form.append('<input type="text" name="type" placeholder="type" />')
          $inputs_form.append('<input type="submit" value="Add input field" />')
          @$el.append($inputs_form)

          $inputs_form.on 'submit', (e) ->
            e.preventDefault()
            $form = $(this)
            $key = $(this).find('[name="key"]')
            $type = $(this).find('[name="type"]')
            key = $.trim($key.val())
            type = $.trim($type.val())
            if key != ''
              # add this to the model custom fields definition and rerender the view.
              self.model.addCustomField(key, type, 'inputs')

              # Simply rerender the sidebar.
              # todo: maybe do something like remove the render.
              self.render()

        return @

      



      # render: () =>
      #   # Compile the template file
      #   @$el.html("<h2>#{@model.get('name')}</h2>")
      #   for f of @model.fields.inputs
      #     field = @model.fields.inputs[f]
      #     view_class = switch field.constructor
      #       when ThreeNodes.fields.Bool then ThreeNodes.views.fields.BoolField
      #       when ThreeNodes.fields.String then ThreeNodes.views.fields.StringField
      #       when ThreeNodes.fields.Float then ThreeNodes.views.fields.FloatField
      #       when ThreeNodes.fields.Code then ThreeNodes.views.fields.CodeField
      #       # Add concatenation, Write File, File,
      #       when ThreeNodes.fields.WriteFile then ThreeNodes.views.fields.WriteFileField
      #       when ThreeNodes.fields.StringConcatenate then ThreeNodes.views.fields.StringConcatenateField
      #       when ThreeNodes.fields.FileSink then ThreeNodes.views.fields.FileSinkField
      #       #Add ServiceField input text 
      #       #when ThreeNodes.fields.Service then ThreeNodes.views.fields.ServiceField
      #       when ThreeNodes.fields.Vector2 then ThreeNodes.views.fields.Vector2Field
      #       when ThreeNodes.fields.Vector3 then ThreeNodes.views.fields.Vector3Field
      #       when ThreeNodes.fields.Vector4 then ThreeNodes.views.fields.Vector4Field
      #       else false

      #     if view_class != false
      #       view = new view_class
      #         model: field
      #       @$el.append(view.el)
      #   return @
