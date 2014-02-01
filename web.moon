import capture_errors, yield_error from require 'lapis.application'

lapis = require 'lapis'
discount = require 'discount'
config = require('lapis.config').get!
require("lapis.features.etlua")

lapis.serve class extends lapis.Application
	@include 'applications.home'
	@include 'applications.me'

	new: =>
		super!
		@templates = require 'templates'

	GetPostBodyByName: (name) =>
		path = config.blogFilePath .. name 
		markdown = ''

		status, error = pcall ->
			io.input path
			markdown = discount(io.read '*all')

		if error then @ThrowUp!

		return markdown	

	ThrowUp: (error) =>
		unless error then yield_error "BARF!<br>I haven't written that one yet"
		yield_error error

