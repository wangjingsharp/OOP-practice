class window.Login extends Framework.Level
	constructor: ()->

	initialize: ()->
		@win = new Windows 300, 100, "登入"
		@win.main.html.style.overflowY = "hidden"
		form = $("<form>")
		userlabel = $("<label>").html("帳號：")
		username = $("<input type='text' class='login-input' id='username' autofocus>")
		passlabel = $("<label>").html("密碼：")
		password = $("<input type='password' class='login-input' id='password'>")
		submit = $("<input type='submit'>").val("登入")
		sign_up = $("<button type='button' class='sign-up'>").html("註冊")
		form
			.append(userlabel)
			.append(username)
			.append(passlabel)
			.append(password)
			.append(sign_up)
			.append(submit)
		that = @
		loginFlag.win = @win
		form.on 'submit', () -> that.login.call(that)
		sign_up.on 'click', () -> that.signUp.call(that)

		$(@win.main.html).append(form)
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
		@gameIntro()

	gameIntro: ()->
		intro = new Windows 500, 500, "遊戲介紹"
		introWord = " 按鍵介紹<br /> "
		introWord += " 攻擊，對話：Z<br /> "
		introWord += " 技能視窗：K<br /> "
		introWord += " 任務視窗：Q<br /> "
		introWord += " 道具視窗：I<br /> "
		introWord += " 對話視窗：Enter<br /> "
		introWord += " 上下左右：↑ ↓ ← → <br /> "
		introWord += " 快捷鍵：X<br /> "
		introWord += " 快捷鍵：C<br /> "
		introWord += " 快捷鍵：A<br /> "
		introWord += " 快捷鍵：S<br /> "
		introWord += " 快捷鍵：D<br /> "
		introWord += " <br /> "
		introWord += " 滑鼠介紹<br /> "
		introWord += " 用來關閉視窗、提升技能、設置道具快捷鍵、選擇對話、配置快捷鍵、購買商品<br /> "
		introWord += " 開啟技能視窗後，雙擊<img src='/images/icon/add.png'>，即可升級技能<br /> "
		introWord += " 升級完技能，雙擊技能可設置快捷鍵<br /> "
		introWord += " 雙擊道具設置快捷鍵後才能使用<br /> "
		introWord += " <br /> "
		introWord += " 密技<br /> "
		introWord += " 被動技<br /> "
		introWord += " 根性：主角最低血量為1，永遠不死<br /> "
		introWord += " 主動技<br /> "
		introWord += " 按下按鍵M，殺死所有怪物<br /> "

		introWord += " <br /> "
		introWord += " 看完把視窗關閉即可登入"
		intro.setMsg introWord


	login: ()->
		that = @
		socket.emit('login', {
			username: $('#username').val(),
			password: $('#password').val()
		})
		return false

	signUp: ()->
		@win.close()
		Framework.Game.goToLevel('signUp')
		# Framework.Game.goToLevel('level1')
		
window.login = new Login()