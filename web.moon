lapis = require 'lapis'
discount = require 'discount'
config = require('lapis.config').get!
articleRepo = require 'repo.articleRepo'

lapis.serve class extends lapis.Application
	@enable 'etlua'
	@include 'applications.me'
	@include 'applications.blog'
	@include 'applications.home'

	@before_filter =>
		@env = config._name

	handle_404: => 
		@PostList = articleRepo.getPostList!
		@write status: 404, render: 'error', layout: 'layout'

