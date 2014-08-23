import respond_to from require 'lapis.application'
import find from require 'underscore'

class HomeApplication extends require('lapis').Application

	[loopback: '/']: =>
		redirect_to: @url_for 'index', slug: require('models.postList')[1].Slug

	[index: "/:slug"]: respond_to {

		before: =>
			@PostList = require 'models.postList'
			@Post = find @PostList, (post) ->
				return post.Slug == @params.slug

			unless @Post then @write status: 404, render: 'error', layout: 'layout'

		GET: =>
			@Title = @Post.Title
			@PostBody = @app\GetPostBodyByName @Post.FileName
			@URL = @req.built_url

			render: true, layout: 'layout'
	}

	[editor: '/:slug/edit']: =>
		'Editor goes here'

	