#### Solr in Lua/Moonscript using SPORE

The other day I had an idea for a website that would basically be a CRUD application where the data store is a search engine.  I wondered how I would do this while still being able to write a web application using the Moonscript/Lapis stack.  

For my search engine, I chose [Apache Solr](http://lucene.apache.org/solr/).  Namely because I have had a little experience with it already and I think it is a fascinating technology that I would like to learn more about.  

One problem is that there are no well known tested client libraries for solr that are written in lua/moonscript.  I did find a couple of sample solutions out on Github but they have both gone untouched for three years which doesn't bid well considering I'm trying to use an up to date version of Solr.  

Then I had the realization that I don't need someone to write a client library for me.  Solr primarily talks using REST over endpoints that you can configure.  So now my quest shifted from looking for a solr client to a rest client for lua.  

My search lead me to [SPORE](http://fperrad.github.io/lua-Spore/index.html).  With SPORE, you write what's called a spec file using JSON to describe a REST API.  From there, your SPORE client takes that spec file and converts it into high level methods for your programming environment.  

So I can describe my Solr API like so:

    {
      "methods": {
        "select": {
          "path": "/select",
          "method": "GET",
          "required_params": [
            "q",
            "wt"
          ]
        },
        "update": {
          "path": "/update/:format",
          "method": "POST",
          "required_params": [
            "format"
          ],
          "required_payload": true
        }
      }
    }

Here is how to use this in Lua.  (I would have shown it in moonscript but the highlighter kept thinking this sample was SQL)

    local Spore = require('Spore')

    local solr = Spore.new_from_spec('solr-spec.json', {
      base_url = 'http://domain.com/solr/collection'
    })
    solr:enable('Format.JSON')

    local result = solr:select({ q = '*:*', wt = 'json' })
    print(result.body.response.docs[1].id)

    local docs = { { id = '123', title = 'stuff' },
                   { id = 'whatever', some_string_s = 'more_stuff' } }
    result = solr:update({ format = "json", payload = docs })
    print(result.body.responseHeader.QTime)

    result = solr:update({ format = "json", payload = { commit = {} } })

And there we are!  A mostly functioning solr integration with less than 50 lines of code, and without all the noise that usually comes from making an http request in code. If that commit method is a little too wordy you can always add another method in the spec file that uses solr's shortcut commit url.  

Now, is this too magical?  The fact is, I am taking it on faith that the methods I am getting back from SPORE simply wrap an http request with data I give it.  If that's the case, then I'm fine with it, and maybe I will dig into the lua-spore client sometime to see if that's the case.  Even if it's not the case, SPORE is just the specification not the client (although this client is by the same person who came up with that specification).  

I could in theory write my own spore client. That may be worthwhile someday as I'm sure there are some optimizations that can be made to complement Openresty's non-blocking io functionality that I have yet to read about :P




