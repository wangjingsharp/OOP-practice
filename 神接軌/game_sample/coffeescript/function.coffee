# 基本函數
#  - 陣列搜尋
#  - data = [{id: 1, name: "Wang"},{id: 2, name: "Ding"}]
#  - ding = data.search (obj)->
#  -    obj.name == "Ding"
#  - console.log ding.id 
# 
#  - 遊戲坐標轉換實際坐標
#  - position = getRealPosition(x, y)
#  - 將會透過玩家的坐標轉換為canvas上面的x y
#
#  - 取得正負號
#  - Math.sign
#  - Math.sign(-19) = -1, Math.sign(10) = 1, Math.sign(0) = 0
Array.prototype.search = (fn)->
	for child, i in this
		if fn(child)
			return child
	return false
	
Array.prototype.delete = (obj)->
	idx = this.indexOf obj
	return false if idx == -1
	this.splice idx, 1
	return true

Math.sign = (x) ->
	if x
		if x < 0
			return -1
		return 1
	return 0

window.getRealPosition = (x,y,offset)->
	return false if x < game.role.position[0] - game.viewRange[0] - 1 || x > game.role.position[0] + game.viewRange[0] + 1 || y < game.role.position[1] - game.viewRange[1] - 1 || y > game.role.position[1] + game.viewRange[1] + 1
	offset = [0, 0] if not offset?
	realPosition = []
	realPosition[0] = (x-(game.role.position[0]-game.viewRange[0])) * game.gridSize + offset[0] - game.role.offset[0]
	realPosition[1] = (y-(game.role.position[1]-game.viewRange[1])) * game.gridSize + offset[1] - game.role.offset[1]
	return realPosition

window.dir2sign = (dir)->
	switch dir
		when 0 then return [0,+1]
		when 1 then return [-1,+1]
		when 2 then return [-1,0]
		when 3 then return [-1,1]
		when 4 then return [0,-1]
		when 5 then return [1,-1]
		when 6 then return [1,0]
		when 7 then return [1,+1]
	return [0,0]
	
window.sign2dir = (x, y)->
	dir = [[3,4,5],[2,0,6],[1,0,7]]
	return dir[y+1][x+1]
	
window.distance = (x,y,x1,y1)->
	return (x-x1)*(x-x1)+(y-y1)*(y-y1)

window.random = (min, max)->
	value = parseInt(Math.random() * (max - min)) + min
	return value

window.cloneUser = (obj)->
	tmp = {}
	for k, v of obj
		if typeof v != "function"
			if v?
				if v.constructor.name == "Sprite"
					switch v.myself
						when "head"
							tmp[k] = head.indexOf(v)
						when "job"
							tmp[k] = job.indexOf(v)
				else if v.constructor.name == "Map"
					tmp[k] = v.name
				else if v.constructor.name == "Monster"
					tmp[k] = v.name
				else if v.constructor.name != "ItemManager" && v.constructor.name != "MissionManager" && v.constructor.name.substr(0, 3) != "NPC" && v.constructor.name != "SkillManager" && v.constructor.name != "HotkeyManager" && v.constructor.name != "KeyManager"
					tmp[k] = v
			else
				tmp[k] = v;
	return tmp;

Object.prototype.indexOf = (obj)->
	for k, v of @
		return k if obj == v

window.resetRole = (des, src) ->
	for k, v of src
		des[k] = v if k != "sprite" && k != "map" && k != "head"
		des[k] = head[v] if k == "head"

	return des
