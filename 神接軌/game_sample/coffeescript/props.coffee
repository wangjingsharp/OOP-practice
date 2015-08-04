class window.Props extends window.Base
	constructor: (@name, @icon, @description, @price) ->
		@sprite = new Sprite "images/" + @icon
		
	showBuyAmount: ()->
		that = @
		win = new Windows 300, 60, "購買"
		win.main.html.style.overflowY = "hidden"
		label = $("<label>").html("數量：")
		text = $("<input type='number' class='login-input' id='amount' autofocus>").val(1)
		buy = new Button "購買"
		cancel = new Button "取消"
		cancel.addEvent win.close, win

		buy.html.addEventListener 'click', ()->
			if !that.buy.call(that, text.val())
				# fail 沒錢
			else
				# success 已購買
			win.close()
		, false
		$(win.main.html)
			.append(label)
			.append(text)

		cancel.appendTo(win.footer)
		buy.appendTo(win.footer)

	buy: (number)->
		console.log game.role.money, number*@price
		return false if (game.role.money - (number * @price)) < 0
		game.role.money -= (number*@price)
		for i in [1..number]
			game.role.item_manager.addItem @
		return true

class window.RedWater extends window.Props
	constructor: () ->
		super "紅色藥水", "props/red_water.png", "補30滴血", 100

	use: ()->
		game.role.heal 30
		
class window.Power extends window.Props
	constructor: () ->
		super "藥劑", "props/hp_plus.png", "增加體力10點，持續5秒", 100
		
	use: ()->
		game.status.s003.use(game.role, 5000)

class window.BlueWater extends window.Props
	constructor: () ->
		super "藍色藥水", "props/blue_water.png", "每秒回5魔力，持續5秒", 100
	
	use: ()->
		game.status.s004.use(game.role, 5000)
		
