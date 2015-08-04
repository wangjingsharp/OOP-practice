class window.Animate extends window.Base
	constructor: (@name, @sprite, @id)->
		@position = [0,0]
		@action_index = 0
		@offset = [0,0]
		@moment = 0
		@dir = 0
		@path = [0]
		@walk_timer = 0
		@target = [0,0]
		@lv = 1
		@healTimeout = @interval @recover, 1000
		@interval @calculate, 1000
		@attackDelaying = 0
		@action = 3
		@talking = 0
		@dieing = 0
		@walking = 0
		@skillCD = []
		@statusList = []
		
		@realFlee = 100
		@flee = 100
		
		@realHit = 80
		@hit = 80

		#能力相關
		@realSpeed = 400
		@speed = 400

		@realMaxHP = 100
		@maxHP = 100
		@hp = 100

		@realRecoverHP = 1
		@recoverHP = 0

		@realMaxMP = 100
		@maxMP = 100
		@mp = 100

		@realRecoverMP = 100
		@recoverMP = 0

		@realAtk = 10
		@atk = 0

		@realAspd = 300
		@aspd = 300

		@exp = 100
		@nextLvNeedExp = 100
		
		@realDef = 1
		@def = 0
	action_clear: ()->
		@offset = [0,0]
		clearTimeout @walkTimeout
		clearTimeout @subWalkTimeout
		clearTimeout @attackTimeout
		clearTimeout @damageTimeout
		clearTimeout @clearActimeTimeout
		@moving = 0
		@action = 3
		return

	die: ()->
		@dieing = 1
		@action = 0
		@timeout @died, 1000

	died: ()->
		@map.monster.splice @map.monster.indexOf(@), 1

	damage: (attack_target, damage)->
		if attack_target.hit / @flee < Math.random()
			game.text.showText "miss", "#FF0000", attack_target.map, attack_target.position[0], attack_target.position[1], [0, 0], [0,-2], 30
			return
		@action_clear()
		@action = 4
		@moment = 0
		dir = @dir % @sprite.rect[@action].length
		@timeout @action_clear, @sprite.rect[@action][dir].length * @aspd
		damage -= random(Math.floor(@def/2), @def)
		if @statusList?
			for o,i in @statusList
				if o[0].id == 8 #反射盾牌
					if o[3] > random(1,20)
						attack_target.damage(@, damage)
						return
		damage = 1 if damage < 1
		@hp -= damage;
		if @ == game.role
			game.text.showDamage(damage ,@map , @position[0], @position[1], "#FF0000")
		else
			game.text.showDamage(damage ,@map , @position[0], @position[1], "#FFFFFF")
		@attack_target = attack_target
		@die() if @hp < 0 and @dieing == 0
		@damage_sub()

	damage_sub: ()->
		dir = @dir % @sprite.rect[@action].length
		@moment = ++@moment % @sprite.rect[@action][dir].length
		@damageTimeout = @timeout @damage_sub, @aspd

	useSkill: ()->
		return 2 if !@hp
		return 3 if @moving
		return 4 if @attackDelaying
		@action_clear()
		@action = 2
		@moment = 0
		@attackDelaying = 1
		dir = @dir % @sprite.rect[@action].length
		@timeout @after_attack, @sprite.rect[@action][dir].length * @aspd
		@clearActimeTimeout = @timeout @action_clear, @sprite.rect[@action][dir].length * @aspd
		@attack_sub()
		return
		
	attack: (target)->
		return 2 if !@hp
		return 3 if @moving
		return 4 if @attackDelaying
		@action_clear()
		@action = 2
		@moment = 0
		@attackDelaying = 1
		dir = @dir % @sprite.rect[@action].length
		@timeout @after_attack, @sprite.rect[@action][dir].length * @aspd
		@clearActimeTimeout = @timeout @action_clear, @sprite.rect[@action][dir].length * @aspd
		@attack_sub()
		return

	after_attack: ()->
		@attackDelaying = 0

	attack_sub: ()->
		dir = @dir % @sprite.rect[@action].length
		@moment = ++@moment % @sprite.rect[@action][dir].length
		@attackTimeout = @timeout @attack_sub, @aspd
		return

	moveTo: (x, y)->
		return if @action != 3 && @action != 5
		return if !@hp
		@action = 5
		if !@moving
			dy = Math.sign(y - @position[1])
			dx = Math.sign(x - @position[0])
			@dir = sign2dir dx, dy
		return if !game.role.map.git[y]? || !game.role.map.git[y][x]?
		return if game.role.map.git[y][x] == 0
		return if @target[0] == x && @target[1] == y
		@target = [x,y]
		@path = path = @map.search_path(@position[0], @position[1], x, y);
		return if @path.length == 0
		@start_move() if !@moving

	start_move: ()->
		@move()
		@walk()
		@action = 5
		return

	move: ()->
		@moment = 0
		@moving = 1
		if @path.length == 0
			@action_clear()
			return
		@dir = @path[0]
		sign = dir2sign(@dir)
		@position[0] += sign[0]
		@position[1] += sign[1]
		@offset[0] = -1 * sign[0] * game.gridSize
		@offset[1] = -1 * sign[1] * game.gridSize
		@path.shift()
		@walkTimeout = @timeout @move, @speed

	walk: ()->
		dir = @dir % @sprite.rect[@action].length
		@moment = ++@moment % @sprite.rect[@action][dir].length
		sign = dir2sign(@dir)
		@offset[0] += sign[0] * game.gridSize / @sprite.rect[@action][dir].length
		@offset[1] += sign[1] * game.gridSize / @sprite.rect[@action][dir].length
		@subWalkTimeout = @timeout @walk, @speed / @sprite.rect[@action][dir].length
		return

	wrapTo: (x, y)->
		@position = [x, y]
		return

	redraw: ()->
		@sprite.draw @position[0], @position[1], @action, @dir, @moment, @offset
		@drawHp()
		@drawName()

	drawHp: ()->
		if @hp >= 0
			position = getRealPosition(@position[0], @position[1], @offset);
			context = game.canvas.context
			context.fillStyle = 'black'
			context.fillRect position[0]-1, position[1] + game.gridSize-1, game.gridSize+2, 7
			context.fillStyle = 'green'
			context.fillStyle = 'red' if (@hp / @maxHP) < 0.1
			context.fillRect position[0], position[1] + game.gridSize, (game.gridSize * (@hp/@maxHP)), 5

	drawName: ()->
		position = getRealPosition(@position[0], @position[1], @offset);
		context = game.canvas.context
		context.font = "12px Arial"
		name_length = @name.length
		name_length *= 12
		name_length /= 2
		context.fillStyle = "black"
		context.textAlign = "center"
		context.fillText @name, position[0] + (game.gridSize/2), position[1] + game.gridSize + 18 + 1
		context.fillText @name, position[0] + (game.gridSize/2), position[1] + game.gridSize + 18 - 1
		context.fillText @name, position[0] + (game.gridSize/2)-1, position[1] + game.gridSize + 18
		context.fillText @name, position[0] + (game.gridSize/2)+1, position[1] + game.gridSize + 18
		context.fillStyle = "white"
		context.fillText @name, position[0] + (game.gridSize/2), position[1] + game.gridSize + 18
		
	heal: (hp, mp)->
		mp = 0 if !mp?
		if hp
			@hp += hp
			@hp = @maxHP if @hp > @maxHP
			game.text.showText hp, "#01814A", @map, @position[0], @position[1], [0, 0], [0,-2], 30
			
		if mp
			@mp += mp
			@mp = @maxMP if @mp > @maxMP
			game.text.showText mp, "#8600FF", @map, @position[0], @position[1], [0, 20], [0,-2], 30
		return
		
	recover: ()->
		if @hp != -1
			@hp += @recoverHP
			@hp = @maxHP if @hp > @maxHP
			
		@mp += @recoverMP
		@mp = @maxMP if @mp > @maxMP

	calculate: ()->
		@speed = @realSpeed
		@atk = @realAtk
		@aspd = @realAspd
		@maxHP = @realMaxHP
		@maxMP = @realMaxMP
		@recoverHP = @realRecoverHP
		@recoverMP = @realRecoverMP
		@hit = @realHit
		@flee = @realFlee
		@def = @realDef
		deleteList = []
		if @statusList?
			for o,i in @statusList
				o[0].fn(@, o[3])
				if new Date().getTime() - o[2] > o[1]
					deleteList.push i

		for i in deleteList
			@statusList.splice i, 1