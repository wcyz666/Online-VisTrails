define [
  'Underscore',
  'Backbone',
  'cs!threenodes/models/Node',
  'cs!threenodes/views/NodeView',
], (_, Backbone) ->
  #"use strict"

  namespace "ThreeNodes.nodes.views",
    NodeWithCenterTextarea: class NodeWithCenterTextarea extends ThreeNodes.NodeView
      initialize: (options) =>
        super
        field = @getCenterField()
        # container = $("<div><input type='text' data-fid='#{field.get('fid')}' /></div>").appendTo($(".center", @$el))
        container = $("<div><textarea data-fid='#{field.get('fid')}'></textarea><br/><button type='button'>Save</button></div>").appendTo($(".center", @$el))

        f_in = $("textarea", container)
        f_save = $("button", container)
        field.on_value_update_hooks.update_center_textarea = (v) ->
          if v != null
            f_in.val(v.toString())
        f_in.val(field.getValue())
        if field.get("is_output") == true
          f_in.attr("disabled", "disabled")
        else
          f_save.click (e) ->
            field.setValue(f_in.val())
            $(this).blur()
        @

      # View class can override this. Possibility to reuse this class
      # accept the name of the field as param
      getCenterField: () => @model.fields.getField("in")
