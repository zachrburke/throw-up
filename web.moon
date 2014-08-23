import capture_errors, yield_error from require 'lapis.application'

lapis = require 'lapis'
discount = require 'discount'
config = require('lapis.config').get!

lapis.serve class extends lapis.Application
	@enable 'etlua'
	@include 'applications.home'
	@include 'applications.me'
	@include 'applications.blog'

	new: =>
		super!
		@templates = require 'templates'

	handle_404: => 
		@PostList = require 'models.postList'
		@write status: 404, render: 'error', layout: 'layout'

	GetPostBodyByName: (name) =>
		path = config.blogFilePath .. name 
		markdown = ''

		status, error = pcall ->
			io.input path
			markdown = discount(io.read '*all')

		return markdown	


