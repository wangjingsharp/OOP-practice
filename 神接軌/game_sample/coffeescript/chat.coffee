class window.Chat
	constructor: () ->
		width = 500
		height = 300
		canvas = $("#__game_canvas__")
		@html = $("<div>")
		@html.addClass("chat")
		@html.width(width).height(height)
		@chat_view = $("<div>")
		@send_view = $("<div>")
		form = $("<form>")
		input = $("<input type='text' id='chat-send-msg' autocomplete='off'>")
		send = $("<button type='submit' class='send'>").html("送出")
		that = @
		form.on "submit", ()->
			that.sendMsg input.val()
			input.val ""
			return false

		input
			.on "blur", ()->
				that.html.removeClass "active-chat"
				$("#hidden-text").remove()
			.on "focus", ()->
				that.html.addClass "active-chat"
			.css "border", "none"

		$(window).resize ()->
			that.html.css "left", (window.innerWidth - canvas.width()) / 2

		if (window.innerHeight > canvas.height()) 
			_h = window.innerHeight - canvas.height()
		else
			_h = 0
		
		@html
			.css "left", (window.innerWidth - canvas.width()) / 2
			.css "bottom", _h
		@chat_view
			.css "height", height - 35
			.css "overflow-y", "scroll"
		@send_view
			.css "position", "absolute"
			.css "bottom", "5px"
		input
			.css "margin", "0"
			.css "border-radius", "3px 0 0 3px"
			.css "width", width - 50
		send
			.css "padding", "0 8px"
			.css "vertical-align", "top"
			.css "border", "none"
			.css "border-left", "1px solid #999"
			.css "border-radius", "0 3px 3px 0"
			.css "line-height", "25px"
			.css "height", "25px"

		form.append(input).append(send)
		@send_view.append(form)
		@html
			.append(@chat_view)
			.append(@send_view)

		@html.appendTo($("body"))
	sendMsg: (msg) ->
		return if !msg? || msg == ""

		tim = new Date();
		if (msg.substr(0, 1) == "@")
			eval "game.role." + msg.substr(1)
		else
			socket.emit 'ReceiveChat'
			, {
				name: game.role.name,
				msg: msg
			}
		return
		
	receiveMsg: (option) ->
		if option.name == game.role.name
			game.text.msg option.msg, game.role
		else
			for user in game.users
				if user.name == option.name
					game.text.msg option.msg, user
		row = $("<div class='row'>")
		time = $("<span class='time'>")
		name = $("<span class='name'>")
		msg = $("<span class='msg'>")
		time.html "[#{option.time}]"
		name.html "#{option.name}:"
		msg.html "#{option.msg}"
		row.append(time).append(name).append(msg)
		@chat_view.append row
		@chat_view.scrollTop @chat_view.scrollTop() + @chat_view.height()
