class status extends window.Base
	constructor: (@name, @id, icon, @fn)->
		@icon = new Sprite(icon)

	use: (self, time, arg)->
		arg = 0 if !arg?
		for o in self.statusList
			if o[0].id == @id
				o[2] = new Date().getTime()
				o[3] = arg
				return
		self.statusList.push [@, time, new Date().getTime(), arg]
		self.calculate()

game.status = {}
game.status.s001 = new status "加速術", 1, "images/status/agiup.png", (self, arg)->
	self.speed -= 50 + 10 * arg

game.status.s002 = new status "回血加速", 2, "images/status/healup.png", (self)->
	self.recoverHP += 5

game.status.s003 = new status "血量增加", 3, "images/status/hpup.png", (self)->
	self.maxHP += 20

game.status.s004 = new status "回魔加速", 4, "", (self)->
	self.recoverMP += 5

game.status.s005 = new status "緩速術", 5, "", (self)->
	self.speed += 70

game.status.s006 = new status "天使之障壁", 6, "images/icon/al_angelus.png", (self, arg)->
	self.def += arg * 3

game.status.s007 = new status "天使之賜福", 7, "images/icon/al_blessing.png", (self, arg)->
	self.atk += arg
	self.hit += arg
	self.flee += arg
	self.maxHP += arg
	
game.status.s008 = new status "反射盾", 8, "images/icon/cr_reflectshield.png", (self, arg)->