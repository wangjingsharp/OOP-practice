class window.Gather
	constructor: () ->
		@items = []

	addItem: (name, amount)->
		item = {
			name: name,
			amount: amount,
			collected: 0
		}
		@items.push item

	collectItem: (item_name)->
		for item in @items
			item.collected++ if item.name == item_name and item.collected < item.amount
		return 

	isComplete: ()->
		for item in @items
			return false if item.collected < item.amount
		return true

	schedule: ()->
		rows = []
		for item in @items
			row = new Row
			checkbox = new Checkbox
			checkbox.complete item.collected == item.amount
			label = new Label "#{item.name}:#{item.collected}/#{item.amount}"

			checkbox.appendTo row
			label.appendTo row
			rows.push row

		return rows
