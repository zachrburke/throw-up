About a few months ago I read [this](http://www.sarahmei.com/blog/2013/11/11/why-you-should-never-use-mongodb/) article by Sarah Mei that flags some possible issues with using MongoDB as a data store for a social networking application.  The bulk of the article talks about using MongoDB as an approach to store activity streams such as those found on the news feed for your facebook account.  It then talks about falling back to PostGreSQL, which was also not exactly optimal for solving the problem either.

This got me thinking, why is it that after so long we are only now considering something **other** than SQL storage for our production applications.  Why is the only alternative to SQL storage a document database?  Here is a quote from that article that really struck me:

>For quite a few years now, the received wisdom has been that social data is not relational, and that if you store it in a relational database, you're doing it wrong.

>But what are the alternatives? Some folks say graph databases are more natural, but I'm not going to cover those here, **since graph databases are too niche to be put into production**

This is interesting, because a graph database strikes me as a perfect model for a social network.  I am betting that the growing popularity of Facebook and social networking was what spawned the idea of a graph database.  So why not use that?  The funny thing is that if you went into most software shops and proposed something like [neo4j](http://www.neo4j.org/) then you would have to explain why you shouldn't solve your graphing problem with a SQL database.  

What I don't understand is why developers can only get comfortable with the idea of a SQL or document database and why those are the only two popular ideas.  There are countless ways to deliver application code.  For example, a simple application to serve web requests can be done easily in so many languages now.

Since Facebook is on my brain right now, I'll give another example about them.  [Hip Hop Virtual Machine](http://hhvm.com/) is a VM capabile of jit compiling PHP for better performance.  On top of that, they also invented the [Hack](http://hacklang.org/) programming language which adds strong typing to PHP.  They would rather have invented a way to compile PHP into C++ than move to another programming language, then invented a new language on top of that.

Another example is the web framework that powers this blog.  [Lapis](http://leafo.net/lapis/) was written by Leaf Corcoran so that he could write [itch.io](http://itch.io) using Moonscript, which was also a language he himself wrote.

Why does this never seem to happen with database technology?  I have seen some technologies like [ActorDB](http://www.actordb.com/), which seeks to make a SQL database that is horizontally scalable and compatible with existing MySQL drivers.  There is also [RethinkDB](http://rethinkdb.com/) which builds off a lot of MongoDB's ideas but adds things like joins and a nice admin UI. 

Those are cool, but to me it's just more of the same.  You are forced to choose between a strict schema that maps to a flat table, or a big unorganized glob of data.  I would like to see developers consider other ways to represent their data, such as the graphing database, or if the problem is something new, then coming up with something new to tackle the problem rather than shoehorning that data into anothe relational database.

