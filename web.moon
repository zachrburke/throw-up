import capture_errors, yield_error from require 'lapis.application'

lapis = require 'lapis'
console = require 'lapis.console'
discount = require 'discount'
_ = require 'underscore'
PostList = require 'models.postList'


lapis.serve class extends lapis.Application

	layout: require 'views.layout'

	[loopback: '/']: =>
		redirect_to: '/building-openresty'

	[index: "/:slug"]: capture_errors =>

		@PostList = PostList
		@Post = _.find PostList, (post) ->
			return post.Slug == @params.slug

		unless @Post then @app\ThrowUp!

		@PostBody = @app\GetPostBodyByName @Post.FileName

		render: true

	[console: '/debug/console']: console.make!

	GetPostBodyByName: (name) =>
		path = 'content/blog/' .. name 
		markdown = ''

		status, error = pcall ->
			io.input path
			markdown = discount(io.read '*all')

		if error then @ThrowUp!

		return markdown	

	ThrowUp: (error) =>
		unless error then yield_error "bluuuuugggh<br>haven't written that one yet"
		yield_error error

	


