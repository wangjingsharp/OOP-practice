class window.MyGame extends Framework.Level

	timeout: (fn, time)->
		that = this
		args = (arguments[i] for i in [2..arguments.length])
		return setTimeout ()->
			fn.apply(that, args)
		, time
		
	interval: (fn, time)->
		that = this
		args = (arguments[i] for i in [2..arguments.length])
		return setInterval ()->
			fn.apply(that, args)
		, time
		
	constructor: ()->
		@maps = new Collection()
		@sprites = new Collection()
		@windows_manager = new WindowManager()
		@monster = []
		@npc = []
		@viewRange = [15,10]
		@gridSize = 40
		@fps = 0
		@users = []
		@keydowning = 0
		@rootScene = {
			update: ()->
			draw: ()->
		}
		this.audio = new Framework.Audio({
			bg: {mp3: define.musicPath + "115.mp3"},
			eff_00: { wav: define.musicPath + 'eff_00.wav', },
			eff_01: { wav: define.musicPath + 'eff_01.wav', },
			eff_02: { wav: define.musicPath + 'eff_02.wav', },
			eff_03: { wav: define.musicPath + 'eff_03.wav', },
			eff_04: { wav: define.musicPath + 'eff_04.wav', },
			eff_05: { wav: define.musicPath + 'eff_05.wav', },
			eff_06: { wav: define.musicPath + 'eff_06.wav', },
			eff_07: { wav: define.musicPath + 'eff_07.wav', },
			eff_08: { wav: define.musicPath + 'eff_08.wav', },
			eff_09: { wav: define.musicPath + 'eff_09.wav', },
		});

		this.audio.play({name: 'bg', loop: true});

	initialize: ()->
		@canvas = document.getElementById("__game_canvas__")
		@canvas.context = @canvas.getContext("2d")
		if @role_name
			game.role = new Role(@role_name, job.Swordsman, @role_id)
		else
			game.role = new Role("主角", job.Swordsman)
		window.npcCreate()
		@ui = new Sprite "images/ui/lt.png"
		@chat = new Chat
		game.role.map = game.maps.data['rock']
		game.role.mapname = 'rock'

		for i in [1..20]
			game.maps.data['prontera'].createMonster(0)

		game.role.position = [5, 10]

	keydown: (e, list)->
		return if $("#chat-send-msg").is(":focus") && e.key != "Enter"
		return if @keydowning
		# 解決按一下觸發兩次
		@keydowning = 1
		that = @
		@timeout ()->
			that.keydowning = 0
		, 100
		role = game.role
		position = role.position
		switch e.key
			when "Left" # -> left
				if role.dir != 2
					role.dir = 2
					role.action_clear()
					return
				role.moveTo(position[0]-1, position[1]) if !role.npc?

			when "Up" # -> up
				if role.dir != 4
					role.dir = 4
					role.action_clear()
					return
				role.moveTo(position[0], position[1]-1) if !role.npc?
				role.npc.selectOptions('top') if role.npc?

			when "Right" # -> right
				if role.dir != 6
					role.dir = 6
					role.action_clear()
					return
				role.moveTo(position[0]+1, position[1]) if !role.npc?

			when "Down" # -> down
				if role.dir != 0
					role.dir = 0
					role.action_clear()
					return
				role.moveTo(position[0], position[1]+1) if !role.npc?
				role.npc.selectOptions('down') if role.npc?

			when "Z"
				role.attack()
				role.talk()
				
			when "X"
				game.role.hotkey_manager.use("X")

			when "C"
				game.role.hotkey_manager.use("C")

			when "A"
				game.role.hotkey_manager.use("A")

			when "S"
				game.role.hotkey_manager.use("S")
				
			when "D"
				game.role.hotkey_manager.use("D")

			when "O"
				game.role.key_manager.show()
				
			when "Q" # open mission list -> q
				role.mission_manager.showMissions()

			when "I" # open items -> i
				role.item_manager.showItems()

			when "K" # open skill -> k
				role.skill_manager.show()
				
			when "M"
				for monster in role.map.monster
					game.effect.e045.show game.role.map, monster.position[0], monster.position[1], monster.dir
					monster.die()

			when "Enter"
				if $(".chat").hasClass('active-chat') && $("#chat-send-msg").val() == ""
					$("#hidden-text").focus().remove()
					$(window).scrollTop(0)
				else
					$(".chat #chat-send-msg").focus()
					$("body").append($("<input type='text' id='hidden-text'>").css("opacity", 0))
			#when "Esc" # close window -> Esc
			#	@windows_manager.removeFocusWindow()
	update:()->
	
	redraw: ()->
		@draw()
		
	draw: ()->
		@canvas.context.fillStyle = "#FFFFFF"
		@canvas.context.clearRect(0,0,$(@canvas).width(),$(@canvas).height())
		@role.map.redraw()
		@role.redraw()
		for user in @users
			user.redraw() if user.name != game.role.name
		for monster in @role.map.monster
			monster.redraw()
		for npc in @role.map.npc
			npc.redraw()
		@role.map.drawFrontObject()
		@effectController.redraw()
		@role.drawUI()
		@text.redraw()

	drag: (e)->
		e = event if !e?
		e.dataTransfer.setData "Text", {
			a: this
		}

window.game = new MyGame()