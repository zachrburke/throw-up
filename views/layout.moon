import Widget from require 'lapis.html'

util = require 'lapis.util'

class Layout extends Widget

	content: =>
		html lang: 'en', itemscope: true, itemtype: "http://schema.org/WebPage", ['xmlns:fb']: "https://www.facebook.com/2008/fbml", ->

			head -> 
				meta name: "viewport", content: 'width=device-width, initial-scale=1.0'
				link rel: "stylesheet", href: '/content/css/typeplate.css'
				link rel: "stylesheet", href: '/content/css/styles.css'
				link rel: "stylesheet", href: '/content/css/default.css'
				link rel: "stylesheet", href: '/content/css/socialicious.css'
				link rel: "stylesheet", href: '//cdn.moot.it/1/moot.css'
				link rel: "icon", href: '/content/images/barf.ico'

				script src: '//code.jquery.com/jquery-1.10.2.min.js'
				script src: '//cdn.moot.it/1/moot.min.js'

				meta ['http-equiv']: 'X-UA-Compatible', content: 'IE=edge,chrome=1'
				meta content: '/content/images/vomit_fountain.png', itemprop: 'image', property: 'og:image'

				title if @Title then @Title else 'throw up;'

			body -> 
				header ->
					hgroup ->
						div ->
							a href: '/', ->
								img src: '/content/images/vomit_fountain.png'
							small "var up = new Exception();"
							h3  "throw up;"
							nav ->
								a href: '/', 'Home'
								a href: '/me/about', 'About'

					section ->
						 ul ->
							li ->
								a href: 'http://twitter.com/zach_no_beard', target: '_blank', ->
									i class: 'icon-twitter'
							li ->
								a href: 'https://github.com/zach-binary', target: '_blank', ->
									i class: 'icon-github'
							li ->
								a href: 'http://ren.itch.io', target: '_blank', ->
									img src: '/content/images/itchio_icon.png'



				section class: 'content', ->
					@content_for "inner"

				@content_for "javascript"

		

				
