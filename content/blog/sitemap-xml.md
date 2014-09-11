For far too long my sitemap has been served as a static xml file that I update every time I write a new post.  I'm forgetful, and I don't want any new articles to be missed by google, so it's a good idea to build up the sitemap when it's requested based on the content I've written so far.

Lapis makes serving up xml requests really easy with it's `@html` builder.  The `@html` builder isn't limited to creating only html elements, so it can be used to generate any arbitrary xml element.  Just change the `Content-Type` of your request to return xml and serve the rest of your request like normal.  Here is what my sitemap action looks like:


    [sitemap: "/sitemap.xml"]: =>
        postList = articleRepo.getPostList!

        @res.headers["Content-Type"] = "application/xml"
        layout: false, @html ->
            urlset { 
                xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9'
                ['xmlns:xsi']: 'http://www.w3.org/2001/XMLSchema-instance'
                ['xsi:schemaLocation']: [[http://www.sitemaps.org/schemas/sitemap/0.9
                    http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd]]
            }, ->

                for i, post in ipairs postList
                    url ->
                        loc "http://throw-up.com/#{post.slug}"

                url ->
                    loc "http://throw-up.com/me"
                url ->
                    loc "http://throw-up.com/me/portfolio"

I also want to make sure that `/sitemap.xml` always serves the sitemap and doesn't get mistaken for any other routes.  To do that, rather than depend on lapis to find the route, I'm going to offload that responsibility onto nginx.  

    location /sitemap.xml {
        default_type application/xml;
        content_by_lua_file "applications/sitemap.lua";
    }

So rather than looking at `web.moon` where the other applications are, I have `/sitemap.xml` look at a seperate application that only gets served when nginx receives that uri.  I just have to tell `sitemap.lua` to serve itself.

    lapis.serve class SiteMap extends lapis.Application 

        [sitemap: "/sitemap.xml"]: =>
        -- ..

That's it, we're done!