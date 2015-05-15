define [
  'Underscore',
  'Backbone',
  'text!templates/upload_file_form.tmpl.html',
  'cs!threenodes/models/Node',
  'cs!threenodes/views/NodeView',
  'jqueryForm'
], (_, Backbone,_template) ->
  #"use strict"

  namespace "ThreeNodes.nodes.views",
    NodeWithUpload: class NodeWithUpload extends ThreeNodes.NodeView

      initialize: (options) =>
        super
        $form = $(_.template(_template)())
        $form.submit ->
          $form.ajaxSubmit {
            error: (xhr) ->
              console.log 'Error: '+xhr.status
            success: (res) ->
              console.log "success"
          }
          return false


        $form.appendTo($(".center", @$el))




        return @
      # events:{}
      # template: _.template(_template)

      getOutputField: () => @model.fields.getField("fileName", true)








      #   field = @getCenterField()
      #   container = $("<div><input type='text' data-fid='#{field.get('fid')}' /></div>").appendTo($(".center", @$el))
      #   f_in = $("input", container)
      #   field.on_value_update_hooks.update_center_textfield = (v) ->
      #     if v != null
      #       f_in.val(v.toString())
      #   f_in.val(field.getValue())
      #   if field.get("is_output") == true
      #     f_in.attr("disabled", "disabled")
      #   else
      #     f_in.keypress (e) ->
      #       if e.which == 13
      #         field.setValue($(this).val())
      #         $(this).blur()
      #   @

      # # View class can override this. Possibility to reuse this class
      # getCenterField: () => @model.fields.getField("in")