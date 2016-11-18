# JSONRequest created by Jordan Dobson on 17 Nov 2016 - @jordandobson - jordandobson@gmail.com

class exports.JSONRequest extends Framer.BaseClass

	# https://davidwalsh.name/xmlhttprequest

	DATA  = "data"
	EVENT = "event"

	@LOAD     = LOAD     = "load"
	@ABORT    = ABORT    = "abort"
	@ERROR    = ERROR    = "error"
	@PROGRESS = PROGRESS = "progress"

	Events.JSONLoaded   = "JSONRequest.#{LOAD    }"
	Events.JSONAbort    = "JSONRequest.#{ABORT   }"
	Events.JSONError    = "JSONRequest.#{ERROR   }"
	Events.JSONProgress = "JSONRequest.#{PROGRESS}"
	Events.JSONEvent    = "JSONRequest.#{EVENT   }"

	MSG_LOAD_ERROR = "Data didn't load"
	MSG_LOAD_ABORT = "Loading Aborted"

	@define DATA, get: -> @_getPropertyValue DATA

	constructor: (options={}) ->
		@request = @url = @response = @event = null
		super options
		@url = options.url
		@request = new XMLHttpRequest()
		setupEvents @

	# Public Methods #####################################################

	get: (url) ->
		@request.open 'GET', url or @url, true
		@request.send null

	# Private Functions ##################################################

	setupEvents = (self) ->
		self.request.addEventListener LOAD,     ((e) -> handleResponse self, e), false
		self.request.addEventListener PROGRESS, ((e) -> handleResponse self, e), false
		self.request.addEventListener ERROR,    ((e) -> handleResponse self, e), false
		self.request.addEventListener ABORT,    ((e) -> handleResponse self, e), false

	handleResponse = (self, event) ->
		switch event.type
			when LOAD     then handleData      self, event
			when ERROR    then handleException self, MSG_LOAD_ERROR, ERROR
			when ABORT    then handleException self, MSG_LOAD_ABORT, ABORT
			when PROGRESS then handleProgress  self

	handleData = (self, event) ->
		response  = event.target.response
		jsonParse = JSON.parse response
		self.response = response
		self._setPropertyValue DATA, jsonParse
		self.emit Events.JSONLoaded, jsonParse
		self.emit Events.JSONEvent,  LOAD, jsonParse

	handleProgress = (self) ->
		self.emit Events.JSONProgress
		self.emit Events.JSONEvent, PROGRESS

	handleException = (self, message, type) ->
		self.emit Events.JSONAbort if type is ABORT
		self.emit Events.JSONError if type is ERROR
		self.emit Events.JSONEvent, ERROR if type is ERROR
		self.emit Events.JSONEvent, ABORT if type is ABORT
		requestExceptionError ERROR, "JSONRequest from URL: #{self.url}"         if type is ERROR
		requestExceptionError ABORT, "JSONRequest aborted from URL: #{self.url}" if type is ABORT
		# Fix Add Error Display

	requestExceptionError = (type, message) ->
		Framer.Extras.ErrorDisplay.enable()
		if type is ERROR
			console.error message
			throw Error message
		else
			console.warn  message if type is ABORT
