class NPC1 extends window.Npc
	constructor: (@mapname)->
		super("沒有頭的戰士", window.job.Swordsman, @mapname, 10, 11)

	start: ()->
		@mes "你看看你身後的那棟建築物"
		@next @step2

	step2: ()->
		@mes "你有發現什麼嗎？"
		@option "有", @yes
		@option "沒有", @no
		@option "接任務", @mis if !@mission_manager.findAllMission("新手教學")
		#@option "接任務random", @misrandom
		@option "完成教學了", @completeMission if @mission_manager.findBeingMission("新手教學")

	yes: ()->
		@mes "你真的有發現什麼？！"
		@mission_manager.tracingComplete(@name)
		@next @yes_step2

	yes_step2: ()->
		@mes "我隨便講講你也認真"
		@next @close

	no: ()->
		@mes "唉，沒想到你竟然什麼也沒發現"
		@next @no_step2

	no_step2: ()->
		@mes "看來你也不過爾爾"
		@next @close

	mis: ()->
		@mission = new Mission '新手教學', '擊敗3隻瘋兔&2隻魔菇&收集兩瓶藥水'
		quest = new Quest() # 尋怪
		quest.addMonster("瘋兔", 3)
		quest.addMonster("魔菇", 2)
		@mission.add quest

		gather = new Gather() # 尋物
		gather.addItem("紅色藥水", 2)
		# gather.addItem("poison1", 1)
		@mission.add gather

		# tracing = new Tracing() # 尋人
		# tracing.addNpc "沒有頭的戰士"
		# @mission.add tracing

		@addMission @mission

		@mes "擊敗3隻瘋兔&2隻魔菇&收集兩瓶藥水，這麼簡單就算是你也應該辦的到吧"
		@next @close

	misrandom: ()->
		mission = new Mission Math.random(), Math.random()
		@addMission mission

	completeMission: ()->
		if @mission_manager.findBeingMission(@mission.name).isComplete()
			@completeMissionTalk()
		else
			@beingMissionTalk()

	completeMissionTalk: ()->
		@mes "恭喜你完成任務惹"
		@next @close
		@mission_manager.completeMission @mission.name

	beingMissionTalk: ()->
		@mes "還沒完成任務阿，你行不行吶"
		@next @close

class NPC_1398182122316 extends window.Npc
	constructor: (@mapname)->
		super("馬囧", window.npc.npc016, @mapname, 22, 7)
	start: ()->
		@mes "你好，要握個手嗎？"
		@option "油電雙漲豪恐怖歐", @option1
		@option "薪水好少喔", @option2
	option2: ()->
		@mes "一份薪水不夠，你可以領兩份阿？<br />像我一樣月領47萬，月存48萬才是有競爭力的表現！"
		@next @close
	option1: ()->
		@mes "我聽到你的聲音了<br />這件事情我管定了"
		@next @close
		
class NPC_1398352070869 extends window.Npc
	constructor: (@mapname)->
		super("", window.npc.none, "prontera", 8, 15, 1, 1)
		game.effect.e062.show(@map, 8, 15, 0)
		
	touch: ()->
		game.role.map = game.maps.data['rock']
		game.role.mapname = "rock"
		game.role.position = [20, 38]
		@close()

class NPC_1398352070870 extends window.Npc
	constructor: (@mapname)->
		super("", window.npc.none, "rock", 23, 40, 1, 1)
		game.effect.e062.show(@map, 22, 39, 0)
		
	touch: ()->
		game.role.map = game.maps.data['prontera']
		game.role.mapname = "prontera"
		game.role.position = [8, 13]

class NPC_1399300918667 extends window.Npc
	constructor: (@mapname)->
		super("統一", window.npc.npc017, @mapname, 10, 11)
		@addShopItem new RedWater
		@addShopItem new BlueWater
	start: ()->
		@mes "來歐<br />不論是塑化劑，滑石粉<br />什麼樣的東西都買的到喔<br />保證便宜捏！"
		@next @openShop
	openShop: ()->
		@viewShop()
		@next @close

class NPC_1399359006013 extends window.Npc
	constructor: (@mapname)->
		super("阿雞絲", window.npc.npc069, @mapname, 30, 5)
	start: ()->
		@mes "找我阿雞絲有什麼速ㄇ"
		@option "想學怎麼煮味噌湯", @cookShup
		@option "沒事", @nothing
	nothing: ()->
		@mes "年輕人不要無所事事<br />趁現在還年輕，好好充實自己<br />想想我當初年輕的時候啊....."
		@next @close
	cookShup: ()->
		@mes "想學怎麼煮味噌湯？<br />哼哼你可真問對人了<br />讓我阿雞絲告訴你個訣竅兒"
		@next @shup
	shup: ()->
		@mes "我煮味噌湯都不加味噌與豆腐der<br />改放菜頭排骨酥用肉燥提味<br />又清又香，但就略油"
		@next @res
	res: ()->
		@mes "這還是味噌湯嗎？<br />感覺是菜頭湯阿..."
		@next @nonono
	nonono: ()->
		@mes "不不不，這不是菜頭湯<br /><br />這味噌湯呢<br />喝起來跟排骨酥湯90%口感很像"
		@next @close

window.npcCreate = ()->
	new NPC1 "rock"
	new NPC_1398182122316 "rock"
	new NPC_1398352070869 "prontera"
	new NPC_1398352070870 "prontera"
	new NPC_1399300918667 "rock"
	new NPC_1399359006013 "rock"