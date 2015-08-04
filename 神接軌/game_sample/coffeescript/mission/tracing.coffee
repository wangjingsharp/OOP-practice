class window.Tracing
	constructor: () ->
		@npcs = []

	addNpc: (name)->
		npc = {
			name: name,
			complete: false
		}
		@npcs.push npc

	tracingComplete: (npc_name)->
		for npc in @npcs
			npc.complete = true if npc.name == npc_name

	isComplete: ()->
		for npc in @npcs
			return false if !npc.complete
		return true

	schedule: ()->
		rows = []
		for npc in @npcs
			row = new Row
			checkbox = new Checkbox
			checkbox.complete npc.complete
			label = new Label npc.name

			checkbox.appendTo row
			label.appendTo row
			rows.push row
		return rows
