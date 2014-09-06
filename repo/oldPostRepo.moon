import find from require 'underscore'
import to_json from require 'lapis.util'

discount = require 'discount'
config = require('lapis.config').get!

_getPostBodyByName = (name) ->
	path = config.blogFilePath .. name 
	markdown = ''

	status, error = pcall ->
		io.input path
		markdown = discount(io.read '*all')

	return markdown	

{
	getOldPostBySlug: (slug) ->
		post = find postList, (_post) ->
			return _post.slug == slug

		if post
			post.body = _getPostBodyByName post.FileName

		return post

	getOldAtomFeed: =>
		postList = {}

		for i, post in self.oldPostList
			post.body = _getPostBodyByName post.FileName
			table.insert postList, post

		return postList

	oldPostList: {
		{
			title: "Extending Sprite Kit classes with swift protocols"
			slug: "swift-protocol-extension"
			FileName: "swift-protocol-extension.md"
			pub_date: "June 13, 2014"
			languages: { 'coffeescript' }
		}
		{
			title: "Embedding lua in .NET"
			slug: "lua-dot-net"
			FileName: "lua-dot-net.md"
			pub_date: "May 30, 2014"
			languages: { 'cs', 'lua' }
		}
		{
			title: "Writer's block is a thing"
			slug: "writers-block"
			FileName: "writers-block.md"
			pub_date: "March 25, 2014"
		}
		{
			title: "Why aren't there more ways to represent data?"
			slug: "data-representation"
			FileName: "data-representation.md"
			pub_date: "March 23, 2014"
		}
		{
			title: "Makin' changes, switchin' to Moot"
			slug: "some-changes"
			FileName: "some-changes.md"
			pub_date: "January 25, 2014"
			languages: { 'coffeescript', 'js' }
		}
		{
			title: "Cleaning up, moonc -t and Guard"
			slug: "cleaning-up"
			FileName: "cleaner-workflow.md"
			pub_date: "January 4, 2014"
			languages: { 'ruby' }
		}
		{
			title: "Benefits of the article Tag"
			slug: "benefits-of-article"
			FileName: "benefits-of-article.md"
			pub_date: "December 22, 2013"
		}
		{
			title: "SOLR in Lua/Moonscript using SPORE"
			slug: "solr-spore"
			FileName: "solr-spore.md"
			pub_date: "November 14, 2013"
			languages: {'js', 'lua'}
		}
		{
			title: "Blogging With Lapis, Deploying to Heroku"
			slug: "deploying-to-heroku"
			FileName: "deploying-to-heroku.md"
			pub_date: "October 29, 2013"
			languages: {'lua'}
		}
		{
			title: "Blogging With Lapis, Implementation"
			slug: "lapis-implementation"
			FileName: "lapis-implementation.md"
			pub_date: "October 27, 2013"
			languages: {'lua', 'coffeescript'}
		}
		{
			title: "Blogging With Lapis, Building Openresty"
			slug: "building-openresty"
			FileName: "building-openresty.md"
			pub_date: "October 22, 2013"
		}
	}
}