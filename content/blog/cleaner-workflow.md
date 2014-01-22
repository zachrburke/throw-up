Today I was bored so I decided to do some cleaning up on throw-up.  A few things have bothered me since I started coding with the lapis/openresty stack.  First is that nginx likes to create several temp directories at the location I run, which is where my code is.  That generates about 4 directories of noise in my code base.  The other thing is that I would compile my moonscript files right where they were, so anytime I glance at my codebase I would see two versions of every .moon file which made a blog that is almost no code seem like a big project.

Using moonc -t, I was able to kill two birds with one stone.  the -t flag tells moonc to place compiled lua files in directory of choice.  I decided to create a bin directory that rests at the root level of my code and put the compiled lua files in there.  I wrote a small shellscript to copy over the content, mime types and nginx.conf file as well so I could run the lapis server in the bin directory instead of the root directory of my code.  Now those temp directories only exist in the bin directory where I don't have to look at them to navigate code.

In hindsight, I should have taken a before and after screenshot, but overall I feel like my code is a lot slimmer now, even though it was technically always slim.  

#####Replacing LiveReload with guard (but keeping live-reload)

One thing I was dissapointed by when first picking up Lapis was that I couldn't use tup to watch and build my moonscript files into lua.  Fortunately I found LiveReload, which not only watched my file system for changes, but also refreshes Chrome for me whenever there were changes.  

This is nice, but one problem is I now have another thing to look at for troubleshooting.  There have been brief spurts where I had a compilation problem that I would glance over for several minutes because I kept forgetting to check my LiveReload log.  

I use iTerm as my terminal emulator on OSX and I already have trained myself to look at that frequently when I encounter bugs.  Plus, it has a nifty split pane ability to give me multiple feeds of data I can easily see at one time.  Wouldn't it be nice if I could pipe the live reload output to iTerm and have all my logging go to one place?

That is where Guard comes in.  [Guard](https://github.com/guard/guard) is a command line tool designed to handle file system events.  Using ruby, you can write a Guardfile that defines how those events get handled.  There is a live reload plugin available for guard that allows you to refresh your browser in response to those events.  

Now I can run that in iTerm and have my build output right beside my server output.  Here is what my Guardfile looks like:

    filter /bin/

    guard 'livereload' do
        watch(%r{bin/views/.+})
        watch(%r{bin/content/.+\.(css|js|html|md)})
        watch(%r{bin/web.lua})
        watch(%r{bin/models/.+})
    end

    watch(%r{.+}) { `sh build.cmd` }

Also, this is all free.  Shame I already purchased LiveReload.  Also, as far as I can tell it's cross-platform, so this may work on Windows.  Having tried .NET Demon at work, I was dissapointed that it wouldn't refresh the browser after changing .cshtml files.  This might be a nice alternative to get past that.

#####One other thing

I'm turning off highlightjs for now.  Half my code is moonscript which isn't supported.  I also never thought I would post up Ruby code so it wasn't included when generating the script file.  I need to rethink how I'm going to post code on the site.  

