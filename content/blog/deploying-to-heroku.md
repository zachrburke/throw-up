#### Blogging With Lapis part 3, Deploying to Heroku

Sometimes, I insist on being different, and sometimes that can come back to bite me.  Writing the code for throw-up was a fun educational journey into front-end design and the lua scripting language.  Deployment on the other hand, was educational in a much more painful way.  

I decided to go with heroku since a lot of the work for that had been done for me.  While Heroku doesn't natively support lua, there is the handy dandy [lua build kit](https://github.com/leafo/heroku-buildpack-lua).  To give Heroku openresty support, there is [this luarock](https://github.com/leafo/heroku-openresty) which makes me wonder if I can't just install openresty using luarocks on my own machine.  

In order to make heroku aware of your projects dependencies on other lua libraries, the lua build kit looks in your project for a .rockspec file.  Mine looks like this

    dependencies = {
      "https://raw.github.com/leafo/heroku-openresty/master/heroku-openresty-dev-1.rockspec",
      "https://raw.github.com/jtarchie/underscore-lua/master/underscore-dev-1.rockspec",
      "https://raw.github.com/leafo/lapis-console/master/lapis_console-dev-1.rockspec",
      "https://raw.github.com/zach-binary/LuaHTML/master/luahtml-1.1.1-1.rockspec",
      "lua-discount",
      "moonscript",
      "lapis",
    }

This is similar to node where you would define your dependencies in a package.json file for npm to go grab when you deploy.  The process isn't perfect.  I found when working with luahtml that it wasn't getting retrieved because it's rockspec file specified a release branch.  The build kit didn't like that, so I had to fork the luahtml repo and modify it's rockspec file in order to make it work. 

Next thing I wanted to do was define an nginx configuration to use in a production environment.  Lapis makes this easy, you can define all your config values in a config.moon/lua file at the top level of your project, like so:

    config 'production', ->
      port os.getenv "PORT"
      num_workers 4
      code_cache 'on'

      blogFilePath 'content/blog/'

Again, this is just moonscript that gets interpreted into a lua table, so if you want you can nest objects as configuration values.  The code_cache tells nginx, I believe, to store an execution plan / build your lua server files in order to improve performance.

Finally, there was the Procfile to tell heroku how to start your server.  Here's what mine looked like originally.

    web: lapis server production

So now I'm ready to deploy my site!  I commit my changes, do a `git push heroku master`, and everything seems to get copied correctly.  Except for the fact that my site is throwing 500's.  What did I miss?

After about 3 hours of cursing heroku and punching empty shoe boxes I found that I forgot to tell heroku to compile my moon files into lua files.  Now I've opened up the troubles of getting heroku to do specific things before running your site.  

The only "clean" solution I found for this was to make a custom buildpack.  That seemed like a lot of work considering I just wanted to do a moonc before starting the server.  Not to mention that heroku only allows you to have one buildpack at a time, and I still need the lua buildpack.  You can bypass this using a special buildpack that is designed to load other buildpacks, but that adds even more excess to an already excessive solution. 

Finally I just added it to the Procfile.

    web: moonc .; moonc views/; moonc models; lapis server production

Not the prettiest solution, but it works.  

#### Keeping Heroku dynos alive

I only need one dyno for this blog right now.  The problem with this is that when you only have one dyno, it gets put to sleep after a hour of inactivity.  Sleep meaning whoever loads the site when the dyno is asleep has to put up with a long page load.  

To get around that, I followed the steps in [this blog post](http://beouk.blogspot.com/2012/02/keeping-heroku-awake.html) and created a scheduled task to ping my site every hour.  No more slacking dynos.

#### Conclusion

This concludes the exciting trilogy of posts about making a blog in Lapis.  Here's a quick list of the pros and cons I found

*pros:*

* **speed**: openresty is fast.  This is one of the key reasons I wanted to try it out.  Running httperf with 1000 sequential connections on my macbook pro retina against the building-openresty page yielded a rate of 0.8 ms per request.  That's sub millisecond to send an http request, parse markdown and send that markdown back.  That seems fast anyway, I'll need a better way to compare metrics to other frameworks.
*  **developer experience**: moonscript was designed so you can write clean code.  It takes a little getting used too, and there was a point where I lost time due to an indentation mistake.  However, I haven't really had to struggle understanding my own code.  It's easy to keep files small and the lack of needed brackets cuts down on a lot of typing and makes writing code flow real quickly.  Sure you have a build step but I quickly forgot about it once I started using live reload (which admittedly did bite me in deployment)

*cons*

* **no repl/debugger**: this is pretty self explanatory. 
* **deployment**: Per this post, there are some improvements that can be made here.  Having nginx interperet moon files directly is a todo for the lapis project, and would be a huge deal sealer for me and probably many other developers.

Some things I may tackle next are writing tests using busted to check my posts for spelling errors and broken links.  

