game.sprite_count = 1
game.loaded_sprite_count = 0
class window.Sprite
	constructor: (@filepath, @rect, @myself)->
		@key = @filepath
		@dom = new Image()
		@dom.src = @filepath
		@status = false
		$(@dom).on 'load', {that: this}, @afterLoadImage
		$(@dom).on 'error', {that: this}, @afterLoadImage
		game.sprite_count++
		return

	afterLoadImage: (e)->
		that = e.data.that
		that.status = true;
		game.loaded_sprite_count++
		console.log game.loaded_sprite_count
		$("#loader").html('<img src="/images/loading.gif"><br/>' + Math.ceil(game.loaded_sprite_count / 755 * 100) + '%')
		if (game.loaded_sprite_count == game.sprite_count)
			$("#loader").hide()
		return

	#畫在整個視窗上
	drawUI: (x,y,w,h)->
		if w?
			game.canvas.context.drawImage @dom, x, y, w, h
		else
			game.canvas.context.drawImage @dom, x, y

	#畫在地圖上某個特定點(像素單位)
	realDraw: (x,y)->
		game.canvas.context.drawImage @dom, x - (game.role.position[0] - game.viewRange[0]) * 40 - game.role.offset[0], y - (game.role.position[1] - game.viewRange[1]) * 40 - game.role.offset[1]
		
	#畫在地圖上(虛擬座標系統)
	draw: (x, y, action, direction, moment, offset)->
		offset = [0,0] if not offset
		position = getRealPosition(x, y, offset)
		return if position == false
		if !action? || action < 0
			if action == -2
				game.canvas.context.translate(game.canvas.context.width, 0);
				game.canvas.context.scale(-1, 1);
				game.canvas.context.drawImage @dom, -(position[0] + offset[0]+@dom.width), position[1] + offset[1]
				game.canvas.context.translate(game.canvas.context.width, 0);
				game.canvas.context.scale(-1, 1);
			else if action == -3
				game.canvas.context.translate(game.canvas.context.width, 0);
				game.canvas.context.scale(1, -1);
				game.canvas.context.drawImage @dom, position[0] + offset[0], -(position[1] + offset[1]+@dom.height)
				game.canvas.context.translate(game.canvas.context.width, 0);
				game.canvas.context.scale(1, -1);
			else
				game.canvas.context.drawImage @dom, position[0] + offset[0], position[1] + offset[1]
		else
			n_action = action % @rect.length
			n_direction = direction % @rect[n_action].length
			n_moment = moment % @rect[n_action][n_direction].length
			rect = @rect[n_action][n_direction][n_moment]
			if rect?
				position[0] += rect[4] if rect[4]?
				position[1] += rect[5] if rect[5]?
			if direction > 5
				game.canvas.context.translate(game.canvas.context.width, 0);
				game.canvas.context.scale(-1, 1);
				game.canvas.context.drawImage @dom, rect[0], rect[1], Math.abs(rect[2]), rect[3], -position[0] - Math.abs(@rect[n_action][n_direction][0][3]), position[1]-rect[3] + 40, Math.abs(rect[2]), rect[3]
				game.canvas.context.translate(game.canvas.context.width, 0);
				game.canvas.context.scale(-1, 1);
			else if @dom?
				game.canvas.context.drawImage @dom, rect[0], rect[1], Math.abs(rect[2]), rect[3], position[0] + 10, position[1] - rect[3] + 40, Math.abs(rect[2]), rect[3]
		return