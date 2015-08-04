class window.Windows extends BaseWindow
	constructor: (@width, @height, @name) ->
		@windows_manager = game.windows_manager
		if win = @windows_manager.findWindow @name
			win.setMsg ''
			return win 
		super 'win'
		@focus = false

		@title = new Row '', 'title'
		@title.appendTo @
		@title.setHeight 20 if !name?
		@setTitle name if name?

		that = @
		close = $("<div>")
		close
			.css "position", "absolute"
			.css "bottom", "0"
			.css "right", "0"
			.css "color", "#FFF"
			.css "background-image", "url(images/icon/close.png)"
			.css "height", "20px"
			.css "width", "20px"
			.css "background-repeat", "no-repeat"
			.css "cursor", "url(images/cursor/worldmap_cursor.png)"
		close.on "click", (e) ->
			that.hide()
		$(@title.html)
			.css "position", "relative"
			.append(close)

		@title.addEvent 'mousedown', @dragStart, @
		document.body.addEventListener 'mousemove', () -> that.dragMove.call(that)
		@title.addEvent 'mouseup', @dragEnd, @
		@html.style.left = (window.innerWidth / 2) + "px";
		@html.style.top = (window.innerHeight / 2) + "px";
		@html.style.marginLeft = -(@width / 2) + "px";
		@html.style.marginTop = -(@height / 2) + "px";
		@addEvent 'mousedown', @focusWindow

		@main = new Main
		@main.html.style.width = "#{@width}px"
		@main.html.style.height = "#{@height}px"
		@main.appendTo @

		@footer = new Row '', 'footer'
		@footer.appendTo @

		@next_button = new Button 'next'
		@next_button.appendTo @footer
		@next_button.hide()

		@node = null
		@options = []
		@selectIndex = 0
		@offset = []
		@draging = false
		@windows_manager.addWindow @
		@focusWindow()
		document.body.appendChild @html

	show: () ->
		super()
		@focusWindow()

	close: () ->
		@windows_manager.removeWindow @
		@html.remove()

	focusWindow: () ->
		@windows_manager.setFocusWindow @

	dragStart: (e) ->
		e = window.event if !e?
		if $(e.target).hasClass('title')
			@html.style.opacity = .5;
			@draging = true
			@offset = [e.offsetX + 3, e.offsetY + 3]

	dragMove: (e) ->
		return if !@draging
		e = window.event if !e?
		document.body.className = 'select-close'
		mouseX = e.clientX
		mouseY = e.clientY
		@html.style.marginLeft = 0
		@html.style.marginTop = 0
		@html.style.left = (Number(mouseX) - Number(@offset[0])) + "px"
		@html.style.top = (Number(mouseY) - Number(@offset[1])) + "px"

	dragEnd: (e) ->
		@draging = false
		@html.style.opacity = 1;
		
	setTitle: (title) ->
		@title.setMsg title

	setMsg: (msg) ->
		@main.setMsg msg

	addOption: (@msg, node, that) ->
		@next_button.hide()
		option = new Options @msg, node, that, @
		$(option.html).data("idx", @options.length)
		option.appendTo @main
		@options.push option
		@node = @options[0].node
		# @options[0].addClass 'active'

		return option

	clearOption: () ->
		@next_button.show()
		@options = []

	select: (selectIndex) ->
		return if @options.length <= 0
		for option in @options
			option.removeClass 'active'
		selectIndex = @options.length - 1 if selectIndex >= @options.length
		selectIndex = 0 if selectIndex < 0
		@node = @options[selectIndex].node
		@options[selectIndex].addClass 'active'
		return selectIndex
