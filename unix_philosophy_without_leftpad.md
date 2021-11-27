## Following the Unix philosophy without getting left-pad

The [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) famously holds that you should write software that "does one thing, and does it well".  That isere are other tenants as well, but I'm focusing on the core idea expressed in [Programming Design in the UNIX Environment](http://harmful.cat-v.org/cat-v/unix_prog_design.pdf):

> Whenever one needs a way to perform a new function, one faces the choice of whether to add a new option or write a new program….  The guiding principle for making the choice should be that each program does one thing. 

For instance, if you're writing a program that produces text in one format, don't _also_ have it print the text in eight alternative formats.  Instead, leave that task for a different [specialized program](https://pandoc.org/) that can process your program's output.  Or, put differently, fight against [Zawinski's law](http://www.catb.org/jargon/html/Z/Zawinskis-Law.html) – the tendency that every program has to "attempt to expand until it can read mail". your program's inherent tendency to "attempt to expand until it can read mail" ([Zawinski's law](http://www.catb.org/jargon/html/Z/Zawinskis-Law.html)). 

Of course, you don't want to follow that maxim too obsessively, and programmers have been arguing about exactly where to draw the line since well before [Rob Pike complained](http://harmful.cat-v.org/cat-v/unix_prog_design.pdf) that "cat(1) came back from Berkley waiving flags"  40 years ago.  Nevertheless, the do-one-thing-and-do-it-well approach is well worth aiming for.

In the context of writing libraries, the Unix philosophy supports the practice of writing micro-packages: small libraries, intentionally limited in scope, that serve exactly one purpose.  Some programming language communities have this as an explicit goal; for example, one of the leading Node.js developers [explicitly invoked the Unix philosophy](https://blog.izs.me/2013/04/unix-philosophy-and-nodejs/) and saidto argue that developers should

> Write modules that do one thing well. Write a new module rather than complicate an old one.

This practice of writing micro packages contrasts sharply with the practice of writing [omnibus packages](https://jquery.com/) that attempt to provide a single, coherent API that aims to solve pretty much evero solve any problem a developer might encounter.  And micro packages benefit from all the advantages that have made the Unix philosophy such good advice for 50 years.  Most notably, micro packages tend to be simple enough (and **small** enough) that you can personally inspect the code – and, if necessary, debug any issues that come up.

### The downside of micro packages

As this post's title probably gave away, the problem with overusing micro packages is that it can lead to what happened with left-pad.  Without rehashing [all the details](https://www.davidhaney.io/npm-left-pad-have-we-forgotten-how-to-program/), there was an 11-line JavaScript package (left-pad) that did nothing other than pad each line of a string with a specified amount of whitespace – and yet, somehow, a huge percentage of the JavaScript ecosystem depended on this simple function either directly or (far more commonly) indirectly.  As a result, when the developer removed the package (in a way that couldn't happen anymore for reasons not relevant here), that same fraction of the JavaScript ecosystem fell over.  I'm not sure exactly how many builds failed, but [one source](https://www.theregister.com/2016/03/23/npm_left_pad_chaos/) estimated that over 2.4 _million_ software builds depended on left-pad every month.  So not a small number.

So, basically, someone finally pulled out the one domino that the entire Internet depended on:

[![xkcd 2347. [A tower of blocks is shown. The upper half consists of many tiny blocks balanced on top of one another to form smaller towers, labeled:]  All modern digital infrastructure  [The blocks rest on larger blocks lower down in the image, finally on a single large block. This is balanced on top of a set of blocks on the left, and on the right, a single tiny block placed on its side. This one is labeled:]  A project some random person in Nebraska has been thanklessly maintaining since 2003.  {alt-text:} Someday ImageMagick will finally break for good and we'll have a long period of scrambling as we try to reassemble civilization from the rubble.](https://codesections.com/xkcd_2347.png)](https://xkcd.com/2347/)

And while left-pad may be an extreme example, the problem of[direct consequence of JavaScript's embrace of the Unix philosophy](https://www.chevtek.io/why-i-think-micro-packages-are-a-good-thing/) is JavaScript programs commonly depending on huge numbers of micro packages is endemic as a [direct consequence of JavaScript's embrace of the Unix philosophy](https://www.chevtek.io/why-i-think-micro-packages-are-a-good-thing/)



![tweet by Steve Klabnik with the text "developers are like 'The UNIX philosophy, the pinnacle of software dev: Make each program to one thing well.'  'lol your project has tons of tiny dependencies? leftpad lolol'" and an image of the Daily Struggle meme (https://knowyourmeme.com/memes/daily-struggle)](https://codesections.com/steveklabnik-tweet-re-unix-vs-leftpad.png)](https://twitter.com/steveklabnik/status/1100978262875037701)third-party packages.  A [2020 study](https://i.blackhat.com/USA-20/Wednesday/us-20-Edwards-The-Devils-In-The-Dependency-Data-Driven-Software-Composition-Analysis.pdf) found that the typical JavaScript program depends on 377 packages (here, "typical" means "at the geometric mean", which reduces the impact of outliers).  And a full 10% depend on over 1,400 third-party-libraries.  Many of these dependencies are admirably tiny: one of the most depended-on packages (used by 86% of JavaScript packages – literally tens of millions of developers – is [essentially just one line of code](https://github.com/juliangruber/isarray/blob/master/index.js).   It's hard to take "do just one thing" to any greater extreme.

And yet.

And yet, I don't believe that any developer can reasonably comprehend a system made up of hundreds (thousands?) of independent packages.  It's not just a matter of the total lines of code climbing to incomprehensible levels (though that [famously happens](https://devhumor.com/media/node-modules-1) and certainly doesn't help matters).  But even if the total lines of code were manageable, the interaction effects simply aren't – remember, these packages weren't designed to form a coherent whole, so they can and will make inconsistent assumptions or create inconsistent effects.

The many different problems that can arise from this abundance of micro packages leads some people to conclude that you should [kill your dependencies](https://www.mikeperham.com/2016/02/09/kill-your-dependencies/).  Or, as Joel Spolsky [put it](https://www.joelonsoftware.com/2001/10/14/in-defense-of-not-invented-here-syndrome/)

> “Find the dependencies — and eliminate them.” When you’re working on a really, really good team with great programmers, everybody else’s code, frankly, is bug-infested garbage, and nobody else knows how to ship on time. When you’re a cordon bleu chef and you need fresh lavender, you grow it yourself instead of buying it in the farmers’ market, because sometimes they don’t have fresh lavender or they have old lavender which they pass off as fresh.

### A wild dilemma appears

At this point, I hope the tension is pretty clear: on the one hand, it's great to keep components small, simple, and composable.  On the other hand, it's terrible to bury yourself in a tangle of different packages, no matter how tiny they are.  The Unix philosophy and killing your dependencies are in tension.

Of course, this is hardly a new insight.  It's a point many people have made over the years; I particularly enjoyed how Rust-evangelist extraordinaire Steve Klabnik put it a couple of years ago:

![tweet by Steve Klabnik with the text "developers are like 'The UNIX philosophy, the pinnacle of software dev: Make each program to one thing well.'  'lol your project has tons of tiny dependencies? leftpad lolol'" and an image of the Daily Struggle meme (https://knowyourmeme.com/memes/daily-struggle)](https://codesections.com/steveklabnik-tweet-re-unix-vs-leftpad.png)](https://twitter.com/steveklabnik/status/1100978262875037701)

But I want to do more than note the tension: I want to provide a solution (or at least an outline of what I view the solution to be).  Before I do so, however, I'd like to note a few non-solutions that I reject.

First, I don't think that we should resolve this dilemma by fully choosing one side or the other.  Like [Russ Cox](https://queue.acm.org/detail.cfm?id=3344149), I acknowledge that installing a dependency entails allowing your "program's execution [to] literally depend[] on code downloaded from [some] stranger on the Internet"; I don't believe that doing so thousands of times will ever be a recipe for crafting robust software.  As much wisdom as there is in the Unix philosophy, it simply won't do to accept it 100% and embrace the micro package dystopia.

At the same time, I don't believe that we can land fully on the "kill your dependencies" side, either.  It would be appealing to live in an ideal world where, like [one developer I admire](https://drewdevault.com/2020/02/06/Dependencies-and-maintainers.html), "I [could] list the entire dependency graph, including transitive dependencies, off of the top of my head", I don't believe that's a tenable solution.  For one thing, the code reuse and code sharing that micro packages enable is a huge part of what gives open source and free software developers superpowers: If a project can only be done by a team of dozens, it will almost certainly be built by a for-profit company.  But if relying on existing packages lets one or two hackers, working alone, create that software – well, then, there's an excellent chance that we'll have a free software version of the program.  (Remember, mega-projects like Linux are very much the exception, not the rule – the median number of maintainers for free software projects is 1, as I've [discussed at length](https://archive.fosdem.org/2021/schedule/event/programming_lang_for_free_software/) elsewhere.)

Even setting aside the practical benefits of code reuse, I _still_ wouldn't agree that we should jettison micro packages.  The inconvenient reality is that the Unix philosophy is just plain correct: for any given volume of code/features, it'll be easier to reason about the system if it's composed of many small, independent modules instead of being one massive blob.  Killing our dependencies and replacing that code with our own implementation would, in many cases, just make a bad situation worse.  So I reject the idea that we can "solve" this problem by picking one extreme or the other.

But I also view a naive compromise between the extremes to be a non-solution. Both extremes have real problems, but that doesn't provide any guarantee that splitting the baby will be any better.  Indeed, there's a real possibility that it'll be worse: if you take a program that depends on 500 micro packages and re-architect it to instead depend on 200 larger packages, then you **still** have far too many packages to manually review and maintain.  But now you are _also_ dealing with packages that are each harder to understand when you do need to start debugging.  [Nice job breaking it, hero](https://tvtropes.org/pmwiki/pmwiki.php/Main/NiceJobBreakingItHero).

### A less naive compromise

Having just rejected both extremes and simple compromise, it's clearly on me to come up with better way to strike this balance.  What we need is a way to limit the _number_ of dependencies for any given software project without leading to a corresponding increase in the _average size_ of each dependency.  (I'm going to discuss this in the context of my programming language of choice, [Raku](https://docs.raku.org), but I'm hopping that these thoughts will be more broadly relevant.)

I believe that a programming language/community can balance the Unix philosophy and dependency minimization by following three steps.  In order from most to least fundamental, the programming language should:
* Maximize the language's expressiveness;
* Have a great standard library; and
* Embrace a utility package (or a few utility packages)
Let's take each of these in turn.

#### Maximize expressiveness
[TODO]
### Great standard library
[TODO]
### Utility package(s)
[TODO]i


<!--stackedit_data:
eyJoaXN0b3J5IjpbOTQxNTA5MDEsLTE5ODc1MTU5NDJdfQ==
-->