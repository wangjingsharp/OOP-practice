class window.HotkeyManager
	constructor: ()->
		@data = []
		@win = new Windows 100, 200, '快捷鍵設置'
		@win.hide()
		@win.next_button.hide()
		@win.addOption "X", @complateSet, "X"
		@win.addOption "C", @complateSet, "C"
		@win.addOption "A", @complateSet, "A"
		@win.addOption "S", @complateSet, "S"
		@win.addOption "D", @complateSet, "D"
		@win.addOption "F", @complateSet, "F"
		@ui = new Sprite "/images/ui/hotkey.png"

	set:()->
		that = game.role.hotkey_manager
		that.win.next_button.hide()
		that.catch = this
		that.win.show()
		
	complateSet: ()->
		that = game.role.hotkey_manager
		that.data[this[0]] = that.catch[0]
		that.win.hide()
		
	use: (key)->
		return if !@data[key]
		if @data[key].constructor.name == 'skill'
			for skill in game.role.skills
				if skill[0] == @data[key]
					skill[0].use(game.role, skill[1])
		else if @data[key] instanceof window.Props
			for item, k in game.role.item_manager.items
				if item.item == @data[key]
					if game.role.item_manager.items[k].amount
						game.role.item_manager.items[k].amount--
						item.item.use()
						game.role.item_manager.reviewItems()
		return
		
	redraw: ()->
		context = game.canvas.context
		@ui.drawUI(500,0)
		hotkey = ["X", "C", "A", "S", "D", "F"]
		hotkey_x = [505, 549, 593, 637, 681, 726]
		context.font = "16px Arial"
		for key,i in hotkey
			context.fillStyle = "#000"
			context.fillText key, hotkey_x[i] + 16, 41
			context.fillStyle = "#FFF"
			context.fillText key, hotkey_x[i] + 15, 40
			if @data[key]?
				@data[key].sprite.drawUI hotkey_x[i], 5, 40, 40

			if @data[key] instanceof window.Props
				amount = 0
				for item, k in game.role.item_manager.items
					if item.item == @data[key]
						if game.role.item_manager.items[k].amount
							amount = game.role.item_manager.items[k].amount
				context.fillStyle = "#000"
				context.fillText amount, hotkey_x[i] + 16, 41
				context.fillStyle = "#FFF"
				context.fillText amount, hotkey_x[i] + 15, 40
				
		
		
		
class window.SkillManager
	constructor: ()->
		@win = new Windows 350, 400, '技能視窗'
		@win.hide()
		
	show: ()->
		if @win.isHide()
			@win.show()
			@redraw()
		else
			@win.hide()
	redraw: ()->
		@win.setMsg ""
		for skill in game.role.skills
			if game.role.skillpoint 
				block = new SkillBlock "/images/icon/add.png", skill[0].name, skill[0].description, skill[1], skill[0].maxLV
				block.addEvent "dblclick", game.role.skillup, skill
			else
				block = new SkillBlock skill[0].icon, skill[0].name, skill[0].description, skill[1], skill[0].maxLV
				block.addEvent "dblclick", game.role.hotkey_manager.set, skill
			block.appendTo @win.main
		block = new Block '技能點數 : ' + game.role.skillpoint
		block.addClass "skillpoint"
		block.appendTo @win.main
			
class window.skill extends window.Base
	constructor: (option)->
		@sprite = new Sprite option.icon
		for k,v of option
			this[k] = v

	start: (self, lv)->

	use: (self, lv)->
		return if self.skillCD[@id] > new Date().getTime()
		return if self.mp < this.mp
		@start(self,lv)
		self.mp -= this.mp
		self.skillCD[@id] = new Date().getTime() + @cd
		self.useSkill()
		if @rangeType == "front"
			@skillDamageTimer = 0
			@damageInterval = @interval @_damageFront, @speed, self, self.dir, lv
			@timeout @clear, @speed * (@range + 1)

		else if @rangeType == "selfAround"
			@skillDamageTimer = 0
			game.skill.s003.use(game.role, 10)
			@damageInterval = @interval @_damageAround, @speed, self, self.dir, lv
			@timeout @clear, @speed * (@range + 1)

	clear: ()->
		clearInterval @damageInterval
		
	_damageFront: (self, dir, lv)->
		@skillDamageTimer++
		sign = dir2sign(dir)
		monster = self.map.findMonster self.position[0] + sign[0] * @skillDamageTimer, self.position[1] + sign[1] * @skillDamageTimer
		@damage(self, lv, [monster]) if monster

	_damageAround: (self, dir, lv)->
		# 0
			
		# 111
		# 101
		# 111

		# 22222
		# 21112
		# 21012
		# 21112
		# 22222
		monsters = []
		if @skillDamageTimer == 0
			monster = self.map.findMonster self.position[0] , self.position[1]
			@damage(self, lv, [monster]) if monster
		else 
			#最上面那行 和最下面那行	
			for x in [self.position[0]-@skillDamageTimer..self.position[0]+@skillDamageTimer]
				monster = self.map.findMonster x , self.position[1]-@skillDamageTimer
				monsters.push monster if monster
				monster = self.map.findMonster x , self.position[1]+@skillDamageTimer
				monsters.push monster if monster
			#左右
			for y in [self.position[1]-@skillDamageTimer+1..self.position[1]+@skillDamageTimer-1]
				monster = self.map.findMonster self.position[0]-@skillDamageTimer, y
				monsters.push monster if monster
				monster = self.map.findMonster self.position[0]+@skillDamageTimer, y
				monsters.push monster if monster
			@damage(self, lv, monsters) if monsters.length > 0
		@skillDamageTimer++

game.skill = {}
game.skill.s001 = new window.skill {
	id: 1,
	name: "狂擊",
	description: "將全身精氣纏繞於劍上, 發出奮力一擊",
	maxLV: 10,
	icon: "/images/icon/sm_bash.png"
	type: "active", #active 主動技能/passive 被動技能
	target: "enemy", #enemy敵人 /self自己/ friend友方
	rangeType: "front", #front前方, selfAround以自己中心, self自己, party組隊, nearestEnemy最近的敵人
	range: 2,
	mp: 10,
	cd: 1000,
	speed: 100,
	start: (self, lv)->
		sign = dir2sign(self.dir)
		game.effect.e003.show(self.map, self.position[0], self.position[1] , self.dir)
	,
	damage: (self, lv, targets)->
		for target in targets
			target.damage(self, Math.ceil(self.atk * lv * (100 + random(-20,20)) / 100))
}
game.skill.s002 = new window.skill {
	id: 2,
	name: "加速術",
	description : "提身自身移動速度",
	maxLV: 10,
	icon: "/images/icon/al_incagi.png"
	type: "active", #active 主動技能/passive 被動技能
	target: "self", #enemy敵人 /self自己/ friend友方
	rangeType: "self", #front前方, selfArounc以自己中心, self自己, party組隊, nearestEnemy最近的敵人
	range: 5,
	mp: 10,
	cd: 1000,
	speed: 10,
	start: (self, lv)->
		game.effect.e001.show(self.map, self.position[0], self.position[1], self.dir)
		game.status.s001.use(self, 10000+lv*1000, lv)
}

game.skill.s003 = new window.skill {
	id: 3,
	name: "緩速速",
	description: "造成周圍的怪物移動速度減緩",
	maxLV: 1,
	icon: "/images/icon/al_decagi.png",
	type: "active",
	target: "enemy",
	rangeType: "selfAround",
	range: 3,
	mp: 10,
	cd: 1000,
	speed: 10,
	start: (self, lv)->
		game.effect.e011.show self.map, self.position[0], self.position[1], 0
	damage: (self, lv, targets)->
		for target in targets
			game.effect.e000.show(target.map, target.position[0], target.position[1], 0)
			game.status.s005.use(target, 5000+lv*500)
}  

game.skill.s004 = new window.skill {
	id: 4,
	name: "天使之障壁",
	description: "提升自身防禦力",
	maxLV: 10,
	icon: "/images/icon/al_angelus.png",
	type: "active",
	target: "self",
	rangType: "self",
	range: 0,
	mp: 10,
	start: (self, lv)->
		game.effect.e002.show(self.map, self.position[0], self.position[1], 0)
		game.status.s006.use self, 10000 + lv * 1000, lv
}

game.skill.s005 = new window.skill {
	id: 5,
	name: "天使之賜福",
	description: "提升自身攻擊力/迴避率/命中率/血量",
	maxLV: 10,
	icon: "/images/icon/al_blessing.png",
	type: "active",
	target: "self",
	rangType: "self",
	range: 0,
	mp: 10,
	start: (self, lv)->
		game.effect.e010.show(self.map, self.position[0], self.position[1], 0)
		game.status.s007.use self, 10000 + lv * 3000, lv
}

game.skill.s006 = new window.skill {
	id: 6, 
	name: "反射盾",
	description: "受到攻擊時有機率將傷害反彈",
	maxLV: 10,
	icon: "/images/icon/cr_reflectshield.png",
	type: "active",
	target: "self",
	rangType: "self",
	range: 0,
	mp: 10,
	start: (self, lv)->
		game.effect.e053.show(self.map, self.position[0], self.position[1], 0)
		game.status.s008.use self, 10000 + lv * 10000, lv
}
