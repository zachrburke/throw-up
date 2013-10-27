#### Blogging with Lapis, Building Openresty

A few weeks ago I read [this](http://kijanawoodard.com/building-a-blog-engine) blog post by Kijana Woodard, which inspired me to create my own blog.  This gives me an opportunity to touch on a number of technologies I've been meaning to checkout.  Namely, [Openresty](http://openresty.org) and [Lapis](http://leafo.net/lapis), a web framework that leverages [moonscript](http://moonscript.org).

I am going to break this out over two posts since I wanted cover the installation of openresty seperate from the rest of the blog implementation.  It should be noted that I did this development on a Mac machine, and I am not sure how I would setup openresty on a windows box just yet.

So I went to the openresty website and faithfully followed their step by step instructions.  I downloaded the latest version which at this time of writing in 1.4.2.9.

PCRE is a prerequisite for Mac users so I started by running this:

	brew install pcre

Then I moved to an appropriate development folder and untarred the build files.

	tar -xvf ngx_openresty-1.4.2.9
	cd ngx_openresty-1.4.2.9

Next I had to configure the build.  Since PCRE was a prereq for me because I'm on a mac, I had to specify where it could find that using the --with-ld-opt and --with-cc-opt arguments.  

	./configure  --with-luajit --with-http_postgres_module --with-cc-opt="-I/usr/local/include" --with-ld-opt="-L/usr/local/lib"

I also told it to include the postgres http module because that is recommended for Lapis, although I have no intention of using a database for this project.  Luajit should just about always be added because it improves performance.

With that, all that was left was to make and install it.

	make
	make install

I did attempt to do this without PCRE only to run into an error in the last step.  Once I installed that everything built smoothly.  

With that I went ahead and installed lapis, which was pretty easy.

	luarocks install --server=http://rocks.moonscript.org/manifests/leafo lapis`  

Created a new site using `lapis new` then tested it with `lapis server` after building the example web.moon.  Everything is green so far!