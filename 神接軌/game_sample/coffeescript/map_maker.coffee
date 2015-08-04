class MapMaker
	constructor: ()->
		@width = prompt("width : ", 100);
		@height = prompt("height : ", 100);
		@canvas = $("canvas")
		@canvas.attr("width", @width * 40);
		@canvas.attr("height", @height * 40);
		@context = (@canvas[0]).getContext("2d")
		@data = []
		@git = []

		@object = []
		@tilePalette = []
		@objectPalette = []
		@selectObjectIndex = -1
		@offsetX = 0
		@offsetY = 0
		for w in [0..@width]
			@data[w] = []
			@git[w] = []
			for h in [0..@height]
				@data[w][h] = 0
				@git[w][h] = 1

		tile_palette = ['images/tile/tile_ch1_t000.png','images/tile/tile_abyss001.png','images/tile/tile_abyss002.png','images/tile/tile_abyss003.png','images/tile/tile_abyss004.png','images/tile/tile_abyss005.png','images/tile/tile_abyss006.png','images/tile/tile_abyss007.png','images/tile/tile_abyss008.png','images/tile/tile_abyss009.png','images/tile/tile_abyss010.png','images/tile/tile_abyss011.png','images/tile/tile_abyss012.png','images/tile/tile_abyss013.png','images/tile/tile_abyss014.png','images/tile/tile_abyss015.png','images/tile/tile_abyss016.png','images/tile/tile_abyss017.png','images/tile/tile_abyss018.png','images/tile/tile_abyss019.png','images/tile/tile_abyss020.png','images/tile/tile_abyss021.png','images/tile/tile_abyss022.png','images/tile/tile_abyss023.png','images/tile/tile_abyss024.png','images/tile/tile_abyss025.png','images/tile/tile_abyss026.png','images/tile/tile_abyss027.png','images/tile/tile_abyss028.png','images/tile/tile_abyss029.png','images/tile/tile_abyss030.png','images/tile/tile_abyss031.png','images/tile/tile_abyss032.png','images/tile/tile_abyss033.png','images/tile/tile_abyss034.png','images/tile/tile_abyss035.png','images/tile/tile_abyss036.png','images/tile/tile_abyss037.png','images/tile/tile_abyss038.png','images/tile/tile_abyss039.png','images/tile/tile_abyss040.png','images/tile/tile_abyss041.png','images/tile/tile_abyss042.png']

		for tile in [0..97]
			if tile < 10
				@addTilePalette "images/tile/tile_ch1_t00"+tile+".png"
			else
				@addTilePalette "images/tile/tile_ch1_t0"+tile+".png"


		gits = [1,0]
		for git in gits
			@addGitPalette git

		for object in [0..24]
			if object < 10
				@addObjectPalette "images/object/obj_ch1_t0"+object+".png"
			else
				@addObjectPalette "images/object/obj_ch1_t"+object+".png"


		that = this

		@canvas.on 'mousedown', {that: this}, @start_draw
		@canvas.on 'mousemove', {that: this}, @draw
		@canvas.on 'mouseup', {that: this}, @end_draw

		$("li[mode='tile']").on 'click', {that: this}, @tileMode
		$("li[mode='git']").on 'click', {that: this}, @gitMode
		$("li[mode='object']").on 'click', {that: this}, @objectMode
		$("li[mode='save']").on 'click', {that: this}, @saveMode
		$(window).on 'keydown', {that: this}, @keyboardChangePalette
		$("li[mode='tile']").click()
		$(".tile:first-child").click()
		$(".git:first-child").click()
		$(".object:first-child").click()
		@redraw()
		return

	keyboardChangePalette: (e)->
		that = e.data.that
		return if that.mode != 'tile'
		switch e.keyCode
			when 219
				$(".tile.selected").removeClass("selected");
				$($(".tile")[--that.selectTilePaletteIndex-1]).addClass("selected")
			when 221
				$(".tile.selected").removeClass("selected");
				$($(".tile")[++that.selectTilePaletteIndex-1]).addClass("selected")
		return

	addTilePalette: (tile)->
		tile_dom = new Image()
		$(tile_dom).addClass("tile palette")
		$(tile_dom).attr("src", tile)
		$(tile_dom).appendTo($("#tile-palette-list"))
		$(tile_dom).on 'click', {that: this}, @selectTilePalette
		$(tile_dom).click()
		@tilePalette.push tile
		return

	addGitPalette: (git)->
		git_dom = document.createElement("div")
		$(git_dom).addClass("git palette")
		$(git_dom).addClass("git-#{git}")
		$(git_dom).appendTo($("#git-palette-list"))
		$(git_dom).on 'click', {that: this}, @selectGitPalette
		$(git_dom).click()
		return

	addObjectPalette: (tile)->
		object = new Image()
		$(object).addClass("object palette")
		$(object).attr("src", tile)
		$(object).appendTo($("#object-palette-list"))
		$(object).on 'click', {that: this}, @selectObjectPalette
		$(object).click()
		@objectPalette.push tile
		return

	addObject: (x,y,idx)->
		object_dom = document.createElement("div")
		@object.push [x,y,idx]
		@objectDomRedraw()
		return @object.length-1

	clearMode: ()->
		$("li").removeClass("selected")
		$("#git-list").fadeOut(0)
		$("#object-list").fadeOut(0)
		$("#tile-list").fadeOut(0)
		$("#save").fadeOut(0)
		return


	tileMode: (e)->
		that = e.data.that
		that.clearMode()
		$(this).addClass("selected")
		$("#tile-list").fadeIn(0)
		that.mode = "tile"
		return

	gitMode: (e)->
		that = e.data.that
		that.clearMode()
		$(this).addClass("selected")
		$("#git-list").fadeIn(0)
		that.mode = "git"
		return

	objectMode: (e)->
		that = e.data.that
		that.clearMode()
		$(this).addClass("selected")
		that.mode = "object"
		$("#object-list").fadeIn(0)
		return

	saveMode: (e)->
		that = e.data.that
		that.clearMode()
		$(this).addClass("selected")
		that.mode = "save"
		$("#save").fadeIn(0)
		return

	selectTilePalette: (e)->
		that = e.data.that
		$(".tile.selected").removeClass("selected");
		$(this).addClass("selected")
		that.selectTilePaletteIndex = $(".tile").index($(this)) + 1
		return

	selectGitPalette: (e)->
		that = e.data.that
		$(".git.selected").removeClass("selected");
		$(this).addClass("selected")
		that.selectGitPaletteIndex = $(".git").index($(this))
		return

	selectObjectPalette: (e)->
		that = e.data.that
		$(".object.selected").removeClass("selected");
		$(this).addClass("selected")
		that.selectObjectPaletteIndex = $(".object").index($(this)) + 1
		return

	selectObject: (e)->
		that = e.data.that
		that.offsetX = 0
		that.offsetY = 0
		that.selectObjectPaletteIndex = 0
		that.selectObjectIndex = e.data.index
		return

	deleteObject: (e)->
		that = e.data.that
		index = $(this).data("index")
		that.object[index] = 0
		that.selectObjectIndex = -1
		$(this).remove()
		return

	orderObject: (e)->
		that = e.data.that
		index = parseInt($(this).parent().data("index"))
		tmp = that.object[index]
		if (index+1 < that.object.length)
			that.object[index] = that.object[index+1]
			that.object[index+1] = tmp
			that.objectDomRedraw()
		e.preventDefault()

	objectDomRedraw: ()->
		$("#object-use-list").html("")
		for object, i in @object
			object_dom = document.createElement("div")
			$(object_dom).html("##{i} #{object[2]} x:"+object[0]+" y:"+object[1] + "  <span>↓</span>")
			$(object_dom).data("index", i)
			$(object_dom).addClass("object")
			$(object_dom).appendTo($("#object-use-list"))
			$(object_dom).on 'dblclick',{that:this}, @deleteObject
			$(object_dom).on 'mouseenter',{that:this}, @highlightObject
			$(object_dom).on 'mouseleave',{that:this}, @disHighlightObject
			$(object_dom).find("span").on 'click',{that:this}, @orderObject

	highlightObject: (e)->
		that = e.data.that
		that.highlightObjectIndex = $(this).data("index")

	disHighlightObject: (e)->
		that = e.data.that
		that.highlightObjectIndex = -1


	start_draw: (e)->
		that = e.data.that
		switch that.mode
			when "tile", "git"
				that.drawing = 1
				that.draw(e)

			when "object"
				if that.selectObjectPaletteIndex
					idx = that.addObject e.pageX-that.canvas.position().left, e.pageY-that.canvas.position().top, that.selectObjectPaletteIndex
					that.selectObjectIndex = idx
				else
					x = e.pageX + $("#left").scrollLeft()
					y = e.pageY + $("#left").scrollTop()
					for object, i in that.object
						if object[0] < x && object[1] < y && x < object[0] + $(".object")[object[2]-1].width && y < object[1] + $(".object")[object[2]-1].height
							that.offsetX = x - object[0]
							that.offsetY = y - object[1]
							that.selectObjectIndex = i
				
		return

	draw: (e)->
		that = e.data.that
		x = Math.ceil((e.pageX - that.canvas.position().left)/40)-1
		y = Math.ceil((e.pageY - that.canvas.position().top)/40)-1
		switch that.mode
			when "tile"
				return if that.drawing != 1
				that.data[y][x] = that.selectTilePaletteIndex

			when "git"
				return if that.drawing != 1
				that.git[y][x] = that.selectGitPaletteIndex

			when "object"
				return if that.selectObjectIndex == -1
				that.object[ that.selectObjectIndex ][0] = e.pageX - that.canvas.position().left - that.offsetX
				that.object[ that.selectObjectIndex ][1] = e.pageY - that.canvas.position().top - that.offsetY
		return

	end_draw: (e)->
		that = e.data.that
		that.drawing = 0
		that.selectObjectIndex = -1
		that.selectObjectPaletteIndex = 0
		return

	redraw: ()->
		@context.fillStyle = "#FFFFFF";
		@context.fillRect(0,0,@width*40,@height*40);
		for w in [0..@width]
			for h in [0..@height]
				if @data[h][w]
					@context.drawImage $(".tile")[@data[h][w]-1],w*40,h*40

		for object, i in @object
			if @selectObjectIndex == i || @highlightObjectIndex == i
				@context.fillStyle = 'rgba(54, 143, 24, .5)'
				@context.fillRect(object[0], object[1], $(".object")[object[2]-1].width, $(".object")[object[2]-1].height);
			if object != 0
				@context.drawImage $(".object")[object[2]-1],object[0],object[1]

		for w in [0..@width]
			for h in [0..@height]
				if (@mode == "git")
					switch @git[h][w]
						when 1 then @context.fillStyle = 'rgba(54, 143, 24, .5)'
						when 0 then @context.fillStyle = 'rgba(179, 41, 41, .5)'
					@context.fillRect(w*40,h*40,40,40);
					
		@context.fillStyle = "#CCCCCC";
		for w in [0..@width]
			@context.fillRect(w*40,0,1,@height*40);
		for h in [0..@height]
			@context.fillRect(0,h*40,@width*40,1);
			
		that = this
		
		setTimeout ()->
			that.redraw.apply(that)
		,100
		return

	load: ()->
		q = $("textarea").val()
		d = eval q
		@width = d[0]
		@height = d[1]
		@data = d[2]
		@git = d[3]
		@tilePalette = []
		@objectPalette = []
		$(".tile.palette").remove()
		$(".object.palette").remove()
		for tile,i in d[5]
			@addTilePalette tile
		for object,i in d[6]
			@addObjectPalette object
		$("#object-use-list").empty()
		for o in d[4]
			@addObject o[0], o[1], o[2]
		@canvas = $("canvas")
		@canvas.attr("width", @width * 40);
		@canvas.attr("height", @height * 40);
		@context = (@canvas[0]).getContext("2d")
		return

	save: ()->
		str = "["+@width+","+@height+","
		str += "["
		for row, w in @data
			str += "["
			for col, h in @data[w]
				str += col+","
			str += "],\n"
		str +="],["
		for row, w in @git
			str += "["
			for col, h in @git[w]
				str += col+","
			str += "],\n"
		str+="],["

		for object in @object
			if object != 0
				str += "[#{object[0]},#{object[1]},#{object[2]}],"
		str+="],["
		for tile in @tilePalette
			str += "\""+ tile + "\","
		str+="],["
		for object in @objectPalette
			str += "\""+ object + "\","
		str+="]]"
		$("#savearea").val(str)

$ ()->
	window.MapMaker = new MapMaker()
	$(window).on 'resize', ()->
		$("#left").css({width: $(window).width() - 281})
	$("#left").css({width: $(window).width() - 281})
