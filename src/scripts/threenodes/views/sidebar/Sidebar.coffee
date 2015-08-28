#This script is to initialize the side bar content...No modifications of look and feel
#This initializes the complete side bar: Modif here to change the names of elements
define [
  'Underscore',
  'Backbone',
  "jquery.ui",
  'cs!threenodes/views/TreeView',
  'cs!threenodes/views/sidebar/NodeSidebarView',
  #"libs/jquery.layout-latest",
], (_, Backbone) ->
  #"use strict"

  ### Sidebar View ###
  namespace "ThreeNodes",
    Sidebar: class Sidebar extends Backbone.View
      initialize: () ->
        super
        # Keep references of node attributes subviews
        @node_views = []

        @initNewNode()
        @initSearch()
        @initTabs()
        @initTreeView()
        @layout = @$el.layout
          scrollToBookmarkOnLoad: false
          north:
            closable: false
            resizable: false
            slidable: false
            #size: 24
            resizerClass: "ui-layout-resizer-hidden"
            spacing_open: 0
            spacing_closed: 0
          center:
            size: "100%"


      initTreeView: () =>
        @treeview = new ThreeNodes.TreeView
          el: $("#tab-list")
        return this

      render: (nodes) =>
        if @treeview then @treeview.render(nodes)

      clearWorkspace: () =>
        @treeview.render(false)

      initTabs: () =>
        @$el.tabs
          fx:
            opacity: 'toggle'
            duration: 100

        return this

      # Display nodes in sidebar when nodes are selected
      renderNodes: (nodes) =>
        removeExistingNodes = () =>
          if @node_views.length > 0
            #j override remove of NodeSidebarView to:
            # 1. unregister events on its model or anything else
            # 2. destroy nested views if any
            # 3. detach from the DOM(jquery will unregister events for you)
            _.each @node_views, (view) -> view.remove()
            #j remove references to the detached views
            @node_views = []

        removeExistingNodes()

        # Always start with an empty element
        $target = $("#tab-attribute")
        $target.html("")

        # If there is no nodes to show abort now
        if !nodes || nodes.length < 1
          return this

        for node in nodes
          ViewClass = switch node.constructor
            when ThreeNodes.nodes.models.DataSource then ThreeNodes.sidebar.nodes.DataSource
            when ThreeNodes.nodes.models.ModelStorage then ThreeNodes.sidebar.nodes.ModelStorage
            else ThreeNodes.NodeSidebarView
          view = new ViewClass
            model: node
            #el: $target
          $target.append(view.el)
          @node_views.push view

        # toggle the tabs
        @$el.tabs('option', 'active', 1)
        return this

      # toggle the tabs to new
      tabsNew: ->
        setTimeout =>
          @$el.tabs('option', 'active', 0)
        , 100

      filterListItem: ($item, value) =>
        s = $.trim($("a", $item).html()).toLowerCase()
        if s.indexOf(value) == -1
          $item.hide()
        else
          $item.show()

      filterList: (ul, value) =>
        self = this
        ul_title = ul.prev()
        has_visible_items = false

        $("li", ul).each () -> self.filterListItem($(this), value)

        if $("li:visible", ul).length == 0
          ul_title.hide()
        else
          ul_title.show()
        return this

      initSearch: () =>
        self = this
        $("#node_filter").keyup (e) ->
          v = $.trim($("#node_filter").val()).toLowerCase()
          if v == ""
            $("#tab-new li, #tab-new h3").show()
          else
            $("#tab-new ul").each () -> self.filterList($(this), v)
        return this

      initNewNode: () =>
        self = this
        $container = $("#tab-new")
        result = []
        # nodes_by_group could be an empty object but we define
        # inital groups to have a coherent ordering in sidebar
        nodes_by_group =
          BasicModules: []
          ControlFlow: []
          Dialogs: []
          PythonCalc: []
          Tabledata: []
          VisTrailsSpreadsheet: []
          Three: []
          Math: []
          PostProcessing: []
          Spread: []
          HTTP: []
          "Particle-sparks": []
          "Particle-sparks-initializers": []
          "Particle-sparks-actions": []
          "Particle-sparks-zone": []
          "Constructive-Geometry": []

        # Organize each node types by group
        for node of ThreeNodes.nodes.models
          # don't show hidden nodes types (group_name = false)
          if ThreeNodes.nodes.models[node].group_name
            group_name = (ThreeNodes.nodes.models[node].group_name).replace(/\./g, "-")
            if !nodes_by_group[group_name]
              nodes_by_group[group_name] = []
            nodes_by_group[group_name].push(node)

        # Render the buttons and add them to the dom
        for group of nodes_by_group
          $container.append("<h3>#{group}</h3><ul id='nodetype-#{group}'></ul>")
          for node in nodes_by_group[group]
            $("#nodetype-#{group}", $container).append("<li><a class='button' rel='#{node}' href='#'>#{ ThreeNodes.nodes.models[node].node_name }</a></li>")

        # Make the list of nodes draggable
        $("a.button", $container).draggable
          revert: "valid"
          opacity: 0.7
          helper: "clone"
          revertDuration: 0
          scroll: false
          containment: "document"

        return this
