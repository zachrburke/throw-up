import config from require 'lapis.config'

config 'development', ->
	port 8080
	code_cache 'off'
	server_name 'dev.throw-up.com'

	blogFilePath 'content/blog/'

	githubClientId 'your github application client id'
	githubClientSecret 'your github application client secret'
	githubOwner 'your github username'
	
	hostUrl 'http://dev.throw-up.com:8080' --as configured in github

	postgres ->
		backend 'pgmoon'
		host '127.0.0.1'
		user 'vagrant'
		database 'vagrant'

config 'production', ->
	port os.getenv "PORT"
	num_workers 4
	code_cache 'on'
	server_name 'throw-up.com www.throw-up'

	blogFilePath 'content/blog/'

	postgres ->
		backend 'pgmoon'
		host '127.0.0.1'
		user 'vagrant'
		database 'vagrant'

