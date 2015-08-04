class window.Loader
	constructor: (@complate)->
		@list = []
		@index = 0

	add: (file)->
		@list.push "game_sample/javascript/" + file

	start: ()->
		@index = 0
		@next()

	next: ()->
		js = document.createElement("script")
		js.type = 'text/javascript';
		js.src = @list[@index];
		js.file = @list[@index];
		js.loader = this;
		js.onload = @afterLoadOne;
		document.getElementsByTagName('head')[0].appendChild(js);

	afterLoadOne: ()->
		@loader.index++
		if @loader.index < @loader.list.length
			@loader.next()
		else
			@loader.complate()

afterLoader = ()->
	# $("#login-warp").fadeIn();
	$("#login-warp").fadeOut();
	$("#game").fadeIn();
	game.init();
	return

loader = new Loader(afterLoader);
loader.add "jquery.js"
loader.add "login.js"
loader.add "base.js"
loader.add "collection.js"
loader.add "function.js"
loader.add "game.js"
loader.add "map.js"
loader.add "animate.js"
loader.add "sprite.js"
loader.add "astar.js"
loader.add "windows.js"
loader.add "monster.js"
loader.add "mission_quest.js"
loader.add "mission_gather.js"
loader.add "mission_tracing.js"
loader.add "mission.js"
loader.add "manager.js"
loader.add "role.js"
loader.add "map/prontera.js"
loader.add "sprite/job.js"
loader.add "sprite/monster.js"
loader.add "npc.js"
loader.add "npc_list.js"
loader.add "props.js"
loader.add "props_list.js"

loader.start();