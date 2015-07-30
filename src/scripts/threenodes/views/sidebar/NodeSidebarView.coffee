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
  'cs!threenodes/views/sidebar/fields/CodeField',
  'cs!threenodes/views/sidebar/fields/LongTextField',
  'cs!threenodes/views/sidebar/fields/AnyField',
  'cs!threenodes/views/sidebar/AddFieldFormView',
  'cs!threenodes/views/sidebar/ContextFormView',
  # 'cs!threenodes/nodes/Base'

], (_, Backbone) ->
  #"use strict"

  ### NodeSidebarView ###
  namespace "ThreeNodes",
    NodeSidebarView: class NodeSidebarView extends Backbone.View
      initialize: (options) ->
        @subviews = []
        super
        Backbone.Events.on "renderSidebar", @render, @


      displayFields: (fields) =>
        for f of fields
          field = fields[f]
          #j check the constructor for class type
          view_class = switch field.constructor
            when ThreeNodes.fields.Bool then ThreeNodes.views.fields.BoolField
            when ThreeNodes.fields.String then ThreeNodes.views.fields.StringField
            when ThreeNodes.fields.LongText then ThreeNodes.views.fields.LongTextField
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
            when ThreeNodes.fields.Any then ThreeNodes.views.fields.AnyField
            else false

          if view_class != false
            #console.log(view_class)
            view = new view_class
              model: field
            @subviews.push view
            @$el.append(view.el)

      render: (field) =>
        # Compile the template file
        @$el.html("<h2>#{@model.get('name')}</h2>")
        if field
          @displayFields [field]
        else
          @displayNode()
        @



      displayNode: ->
        # the custom_fields are not real fields; just objects wrapping the type 
        # and name property; their constructors are Object. So calling displayFields
        # on them won't achieve anything. BTW, fields itself already includes custom 
        # fields.

        # add field form for adding custom fields
        if @model.add_field
          addFieldView = new ThreeNodes.AddFieldFormView() 
          @subviews.push addFieldView
          addFieldView.on "addField", (obj)=>
            if obj.key != ''
              # this port type is not the port type in the page
              if obj.portType == 'inputs' || obj.portType == 'outputs'
                props = 
                  "data": obj.data
                  "datatype": obj.datatype
                  "dataset": obj.dataset
                this.model.addCustomField(obj.name, obj.type, obj.portType, props)
          @.$el.append(addFieldView.$el)
          # 1. only rerender the subview
          # 2. rerendering of addFieldView should be taken care of by itself

        # context form for abstractTask model
        if @model instanceof ThreeNodes.nodes.models.AbstractTask
          contextFormView = new ThreeNodes.ContextFormView
            model: @model.context
          @subviews.push contextFormView

          @.$el.append contextFormView.$el
        return @


      # remove should: 
      # 1. unregister all events(on DOM, on itself, and on its nested objs)
      # 2. tear down subviews and remove references to subviews
      # 3. detach self from DOM
      remove: =>
        for view in @subviews
          view.off()
          view.remove()
        # this is also important
        Backbone.Events.off null, null, @
        @subViews = []
        @off()
        super








      


