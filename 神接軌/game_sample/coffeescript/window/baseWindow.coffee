class window.BaseWindow
	constructor: (cls) ->
		@html = document.createElement('div')
		@addClass cls
		@events = []
		@init()

	init: () ->
		@childrens = []

	setMsg: (msg) ->
		@html.innerHTML = msg

	addClass: (cls) ->
		@html.className += " #{cls}"

	removeClass: (cls) ->
		clsname = @html.className.split(cls)
		@html.className = ""
		for cls in clsname
			@html.className += cls

	appendTo: (parent) ->
		parent.childrens.push @
		parent.html.appendChild @html

	show: () ->
		@html.style.display = "block"

	hide: () ->
		@html.style.display = "none"

	isHide: () ->
		return @html.style.display == "none"

	close: () ->
		@html.remove()

	setHeight: (@height) ->
		@html.style.height = "#{@height}px"

	addEvent: (handler, fn, that) ->
		that = @ if !that?
		if !@isEvent handler
			@html.addEventListener handler, () -> 
				fn.call(that)
			, false
			@events.push handler

	removeEvent: (handler) ->
		@html.removeEventListener handler

	isEvent: (handler) ->
		return @events.indexOf(handler) != -1