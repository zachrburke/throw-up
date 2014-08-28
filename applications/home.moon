import respond_to from require 'lapis.application'
import to_json from require 'lapis.util'
import Articles from require 'models.articles'

class HomeApplication extends require('lapis').Application

	[loopback: '/']: =>
		redirect_to: @url_for 'index', slug: Articles\getLatestPostSlug!

	[index: "/:slug"]: respond_to {

		before: =>
			@PostList = Articles\getPostList!
			@Post = Articles\getArticleBySlug @params.slug

			unless @Post then @write status: 404, render: 'error', layout: 'layout'

		GET: =>
			@Title = @Post.title
			@URL = @req.built_url
			@Post.languages = to_json @Post.languages

			render: true, layout: 'layout'
	}

	[editor: '/:slug/edit']: =>
		'Editor goes here'

	