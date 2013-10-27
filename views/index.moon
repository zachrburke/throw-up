import Widget from require 'lapis.html'

luahtml = require 'luahtml'

class Index extends Widget

	content: =>
		article ->
			section ->
				
				if @Post
					small 'posted sometime around ' .. @Post.PubDate 

				unless @errors
					raw @PostBody
					@RenderDisqus!
				else 
					raw @errors

		aside ->
			section ->

				className = ''

				for i, post in ipairs @PostList
					if @Post
						className = if post.Slug == @Post.Slug then 'selected' else ''

					a href: '/' .. post.Slug, class: className, ->
						text post.Title
					small post.PubDate

	RenderDisqus: =>
		status, error = pcall ->
			raw luahtml.open('templates/disqus.html', { slug: @Post.Slug })

		raw error

		


