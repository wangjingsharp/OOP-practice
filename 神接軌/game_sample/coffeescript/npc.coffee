class window.Npc extends window.Animate
	constructor: (@name, @sprite, @map, x, y, @range_x, @range_y)->
		if !@range_x?
			@range_x = -1
			@range_y = -1
		super @name, @sprite
		@position = [x, y]
		game.maps.data[@map].npc.push @
		@map = game.maps.data[@map]
		@mission_manager = game.role.mission_manager
		@windows_manager = game.windows_manager
		@items = []
		@init()

	init: ()->
		@hp = -1
		@node = null
		@optionIndex = 0

	talkStart: ()->
		sign = dir2sign @dir
		reverse_dir = sign2dir sign[0] * -1, sign[1]  * -1
		if game.role.dir == reverse_dir and game.role.position[0] == @position[0] + sign[0] and game.role.position[1] == @position[1] + sign[1]
			@win = new Windows 300, 100, '對話', @
			@win.next_button.show()
			@start()

	touch: ()->
		
	talk: ()->
		@win.clearOption()
		@win.node.call(@)

	next: (@node)->
		@win.node = @node
		@win.next_button.addEvent @talk, @

	close: ()->
		game.role.talking = 0
		game.role.npc = null
		@win.close() if @win
		@win = null

	option: (name, fn)->
		@win.addOption name, fn, @
		@optionIndex = 0

	selectOptions: (path)->
		if path == 'top'
			@optionIndex--
		else if path == 'down'
			@optionIndex++
		@optionIndex = @win.select(@optionIndex)

	mes: (msg)->
		@win.setMsg msg

	addMission: (mission)->
		game.role.mission_manager.addMission mission

	addShopItem: (props)->
		@items.push props

	viewShop: ()->
		@win.close()
		@win = new Windows 350, 400, '商品'
		for i in [0..49]
			block = new Block ''
			block.appendTo @win.main
			block.addClass "shop-item"
		that = @

		for item, key in @items
			block = @win.main.childrens[key]
			label = new Label
			label.html.style.backgroundImage = "url(images/#{item.icon})"
			label.html.style.backgroundSize = "auto 100%"
			label.html.style.backgroundPosition = "center"
			label.html.style.backgroundRepeat = "no-repeat"
			label.html.style.width = "100%"
			label.html.style.height = "100%"
			label.appendTo block
			price = $("<div>")
				.html item.price
				.css "position", "absolute"
				.css "right", "3px"
				.css "bottom","0px"
			$(block.html).append(price)
			label.addEvent 'dblclick', () ->
				@showBuyAmount()
			, item
			label.addEvent 'click', () ->
				$(".shop-item").removeAttr "id"
				$(@html).attr "id", "shop-select"
			, block

		buy = new Button "購買"
		cancel = new Button "取消"
		cancel.addEvent @talk, @
		buy.addEvent ()->
			label = document.getElementById('shop-select').getElementsByClassName('label')[0]
			event = document.createEvent 'Event' # 建立事件
			event.initEvent 'dblclick', true, true # 初始化事件
			label.dispatchEvent event # 觸發事件
			return
		, @
		@win.main.html.style.paddingBottom = "0px"
		@win.main.html.style.marginBottom = "40px"
		@win.footer.html.style.backgroundColor = "#FFF"
		cancel.html.style.marginRight = "20px"
		buy.html.style.marginRight = "10px"
		cancel.appendTo @win.footer
		buy.appendTo @win.footer
