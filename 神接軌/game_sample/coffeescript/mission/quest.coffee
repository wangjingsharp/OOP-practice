class window.Quest
	constructor: () ->
		@monsters = []

	addMonster: (name, amount)->
		monster = {
			name: name,
			amount: amount,
			killed: 0,
		}
		@monsters.push monster

	killMonster: (monster_name)->
		for monster in @monsters
			monster.killed++ if monster.name == monster_name && monster.killed < monster.amount

	isComplete: ()->
		for monster in @monsters
			return false if monster.killed < monster.amount
		return true

	schedule: ()->
		rows = []
		for monster in @monsters
			row = new Row
			checkbox = new Checkbox
			checkbox.complete monster.amount == monster.killed
			label = new Label "#{monster.name}:#{monster.killed}/#{monster.amount}"

			checkbox.appendTo row
			label.appendTo row
			rows.push row

		return rows
		