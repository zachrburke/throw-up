import respond_to from require 'lapis.application'
import to_json from require 'lapis.util'

articleRepo = require 'repo.articleRepo'

class HomeApplication extends require('lapis').Application

	[loopback: '/']: =>
		redirect_to: @url_for 'index', slug: articleRepo.getLatestPostSlug!

	[index: "/:slug"]: respond_to {

		before: =>
			@PostList = articleRepo.getPostList!
			@Post = articleRepo.getArticleBySlug @params.slug

			unless @Post then @write status: 404, render: 'error', layout: 'layout'

		GET: =>
			@Title = @Post.title
			@URL = @req.built_url
			@Post.languages = to_json @Post.languages

			render: true, layout: 'layout'
	}

	[editor: '/:slug/edit']: respond_to {

		GET: =>
			@Post = articleRepo.getArticleBySlug @params.slug
			unless @Post then @write status: 404, render: 'error', layout: 'layout'
			@Title = @Post.title..' / Edit'

			render: 'home.editor', layout: 'layout'
	}

	