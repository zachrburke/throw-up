import Widget from require 'lapis.html'

class Layout extends Widget

	content: =>
		html_5 ->

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

				title if @Title then @Title else 'throw up;'

			body -> 
				header ->
					hgroup ->
						div ->
							small "var up = new Exception();"
							h3  "throw up;"

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

				-- script src: '/content/js/highlight.pack.js'
				-- script 'hljs.initHighlightingOnLoad();' 
