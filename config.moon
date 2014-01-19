import config from require 'lapis.config'

config 'development', ->
	port 8080
	code_cache 'off'
	server_name 'dev.throw-up.com'

	blogFilePath 'content/blog/'

config 'production', ->
	port os.getenv "PORT"
	num_workers 4
	code_cache 'on'
	server_name 'throw-up.com www.throw-up'

	blogFilePath 'content/blog/'

