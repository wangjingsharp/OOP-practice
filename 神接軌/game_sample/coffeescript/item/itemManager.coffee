class window.ItemManager
	constructor: () ->
		@packLimit = 50
		@items = []

	addItem: (item) ->
		idx = @items.map (ele) ->
			return ele.item.name
		.indexOf item.name

		if idx == -1
			@items.push {item: item, amount: 1}
		else
			@items[idx].amount++

		@mission_manager = game.role.mission_manager if !@mission_manager?
		@mission_manager.collectItem item.name
		@windows_manager = game.windows_manager if !@windows_manager?
		@reviewItems() if @windows_manager.findWindow '背包'

	removeItem: (item) ->
		@items.delete item

	showItems: () ->
		@windows_manager = game.windows_manager if !@windows_manager?

		if win = @windows_manager.findWindow '背包'
			if win.isHide()
				win.show()
				@reviewItems()
			else
				win.hide()
		else
			@win = new Windows 350, 400, '背包'
			for i in [0..@packLimit-1]
				block = new Block ''
				block.appendTo @win.main
			@reviewItems()

	reviewItems: () ->
		that = @
		for i in [0..@packLimit-1]
			block = @win.main.childrens[i]
			block.setMsg ''
			block.removeEvent 'dblclick'
		
		for item, key in @items
			block = @win.main.childrens[key]
			item.label = new Label
			item.label.html.style.backgroundImage = "url(images/#{item.item.icon})";
			item.label.html.style.backgroundSize = "auto 100%";
			item.label.html.style.backgroundPosition = "center";
			item.label.html.style.backgroundRepeat = "no-repeat";
			item.label.html.style.width = "100%";
			item.label.html.style.height = "100%";
			item.label.appendTo block
			if !item.label.isEvent 'dblclick'
				item.label.addEvent 'dblclick', game.role.hotkey_manager.set, [item.item]
			label = new Label item.amount
			label.html.style.position = "absolute"
			label.html.style.bottom = 0
			label.html.style.right = 0
			label.appendTo block

		money = $("<div class='item-money'>")
		money.html game.role.money

		$(@win.footer.html)
			.html ""
			.css "background-color", "#FFF"
			.append money