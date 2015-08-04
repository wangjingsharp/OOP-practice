var app = require('http').createServer(handler),
	io = require('socket.io').listen(app),
	mongodb = require('mongodb'),
	path = require('path'),
	fs = require('fs'),
	zlib = require('zlib'),
	extensions = {
		".html": "text/html",
		".css": "text/css",
		".js": "application/javascript",
		".png": "image/png",
		".gif": "image/gif",
		".jpg": "image/jpeg"
	};

app.listen(81);

function handler(req, res) {
	var filename = req.url || "game_sample.html";
    if(filename == "/") filename = "/game_sample.html";	
    var ext = path.extname(filename),
        mimeType = extensions[ext];

    fs.stat((__dirname + filename), function(err, stat){
    	if (err){
	    	responseWrite(res, 404, {'Content-Type' : 'text/plain'}, 'This request URL ' + req.url + ' was not found on this server.');
    	} else if (stat.isDirectory()){
	    	responseWrite(res, 500, err);
	    } else {
		    var header = {'Content-Type' : mimeType || 'text/plain'};
			if(ext.slice(1).match(/^(g)$/ig)){
				var expires = new Date(),
				maxAge = 60 * 60 * 24 * 30;
				expires.setTime(expires.getTime() + maxAge * 1000);
				header['Expires'] = expires.toUTCString();
				header['Cache-Control'] = 'max-age=' + maxAge;
				fs.stat((__dirname + filename), function(err, stat){
					
				});
				var lastModified = stat.mtime.toUTCString();
				header['Last-Modified'] = lastModified;
				if(req.headers['if-modified-since'] && lastModified == req.headers['if-modified-since']){
					readFile(req, res, (__dirname + filename), header, ext.slice(1));
				} else {
					readFile(req, res, (__dirname + filename), header, ext.slice(1));
				}
			} else {
				readFile(req, res, (__dirname + filename), header, ext.slice(1));
			}
			
	    }
    });
}

function readFile(req, res, realPath, header, type){
	var raw = fs.createReadStream(realPath), cFun;
	if( type.match(/css|js|html/ig) && req.headers['accept-encoding']){
		if(req.headers['accept-encoding'].match(/\bgzip\b/)){
			header['Content-Encoding'] = 'gzip';
			cFun = 'createGzip';
		}else if(req.headers['accept-encoding'].match(/\bdeflate\b/)){
			header['Content-Encoding'] = 'deflate';
			cFun = 'createDeflate';
		}
	}
	res.writeHead(200, header);
	if(cFun){
		raw.pipe(zlib[cFun]()).pipe(res);
	}else{
		raw.pipe(res);
	}
}

function responseWrite(res, starus, header, output, encoding){
	encoding = encoding || 'utf8';
	res.writeHead(starus, header);
	if(output){
		res.write(output, encoding);
	}
	res.end();
}

var users = [];
var mongodbServer = new mongodb.Server('localhost', 27017, { auto_reconnect: true, poolSize: 10 });
var db = new mongodb.Db('mydb', mongodbServer, {w: 1});
io.set('log level', 1);

io.on('connection', function(socket) {
	socket.on('login', function(data) {
		db.open(function() {
			db.collection('users', function(err, collection) {
				var re;
				collection.findOne({
					username: data.username,
					password: data.password
				}, function(err, user) {
					if (user) {
						re = "success";
					} else {
						re = "error";
					}
					socket.emit('LoginResponse', {
						request: re,
						user: user
					});
					db.close();
				})
			})
		})
	})

	socket.on('Users', function (data) {
		var idx = users
				.map(function (ele) { return JSON.parse(ele.user).id; })
				.indexOf(JSON.parse(data.user).id);
		if (idx == -1) {
			users.push({
				user: data.user,
				lastTime: data.lastTime
			});
		} else {
			users[idx].user = data.user;
			users[idx].lastTime = data.lastTime;
		}
		console.log(users);
		var users_by_map = findUserByMap(JSON.parse(data.user).map);
		socket.emit('UsersByMapResponse', {
			users: users_by_map
		})

	})

	socket.on('SignUp', function(data) {
		db.open(function() {
			db.collection('users', function(err, collection) {
				var re;
				//console.log(data.username, data.password);
				collection.insert({
					name: data.name,
					username: data.username,
					password: data.password,
					job: data.job
				}, function(err, user) {
					if (user) {
						console.log("insert success");
						socket.emit("SignUpResponse", {
							request: "success",
							user: user
						})
					} else {
						console.log("insert fail");
						socket.emit("SignUpResponse", {
							request: "error",
							reason: err
						})
					}
					db.close();
				})
			})
		})

	})

});

io.sockets.on('connection', function(socket) {

	socket.on('ReceiveChat', function(data) {
		var tim = new Date()
		 io.sockets.emit('Chat', {
			time: tim.getHours() + ":" + tim.getMinutes(),
			name: data.name,
			msg: data.msg
		})
	})

});

function findUserByMap (mapname) {
	var users_by_map = [];
	for (var i = 0; i < users.length; i++) {
		if (JSON.parse(users[i].user).map == mapname)
			users_by_map.push(users[i]);
	};
	return users_by_map;
}

setInterval(userTimeout, 3000); // 登出判斷

function userTimeout () {
	var tim = new Date();
	users.map(function(ele) {
		if((tim.getTime() - ele.lastTime) > (1000 * 5)) {
			removeUser(JSON.parse(ele.user).name);
		}
	})
}

function removeUser (user_name) {
	var idx = users
		.map(function(ele) { return JSON.parse(ele.user).name })
		.indexOf(user_name);
	if (idx != -1) {
		users.splice(idx, 1);
	};
}