class window.Map extends window.Base
	constructor: (@name, @width, @height, @data, @git, @objects, palettes, _objects)->
		@key = @name
		game.maps.add @
		@palette = []
		@monster_list = [
			["瘋兔", monster.m001,50, 5],
			["魔菇", monster.m002,50, 5],
			["食人花", monster.m003,50, 5],
			["狼", monster.m004,50, 5],
			["大腳熊", monster.m005,50, 5],
			["獸人戰士", monster.m006,50, 5],
			["巨石兵", monster.m007,50, 5],
			["天使波利", monster.m008,50, 5],
			["褐色方塊體", monster.m009,50, 5],
			["巴風特", monster.m010, 668000,2864],
			["波利", monster.m011,50, 5],
			["藍兔", monster.m012,65, 70],
			["蒼鷹男爵", monster.m013, 21000, 450],
			["赤焰小惡魔", monster.m014, 10579, 544],
			["獸人腐屍", monster.m015, 1908, 109],
			["獸人英雄", monster.m016, 80000, 1000],
			["蒼蠅", monster.m020, 57, 11],
			["青蛇", monster.m021, 217, 23],
			["磨卡", monster.m022, 468, 66],
			["蠍子", monster.m023, 150, 33],
			["女僕", monster.m024, 920, 390],
			["毒蛇", monster.m025, 8500, 380 ],
			["嗜血怪人", monster.m026, 14000, 800],
		]
		@monster = []
		@npc = []
		for palette,i in palettes
			@palette[i] = game.sprites.add new Sprite(palette)
			
		@object = []
		for o,i in _objects
			@object[i] = game.sprites.add new Sprite(o)


	redraw: ()->
		centerPosition = game.role.position
		for w in [centerPosition[0]-game.viewRange[0]-1..centerPosition[0]+game.viewRange[0]+1]
			for h in [centerPosition[1]-game.viewRange[1]-1..centerPosition[1]+game.viewRange[1]+1]
				continue if w < 0 || w >= @data.length-1 || h < 0 || h >= @data[w].length-1 || @data[w][h] == 0
				@data[h][w] = 1 if @data[h][w] <= 0
				@palette[@data[h][w]-1].draw w, h

		for object,i in @objects
			@object[object[2]-1].realDraw object[0],object[1]
		return


	drawFrontObject: ()->
		for object,i in @objects
			if object[1] + @object[object[2]-1].dom.height - 80 > game.role.position[1] * 40
				@object[object[2]-1].realDraw object[0],object[1]
		return

	findNpc: (x, y)->
		for npc in @npc
			if npc.position[0] == x and npc.position[1] == y
				return npc
		return null

	touchNPC: (x, y)->
		for npc in @npc
			if npc.position[0] + npc.range_x >= x and npc.position[0] - npc.range_x <= x and npc.position[1] + npc.range_y >= y and npc.position[1] - npc.range_y <= y
				return npc
		return null


	findMonster: (x, y)->
		for monster in @monster
			if monster.position[0] == x and monster.position[1] == y
				return monster
		return null

	findPath: ()->
		path = []
		for r, y in @git
			for c, x in r
				path.push [x, y] if c == 1
		return path

	search_path: (x, y, to_x, to_y)->
		path_choicse = [
			[3,4,5],
			[2,0,6],
			[1,0,7]
		];
		path = []
		_git = []
		for i,_y in @git[0]
			_git[_y] = []
		for i,_x in @git
			for j,_y in @git[x]
				_git[_y][_x] = @git[_x][_y]
		# bump
		#for monster in game.monster
		#	_git[monster.position[0]][monster.position[1]] = 0
		#for npc in game.npc
		#	_git[npc.position[0]][npc.position[1]] = 0
		#_git[game.role.position[0]][game.role.position[1]] = 0

		graph = new Graph _git
		return if (!graph.nodes[x][y]? || !graph.nodes[to_x]? || !graph.nodes[to_x][to_y]?)
		start = graph.nodes[x][y]
		end = graph.nodes[to_x][to_y]
		result = astar.search graph.nodes, start, end
		for node in result
			dx = Math.sign(node.x - x)
			dy = Math.sign(node.y - y)
			x = node.x
			y = node.y
			path.push path_choicse[dy+1][dx+1]
		return path

	createMonster: (time) ->
		path = @findPath()
		local = path[random(0, path.length)]
		time = 6000 if !time?

		@timeout () ->
			monster_idx = random 0, @monster_list.length
			monster = new Monster @monster_list[monster_idx][0], @monster_list[monster_idx][1] , @name, local[0], local[1]
			monster.realMaxHP = @monster_list[monster_idx][2]
			monster.maxHP = @monster_list[monster_idx][2]
			monster.hp = @monster_list[monster_idx][2]
			monster.exe = monster.hp / 2;
			monster.realAtk = @monster_list[monster_idx][3]
			monster.atk = @monster_list[monster_idx][3]
			red_water = new RedWater
			blue_water = new BlueWater
			monster.addGife red_water
			monster.addGife blue_water
		, time