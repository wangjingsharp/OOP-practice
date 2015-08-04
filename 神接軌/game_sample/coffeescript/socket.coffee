window.sendServer = () ->
	@move = (x, y) ->
		socket.emit 'Users', {
			id: game.role.id,
			move: [x, y]
		}
	@action = (dir) ->
		socket.emit 'Users', {
			id: game.role.id,
			action: dir
		}

window.sendUser = () ->
	tim = new Date()
	return if typeof game == "undefined" || !game.role
	user = cloneUser game.role
	user = $.extend {}, user
	user.statusList = null
	user.skills = null
	socket.emit 'Users', {
		user: JSON.stringify(user),
		lastTime: tim.getTime()
	}


socket.on 'LoginResponse'
, (data) ->
	if data.request == "success"
		loginFlag.win.close()
		game.role_name = data.user.name
		game.role_id = data.user._id
		Framework.Game.goToLevel('level1')
	else
		console.log("fail login")

socket.on 'SignUpResponse'
, (data) ->
	if (data.request == "success")
		signUpFlag.win.close();
		game.role_name = data.user[0].name;
		Framework.Game.goToLevel('level1');
	else
		console.log("fail signUp");
		console.log(data.reason)

socket.on 'UsersByMapResponse'
, (data) ->
	users = data.users
	idx = 0;
	for user in users
		user = JSON.parse user.user
		continue if user.id == game.role.id
		idx = game.users
			.map (ele) ->
				return ele.id
			.indexOf(user.id)
		if idx == -1
			console.log user.head
			new_user = new Role user["name"], job[user["sprite"]]
			new_user = resetRole new_user, user
			console.log new_user
			game.users.push new_user
		else
			game.users[idx] = resetRole game.users[idx], user

	for user, i in game.users
		idx = users
			.map (ele) ->
				return JSON.parse(ele.user).id
			.indexOf(user.id);
		if idx == -1
			# 在傳回的資料裡面沒有發現目前已有的 user
			# 代表那個 user 可能離開地圖或下線了
			game.users.splice(i, 1);

socket.on 'Chat'
, (data) ->
	game.chat.receiveMsg(data)

setInterval sendUser, 33

game.loaded_sprite_count++
if (game.loaded_sprite_count == game.sprite_count)
	$("#loader").hide()
return

