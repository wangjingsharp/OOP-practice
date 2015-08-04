class textController extends window.Base
	constructor: ()->
		@text = []
		@msgs = []
		@interval @move, 50
		
	showDamage: (damage, map, x, y, color)->
		color = "#FFFFFF" if !color?
		@showText damage, color, map, x, y, [0, 0], [Math.random() * 2 - 1,-2], 30
		
	showText: (text, color, map, x, y, offset, v, time)->
		@text.push [text,color,map,x,y,offset,v,time]
		
	msg: (text, self)->
		@msgs.push [text, self, 50]
		
	move: ()->
		deleteList = []
		for text, i in @text
			deleteList.push i if --@text[i][7] == 0
			@text[i][5][0] += @text[i][6][0]
			@text[i][5][1] += @text[i][6][1]

			
		deleteList.sort (a, b)-> b-a
		for i in deleteList
			@text.splice(i,1)

		deleteList = []
		for text, i in @msgs
			deleteList.push i if --@msgs[i][2] == 0
		deleteList.sort (a, b)-> b-a
		for i in deleteList
			@msgs.splice(i,1)

	redraw: ()->
		context = game.canvas.context
		for text in @text
			if (text[2] == game.role.map)
				position = getRealPosition(text[3], text[4], text[5])
				context.font = "14px Arial"
				context.fillStyle = "#000"
				context.textAlign = 'center'
				context.fillText text[0], position[0]+21, position[1]+21
				context.fillStyle = text[1]
				context.fillText text[0], position[0]+20, position[1]+20
				
		for text in @msgs
			if (text[1].mapname == game.role.mapname)
				context.beginPath()
				context.font = "14px Arial"
				context.textAlign = 'center'
				
				position = getRealPosition(text[1].position[0], text[1].position[1], [0, -45])
				
				context.globalAlpha = .3
				context.fillStyle = '#333'
				metrics = context.measureText text[1].name + " : " + text[0];
				context.fillRect text[1].offset[0]+position[0]+20-metrics.width/2-5, text[1].offset[1]+position[1]-17, metrics.width+10, 24
				context.globalAlpha = 1
				context.fillStyle = "#000"
				context.fillText text[1].name + " : " + text[0], text[1].offset[0]+position[0]+21, text[1].offset[1]+position[1]+1
				context.fillStyle = "#FFF"
				context.fillText text[1].name + " : " + text[0], text[1].offset[0]+position[0]+20, text[1].offset[1]+position[1]
				context.strokeStyle = "#FC0"
				context.rect text[1].offset[0]+position[0]+20-metrics.width/2-5, text[1].offset[1]+position[1]-17, metrics.width+10, 24
				context.stroke()

game.text = new textController()