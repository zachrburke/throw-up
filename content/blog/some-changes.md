For the past few weeks I have been making changes to the look and feel of throw-up.  The changes boil down to

* Upgrading HighlightJS
* Squashing the side articles bar
* Switching out [Disqus](lkhlkh) with [Moot](http://moot.it) for handling comments

#####HighlightJS

In my last post about Guard, I mentioned that I turned off [HighlightJS](lkhlkh) because I was having issues getting it to detect the right language for a code block, and because I had a ruby snippet to show but didn't initially include ruby with my packed highlightjs file.  At the time I decided it was easier to just drop it instead of rebuild it with the ruby language included.

The decision to pick a small set of languages wasn't to reduce page weight, although that is a qualifying factor.  It was to reduce the probability that the wrong language would be detected on a page where I refer to code.  With their 0.80 release, they fix this problem by allowing you to specify what languages highlightjs should look for before having it auto highlight anything.  Now, in my post list I specify the programming languages to be expected in a blog post, like so:

    return {
    {
        Title: "Makin' changes, switchin' to Moot"
        Slug: "some-changes"
        FileName: "some-changes.md"
        PubDate: "January 25, 2014"
        Languages: { 'coffeescript', 'js' }
    }
    --... more code

I then initialize HighlightJS like this:

    if @Post.Languages
        script src: '/content/js/highlight.pack.js'
        script -> 
            raw "var languages = #{util.to_json(@Post.Languages)};\n"
            raw [[
            hljs.configure({
                languages: languages
            });
            hljs.initHighlightingOnLoad();
        ]]

It's worthwhile to note the Languages attribute is optional, if it doesn't exist I don't even request HLJS which saves me about 8-10ms in page load time.

#####Squashing the Archive

I decided to move the archive to the bottom of the page because I don't have that many posts yet.  So I could no longer justify using up 20% of the width of the screen when a long post like this one would mean leaving a huge gap of empty space beside the main content.  Afterall, it's the content that people care about, or so I hope.  

#####Switching out Disqus with Moot

This is probably the most signifigant change.  Comments haven't really brought any value to throw-up yet, but I didn't want to remove the option to leave a comment.  However, Disqus weighs a lot to keep around just in case someone wants to leave a comment, so I decided to try out [Moot](http://moot.it) instead.  

Moot is a forum and commenting engine that leverages Redis as a primary datastore.  That last fact is interesting because Redis lives in memory, so to use it in lieu of a database might actually frighten some people.  [this](https://moot.it/blog/technology/redis-as-primary-datastore-wtf.html) post here details the pains they went through to make the Redis datastore a reality and may calm some fears of trusting a memory store to persist data.  It's also a worthy read for anyone considering using Redis at all, even for a caching layer. 

Because of their storage strategy, they boast 2ms load speeds when under load.  Meaning I can have my comments without as much weight.  Unfortanetly this means you have to use a moot or facebook account to leave any comments.  One cool thing is when you register with moot is that you get a forum by default.  So if this takes off, adding a forum to capture the discussion that happens on the site would be trivial.

#####Other small changes

I addded some share buttons to the top of the blog post in hopes to improve traffic.  I didn't like how my posts looked on facebook without an image so I decided to add a little logo.  It was surprisingly easy to find a non-offensive image depicting someone throwing up.

That's it!  Maybe one day I'll write about code not related to throw-up.  :P

