# RemoteControl Class
# Created 29 AUG 2016 by Jordan Robert Dobson / jordandobson@gmail.com / @jordandobson

class exports.RemoteControl extends MIDIComponent

	################################################################################
	# CONSTANTS

	@UP     = UP     = "up"
	@DOWN   = DOWN   = "down"
	@LEFT   = LEFT   = "left"
	@RIGHT  = RIGHT  = "right"
	@BACK   = BACK   = "back"
	@SELECT = SELECT = "select"
	@START  = START  = "start"
	@MENU   = MENU   = "menu"
	@OTHER  = OTHER  = "other"

	EVENT_BUTTON    = "press:button"
	EVENT_DIRECTION = "press:direction"
	EVENT_OTHER     = "press:other"

	MAX_VALUE = 127
	MIN_VALUE = 0

	TYPE_KEYBOARD = "keyboard"

	################################################################################
	# INITIALIZATION

	constructor:(options={}) ->
		@midiControlIDs = options.midiControlIDs or {}
		@keyCodeIDs     = options.keyCodeIDs     or {}
		super options
		unless Object.keys(@keyCodeIDs).length is 0
			window.onkeydown = (event) =>
				handleInput @, MAX_VALUE, type: TYPE_KEYBOARD, control: event.keyCode

		@.onValueChange (value, info) ->
			# Set the source and channel the first time unless they're set already
			@.source  = info.source  unless @.source
			@.channel = info.channel unless @.channel
			handleInput @, value, info

	################################################################################
	# PUBLIC METHODS

	emitEvent: (type, action, value, info) -> @.emit type, action, value, info

	################################################################################
	# PRIVATE METHODS

	handleInput = (self, value, info) ->
		control = info.control
		type = action = null
		if info.type is TYPE_KEYBOARD 		  # Check Keyboard Value & Type
			type = EVENT_BUTTON    if type is null and action = checkButtonKeyboard      self, control
			type = EVENT_DIRECTION if type is null and action = checkDirectionKeyboard   self, control
		unless info.type is TYPE_KEYBOARD 	# Check Controller Value & Type
			type = EVENT_BUTTON    if type is null and action = checkButtonController    self, control
			type = EVENT_DIRECTION if type is null and action = checkDirectionController self, control
		unless type							            # Set as Other Event & Type
			type = EVENT_OTHER
			action = "#{OTHER}: #{control}"
			action += " - " + info.type if info.type?
		return self.emitEvent type, action, value, info

	checkDirectionKeyboard = (self, control) ->
		switch control
			when self.keyCodeIDs.up    then return UP
			when self.keyCodeIDs.down  then return DOWN
			when self.keyCodeIDs.left  then return LEFT
			when self.keyCodeIDs.right then return RIGHT

	checkButtonKeyboard = (self, control) ->
		switch control
			when self.keyCodeIDs.select then return SELECT
			when self.keyCodeIDs.back   then return BACK
			when self.keyCodeIDs.start  then return START

	checkButtonController = (self, control) ->
		switch control
			when self.midiControlIDs.select then return SELECT
			when self.midiControlIDs.back   then return BACK
			when self.midiControlIDs.start  then return START

	checkDirectionController = (self, control) ->
		switch control
			when self.midiControlIDs.up    then return UP
			when self.midiControlIDs.down  then return DOWN
			when self.midiControlIDs.left  then return LEFT
			when self.midiControlIDs.right then return RIGHT
