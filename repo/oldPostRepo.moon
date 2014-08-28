import find from require 'underscore'
import to_json from require 'lapis.util'

discount = require 'discount'
config = require('lapis.config').get!
postList = require 'repo.postList'

_getPostBodyByName = (name) ->
	path = config.blogFilePath .. name 
	markdown = ''

	status, error = pcall ->
		io.input path
		markdown = discount(io.read '*all')

	return markdown	

{
	getOldPostBySlug: (slug) ->
		post = find postList, (_post) ->
			return _post.slug == slug

		if post
			post.body = _getPostBodyByName post.FileName

		return post

	oldPostList: postList
}