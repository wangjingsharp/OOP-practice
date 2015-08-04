class window.Role extends window.Animate
	constructor: (@name, @sprite, @id)->
		super @name, @sprite, @id
		@key_manager = new KeyManager
		@mission_manager = new MissionManager
		@item_manager = new ItemManager
		@skill_manager = new SkillManager
		@hotkey_manager = new HotkeyManager
		@head = head.h001
		@money = 10000 # 持有金錢
		@realAspd = 100
		@realSpeed = 200
		@realAtk = 10
		@calculate()
		@skills = [
			[game.skill.s001, 0],
			[game.skill.s002, 0],
			[game.skill.s003, 0],
			[game.skill.s004, 0],
			[game.skill.s005, 0],
			[game.skill.s006, 0]
		]
		@skillpoint = 3
		return @
	talk: ()->
		sign = dir2sign @dir
		@npc = @map.findNpc @position[0] + sign[0], @position[1] + sign[1] if !@talking
		if @npc
			@npc.dir = sign2dir sign[0] * -1, sign[1] * -1
			if !@talking
				@npc.talkStart()
				@talking = 1
			else
				@npc.talk()

	move: ()->
		super();
		@npc = @map.touchNPC @position[0], @position[1] if !@talking
		if @npc and !@talking
			@npc.touch()
		
	attack: ()->

		sign = dir2sign @dir
		monster = @map.findMonster @position[0] + sign[0], @position[1] + sign[1]
		return if super(monster)
		game.audio.play({name: 'eff_00', loop: true});
		game.effect.e004.show @map, @position[0], @position[1], @dir
		monster.damage(@, @atk) if monster
		
	useSkill: ()->
		return if super()

	redraw: ()->
		@hp = 1 if @hp < 1
		@sprite.draw @position[0], @position[1], @action, @dir, @moment, @offset
		@head.draw @position[0], @position[1], @action, @dir, @moment, @offset
		@drawHp()
		@drawName()

	drawUI: ()->
		context = game.canvas.context
		context.textAlign = "left"
		context.fillStyle = '#FFF'
		context.fillRect 236, 10, 210, 18
		context.fillRect 222, 35, 210, 18
		context.fillRect 210, 64, 210, 18
		
		#hp
		context.fillStyle = '#ccc'
		context.fillRect 236, 10, 210, 18
		context.fillStyle = '#c90909'
		context.fillRect 236, 10, 210 * @hp / @maxHP, 18
		#mp
		context.fillStyle = '#ccc'
		context.fillRect 222, 35, 210, 18
		context.fillStyle = '#093b85'
		context.fillRect 222, 35, 210 * @mp / @maxMP, 18
		#exp
		context.fillStyle = '#ccc'
		context.fillRect 210, 64, 210, 18
		context.fillStyle = '#ce801b'
		context.fillRect 210, 64, 210 * @exp / @nextLvNeedExp, 18

		context.font = "18px Arial"
		context.fillStyle = "#FFF"
		context.fillText @hp + " / " + @maxHP, 250, 26
		context.fillText @mp + " / " + @maxMP, 240, 52
		context.fillText @exp + " / " + @nextLvNeedExp, 230, 80
		game.ui.drawUI(0,0)
		context.fillText @lv, 185, 109
		
		@hotkey_manager.redraw()
		for o,i in @statusList
			o[0].icon.drawUI(1150,200 + i * 60)
			context.globalAlpha = .3
			context.fillStyle = '#333'
			context.fillRect 1150,200 + i * 60, 40, Math.max(40 - 40 * (new Date().getTime() - o[2]) / o[1],0)
			context.globalAlpha = 1
			context.font = "12px Arial"
			context.textAlign = "center"
			context.fillStyle = "#000"
			context.fillText o[0].name, 1171,200+i*60+53
			context.fillStyle = "#FFF"
			context.fillText o[0].name, 1170,200+i*60+52
			
	skillup: ()->
		for skill in game.role.skills
			if skill == this && skill[1] < skill[0].maxLV
				skill[1]++
				game.role.skillpoint--
				game.role.skill_manager.redraw()
				return
	lvup: (i)->
		while(i--)
			game.effect.e037.show game.role.map, game.role.position[0], game.role.position[1], game.role.dir
			@realAtk += @lv
			@realAspd -= @lv / 5
			@realMaxHP += @lv *2
			@realMaxMP += @lv *2
			@realHit += 1
			@lv++
			@nextLvNeedExp = Math.floor(@nextLvNeedExp * 1.3)
			@skillpoint++
			@exp = 0
		
	getExp: (exp)->
		@exp += exp
		if @exp >= @nextLvNeedExp
			@lvup(1)