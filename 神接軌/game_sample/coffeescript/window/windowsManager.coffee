class window.WindowManager
	constructor: () ->
		@windows = []

	addWindow: (windows) ->
		if !(win = @findWindow windows)
			@windows.push windows

	removeWindow: (windows) ->
		@windows.delete windows
		windows.html.remove()
		windows = null

	findWindow: (windows) ->
		index = @windows.map (ele) ->
			return ele.name
		.indexOf windows
		if index != -1 then return @windows[index] else return false

	getFocusWindow: () ->
		for windows in @windows
			return windows if windows.focus
		return false

	setFocusWindow: (windows) ->
		for win in @windows
			win.focus = false
			win.removeClass 'focus'
		windows = @windows.indexOf windows
		@windows[windows].focus = true
		@windows[windows].addClass 'focus'

	removeFocusWindow: () ->
		windows = @getFocusWindow()
		@removeWindow windows if windows