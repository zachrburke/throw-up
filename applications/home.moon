import capture_errors, yield_error from require 'lapis.application'
import render_html from require 'lapis.html'

lapis = require 'lapis'
_ = require 'underscore'
PostList = require 'models.postList'
config = require('lapis.config').get!
date = require 'date'

class HomeApplication extends lapis.Application

	[loopback: '/']: =>
		redirect_to: @url_for 'index', slug: PostList[1].Slug

	[index: "/:slug"]: capture_errors =>

		@PostList = PostList
		@Post = _.find PostList, (post) ->
			return post.Slug == @params.slug

		unless @Post then @app\ThrowUp!
		
		@Title = @Post.Title
		@PostBody = @app\GetPostBodyByName @Post.FileName
		@URL = @req.built_url

		render: true, layout: 'layout'

	[atom: "/blog/feed.atom"]: =>
		xml = render_html ->
			feed xmlns: 'http://www.w3.org/2005/Atom', ->
				link href: 'http://throw-up.com/blog/feed.atom', rel: 'self'
				title 'Throw Up RSS'
				updated date(PostList[1].PubDate)\fmt('%Y-%m-%dT%H:%M:%SZ')
				author ->
					name 'Zach Burke'
				id 'http://throw-up.com/'

				for i, post in ipairs PostList
					entry ->
						title post.Title
						link href: "http://throw-up.com/#{post.Slug}"
						id "http://throw-up.com/#{post.Slug}"
						updated date(post.PubDate)\fmt('%Y-%m-%dT%H:%M:%SZ')
						content type: 'html', @app\GetPostBodyByName post.FileName

		@res.headers["Content-Type"] = "application/xml"
		layout: false, xml 


	