import Widget from require 'lapis.html'

etlua = require 'etlua'
util = require 'lapis.util'

class Index extends Widget

	content: =>
		section ->

			div class: 'metadata', ->
				if @Post and @errors == nil
					small 'posted sometime around ' .. @Post.PubDate 
					h4 @Post.Title
					@Render 'share', { url: @URL, twitterText: @Title }

			article ->
				
				if @Post and @errors == nil
					raw @PostBody
				else
					raw @errors

			div class: 'Disqus', ->
				unless @errors
					@Render 'disqus', @Post.Slug
					-- a class: 'moot', href: 'https://moot.it/i/throw-up/'..@Post.Slug..':S', ->
						-- 'Comments for this blog entry'

		aside ->
			section ->

				className = ''

				for i, post in ipairs @PostList
					if @Post
						className = if post.Slug == @Post.Slug then 'selected' else ''

					div class: 'headline', ->
						a href: '/' .. post.Slug, class: className, ->
							text post.Title
						small post.PubDate

		@content_for "javascript", ->
			if @Post.Languages
				script src: '/content/js/highlight.pack.js'
				script -> 
					raw "var languages = #{util.to_json(@Post.Languages)};\n"
					raw [[
					hljs.configure({
						languages: languages
					});
					hljs.initHighlightingOnLoad();
				]]


	Render: (templateName, data) =>
		raw @app.templates[templateName](data)		


