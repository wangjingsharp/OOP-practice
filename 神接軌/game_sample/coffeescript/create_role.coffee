class window.CreateRole extends Framework.Level
	constructor: () ->
	
	initialize: ()->
		@win = new Windows 300, 180, "創新帳號"
		@win.main.html.style.overflowY = "hidden"
		userlabel = $("<label>").html("帳號：")
		username = $("<input type='text' class='login-input' id='username' autocomplete='off'>")
		passlabel = $("<label>").html("密碼：")
		password = $("<input type='password' class='login-input' id='password'>")
		namelabel = $("<label>").html("角色名稱：")
		rolename = $("<input type='text' class='login-input' id='name' autocomplete='off'>").width(168)
		joblabel = $("<label>").html("職業：")
		jobselect = $("<select id='job'>").width(208)
			.append($("<option value='Swordsman'>").html("劍士"))
			# .append($("<option value='Knight'>").html("騎士"))
			.append($("<option value='Mage'>").html("法師"))
			# .append($("<option value='Wizard'>").html("巫師"))
			.append($("<option value='Acolyte'>").html("服侍"))
			# .append($("<option value='Priest'>").html("牧師"))
			.append($("<option value='Thief'>").html("盜賊"))
			# .append($("<option value='Assassin'>").html("刺客"))

		submit = $("<input type='submit'>").val("建立新角色")
		that = @
		signUpFlag.win = @win;
		submit.on 'click', () -> that.signUp.call(that)

		$(@win.main.html)
			.append(userlabel)
			.append(username)
			.append(passlabel)
			.append(password)
			.append(joblabel)
			.append(jobselect)
			.append(namelabel)
			.append(rolename)
			.append(submit)

		@background = new Image()
		@background.src = "images/start.jpg";
		canvas = document.getElementById '__game_canvas__'
		@ctx = canvas.getContext('2d')
		@background.onload = () ->
			that.ctx.drawImage(@, 0, 0)
		@rootScene = {
			update: ()->
			draw: ()->
				that.ctx.drawImage(that.background, 0, 0)
		}
	
	signUp: ()->
		username = $('#username').val()
		password = $('#password').val()
		rolename = $('#name').val()
		job = $('#job').val()
		if username? and password? and rolename?
			socket.emit('SignUp', {
				username: username,
				password: password,
				name: rolename,
				job: job
			})

window.createRole = new CreateRole