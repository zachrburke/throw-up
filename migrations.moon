import create_table, types from require 'lapis.db.schema'

db = require 'lapis.db'
util = require 'lapis.util'

{
  	[1409023234219]: =>
	    create_table "articles", {
	      { "id", types.serial }
	      { "title", types.varchar }
	      { "slug", types.varchar }
	      { "body", types.text }
	      { "pub_date", types.date }
	      { "languages", "json" }

	      "PRIMARY KEY (id)"
	    }

	[1409024253675]: =>
		discount = require 'discount'
		postList = require 'repo.postList'
		config = require('lapis.config').get!

		for i, post in ipairs(postList)
			path = config.blogFilePath .. post.FileName
			io.input path
			db.insert 'articles', {
				title: post.title
				slug: post.slug
				body: discount(io.read '*all')
				pub_date: post.pub_date
				languages: util.to_json(post.languages)
			}

}