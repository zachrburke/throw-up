I am not against using hooks.  I have been known to use them and in fact, many popular build systems such as [TeamCity](http://www.jetbrains.com/teamcity/) would not be as nice if not for git hooks.  Hooks can be found in many javascript mvvm frameworks such as [KnockoutJS](http://knockoutjs.com/)

####What is a hook?

A hook is a non-intrusive way to add behaviour at specific points of a method.  For example, when performing a commit with git you can write a script (in a variety of languages) that can be run before or after the commit starts and completes.  If there is behaviour you would like to see specifically during a git commit, you can add it without modifying the git source.  

A hook is similar to an event you might fire in a pub/sub pattern.  One key difference is that an event may be asynchronous, a hook is usually synchronous.  Here is how you might create a hook in javascript:

    var ShoeMaker = {
        preMakeShoe: null,
        postMakeShoe: null,

        makeShoe: function(color, size) {
            if (this.preMakeShoe)
                this.preMakeShoe(color, size);

            // make a shoe code goes here...

            if (this.postMakeShoe)
                this.postMakeShoe(color, size);
        }
    }

    ShoeMaker.preMakeShoe = function(color, size) {
        // this happens before the shoe is made
    }

    ShoeMaker.makeShoe('red', 12);

You'll find hooks present in many low level apis such as the win32 api, which provides hooks to intercept keyboard events.  

####Okay cool, I think I'm going to try something like that!

Wait!  The examples I've provided work well because they allow you to define what happens to external programs without having to modify them.  What is one way this might go wrong?

Let's take a look at a bad example of using hooks.  A bad example of a hook would be ASP.NET webforms, which defines a rather complicated pipeline events that have to occur to respond to a web request.  ASP.NET provides hooks at every point in their pipeline for you to add custom code.  If you want to see good way to *not* use hooks then take a look at any ASP.NEt webforms application.

####The distinction between good and bad

When the git team added hooks to their most used set of commands, it likely came as an afterthought.  I say this assuming there is a fair share of git users who aren't aware of git hooks.  Usually what git provides out of the box is more than enough to satisfy your source control needs without doing any extra code work.  However, at some point it was decided that git would provide "a way out" in case it didn't satisfy all those needs.  That same decision was made for the win32 api, explaining it's longevity.

In contrast, Webforms forces you to depend on the hooks it provides.  

