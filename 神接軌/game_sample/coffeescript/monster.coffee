class window.Monster extends window.Animate
	constructor: (@name, @sprite, @mapname, x, y)->
		super(@name, @sprite)
		@map = game.maps.data[@mapname]
		@key = @name
		@position = [x,y]
		@gifes = []
		@initiative = 0 # 主動怪設定, 1:主動, 0:被動
		@range = 10
		@atk = 1
		@autoMove()
		@interval_id = @interval @autoMove, 1500 + random(0,1000)
		@exp = 10
		@map.monster.push @

	die: ()->
		super()
		game.role.mission_manager.killMonster @name
		game.role.getExp(@exp)
		clearInterval @interval_id
		for gife in @gifes
			game.role.item_manager.addItem gife if random(0, 2) == 1
		@map.createMonster()
		return
		
	died: ()->
		super()
		delete @
		
	autoMove: ()->
		if @initiative == 1
			role_position = game.role.position
			diff = Math.sqrt(Math.pow(role_position[0] - @position[0], 2) + Math.pow(role_position[1] - @position[1], 2))
			if diff < @range then @attack_target = game.role else @attack_target = null
		
		loop
			x = @position[0] + parseInt(Math.random() * 7) - 3
			y = @position[1] + parseInt(Math.random() * 7) - 3
			break if !(x>=0 && y>=0 && x<@map.width && y<@map.height && @map.git[x][y] == 0)
		sign = [0,0]
		if @attack_target?
		 	x = @attack_target.position[0]
		 	y = @attack_target.position[1]
		 	min_length = 1000
		 	for dir in [0,2,4,6]
		 		sign = dir2sign(dir)
		 		continue if !@map.git[@position[0]+sign[0]]? || !@map.git[@position[0]+sign[0]][@position[1]+sign[1]]
		 		_length = distance(@position[0], @position[1], x+sign[0], y+sign[1])
		 		if (_length < min_length)
		 			min_length = _length
		 			min_dir = dir
		 	sign = dir2sign(min_dir)
			if (min_length == 0)
				@attack(@)
				@attack_target.damage(@, @atk)
		@moveTo x+sign[0], y+sign[1]

	addGife: (item)->
		@gifes.push item