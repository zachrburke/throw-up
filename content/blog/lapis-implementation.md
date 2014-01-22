This has been exciting.  In my freetime for the past 5-6 days I have been working furiously on this blog.  I've decided that I need three posts to accurately sum up what has been an englightening project for me.  This post I'll write about the actual implementation of throw-up.

Yes, you heard me correctly, throw-up.  I thought the name was so clever I bought the domain sometime in late 2012-early 2013.  I thought I would dedicate it to the don'ts of the programming world.  My own version of [the daily wtf](http://thedailywtf.com/). 

My requirements were simple.  I liked the idea of writing posts in markdown.  I didn't want to bother with a database since I don't think I will write that much.  Also, since Kijana claimed he was able to load his page in under 50ms before adding disqus, I wanted to be faster than that.

Somewhere in working on this I decided I wanted to have syntactical highlighting since I would primarily talk about code.  In the end, here are the front-end tools I ended up using.

[Typelate](http://typeplate.com/) for typography.<br>
[Highlight.JS](http://softwaremaniacs.org/soft/highlight/en/) for syntax highlighting.  
[Socialicious](http://shalinguyen.github.io/socialicious/) for social media icons.<br>
also [Disqus](http://disqus.com/) of course because they freakin' sweet.

As for CSS frameworks, I opted out of those (with the exception of typelate).  I realized that when I look at frameworks like bootstrap I really just want a grid and I don't care about or need the rest of the stuff. I looked around for a standalone css grid then eventually rolled my own after reading [this](http://css-tricks.com/dont-overthink-it-grids/) post about grids by Chris Coyier.  I like how my design is less "poppy" than a default twitter bootstrap build would get you.

One problem with writing posts in markdown is it's a challenge to apply syntax highlighting.  Highlight JS solves this by looking at any code blocks in a document and using a heuristic to guess what kind language the code is in. This does mean it can be wrong.  It also doesn't support moonscript so I had to try and trick it into thinking code blocks on this page were coffeescript.  

I tried Font Awesome at first for icon support, but I don't think nginx liked it.  Rather than look into the issue I looked for another solution.  Socialicious was better for me since I really just wanted social media icons, and Socialicious is much smaller than font awesome so less page weight.

#### Learning Lapis

Lapis and moonscript held up pretty well considering they are both under two years old (Lapis being less than a year old itself).  Since moonscript compiles into lua, you get access to any existing lua library, and I was surprised to see there are tons of useful lua libraries if you are building a website.  For markdown parsing, there was [lua-discount](http://asbradbury.org/projects/lua-discount/).  For templating there is [luahtml](https://github.com/TheLinx/LuaHTML).  I originally wanted to use [etlua](https://github.com/leafo/etlua) but it won't work with lapis just [yet](https://github.com/leafo/etlua/issues/1)

One thing that concerned me about using Lapis was lack of robustness when dealing with lists/tables of information.  lua doesn't have a lot of built in support for tables, so doing something like getting the size of a table involves writing a function to iterate through the table and count how many elements are contained in it.  Fortunately, there exists [underscore-lua](https://github.com/jtarchie/underscore-lua), a 1-to-1 port of underscorejs to lua.  This pretty much grants us functionaltiy similar to Microsoft LINQ.  So it's possible to write code like this (last example from underscore documentation):

    local stooges = {{name='curly', age=25}, {name='moe', age=21}, {name='larry', age=23}}
    local youngest = _.chain(stooges)
      :sortBy(function(stooge) return stooge.age end)
      :map(function(stooge) return stooge.name .. ' is ' .. stooge.age end)
      :first()
      :value()
    => "moe is 21"

Lapis has it's own idea of how to create a view which I'm sure some of you will find a bit wacky.  Here is a snippet of the code used in my layout

    content: =>
        html_5 ->

          head -> 
            link rel: "icon", href: '/content/images/barf.ico'
            title if @Title then @Title else 'throw up;'

          body -> 
            header ->
              hgroup ->
                div ->
                  small "var up = new Exception();"
                  h3  "throw up;"

              section ->
                 ul ->
                  li ->
                    a href: 'http://twitter.com/zach_no_beard', target: '_blank', ->
                      i class: 'icon-twitter'
                  li ->
                    a href: 'https://github.com/zach-binary', target: '_blank', ->
                      i class: 'icon-github'
                  li ->
                    a href: 'http://ren.itch.io', target: '_blank', ->
                      small 'itch'

So what is this?  Well, this is moonscript.  What we have here is a very clever use of moonscript syntax.  I have a view called Index, and in that view I have a content method which defines a template for my view.  From there you can call just about any method you want, and if that method name isn't defined somewhere then it will be reflected into an html element.  The first parameter can be a table defining any number of attributes you want attached to that element.  You can pass in a callback that will generate output to be nested in that element, or for brevity, you can pass in a single value if you only want a small amount of content to be stored in that element.  The result is a templating language that resembles [Jade](http://jade-lang.com/)

This is an interesting approach since most people would hand you a view and say "it's just data", but here I'm handing you a view and I'm saying "it's just code."  At the same time, I can see how this approach could be very powerful, yet it's clean and understandable.  It may be considered overkill for view generation though.  

If this approach is too magical, then you can always introduce a templating engine.  Here I use a template to render the disqus widget because dumping the html for that in my moonscript views looked pretty ugly to me.  

    content: =>
        article ->
          section ->
            
            if @Post
              small 'posted sometime around ' .. @Post.PubDate 

            unless @errors
              raw @PostBody
              @RenderDisqus!
            else 
              raw @errors

    RenderDisqus: => 
      status, error = pcall ->
        raw luahtml.open('templates/disqus.html', { slug: @Post.Slug })


The full code is up on github.  I'm happy to say I was able to hit my page load goal of under 50ms.  The building openresty page clocks in between 20-25ms pre-disqus when running with production settings on my local machine.  

I would like to note that Lapis has a pretty slick looking integration with PostGres SQL.  I may consider changing my storage approach later to leverage that.  

#### Life without a debugger

Moonscript is still a new language and as a result, advanced features like a repl have not been implemented yet.  As a result, that means there is no way (that I know of anyway) to step through code using a debugger.  

Lapis attempts to combat this with a web console you can route to from your lapis application.  One thing you get from this is the ability to unfold and see what is in your tables, which the lua/moonscript console doesn't do.  

Still, I found it easier to add a debug directory to my project and populate that with scripts when any form of advanced investigation of my objects was necessary.  This way I can write code with Sublime.  I would prefer a debugger much more though ;-)

My next post I'll write about deployment.

