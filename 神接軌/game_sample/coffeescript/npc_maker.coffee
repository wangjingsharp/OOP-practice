class NpcMaker
	constructor: ()->
		@node = @root = new Node '開始', '', 'start'
		@redraw()

	testNode: ()->
		@root.addNode(new Node '便當吃不飽怎麼辦？', "一個吃不飽，你不會吃兩個嗎？", "next1")
		@root.next[0].addNode(new Node 'ANS', "真是謝謝你的高見齁", "next1_1")
		@root.addNode(new Node '我做了很多事，卻得不到掌聲T^T', "乾我屁事= =", "next2")

	redraw: ()->
		ul = @createHtmlTree @root, 0
		$('.tree-node').html('').append ul

	createHtmlTree: (node, layer)->
		ul = $('<ul>')
		li = $('<li>')
		li.html node.name
		li.data 'node', node
		li.on 'click', @getNode
		li.css {
			paddingLeft: layer * 10
		}
		for node_child in node.next
			li.append @createHtmlTree(node_child, layer + 1)
		ul.append li
		return ul

	createCodeTree: ()->
		node = @root
		tmp = new Date()
		str = "class NPC_#{tmp.getTime()} extends window.Npc\n"
		str += "\tconstructor: (@mapname)->\n"
		str += "\t\tsuper(\"#{NPC_NAME}\", window.job.Swordsman, @mapname, 10, 11)\n"
		stack = []
		loop
			str += @createFunction node
			if node.next.length > 0
				stack.push node
				node = node.next.pop()
			else
				if stack.length > 0
					loop
						node = stack.pop()
						if node.next.length > 0
							stack.push node
							node = node.next.pop()
							break
						break if stack.length == 0
			break if stack.length == 0
		return str

	setMsg: (msg)->
		msg = msg.replace(/\n/g, "<br />")
		return "\t\t@mes \"#{msg}\"\n"

	jumpNextNode: (node)->
		return "\t\t@next @#{node.fn_name}\n"

	optionNode: (node)->
		return "\t\t@option \"#{node.name}\", @#{node.fn_name}\n"

	createFunction: (node, name)->
		str = "\t#{node.fn_name}: ()->\n"
		str += @setMsg node.content
		if node.next.length > 1
			str += @optionNode node_child for node_child in node.next
		else if node.next.length == 1
			str += @jumpNextNode node.next[0]
		else
			str += "\t\t@next @close\n"
		return str

	addContent: ()->
		that = @
		name = $('#content-name').val()
		content = $('#content-text').val()
		that.node.next[that.node.next.length] = new Node name, content, 0, that.node.layer + 1
		that.redraw()

	getNode: ()->
		that = npcMaker
		that.node = $(@).data "node"
		console.log that.node
		$('#content-name').val(that.node.name)
		$('#content-text').val(that.node.content)
		$('#save-content').on 'click', () ->
			that.node.name = $('#content-name').val()
			that.node.content = $('#content-text').val()
			that.redraw()
		that.redraw()

	export: ()->
		$("#export-content").html @createCodeTree()


$ ()->
	$('.content').hide()
	$('#content-main').show()

	window.NPC_NAME = prompt "輸入NPC的名字"
	window.npcMaker = new NpcMaker()
	# npcMaker.testNode()

	$('#btn-export').on 'click', () ->
		$('.content').hide()
		$('#export-main').show()
		npcMaker.export()

	$('#btn-content').on 'click', () ->
		name = prompt "輸入節點名稱"
		fn_name = prompt "輸入function名稱"
		window.npcMaker.node.addNode(new Node name, "", fn_name)
		npcMaker.redraw()

	$('#btn-mission').on 'click', () ->
		name = prompt "輸入任務名稱"
		window.npcMaker.node.addMission(new Mission name, '')
		npcMaker.redraw()

	$(window).on 'resize', ()->
		$(".right").css {height: $(window).height() - $('nav').height()}

	$(".right").css {height: $(window).height() - $('nav').height()}
