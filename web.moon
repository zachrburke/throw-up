import capture_errors, yield_error from require 'lapis.application'

lapis = require 'lapis'
console = require 'lapis.console'
discount = require 'discount'
_ = require 'underscore'
PostList = require 'models.postList'
config = require('lapis.config').get!

util = require 'lapis.util'


lapis.serve class extends lapis.Application

	layout: require 'views.layout'

	[loopback: '/']: =>
		redirect_to: PostList[1].Slug

	[index: "/:slug"]: capture_errors =>

		@PostList = PostList
		@Post = _.find PostList, (post) ->
			return post.Slug == @params.slug

		unless @Post then @app\ThrowUp!
		
		@Title = @Post.Title
		@PostBody = @app\GetPostBodyByName @Post.FileName
		@Environment = config._name
		@URL = @app\GetURL @req.parsed_url

		ngx.log ngx.NOTICE, @URL

		render: true

	[console: '/debug/console']: console.make!

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

	GetURL: (parsed_url) => 
		url = parsed_url.scheme..'://'..parsed_url.host
		if parsed_url.port then url = url..':'..parsed_url.port
		if parsed_url.path then url = url..parsed_url.path
		if parsed_url.query then url = url..'?'..parsed_url.query
		return url

	


