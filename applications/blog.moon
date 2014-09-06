articleRepo = require 'repo.articleRepo'

class Blog extends require('lapis').Application 

	[atom: "/blog/feed.atom"]: =>
		date = require 'date'
		postList = articleRepo.getAtomFeed!

		xml = @html ->
			feed xmlns: 'http://www.w3.org/2005/Atom', ->
				link href: 'http://throw-up.com/blog/feed.atom', rel: 'self'
				title 'Throw Up RSS'
				updated date(postList[1].pub_date)\fmt('%Y-%m-%dT%H:%M:%SZ')
				author ->
					name 'Zach Burke'
				id 'http://throw-up.com/'

				for i, post in ipairs postList
					entry ->
						title post.title
						link href: "http://throw-up.com/#{post.slug}"
						id "http://throw-up.com/#{post.slug}"
						updated date(post.pub_date)\fmt('%Y-%m-%dT%H:%M:%SZ')
						content type: 'html', post.body

		@res.headers["Content-Type"] = "application/xml"
		layout: false, xml 