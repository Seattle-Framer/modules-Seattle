$ = {}

$.app        = {}
$.view       = {}
$.states     = {}
$.kind       = {}

$.fontFamily = {}
$.type       = {}
$.font       = {}

$.layout     = {}
$.ratio      = {}

$.content    = {}

$.style      = {}

$.color =
  white: new Color "#fff"
  black: new Color "#000"
  clear: new Color "rgba(0,0,0,0)"

$.curve =
  linear: "linear"

$.state =
  show: "SHOW"
  hide: "HIDE"
  push: "PUSH"
  next: "NEXT"

$.utils =
	error: (message) ->
		Framer.Extras.ErrorDisplay.enable()
		throw Error message
	backgroundGradient: (layer, start="rgba(0,0,0,1)", stop="rgba(0,0,0,0)", deg=0) ->
		gradient = "linear-gradient(#{deg}deg, #{start}, #{stop})"
		return if layer? then layer.style.backgroundImage = gradient else gradient

exports.$ = $
