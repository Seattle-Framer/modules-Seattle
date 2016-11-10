###################################################################################
# Created by Jordan Robert Dobson on 05 OCT 2015
# Updated by Jordan Robert Dobson on 14 SEP 2016
#
# Use to add font files and reference them in your CSS style settings.
#
# To Get Started...
#
# 1. Place the FontFace.coffee file in Framer Studio modules directory
#
# 2. In your project include:
#     {FontFace} = require "FontFace"
#
# 3. To add a font face:
#     gotham = new FontFace name: "Gotham", file: "Gotham.ttf", weight: 400
#
# 4. It checks that the font was loaded. Errors can be suppressed like so...
#    gotham = new FontFace name: "Gotham", file: "Gotham.ttf", hideErrors: true
#
###################################################################################

class exports.FontFace

	TEST =
		face: "monospace"
		text: "foo"
		time: .01
		maxLoadAttempts: 200
		hideErrorMessages: true

	TEST.style =
		width:      "auto"
		fontSize:   "150px"
		fontFamily: TEST.face

	TEST.layer = new Layer
		name:   ".FontFace Tester"
		width:   0
		height:  1
		maxX:    -(Screen.width)
		visible: false
		html:    TEST.text
		style:   TEST.style


	# SETUP FOR EVERY INSTANCE
	constructor: (options) ->

		@name = @file = @testLayer = @isLoaded = @loadFailed = @loadAttempts = @originalSize = @hideErrors =  null

		if options?
			@name   = options.name   or null
			@file   = options.file   or null
			@weight = options.weight or 400
			@style  = options.style  or "normal"

		return missingArgumentError() unless @name? and @file?

		@testLayer         = TEST.layer.copy()
		@testLayer.style   = TEST.style
		@testLayer.maxX    = -(Screen.width)
		@testLayer.visible = true

		@isLoaded     = false
		@loadFailed   = false
		@loadAttempts = 0
		@hideErrors   = options.hideErrors

		return addFontFace @

	##############################################################################
	# Private Helper Methods #####################################################

	addFontFace = (self) ->
		# Create our Element & Node
		styleTag = document.createElement 'style'
		faceCSS  = document.createTextNode """
			@font-face {
				font-family:"#{self.name  }";
					src:  url("#{self.file  }") format("truetype");
				font-weight: #{self.weight};
				font-style:  #{self.style };
			}"""
		# Add the Element & Node to the document
		styleTag.appendChild faceCSS
		document.head.appendChild styleTag
		# Test out the Font to see if it changed
		testNewFace self.name, self

	##############################################################################

	removeTestLayer = (self) ->
		self.testLayer.destroy()
		self.testLayer = null

	##############################################################################

	testNewFace = (name, self) ->

		initialWidth = self.testLayer._element.getBoundingClientRect().width

		# Check to see if it's ready yet
		if initialWidth is 0
			if self.hideErrors is false or TEST.hideErrorMessages is false
				print "Load testing failed. Attempting again."
			return Utils.delay TEST.time, -> testNewFace name, self

		self.loadAttempts++

		if self.originalSize is null
			self.originalSize = initialWidth
			self.testLayer.style = fontFamily: "#{name}, #{TEST.face}"

		widthUpdate = self.testLayer._element.getBoundingClientRect().width

		if self.originalSize is widthUpdate
			# If we can attempt to check again... Do it
			if self.loadAttempts < TEST.maxLoadAttempts
				return Utils.delay TEST.time, -> testNewFace name, self

			print       "⚠️ Failed loading FontFace: #{name} #{self.weight}" unless self.hideErrors
			console.log "⚠️ Failed loading FontFace: #{name} #{self.weight}"
			self.isLoaded   = false
			self.loadFailed = true
			loadTestingFileError self unless self.hideErrors
			return

		else
			print "LOADED: #{name} #{self.weight}" unless self.hideErrors is false or TEST.hideErrorMessages
			console.log "FONT FACE - LOADED: #{name} #{self.weight}"
			self.isLoaded   = true
			self.loadFailed = false

		removeTestLayer self
		return name

	##############################################################################
	# Error Handler Methods ######################################################

	missingArgumentError = ->
		error """<b>FontFace</b> Missing Name and/or File: See Console"""
		console.error """
			Error: You must pass name & file properites when creating a new FontFace. \n
			Example: myFace = new FontFace name:\"Gotham\", file:\"gotham.ttf\" \n"""

	loadTestingFileError = (self) ->
		error """<b>FontFace</b>  Loading Error: See Console"""
		console.error """
			Error: Couldn't detect the font: \"#{self.name}\" and file: \"#{self.file}\" was loaded.  \n
			Either the file couldn't be found or your browser doesn't support the file type that was provided. \n
			Suppress this message by adding \"hideErrors: true\" when creating a new FontFace. \n"""

	error = (message) ->
		Framer.Extras.ErrorDisplay.enable()
		throw Error message
