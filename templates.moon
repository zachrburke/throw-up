etlua = require 'etlua'
templates = {}
util = require 'lapis.util'

status, error = pcall ->
	io.input 'templates/disqus.html'
	templates.disqus = etlua.compile(io.read('*all'))

	io.input 'templates/google_analytics.html'
	templates.google_analytics = etlua.compile(io.read('*all'))

	io.input 'templates/share.html'
	templates.share = etlua.compile(io.read('*all'))

	io.input 'templates/maillist.html'
	templates.maillist = etlua.compile(io.read('*all'))

if error
	ngx.log ngx.NOTICE, error

return templates