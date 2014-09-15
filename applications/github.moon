config = require('lapis.config').get!
util = require 'lapis.util'
http = require 'lapis.nginx.http'
githubAuth = require 'auth.github'
csrf = require 'lapis.csrf'

class Github extends require('lapis').Application

	[token: '/github/token']: =>
		csrf.assert_token @
		token = githubAuth.accessToken(@params.code)

		if token.access_token
			@cookies.access_token = token.access_token

		redirect_to: @url_for 'editor', { slug: @params.slug }

