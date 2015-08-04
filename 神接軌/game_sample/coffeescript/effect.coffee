
class effectController extends window.Base
	constructor: ()->
		@list = []
		@interval @timer, 100
	add: (effect, map, x, y, dir)->
		@list.push [effect, map, x, y, dir, 0, 0]
		return
	timer: ()->
		removeList = []
		for item,i in @list
			effect = item[0]
			dir = item[4] % effect.timeline.length
			counter = item[6]
			timeline = effect.timeline[dir]
			if typeof timeline[@list[i][5]] == "undefined"
				removeList.push i
			else if ++@list[i][6] >= timeline[ @list[i][5] ][3]
				@list[i][6]=0
				@list[i][5]++
				if @list[i][5] == timeline.length
					removeList.push i
				else if timeline[@list[i][5]][0] == -1
					@list[i][6]=0
					@list[i][5]=0 
		for i in removeList
			@list.splice i,1
		return
	redraw: ()->
		for item in @list
			effect = item[0]
			dir = item[4] % effect.timeline.length
			map = item[1]
			x = item[2]
			y = item[3]
			moment = item[5]
			timeline = effect.timeline[dir]
			if map == game.role.map && timeline[moment]?
				image = effect.image[ timeline[moment][0] ]
				if timeline[moment][4] == 1
					image.draw x, y, -2, 0, 0, [(-image.dom.width/2+20)/2 + timeline[moment][1] + effect.offset[0], (20-image.dom.height/2)/2 + timeline[moment][2] + effect.offset[1]]
				else if timeline[moment][4] == 2
					image.draw x, y, -3, 0, 0, [(-image.dom.width/2+20)/2 + timeline[moment][1] + effect.offset[0], (20-image.dom.height/2)/2 + timeline[moment][2] + effect.offset[1]]
				else
					image.draw x, y, -1, 0, 0, [(-image.dom.width/2+20)/2 + timeline[moment][1] + effect.offset[0], (20-image.dom.height/2)/2 + timeline[moment][2] + effect.offset[1]] 
		return
		
game.effectController = new effectController()
class effect
	constructor: (content)->
		@image = []
		for image in content.images
			@image.push new Sprite("images/effect/#{image}")
		@timeline = content.timeline
		if content.offset?
			@offset = content.offset
		else
			@offset = [0,0]
		if @timeline.length == 0
			@timeline[0] = []
			for k, v in @image
				@timeline[0].push [v,0,0,1]
	show: (map, x, y, dir)->
		game.effectController.add(@, map, x, y, dir)
		return
game.effect = {}
game.effect.e000 = new effect {
	images: [
	    "agidown_effect00.png",
	    "agidown_effect01.png",
	    "agidown_effect02.png",
	    "agidown_effect03.png",
	    "agidown_effect04.png"
	],
	timeline: [[
		[0,0,0,1],
		[1,0,0,1],
		[2,0,0,1],
		[3,0,0,1],
		[4,0,0,1]
	]]
}
game.effect.e001 = new effect {
	images: [
	    "agiup_effect00.png",
	    "agiup_effect01.png",
	    "agiup_effect02.png",
	    "agiup_effect03.png",
	    "agiup_effect04.png"
	],
	timeline: [[
		[0,0,0,1],
		[1,0,0,1],
		[2,0,0,1],
		[3,0,0,1],
		[4,0,0,1]
	]]
}
game.effect.e002 = new effect {
	offset: [0, -40],
	images: [
	    "angellus_effect00.png",
	    "angellus_effect01.png",
	    "angellus_effect02.png",
	    "angellus_effect03.png",
	    "angellus_effect04.png",
	    "angellus_effect05.png",
	    "angellus_effect06.png",
	    "angellus_effect07.png",
	    "angellus_effect08.png"
	],
	timeline: [[
		[0,0,0,1],
		[1,0,0,1],
		[2,0,0,1],
		[3,0,0,1],
		[4,0,0,1],
		[5,0,0,1],
		[6,0,0,1],
		[7,0,0,1],
		[8,0,0,1]
	]]
}
game.effect.e003 = new effect {
	images: [
	    "attack_effect00.png",
	    "attack_effect01.png",
	    "attack_effect02.png",
	    "attack_effect03.png",
	    "attack_effect04.png",
	    "attack_effect05.png",
	    "attack_effect06.png",
	    "attack_effect07.png",
	    "attack_effect08.png",
	    "attack_effect09.png",
	    "attack_effect10.png",
	    "attack_effect11.png",
	    "attack_effect12.png",
	    "attack_effect13.png",
	    "attack_effect14.png",
	    "attack_effect15.png",
	    "attack_effect16.png",
	    "attack_effect17.png"
	],
	timeline: [[			#方位
		[0,0,20,1],				#[圖片編號, x偏移, y偏移, 持續時間, 翻轉(1水平,2垂直)]
		[1,0,20,1],
		[2,0,20,1]
	],[],[
		[6,-20,0,1],
		[7,-20,0,1],
		[8,-20,0,1]
	],[],[
		[15,-20,0,1],
		[16,-20,0,1]
	],[],[
		[6,20,0,1,1],
		[7,20,0,1,1],
		[8,20,0,1,1]
	]]
}
game.effect.e004 = new effect {
	images: [
	    "attack_effect18.png",
	    "attack_effect19.png",
	    "attack_effect20.png",
	    "attack_effect21.png",
	    "attack_effect22.png",
	    "attack_effect23.png"
	],
	timeline: [[
		[0,-10,10,1],
		[1,-10,10,1],
		[2,-10,10,1]
	],[],[
		[3,-20,0,1],
		[4,-20,0,1],
		[5,-20,0,1]
	],[],[
		[0,-15,-10,1],
		[1,-15,-10,1],
		[2,-15,-10,1]
	],[],[
		[3,20,0,1,1],
		[4,20,0,1,1],
		[5,20,0,1,1]
	]]
}
game.effect.e005 = new effect {
	images: [
	    "attack_effect24.png",
	    "attack_effect25.png",
	    "attack_effect26.png",
	    "attack_effect27.png",
	    "attack_effect28.png",
	    "attack_effect29.png"
	],timeline: [[
		[0,-10,-10,1],
		[1,-10,-10,1],
		[2,-10,-10,1]
	],[],[
		[3,0,0,1],
		[4,0,0,1],
		[5,0,0,1]
	],[],[
		[0,-15,10,1],
		[1,-15,10,1],
		[2,-15,10,1]
	],[],[
		[3,0,0,1,1],
		[4,0,0,1,1],
		[5,0,0,1,1]
	]]
}
game.effect.e006 = new effect {
	images: [
	    "attack_effect30.png",
	    "attack_effect31.png",
	    "attack_effect32.png",
	    "attack_effect33.png",
	    "attack_effect34.png",
	    "attack_effect35.png",
	    "attack_effect36.png",
	    "attack_effect37.png",
	    "attack_effect38.png",
	    "attack_effect39.png",
	],
	timeline: [[
		[0,-20,-10,1],
		[1,-20,-10,1],
		[2,-20,-10,1]
	],[],[
		[3,0,0,1],
		[4,0,0,1],
		[5,0,0,1]
	],[],[
		[6,-15,20,1],
		[7,-15,20,1],
		[8,-15,20,1]
	],[],[
		[3,0,0,1,1],
		[4,0,0,1,1],
		[5,0,0,1,1]
	]]
}
game.effect.e006_1 = new effect {
	images: [
	    
	    "attack_effect40.png",
	    "attack_effect41.png",
	    "attack_effect42.png",
	    "attack_effect43.png",
	    "attack_effect44.png",
	    "attack_effect45.png",
	    "attack_effect46.png",
	    "attack_effect47.png"
	],
	timeline: [[
		[0,-20,-10,1],
		[1,-20,-10,1],
		[2,-20,-10,1]
	],[],[
		[3,0,0,1],
		[4,0,0,1],
		[5,0,0,1]
	],[],[
		[6,-15,20,1],
		[7,-15,20,1]
	],[],[
		[3,0,0,1,1],
		[4,0,0,1,1],
		[5,0,0,1,1]
	]]
}
game.effect.e007 = new effect {
	images: [
	    "attack_effect48.png",
	    "attack_effect49.png",
	    "attack_effect50.png",
	    "attack_effect51.png",
	    "attack_effect52.png",
	    "attack_effect53.png"
	],
	timeline: [[
		[0,0,-10,1,2],
		[1,0,-10,1,2],
		[2,0,-10,1,2]
	],[],[
		[3,10,0,1],
		[4,10,0,1],
		[5,10,0,1]
	],[],[
		[0,0,10,1],
		[1,0,10,1],
		[2,0,10,1]
	],[],[
		[3,-10,0,1,1],
		[4,-10,0,1,1],
		[5,-10,0,1,1]
	]]
}
game.effect.e008 = new effect {
	images: [
	    "attack_effect54.png",
	    "attack_effect55.png",
	    "attack_effect56.png",
	    "attack_effect57.png",
	    "attack_effect58.png",
	    "attack_effect59.png"
	],
	timeline: []
}
game.effect.e009 = new effect {
	images: [
	    "bash_effect00.png",
	    "bash_effect01.png",
	    "bash_effect02.png",
	    "bash_effect03.png",
	    "bash_effect04.png",
	    "bash_effect05.png"
	],
	timeline: []
}
game.effect.e010 = new effect {
	images: [
	    "blessing_effect00.png",
	    "blessing_effect01.png",
	    "blessing_effect02.png",
	    "blessing_effect03.png",
	    "blessing_effect04.png",
	    "blessing_effect05.png",
	    "blessing_effect06.png",
	    "blessing_effect07.png",
	    "blessing_effect08.png"
	],
	timeline: []
}
game.effect.e011 = new effect {
	images: [
	    "casting_effect00.png",
	    "casting_effect01.png",
	    "casting_effect02.png",
	    "casting_effect03.png",
	    "casting_effect04.png",
	    "casting_effect05.png"
	],
	timeline: []
}
game.effect.e012 = new effect {
	images: [
	    "charge_effect00.png",
	    "charge_effect01.png",
	    "charge_effect02.png",
	    "charge_effect03.png"
	],
	timeline: []
}
game.effect.e013 = new effect {
	images: [
	    "coldbolt_effect00.png",
	    "coldbolt_effect01.png",
	    "coldbolt_effect02.png",
	    "coldbolt_effect03.png",
	    "coldbolt_effect04.png"
	],
	timeline: []
}
game.effect.e014 = new effect {
	images: [
	    "cure_effect00.png",
	    "cure_effect01.png",
	    "cure_effect02.png",
	    "cure_effect03.png",
	    "cure_effect04.png",
	    "cure_effect05.png",
	    "cure_effect06.png",
	    "cure_effect07.png"
	],
	timeline: []
}
game.effect.e015 = new effect {
	images: [
	    "damage_effect00.png",
	    "damage_effect01.png",
	    "damage_effect02.png"
	],
	timeline: []
}
game.effect.e016 = new effect {
	images: [
	    "deadlycross_effect00.png",
	    "deadlycross_effect01.png",
	    "deadlycross_effect02.png",
	    "deadlycross_effect03.png",
	    "deadlycross_effect04.png",
	    "deadlycross_effect05.png",
	    "deadlycross_effect06.png"
	],
	timeline: []
}
game.effect.e017 = new effect {
	offset: [0,-20],
	images: [
	    "deathblade_effect00.png",
	    "deathblade_effect01.png",
	    "deathblade_effect02.png",
	    "deathblade_effect03.png",
	    "deathblade_effect04.png",
	    "deathblade_effect05.png",
	    "deathblade_effect06.png",
	    "deathblade_effect07.png"
	],
	timeline: []
}
game.effect.e018 = new effect {
	images: [
	    "doubleattack_effect00.png",
	    "doubleattack_effect01.png",
	    "doubleattack_effect02.png",
	    "doubleattack_effect03.png",
	    "doubleattack_effect04.png"
	],
	timeline: []
}
game.effect.e019 = new effect {
	images: [
	    "earthspike_effect00.png",
	    "earthspike_effect01.png",
	    "earthspike_effect02.png",
	    "earthspike_effect03.png",
	    "earthspike_effect04.png",
	    "earthspike_effect05.png",
	    "earthspike_effect06.png",
	    "earthspike_effect07.png",
	    "earthspike_effect08.png"
	],
	timeline: []
}
game.effect.e020 = new effect {
	images: [
	    "energycoat_effect00.png",
	    "energycoat_effect01.png",
	    "energycoat_effect02.png",
	    "energycoat_effect03.png",
	    "energycoat_effect04.png",
	    "energycoat_effect05.png",
	    "energycoat_effect06.png"
	],
	timeline: []
}
game.effect.e021 = new effect {
	images: [
	    "envenom_effect00.png",
	    "envenom_effect01.png",
	    "envenom_effect02.png",
	    "envenom_effect03.png",
	    "envenom_effect04.png"
	],
	timeline: []
}
game.effect.e022 = new effect {
	images: [
	    "firebolt_effect00.png",
	    "firebolt_effect01.png",
	    "firebolt_effect02.png",
	    "firebolt_effect03.png",
	    "firebolt_effect04.png",
	    "firebolt_effect05.png"
	],
	timeline: []
}
game.effect.e023 = new effect {
	offset:[0,-14],
	images: [
	    "firewall_effect00.png",
	    "firewall_effect01.png",
	    "firewall_effect02.png",
	    "firewall_effect03.png",
	    "firewall_effect04.png",
	    "firewall_effect05.png",
	    "firewall_effect06.png",
	    "firewall_effect07.png",
	    "firewall_effect08.png",
	],
	timeline: []
}
game.effect.e024 = new effect {
	offset:[0,-6],
	images: [
	    "frostdiver_effect00.png",
	    "frostdiver_effect01.png",
	    "frostdiver_effect02.png",
	    "frostdiver_effect03.png",
	    "frostdiver_effect04.png",
	    "frostdiver_effect05.png",
	    "frostdiver_effect06.png",
	    "frostdiver_effect07.png",
	],
	timeline: []
}
game.effect.e025 = new effect {
	images: [
	    "grimtooth_effect00.png",
	    "grimtooth_effect01.png",
	    "grimtooth_effect02.png",
	    "grimtooth_effect03.png",
	    "grimtooth_effect04.png",
	    "grimtooth_effect05.png",
	    "grimtooth_effect06.png",
	    "grimtooth_effect07.png",
	    "grimtooth_effect08.png",
	],
	timeline: []
}
game.effect.e026 = new effect {
	images: [
	    "heal_effect00.png",
	    "heal_effect01.png",
	    "heal_effect02.png",
	    "heal_effect03.png",
	    "heal_effect04.png",
	],
	timeline: []
}
game.effect.e027 = new effect {
	offset:[0,-25],
	images: [
	    "holyhammer_effect00.png",
	    "holyhammer_effect01.png",
	    "holyhammer_effect02.png",
	    "holyhammer_effect03.png",
	    "holyhammer_effect04.png",
	    "holyhammer_effect05.png",
	    "holyhammer_effect06.png",
	    "holyhammer_effect07.png",
	],
	timeline: []
}
game.effect.e028 = new effect {
	offset:[0,-15],
	images: [
	    "holylight_effect00.png",
	    "holylight_effect01.png",
	    "holylight_effect02.png",
	    "holylight_effect03.png",
	    "holylight_effect04.png",
	],
	timeline: []
}
game.effect.e029 = new effect {
	images: [
	    "inccrit_effect00.png",
	    "inccrit_effect01.png",
	    "inccrit_effect02.png",
	    "inccrit_effect03.png",
	    "inccrit_effect04.png",
	    "inccrit_effect05.png",
	    "inccrit_effect06.png",
	],
	timeline: []
}
game.effect.e030 = new effect {
	images: [
	    "item_effect00.png",
	    "item_effect01.png",
	    "item_effect02.png",
	    "item_effect03.png",
	    "item_effect04.png"
	],
	timeline: []
}
game.effect.e031 = new effect {
	images: [
	    "item_effect05.png",
	    "item_effect06.png",
	    "item_effect07.png",
	    "item_effect08.png",
	    "item_effect09.png",
	    "item_effect10.png"
	],
	timeline: []
}
game.effect.e032 = new effect {
	images: [
	    "item_effect11.png",
	    "item_effect12.png",
	    "item_effect13.png"
	],
	timeline: []
}
game.effect.e033 = new effect {
	images: [
	    "item_effect14.png",
	    "item_effect15.png",
	    "item_effect16.png"
	],
	timeline: []
}
game.effect.e034 = new effect {
	images: [
	    "item_effect17.png",
	    "item_effect18.png",
	    "item_effect19.png"
	],
	timeline: []
}
game.effect.e035 = new effect {
	images: [
	    "item_effect20.png",
	    "item_effect21.png",
	    "item_effect22.png"
	],
	timeline: []
}
game.effect.e036 = new effect {
	images: [
	    "legcut_effect00.png",
	    "legcut_effect01.png",
	    "legcut_effect02.png",
	    "legcut_effect03.png",
	    "legcut_effect04.png"
	],
	timeline: []
}
game.effect.e037 = new effect {
	offset: [0, -40],
	images: [
	    "levelup_effect00.png",
	    "levelup_effect01.png",
	    "levelup_effect02.png",
	    "levelup_effect03.png",
	    "levelup_effect04.png",
	    "levelup_effect05.png",
	    "levelup_effect06.png"
	],
	timeline: [[
		[0,0,0,1],
		[1,0,0,1],
		[2,0,0,1],
		[3,0,0,1],
		[4,0,0,1],
		[5,0,0,1],
		[6,5,-10,2]
	]]
}
game.effect.e038 = new effect {
	offset: [0, -40],
	images: [
	    "levelup_effect07.png",
	    "levelup_effect08.png",
	    "levelup_effect09.png",
	    "levelup_effect10.png",
	    "levelup_effect11.png",
	    "levelup_effect12.png"
	],
	timeline: [[
		[5,0,0,1],
		[1,0,0,1],
		[2,0,0,1],
		[3,0,0,1],
		[4,0,0,1],
		[0,5,-10,2],	
	]]
}
game.effect.e039 = new effect {
	offset: [0,-50],
	images: [
	    "lightningbolt_effect00.png",
	    "lightningbolt_effect01.png",
	    "lightningbolt_effect02.png",
	    "lightningbolt_effect03.png",
	    "lightningbolt_effect04.png",
	    "lightningbolt_effect05.png",
	    "lightningbolt_effect06.png",
	    "lightningbolt_effect07.png",
	    "lightningbolt_effect08.png"
	],
	timeline: [[
		[0,0,-43,1],
		[1,0,-31,1],
		[2,0,-31,1],
		[3,0,0,1],
		[4,0,0,1],
		[5,0,0,1],
		[6,0,0,1],
		[7,0,0,1],
		[8,0,0,1],
	]]
}
game.effect.e040 = new effect {
	offset: [0, -25],
	images: [
	    "lordofver_effect00.png",
	    "lordofver_effect01.png",
	    "lordofver_effect02.png",
	    "lordofver_effect03.png",
	    "lordofver_effect04.png"
	],
	timeline: []
}
game.effect.e041 = new effect {
	offset: [0, -25],
	images: [
	    "magnumbreak_effect00.png",
	    "magnumbreak_effect01.png",
	    "magnumbreak_effect02.png",
	    "magnumbreak_effect03.png",
	    "magnumbreak_effect04.png"
	],
	timeline: []
}
game.effect.e042 = new effect {
	offset: [0, -25],
	images: [
	    "meteoassault_effect00.png",
	    "meteoassault_effect01.png",
	    "meteoassault_effect02.png",
	    "meteoassault_effect03.png",
	    "meteoassault_effect04.png",
	    "meteoassault_effect05.png",
	    "meteoassault_effect06.png"
	],
	timeline: []
}
game.effect.e043 = new effect {
	images: [
	    "meteostorm_effect00.png",
	    "magnumbreak_effect00.png",
	    "magnumbreak_effect01.png",
	    "magnumbreak_effect02.png",
	    "magnumbreak_effect03.png",
	    "magnumbreak_effect04.png"
	],
	timeline: [[
		[0,20,0,1],
		[0,15,0,1],
		[0,10,0,1],
		[0,5,0,1],
		[0,5,0,1],
	]]
}
game.effect.e044 = new effect {
	images: [
	    "napalmbeat_effect00.png",
	    "napalmbeat_effect01.png",
	    "napalmbeat_effect02.png",
	    "napalmbeat_effect03.png",
	    "napalmbeat_effect04.png",
	    "napalmbeat_effect05.png",
	    "napalmbeat_effect06.png",
	    "napalmbeat_effect07.png"
	],
	timeline: []
}
game.effect.e045 = new effect {
	images: [
	    "panic_effect00.png",
	    "panic_effect01.png",
	    "panic_effect02.png",
	    "panic_effect03.png",
	    "panic_effect04.png"
	],
	timeline: [[
		[0,0,-20,1],
		[1,0,-20,1],
		[2,0,-20,1],
		[3,0,-20,1],
		[4,0,-20,1],
	]]
}
game.effect.e046 = new effect {
	images: [
	    "poison_effect00.png",
	    "poison_effect01.png",
	    "poison_effect02.png",
	    "poison_effect03.png",
	    "poison_effect04.png"
	],
	timeline: []
}
game.effect.e047 = new effect {
	images: [
	    "provoke_effect00.png",
	    "provoke_effect01.png",
	    "provoke_effect02.png",
	    "provoke_effect03.png",
	    "provoke_effect04.png",
	    "provoke_effect05.png",
	    "provoke_effect06.png",
	    "provoke_effect07.png"
	],
	timeline: []
}
game.effect.e048 = new effect {
	images: [
	    "quagmire_effect00.png",
	    "quagmire_effect01.png",
	    "quagmire_effect02.png",
	    "quagmire_effect03.png",
	    "quagmire_effect04.png",
	    "quagmire_effect05.png",
	    "quagmire_effect06.png"
	],
	timeline: []
}
game.effect.e049 = new effect {
	images: [
	    "quicken_effect00.png",
	    "quicken_effect01.png",
	    "quicken_effect02.png",
	    "quicken_effect03.png",
	    "quicken_effect04.png",
	    "quicken_effect05.png",
	    "quicken_effect06.png"
	],
	timeline: []
}
game.effect.e050 = new effect {
	images: [
	    "resurrection_effect00.png",
	    "resurrection_effect01.png",
	    "resurrection_effect02.png",
	    "resurrection_effect03.png",
	    "resurrection_effect04.png",
	    "resurrection_effect05.png",
	    "resurrection_effect06.png",
	    "resurrection_effect07.png"
	],
	timeline: []
}
game.effect.e051 = new effect {
	images: [
	    "safetywall_effect00.png",
	    "safetywall_effect01.png",
	    "safetywall_effect02.png",
	    "safetywall_effect03.png",
	    "safetywall_effect04.png",
	    "safetywall_effect05.png",
	    "safetywall_effect06.png",
	    "safetywall_effect07.png",
	    "safetywall_effect08.png",
	    "safetywall_effect09.png",
	    "safetywall_effect10.png",
	    "safetywall_effect11.png"
	],
	timeline: []
}
game.effect.e052 = new effect {
	offset: [0,-10],
	images: [
	    "sanctuary_effect00.png",
	    "sanctuary_effect01.png",
	    "sanctuary_effect02.png",
	    "sanctuary_effect03.png",
	    "sanctuary_effect04.png",
	    "sanctuary_effect05.png",
	    "sanctuary_effect06.png",
	    "sanctuary_effect07.png",
	    "sanctuary_effect08.png",
	    "sanctuary_effect09.png",
	    "sanctuary_effect10.png",
	    "sanctuary_effect11.png"
	],
	timeline: [[
		[0,0,-12,1],
		[1,0,-5,1],
		[2,0,-16,1],
		[3,0,-23,1],
		[4,0,-9,1],
		[5,0,0,1],
	]]
}
game.effect.e053 = new effect {
	images: [
	    "shieldmaster_effect00.png",
	    "shieldmaster_effect01.png",
	    "shieldmaster_effect02.png",
	    "shieldmaster_effect03.png",
	    "shieldmaster_effect04.png"
	],
	timeline: []
}
game.effect.e054 = new effect {
	offset: [-30,-20],
	images: [
	    "slow_effect00.png",
	    "slow_effect01.png",
	    "slow_effect02.png"
	],
	timeline: []
}
game.effect.e055 = new effect {
	images: [
	    "sonicattack_effect00.png",
	    "sonicattack_effect01.png",
	    "sonicattack_effect02.png",
	    "sonicattack_effect03.png",
	    "sonicattack_effect04.png",
	    "sonicattack_effect05.png",
	    "sonicattack_effect06.png"
	],
	timeline: []
}
game.effect.e056 = new effect {
	images: [
	    "soulstrike_effect00.png",
	    "soulstrike_effect01.png",
	    "soulstrike_effect02.png",
	    "soulstrike_effect03.png",
	    "soulstrike_effect04.png",
	    "soulstrike_effect05.png",
	    "soulstrike_effect06.png",
	    "soulstrike_effect07.png",
	    "soulstrike_effect08.png",
	    "soulstrike_effect09.png",
	    "soulstrike_effect10.png",
	    "soulstrike_effect11.png"
	],
	timeline: []
}
game.effect.e057 = new effect {
	offset: [0, -5],
	images: [
	    "stormgast_effect00.png",
	    "stormgast_effect01.png",
	    "stormgast_effect02.png",
	    "stormgast_effect03.png",
	    "stormgast_effect04.png"
	],
	timeline: []
}
game.effect.e058 = new effect {
	offset: [2,-22],
	images: [
	    "sturn_effect00.png",
	    "sturn_effect01.png",
	    "sturn_effect02.png",
	    "sturn_effect03.png",
	    "sturn_effect04.png"
	],
	timeline: []
}
game.effect.e059 = new effect {
	images: [
	    "teleport_effect00.png",
	    "teleport_effect01.png",
	    "teleport_effect02.png",
	    "teleport_effect03.png",
	    "teleport_effect04.png",
	    "teleport_effect05.png",
	    "teleport_effect06.png",
	    "teleport_effect07.png"
	],
	timeline: [[
		[0,0,0,1],
		[1,0,0,1],
		[2,0,-15/2+3,1],
		[3,0,-30/2+3,1],
		[4,0,-70/2,1],
		[5,0,-121/2+25,1],
		[6,0,-119/2+17,1],
		[7,0,+1/2+12,1],
	]]
}
game.effect.e060 = new effect {
	offset: [0, -40],
	images: [
	    "thunderstorm_effect00.png",
	    "thunderstorm_effect01.png",
	    "thunderstorm_effect02.png",
	    "thunderstorm_effect03.png",
	    "thunderstorm_effect04.png",
	    "thunderstorm_effect05.png",
	    "thunderstorm_effect06.png"
	],
	timeline: []
}
game.effect.e061 = new effect {
	images: [
	    "vitalpoint_effect00.png",
	    "vitalpoint_effect01.png",
	    "vitalpoint_effect02.png"
	],
	timeline: []
}
game.effect.e062 = new effect {
	images: [
	    "warp_effect00.png",
	    "warp_effect01.png",
	    "warp_effect02.png",
	    "warp_effect03.png",
	    "warp_effect04.png"
	],
	timeline: [[
		[4,0,0,1],
		[3,0,0,1],
		[2,0,0,1],
		[1,0,0,1],
		[0,0,0,1],
		[-1]
	]]
}
game.effect.e063 = new effect {
	images: [
	    "whirlattack_effect00.png",
	    "whirlattack_effect01.png",
	    "whirlattack_effect02.png",
	    "whirlattack_effect03.png"
	],
	timeline: []
}
game.effect.e064 = new effect {
	images: [
	    "sanctuary_effect09.png",
	    "sanctuary_effect10.png",
	    "sanctuary_effect11.png",
	],
	timeline: []
}