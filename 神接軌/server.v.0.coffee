app = require('http').createServer(handler)
io = require('socket.io').listen(app)
mongodb = require('mongodb')
path = require('path')
fs = require('fs')
zlib = require('zlib')
extensions = {
	".html": "text/html",
	".css": "text/css",
	".js": "application/javascript",
	".png": "image/png",
	".gif": "image/gif",
	".jpg": "image/jpeg"
}

app.listen 81

handler = (req, res)->
	if req.url?
		filename = req.url
	else
	 	filename = "game_sample.html"
	filename = "/game_sample.html" if filename == "/"
	ext = path.extname(filename)
	mimeType = extensions[ext]

	fs.stat (__dirname + filename), (err, stat) ->
		if err
			responseWrite(res, 404, {'Content-Type' : 'text/plain'}, 'This request URL ' + req.url + ' was not found on this server.');
		else if stat.isDirectory()
			responseWrite res, 500, err
		else
			header = {'Content-Type' : mimeType || 'text/plain'}
			if ext.slice(1).match(/^(gif|png|jpg|css)$/ig)
				expires = new Date()
				maxAge = 60 * 60 * 24 * 30
				expires.setTime(expires.getTime() + maxAge * 1000)
				header['Expires'] = expires.toUTCString()
				header['Cache-Control'] = 'max-age=' + maxAge
				fs.stat (__dirname + filename), (err, stat)->
					
				lastModified = stat.mtime.toUTCString();
				header['Last-Modified'] = lastModified;
				if req.headers['if-modified-since'] && lastModified == req.headers['if-modified-since']
					responseWrite(res, 304, 'Not Modified');
				else
					readFile req, res, (__dirname + filename), header, ext.slice(1)
			else
				readFile req, res, (__dirname + filename), header, ext.slice(1)

readFile = (req, res, realPath, header, type) ->
	raw = fs.createReadStream(realPath)
	cFun = null
	if type.match(/css|js|html/ig) && req.headers['accept-encoding']
		if req.headers['accept-encoding'].match(/\bgzip\b/)
			header['Content-Encoding'] = 'gzip';
			cFun = 'createGzip';
		else if req.headers['accept-encoding'].match(/\bdeflate\b/)
			header['Content-Encoding'] = 'deflate';
			cFun = 'createDeflate';

	res.writeHead 200, header
	if cFun
		raw
			.pipe zlib[cFun]()
			.pipe res
	else
		raw.pipe res

responseWrite = (res, starus, header, output, encoding) ->
	encoding = encoding || 'utf8'
	res.writeHead starus, header
	if output
		res.write output, encoding
	res.end()

users = [];
mongodbServer = new mongodb.Server 'localhost', 27017, { auto_reconnect: true, poolSize: 10 }
db = new mongodb.Db 'mydb', mongodbServer, {w: 1}
io.set 'log level', 1

io.on 'connection', (socket) ->
	socket.on 'login', (data) ->
		db.open () ->
			db.collection 'users', (err, collection) ->
				re = ""
				collection.findOne {
					username: data.username,
					password: data.password
				}, (err, user) ->
					if user then re = "success" else re = "error"
					socket.emit 'LoginResponse', {
						request: re,
						user: user
					}
					db.close()

	socket.on 'Users', (data) ->
		idx = users
		 		.map (ele) ->
		 			return JSON.parse(ele.user).name
		 		.indexOf JSON.parse(data.user).name
		if idx == -1
			users.push {
				user: data.user,
				lastTime: data.lastTime
			}
		else
			users[idx].user = data.user
			users[idx].lastTime = data.lastTime

		users_by_map = findUserByMap JSON.parse(data.user).map
		socket.emit 'UsersByMapResponse', {
			users: users_by_map
		}

	socket.on 'SignUp', (data) ->
		db.open () ->
			db.collection 'users', (err, collection) ->
				re = ""
				collection.insert {
					name: data.name,
					username: data.username,
					password: data.password,
					job: data.job,
					position: [22, 9],
					map: "rock",
				}, (err, user) ->
					if user 
						socket.emit "SignUpResponse", {
							request: "success",
							user: user
						}
					else
						socket.emit "SignUpResponse", {
							request: "error",
							reason: err
						}
					db.close()

io.sockets.on 'connection', (socket) ->

	socket.on 'ReceiveChat', (data) ->
		tim = new Date()
		io.sockets.emit 'Chat', {
			time: tim.getHours() + ":" + tim.getMinutes(),
			name: data.name,
			msg: data.msg
		}

findUserByMap = (mapname) ->
	users_by_map = [];
	for user in users.length
		users_by_map.push user if JSON.parse(user.user).map == mapname
	return users_by_map

setInterval userTimeout, 3000 # 登出判斷

userTimeout = () ->
	tim = new Date();
	users.map (ele) ->
		removeUser JSON.parse(ele.user).id if (tim.getTime() - ele.lastTime) > (1000 * 5)

removeUser = (user_id) ->
	idx = users
		.map (ele) ->
			return JSON.parse(ele.user).id
		.indexOf user_id
	if idx != -1
		users.splice(idx, 1);