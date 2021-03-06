
define [
  'Underscore',
  'Backbone',
  "timeline",
  "timeline-gui",
], (_, Backbone) ->
  #"use strict"

  ### Timeline View ###
  namespace "ThreeNodes",
    AppTimeline: class AppTimeline extends Backbone.View
      initialize: (options) =>
        super
        # reset canvas height
        localStorage["timeline.js.settings.canvasHeight"] = @$el.innerHeight()

        @$el.html("")
        self = this
        # @j: use the timeline lib, create an instance
        @timeline = new Timeline
          element: @el
          displayOnlySelected: true
          colorBackground: "#333"
          colorButtonBackground: "#222222"
          colorButtonStroke: "#777"
          colorScrollbar: "#373737"
          colorScrollbarThumb: "#555"
          colorTimelineLabel: "#999"
          colorTimelineTick: "#555"
          colorTimeScale: "#666"
          colorHeaderBorder: "#222"
          colorTimeTicker: "#f00"
          colorTrackBottomLine: "#555"
          colorPropertyLabel: "#999"
          # @j: override some of the event handlers
          onGuiSave: () =>
            self.trigger "OnUIResize"
          setPropertyValue: (propertyAnim, t) ->
            propertyAnim.target[propertyAnim.propertyName].setValue(t)
          applyPropertyValue: (propertyAnim, t) ->
            propertyAnim.target[propertyAnim.propertyName].setValue(propertyAnim.startValue + (propertyAnim.endValue - propertyAnim.startValue) * t)
          getPropertyValue: (propertyAnim) ->
            val = propertyAnim.target[propertyAnim.propertyName].attributes["value"]
            if $.type(val) != "array"
              return val
            else
              return val[0]
          onTrackRebuild: () => @trigger("trackRebuild")
          onStop: () => @trigger("stopSound")
          onPlay: (time) =>
            @trigger("startSound", time)
            @trigger("runWorkflow")

        Timeline.globalInstance = @timeline

        @timeline.loop(-1)
        @time = 0

        if options.ui
          @ui = options.ui
          @ui.on("render", @update)
          @ui.on("selectAnims", @selectAnims)
          @ui.on("timelineResize", @resize)

        @trigger("OnUIResize")

      # @j: a wrapper method for the selectAnims in tiemline lib,
      selectAnims: (nodes) =>
        if @timeline
          @timeline.selectAnims(nodes)

      onNodeRemove: (node) =>
        @selectAnims([])

      remove: () =>
        @undelegateEvents()

        if @ui
          @ui.off("render", @update)
          @ui.off("selectAnims", @selectAnims)
          @ui.off("timelineResize", @resize)
          delete @ui

        @timeline.destroy()
        delete @timeline
        @time = null
        # we don't want to remove the el since it is used by jquery-template
        # that's why we will not call super there
        #super

      resize: (height) =>
        if @timeline
          @timeline.canvasHeight = height
          @timeline.tracksScrollY = 0
          @timeline.tracksScrollThumbPos = 0
          @timeline.save()

      update: () =>
        n = Date.now()
        if @timeline
          dt = n - @time
          @timeline.update(dt / 1000)
        @time = n
