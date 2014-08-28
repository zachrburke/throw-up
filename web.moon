import Articles from require 'models.articles'

lapis = require 'lapis'
discount = require 'discount'
config = require('lapis.config').get!

lapis.serve class extends lapis.Application
	@enable 'etlua'
	@include 'applications.home'
	@include 'applications.me'
	@include 'applications.blog'

	@before_filter =>
		@env = config._name

	handle_404: => 
		@PostList = Articles\getPostList!
		@write status: 404, render: 'error', layout: 'layout'
