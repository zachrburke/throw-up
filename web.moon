lapis = require 'lapis'
discount = require 'discount'
config = require('lapis.config').get!
articleRepo = require 'repo.articleRepo'
date = require 'date'

lapis.serve class extends lapis.Application
	@enable 'etlua'
	@include 'applications.me'
	@include 'applications.blog'
	@include 'applications.home'
	@include 'applications.github'

	cookie_attributes: (name, value) =>
		if name == 'access_token'
			expires = date(true)\addminutes(15)\fmt "${http}"
			return "Expires=#{expires}; Path=/; HttpOnly"

		-- default session cookie
		return "Path=/; HttpOnly"

	@before_filter =>
		@env = config._name
		@authUrl = config.authUrl

	handle_404: => 
		@PostList = articleRepo.getPostList!
		@write status: 404, render: 'error', layout: 'layout'

