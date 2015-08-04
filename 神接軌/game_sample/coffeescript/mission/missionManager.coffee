class window.MissionManager
	constructor: () ->
		@missions = []
		@complete_missions = []
		@finish_missions = []
		@mission_index = 0

	addMission: (mission) ->
		@missions.push mission

		@windows_manager = game.windows_manager if !@windows_manager?
		@reviewMissions() if @windows_manager.findWindow '任務清單'

	findAllMission: (name) ->
		for mission in @missions
			return mission if mission.name == name
		for mission in @complete_missions
			return mission if mission.name == name
		return false

	findBeingMission: (name) ->
		idx = @missions.map (ele) ->
			return ele.name
		.indexOf name
		return @missions[idx]
		# for mission in @missions
		# 	return mission if mission.name == name

	removeMission: (name) ->
		idx = @missions.map (ele) ->
			return ele.name
		.indexOf name 
		mission = @missions[idx]
		@missions.delete mission
		# for mission, key in @missions
		# 	if mission.name == name
		# 		@missions.delete mission

	completeMission: (name) ->
		idx = @missions.map (ele) ->
			return ele.name
		.indexOf name
		mission = @missions[idx]
		@complete_missions.push mission
		@removeMission name

	killMonster: (monster_name) ->
		for mission, idx in @missions
			for mission_children in mission.missions
				if typeof mission_children.killMonster == "function"
					mission_children.killMonster monster_name
					@missionView idx if @windows_manager.findWindow mission.name
					# @completeMission mission

		return

	collectItem: (item_name)->
		for mission, idx in @missions
			for mission_children in mission.missions
				if typeof mission_children.collectItem == "function"
					mission_children.collectItem item_name
					@missionView idx if @windows_manager.findWindow mission.name
					# @completeMission mission

		return

	tracingComplete: (npc_name) ->
		for mission, idx in @missions
			for mission_children in mission.missions
				if typeof mission_children.tracingComplete == "function"
					mission_children.tracingComplete npc_name
					@missionView idx if @windows_manager.findWindow mission.name
					# @completeMission mission

		return

	showMissions: ()->
		@windows_manager = game.windows_manager if !@windows_manager?

		if win = @windows_manager.findWindow '任務清單'
			if win.isHide()
				win.show()
			else
				win.hide()
		else
			@win = new Windows 300, 500, '任務清單'
			for mission in @missions
				option = @win.addOption mission.name, @missionView, @
				option.addClass "mission_option"
			
	reviewMissions: ()->
		return if !@win
		@win.setMsg ''
		for mission in @missions
			option = @win.addOption mission.name, @missionView, @

	missionView: (index)->
		mission = @missions[index]
		
		@win.next_button.hide()
		# if win = game.windows_manager.findWindow(mission.name)
		# 	win.close()
		win = new Windows 600, 300, mission.name
		description = new Row mission.description
		description.appendTo win.main
		for submission in mission.missions
			rows = submission.schedule()
			for row in rows
				row.appendTo win.main