class window.Main extends BaseWindow
	constructor: () ->
		super 'main'

class window.Row extends BaseWindow
	constructor: (msg, cls) ->
		super 'row'
		@addClass cls if cls?
		@setMsg msg if msg?

class window.Options extends BaseWindow
	constructor: (msg, @node, that, win) ->
		super 'option'
		option = @
		@addEvent 'click', () ->
			win.clearOption()
			option.node.call(that, $(@html).data("idx"))
		@setMsg msg if msg?

		
class window.Checkbox extends BaseWindow
	constructor: () ->
		@html = document.createElement('input')
		@html.type = 'checkbox'
		@html.disabled = 'disabled'

	complete: (status) ->
		@html.checked = status

class window.Label extends BaseWindow
	constructor: (msg) ->
		super 'label'
		@setMsg msg if msg?

class window.Button extends BaseWindow
	constructor: (msg) ->
		super 'btn'
		@addClass 'submit'
		@html.style.marginTop = "3px"
		@html.style.marginBottom = "3px"
		@html.style.marginLeft = "0px"
		@setMsg msg

	addEvent: (fn, target) ->
		super 'click', fn, target

class window.Block extends BaseWindow
	constructor: (msg) ->
		super 'block'
		@setMsg msg

class window.SkillBlock extends BaseWindow
	constructor: (icon, name, description, lv, maxlv)->
		super 'skill'
		@setMsg "<img class='icon' src='#{icon}'/><div class='name'>#{name}</div><div class='lv'>#{lv}</div><div class='maxlv'>#{maxlv}</div><div class='description'>#{description}</div>"