import config from require 'lapis.config'

config 'development', ->
	port 8080
	code_cache 'off'

config 'production', ->
	port 80
	num_workers 4
	code_cache 'on'