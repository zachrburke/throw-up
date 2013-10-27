import Widget from require 'lapis.html'

require etlua = require 'etlua'

class Index extends Widget

	content: =>
		article ->
			section -> 
				raw @PostBody
				if @errors == nil
					@RenderDisqus!
				else 
					raw @errors

		aside ->
			section ->

				for i, post in ipairs @PostList
					className = if post.Slug == @Post.Slug then 'selected' else ''

					a href: '/' .. post.Slug, class: className, ->
						text post.Title
					small post.PubDate

	RenderDisqus: =>
		io.input '/templates/disqus.html'
		template = etlua.compile io.read('*all')
		raw template slug: @Post.Slug


