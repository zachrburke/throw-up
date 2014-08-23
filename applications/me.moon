lapis = require 'lapis'

class MeApplication extends lapis.Application
	@path: '/me'

	[about: '/about']: =>
		@Title = "About"
		render: 'me.about', layout: 'layout'

	[portfolio: '/portfolio']: =>
		@Title = "Portfolio"
		render: 'me.portfolio', layout: 'layout'
