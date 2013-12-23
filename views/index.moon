import Widget from require 'lapis.html'

etlua = require 'etlua'

class Index extends Widget

	content: =>
		section ->
			article ->
				
				if @Post and @errors == nil
					small 'posted sometime around ' .. @Post.PubDate 
					raw @PostBody
				else
					raw @errors

			div class: 'Disqus', ->
				unless @errors
					@Render 'templates/disqus.html', { slug: @Post.Slug }

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
				@Render 'templates/google_analytics.html'


	Render: (templateName, data) =>
		status, error = pcall ->
			io.input templateName
			template = etlua.compile(io.read('*all'))
			raw template data

		


