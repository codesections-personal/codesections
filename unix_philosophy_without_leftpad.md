## Following the Unix philosophy without getting left-pad

The [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) famously holds that you should write software that "does one thing, and does it well".  That is, if you're writing a program that produces text in one format, don't _also_ have it print the text in eight alternative formats.  Instead, leave that task for a different [specialized program](https://pandoc.org/) that can process your program's output.  Or, put differently, fight against [Zawinski's law](http://www.catb.org/jargon/html/Z/Zawinskis-Law.html) – the tendency that every program has to "attempt to expand until it can read mail". Of course, you don't want to follow that maxim too obsessively, and programmers have been arguing about exactly where to draw the line since well before [Rob Pike complained](http://harmful.cat-v.org/cat-v/unix_prog_design.pdf) that "cat(1) came back from Berkley waiving flags"  40 years ago.  Nevertheless, the do-one-thing-and-do-it-well approach is well worth aiming for.

In the context of writing libraries, the Unix philosophy supports the practice of writing micro-packages: small libraries, intentionally limited in scope, that serve exactly one purpose.  Some programming language communities have this as an explicit goal; for example, one of the leading Node.js developers [explicitly invoked the Unix philosophy](https://blog.izs.me/2013/04/unix-philosophy-and-nodejs/) and said that developers should

> Write modules that do one thing well. Write a new module rather than complicate an old one.

This practice of writing micro packages contrasts sharply with the practice of writing [omnibus packages](https://jquery.com/) that attempt to provide a single, coherent API that aims to solve pretty much every problem a developer might encounter.  And micro packages benefit from all the advantages that have made the Unix philosophy such good advice for 50 years.  Most notably, micro packages tend to be simple enough (and **small** enough) that you can personally inspect the code – and, if necessary, debug any issues that come up.

### The downside of micro packages

As this post's title probably gave away, the problem with overusing micro packages is that it can lead to what happened with left-pad.  Without rehashing [all the details](https://www.davidhaney.io/npm-left-pad-have-we-forgotten-how-to-program/), there was an 11-line JavaScript package (left-pad) that did nothing other than pad each line of a string with a specified amount of whitespace – and yet, somehow, a huge percentage of the JavaScript ecosystem depended on this simple function either directly or (far more commonly) indirectly.  As a result, when the developer removed the package (in a way that couldn't happen anymore for reasons not relevant here), that same fraction of the JavaScript ecosystem fell over.  I'm not sure exactly how many builds failed, but [one source](https://www.theregister.com/2016/03/23/npm_left_pad_chaos/) estimated that over 2.4 _million_ software builds depended on left-pad every month.  So not a small number.

So, basically, someone finally pulled out the one domino that the entire Internet depended on:

[![xkcd 2347. [A tower of blocks is shown. The upper half consists of many tiny blocks balanced on top of one another to form smaller towers, labeled:]  All modern digital infrastructure  [The blocks rest on larger blocks lower down in the image, finally on a single large block. This is balanced on top of a set of blocks on the left, and on the right, a single tiny block placed on its side. This one is labeled:]  A project some random person in Nebraska has been thanklessly maintaining since 2003.  {alt-text:} Someday ImageMagick will finally break for good and we'll have a long period of scrambling as we try to reassemble civilization from the rubble.](https://codesections.com/xkcd_2347.png)](https://xkcd.com/2347/)

And while left-pad may be an extreme example, the problem of JavaScript programs depending on huge numbers of micro packages is endemic as a [direct consequence of JavaScript's embrace of the Unix philosophy](https://www.chevtek.io/why-i-think-micro-packages-are-a-good-thing/)



![tweet by Steve Klabnik with the text "developers are like 'The UNIX philosophy, the pinnacle of software dev: Make each program to one thing well.'  'lol your project has tons of tiny dependencies? leftpad lolol'" and an image of the Daily Struggle meme (https://knowyourmeme.com/memes/daily-struggle)](https://codesections.com/steveklabnik-tweet-re-unix-vs-leftpad.png)](https://twitter.com/steveklabnik/status/1100978262875037701)

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE5ODc1MTU5NDJdfQ==
-->