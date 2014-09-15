config = require('lapis.config').get!
util = require 'lapis.util'
http = require 'lapis.nginx.http'
csrf = require 'lapis.csrf'

_githubAuthUrl = 'https://github.com/login/oauth'
_githubApiUrl = 'https://api.github.com'

_redirect = (slug, state) ->
	authData = {
		:state
		client_id: config.githubClientId
		redirect_uri: "#{config.hostUrl}/github/token?slug=#{slug}"
	}
	return redirect_to: "#{_githubAuthUrl}/authorize?#{util.encode_query_string(authData)}"

_verifyOwner = (access_token) ->
	queryString = util.encode_query_string { access_token: access_token }
	body = http.simple {
		url: "#{_githubApiUrl}/user?#{queryString}"
		method: 'GET'
		headers: {
			'User-Agent': 'throw-up'
		}
	}

	user = util.from_json(body)
	return user.login == config.githubOwner

accessToken = (code) ->
	body = http.simple "#{_githubAuthUrl}/access_token", {
		client_id: config.githubClientId
		client_secret: config.githubClientSecret
		code: code
	}

	return util.parse_query_string(body)

require_github_auth = (fn) ->
	=>
		unless @cookies.access_token
			@write _redirect(@params.slug, csrf.generate_token @)
			return

		unless _verifyOwner(@cookies.access_token)
			@write status: 403, 'Not Allowed'
			return

		fn @

return { 
	:require_github_auth
	:accessToken
}
