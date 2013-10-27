import config from require 'lapis.config'

config 'development', ->
	port 8080
	code_cache 'off'

	blogFilePath 'content/blog/'

config 'production', ->
	port os.getenv "PORT"
	num_workers 4
	code_cache 'on'

	blogFilePath 'content/blog/'