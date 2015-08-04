# 基本類別
#  - Timeout or Interval
#  - @fn: (a,b)->
#  -    console.log this //印出role的物件
#  -    console.log a  //印出1
#  -    console.log b  //印出2
#  - role.timeout @fn, 1000, 1, 2
class window.Base
	timeout: (fn, time)->
		that = this
		args = (arguments[i] for i in [2..arguments.length])
		return setTimeout ()->
			fn.apply(that, args)
		, time
		
	interval: (fn, time)->
		that = this
		args = (arguments[i] for i in [2..arguments.length])
		return setInterval ()->
			fn.apply(that, args)
		, time