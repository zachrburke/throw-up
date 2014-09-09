lapis = require 'lapis'
articleRepo = require 'repo.articleRepo'
date = require 'date'

lapis.serve class SiteMap extends lapis.Application 

	[sitemap: "/sitemap.xml"]: =>
		postList = articleRepo.getPostList!

		@res.headers["Content-Type"] = "application/xml"
		layout: false, @html ->
			urlset { 
				xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9'
				['xmlns:xsi']: 'http://www.w3.org/2001/XMLSchema-instance'
				['xsi:schemaLocation']: [[http://www.sitemaps.org/schemas/sitemap/0.9
					http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd]]
			}, ->

				for i, post in ipairs postList
					url ->
						loc "http://throw-up.com/#{post.slug}"

				url ->
					loc "http://throw-up.com/me"
				url ->
					loc "http://throw-up.com/me/portfolio"