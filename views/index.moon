import Widget from require 'lapis.html'

etlua = require 'etlua'

class Index extends Widget

	content: =>
		article ->
			section ->
				
				if @Post
					small 'posted sometime around ' .. @Post.PubDate 

				unless @errors
					raw @PostBody
					@Render 'templates/disqus.html', { slug: @Post.Slug }
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

			if @Environment != 'development'
				@Render 'templates/track_page.html', { slug: @Post.Slug }


	Render: (templateName, data) =>
		status, error = pcall ->
			io.input templateName
			template = etlua.compile(io.read('*all'))
			raw template data

		


