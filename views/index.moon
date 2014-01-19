import Widget from require 'lapis.html'

etlua = require 'etlua'

class Index extends Widget

	content: =>
		section ->
			article ->
				
				if @Post and @errors == nil
					small 'posted sometime around ' .. @Post.PubDate 
					@Render 'share', { url: @URL, twitterText: @Title }
					raw @PostBody
				else
					raw @errors

			div class: 'Disqus', ->
				unless @errors
					a class: 'moot', href: 'https://moot.it/i/throw-up/'..@Post.Slug..':S', ->
						'Comments for this blog entry'

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
				@Render 'google_analytics'


	Render: (templateName, data) =>
		raw @app.templates[templateName](data)		


