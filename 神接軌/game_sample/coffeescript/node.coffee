class window.Node
	constructor: (@name, @content, @fn_name)->
		@next = []
		@event = ""
	setContent: (@content)->

	addNode: (node)->
		@next.push node
		npcMaker.redraw()

	addMission: (@mission)->