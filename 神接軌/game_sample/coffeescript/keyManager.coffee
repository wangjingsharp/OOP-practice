class window.KeyManager
	constructor: () ->
		@keys = []
		@win = null
		@keys_list = [
			["`",  "1",  "2",  "3",  "4",  "5",  "6",  "7",  "8",  "9",  "0",  "-",  "=",  "Backspace"],
			["Tab",  "Q",  "W",  "E",  "R",  "T",  "Y",  "U",  "I",  "O",  "P",  "[",  "]",  "\\"],
			["Caps Lock",  "A",  "S",  "D",  "F",  "G",  "H",  "J",  "K",  "L",  ";",  "'",  "Enter"],
			["Shift",  "Z",  "X",  "C",  "V",  "B",  "N",  "M",  ",",  ".",  "/",  "Shift",  "Top"],
			["Ctrl",  "Alt",  "Space",  "Alt",  "Ctrl",  "Left",  "Down",  "Right"]
		]

	createKeyBoard: () ->
		@win = new Windows 1100, 335, "快捷鍵設定"
		@win.main.html.style.overflowY = "hidden"
		for keys_row in @keys_list
			row = new Row
			for k, v of keys_row
				if typeof v != "function"
					b = new Block v
				b.addClass "keyboard"
				switch v
					when "Backspace"
						b.html.style.width = "100px"
					when "Tab"
						b.html.style.width = "80px"
					when "\\"
						b.html.style.width = "76px"
					when "Caps Lock"
						b.html.style.width = "101px"
					when "Enter"
						b.html.style.width = "120px"
					when "Shift"
						b.html.style.width = "143px"
					when "Ctrl"
						b.html.style.width = "90px"
					when "Alt"
						b.html.style.width = "80px"
					when "Space"
						b.html.style.width = "510px"
				b.appendTo row
			row.appendTo @win.main
		@win.hide()
		return

	show: () ->
		@createKeyBoard() if @win == null
		if @win.isHide()
			@win.show()
		else
			@win.hide()