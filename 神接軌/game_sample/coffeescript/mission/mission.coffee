class window.Mission
	# 打怪 quest
	# 收集道具 gather
	# 尋人 tracing
	constructor: (@name, @description) ->
		@missions = []
		# name
		# gift
		# complete

	add: (mission)->
		@missions.push mission

	isComplete: ()->
		for mission in @missions
			return false if !mission.isComplete()
		return true