import render_html from require 'lapis.html'

class Blog extends require('lapis').Application 
	@path: '/blog'

	[atom: "/feed.atom"]: =>
		postList = require 'models.postList'
		date = require 'date'

		xml = render_html ->
			feed xmlns: 'http://www.w3.org/2005/Atom', ->
				link href: 'http://throw-up.com/blog/feed.atom', rel: 'self'
				title 'Throw Up RSS'
				updated date(postList[1].PubDate)\fmt('%Y-%m-%dT%H:%M:%SZ')
				author ->
					name 'Zach Burke'
				id 'http://throw-up.com/'

				for i, post in ipairs postList
					entry ->
						title post.Title
						link href: "http://throw-up.com/#{post.Slug}"
						id "http://throw-up.com/#{post.Slug}"
						updated date(post.PubDate)\fmt('%Y-%m-%dT%H:%M:%SZ')
						content type: 'html', @app\GetPostBodyByName post.FileName

		@res.headers["Content-Type"] = "application/xml"
		layout: false, xml 