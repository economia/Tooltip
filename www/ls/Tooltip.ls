window.Tooltip = class Tooltip
    (@options = {}) ->
        @options.parent ?= $ 'body'
        @createElement!
        $ document .bind \mousemove @onMouseMove
        $ document .bind \touchstart @onTouch

    watchElements: ->
        $ document .on \mouseover "[data-tooltip]" ({currentTarget}:evt) ~>
            content = $ currentTarget .attr 'data-tooltip'
            content = unescape content
            return if not content.length
            $content = $ "<p></p>"
                ..addClass 'only-child'
                ..html content
            @display $content

        $ document .on \mouseout "[data-tooltip]" @~hide

    display: ($content, mouseEvent) ->
        @$element.empty!
        @$element
            ..append $content
            ..appendTo @options.parent

        @setPosition!

    hide: ->
        @$element.detach!
        @mouseBound = false

    reposition: ([left, top, clientLeft = 0, clientTop = 0]) ->
        dX = left - clientLeft
        dY = top - clientTop
        width = @$element.width!
        left -= width / 2
        maxLeft = $ window .width! - width - 10
        top -= @$element.height!
        left = Math.max dX + 12, left
        left = Math.min left, dX + maxLeft
        if top <= 19 + dY
            topMargin = parseInt @$element.css 'margin-top'
            top += @$element.height! - 2 * topMargin
        @$element
            ..css 'left' left
            ..css 'top' top

    createElement: ->
        @$element = $ "<div class='tooltip' />"

    setPosition: ->
        if @options.positionElement
            @setPositionByElement!
        else
            @setPositionByMouse!

    setPositionByElement: ->
        $parent = @options.positionElement
        {left, top} = $parent.offset!
        left += @options.positionElement.width! / 2
        @reposition [left, top]

    setPositionByMouse: ->
        @mouseBound = true
        @reposition @lastMousePosition if @lastMousePosition

    onMouseMove: (evt) ~>
        @lastMousePosition = [evt.pageX, evt.pageY, evt.clientX, evt.clientY]
        if @mouseBound then @reposition @lastMousePosition

    onTouch: (evt) ~>
        @onMouseMove evt.originalEvent
