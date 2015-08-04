# 集合類別
#  - maps = new collection()
#  - map = new map()
#  - maps.add(map) //不會重複記錄相同的資源, 加入的物件必須有個屬性key
class window.Collection extends window.Base
	constructor: ()->
		@data = []

	get: (key)->
		return @data[key]

	add: (object)->
		return @data[object.key] if @data[object.key]?
		if @data.indexOf(object.key) == -1
			@data[object.key] = object
		return object

	remove: (object)->
		for i,o in @data
			if o == object
				@data.splice(i, 1)

	size: ()->
		return @data.length

	clear: ()->
		@data = []