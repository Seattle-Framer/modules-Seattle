# Text Class
# Created 14 SEP 2016 by Jordan Robert Dobson / jordandobson@gmail.com / @jordandobson

class exports.Text

  ####################################################################################################
	# CONSTANTS

	@NO_WRAP     = NO_WRAP     = whiteSpace:   "nowrap"
	@WRAP        = WRAP        = whiteSpace:   "auto"
	@ELLIPSIS    = ELLIPSIS    = textOverflow: "ellipsis"
	@NO_OVERFLOW = NO_OVERFLOW = overflow:     "hidden"
	@INLINE      = INLINE      = display:      "inline"
	@BLOCK       = BLOCK       = display:      "block"
	@BOX         = BOX         = display:      "-webkit-box"
	@ORIENT      = ORIENT      = "-webkit-box-orient": "vertical"
	@CLAMP       = CLAMP       = "-webkit-line-clamp"

  ####################################################################################################
	# CLASS METHODS

	@disableLineBreak = (layer) ->
			return NO_WRAP unless layer?
			# layer.style = NO_WRAP
			for property, value of NO_WRAP
				layer._element.children[0].style[property] = value

	@enableLineBreak = (layer) ->
			return NO_WRAP unless layer?
			# layer.style = NO_WRAP
			for property, value of NO_WRAP
				layer._element.children[0].style[property] = value

	@enableEllipsis = (layer) ->
			# Check Type to see if layer or should apply to first child
			ellipsisProperties = _.extend( {}, NO_WRAP, ELLIPSIS, NO_OVERFLOW )
			return ellipsisProperties unless layer?
			layer._element.children[0].style[property] = value for property, value of ellipsisProperties

	@enableInline = (layer) ->
		return INLINE unless layer?
		layer._element.children[0].style[property] = value for property, value of INLINE
		return

	@enableBlock = (layer) ->
		return BLOCK unless layer?
		layer._element.children[0].style[property] = value for property, value of BLOCK
		return

	@enableEllipsisLineClamp = (layer, lineCount=2) ->
		# https://css-tricks.com/line-clampin/#article-header-id-0
		lineClampProperties = _.extend( {}, ELLIPSIS, NO_OVERFLOW, BOX, ORIENT, {"#{CLAMP}": lineCount} )
		return lineClampProperties unless layer?
		layer._element.children[0].style[property] = value for property, value of lineClampProperties

	@intrinsicHeight = (layer, setHeight) ->
		return unless layer
		height = layer._element.children[0].offsetHeight
		layer.height = height if setHeight
		return height

	@intrinsicWidth = (layer) ->
		return unless layer
		Text.disableLineBreak layer
		Text.enableInline layer
		width = layer._element.children[0].offsetWidth
		Text.enableBlock layer
		return width
