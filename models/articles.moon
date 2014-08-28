import Model from require 'lapis.db.model'
import getOldPostBySlug, oldPostList from require 'repo.oldPostRepo'

date = require 'date'
db = require 'lapis.db'

class Articles extends Model
	@getArticleBySlug: (slug) =>
		post = nil

		status, error = pcall ->
			post = Articles\find slug: slug
			post.pub_date = date(post.pub_date)\fmt('%B %d, %Y')

		-- fallback to loading .md file if slug not found
		unless post then post = getOldPostBySlug(slug)

		return post

	@getPostList: =>
		postList = nil

		status, error = pcall ->
			postList = db.select([[title, slug, to_char(pub_date, 'Mon DD, YYYY') as pub_date from articles]])

		unless postList then postList = oldPostList

		return postList

	@getLatestPostSlug: =>
		slug = nil

		status, error = pcall ->
			slug = db.select('slug from articles order by id desc limit 1').slug

		unless slug then slug = oldPostList[1].slug

		return slug

return { 
	Articles: Articles
}