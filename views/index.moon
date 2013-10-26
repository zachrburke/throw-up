import Widget from require 'lapis.html'

class Index extends Widget

	content: =>
		article ->
			section -> 
				raw @PostBody
				if @errors == nil
					@RenderDisqus!
				else 
					raw @errors

		aside ->
			section ->

				for i, post in ipairs @PostList
					className = if post.Slug == @Post.Slug then 'selected' else ''

					a href: '/' .. post.Slug, class: className, ->
						text post.Title
					small post.PubDate

	RenderDisqus: =>
		raw string.format [[
			<div id="disqus_thread"></div>
	    <script type="text/javascript">
	        var disqus_shortname = 'throwup'; // required: replace example with your forum shortname
	        var disqus_identifier = '%s';
	        (function() {
	            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
	            dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
	            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
	        })();
	    </script>
	    <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
	    <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
		]], @Post.Slug


