lapis = require 'lapis'

class MeApplication extends lapis.Application
	views_prefix: "views.me" --todo: make this work

	[about: '/me/about']: =>
		@Title = "About"
		render: 'me.about', layout: 'layout'

	[portfolio: '/me/portfolio']: =>
		@Title = "Portfolio"
		render: 'me.portfolio', layout: 'layout'
