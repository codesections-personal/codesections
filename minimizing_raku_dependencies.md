
# Minimizing Raku Dependencies with a new utilities package

In [yesterday's post](https://raku-advent.blog/2021/12/06/unix_philosophy_without_leftpad), I made a case for why Raku should have a utility library that provides small-but-commonly-needed functions.  Today I'm introducing a package that I hope will fill that gap.

I'm going to start by telling you what the package is right now.  Then I'll turn to plans for the future and how I'd like to see this package (or a similar one) grow over time.  Finally, we'll wrap up by tying all this back in to the bigger-picture issues we talked about yesterday.

## _

####	The name
First of all, the name: the utility package I've started is named `_` (pronounced/a.k.a. `lowbar`just like it is [in
the HTML spec](https://html.spec.whatwg.org/multipage/named-characters.html#named-character-references)).  I recognize that this name seems like a nod to JavaScript's [underscore](https://underscorejs.org/) and [lodash](https://lodash.com/) libraries, but it's not really meant to be – despite admiring lobar in many ways, the problem space `_` addresses is a bit different.  Instead, the name `_` just falls naturally out of Raku's topic variables: in Raku, if you want to refer to the current topic without giving it a specific name, you use the appropriate sigil followed by `_`: [`$_`](https://docs.raku.org/language/variables#The_$__variable) [`@_`](https://docs.raku.org/language/functions#Automatic_signatures), and [`%_`](https://docs.raku.org/language/functions#Automatic_signatures).  So it only follows that a utilities package – which inherently cannot have a descriptive name – would use `_` (in this case without a sigil, since Modules don't use sigils).

And, besides, if it wasn't named `_`, the other obvious name would be `util` – but that name is more-or-less occupied by a [fellow Rakoon](https://github.com/Util)!

#### The goal
`_`'s purpose is to be meta utility package that aggregates various small bits of Raku code that don't quite
justify their own package but that nevertheless seem worth sharing.  In particular, every sub-package in`_` promises to be:

  1. A single file (not counting tests/docs)
  2. With zero dependencies (with a grudging exception for `_` files or [core
     modules](https://docs.raku.org/language/modules-core))
  3. That's no more than 70 lines long

If you have a package or script that meets those requirements and that you'd like to include, please
feel free to open a PR.  (Or even if it slightly exceeds the requirements; I'm happy to be a bit
flexible.)

#### Why those rules?

These rules might strike some of you as a bit odd.  In particular, why is `_` so focused on keeping the total code size down?  I talked a bit about the value of reducing lines of code a bit yesterday, but I know that [not everyone was convinced](https://www.reddit.com/r/ProgrammingLanguages/comments/raau00/following_the_unix_philosophy_without_getting/hnhi5km/).  And it _is_ a reasonable question – if taken too far, writing concise code can [reduce readability](https://code.golf/) rather than enhance it.

Here's the answer: `_` packages need to be short enough that you don't need to trust them.  The goal is for anyone fluent in Raku to be able to open a file, read the code on their screen, and see 100% of the functionality that package implements.  (That's where the "70 lines" limit comes from – it's my best guess for the number of lines that can fit on a typical screen.)

My hope is that this will provide a very different level of confidence than we typically get from software.  Our profession is absolutely enamored with [black box abstraction](https://en.wikipedia.org/wiki/Black_box) – the idea that you can implement some complex functionality, box it up, and expose it to the outside world so carefully that they can _totally ignore_ the implementation details and can care only about the inputs and outputs.

![An image depicting a function as a box that takes apples as input and produces bananas as output](https://codesections.com/photos/black_box.png)
And I agree that it's a [phenomenally powerful tool](https://mitpress.mit.edu/sites/default/files/sicp/full-text/sicp/book/node13.html).  Without black box abstraction, there's simply no way that the vast majority of software would be remotely possible.  Indeed, part of what makes programming in Raku so enjoyable is that Raku both provides very good abstractions and gives us powerful tools to create own own new abstractions.  As programmers [like to say](https://stackoverflow.com/questions/2057503/does-anybody-know-from-where-the-layer-of-abstraction-layer-of-indirection-q), there's no problem that can't be solved by adding another layer of abstraction – and, as a profession, we sure have solved (and created) a _lot_ of problems.

But I also think we reach for black box abstraction a bit _too_ quickly and don't think enough about the cost of adding more abstraction.  In particular, whenever code depends on a black box then, **by design**, you're using code that you don't understand.  In turn, that means that you can never fully understand the code you're currently reading either; the very best you can do is reach a partial understanding subject to the disclaimer "assuming both that I'm correct about the promises that black box is making and that the black box keeps all its promises".

The slight flaw is that [black boxes **never** keep all their promises](https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/).  (Well, ok, that's too strong; maybe it'd be better to say "can never be guaranteed to keep all their promises".)  As a result, anyone who relies on a black box will, sooner or later, need to open it up and debug the box.  And, as anyone who has ever followed a deep callstack can attest, that often means discovering all the various black boxes nested inside the first and getting to play with your very own set of [software matryoshka dolls](https://www.toolbox.com/tech/it-strategy/blogs/the-matryoshka-principle-and-software-design-101711/).

[![A meme-style image of a set of matryoshka dolls with the caption "RUSSIAN DOLLS \n So full of themselves"](https://codesections.com/photos/nesting_dolls.png)](https://cheezburger.com/4767398656/theyre-total-egomatryoshkas-really)

In fact, you could say that the whole reason for `_` is that we can't fully trust black box abstraction – if we could, than having thousands of dependencies would be much less of a problem.  So `_` is deeply committed to not adding additional abstraction.   This means that you can look at a file and (in theory) see whether it's correct.  I'm sure that theory won't 100% survive contact practice any better than theory ever does, but the lack of abstraction also means that you'll also be able to debug any issues without needing to understand anything outside the text of that one file.  In other words, `_` embraces "transparency over abstraction" to [borrow a phrase](https://sway.office.com/b1pRwmzuGjqB30On) from Aaron Hsu.

(All of this these lofty promises implicitly assume that every abstraction the Raku compiler you're using is entirely leak-free – which we [know not to believe](https://github.com/rakudo/rakudo/issues).  But we have to trust _some_ code, and "Rakudo and the tech stack below it" is where I'm drawing that line).

#### The scope

Those rules place limits on what packages `_` can include but don't say anything at all about what it aims to include.  That scope is easy enough to state in broad terms: `_` aims to include packages that would otherwise turn into mico-packeges in the Raku ecosystem, with a particular focus on preempting micro packages that would likely become dependencies of many Raku programs.

But, as easy as that is to say, knowing what that means is practice is a bit trickier and to be honest, I'm not entirely sure what `_`'s proper scope will turn out to be.   Many utility libraries implement fairly basic helper functions that – `reverse`, `zipWith`, `sortBy`, etc – that won't have a home in `_` because they're already either built in to Raku or a trivial combination of Raku builtins.  This frees `_` up to include higher-level utilities, but we'll have to discover together what exactly that looks like.  Right now, I'm still coming up with ideas – in part by keeping `_` in the back of my mind and considering every utility I write as a potential `_` candidate.  If you have ideas for `_` packages, please let me know – or, even better, submit a PR!  

That said, I do have three general categories of packages that might make a package a good fit for `_`:

* **Code that should be in Raku's standard library (one day) ** - one role I envision `_` playing is to allow experimentation with packages that might be a good fit for Raku, but that need a bit more user feedback/time to bake before Raku commits to adding them (and the [fairly strong backwards compatibility guarantee](https://github.com/rakudo/rakudo/blob/master/docs/language_versions.md#language-versioning) entailed by inclusion in Raku itself).  [`use experimental`](https://docs.raku.org/language/experimental) already fills this role to a certain extent, but `_` could be a good home for any package not quite ready for Raku, even behind an experimental pragma.
* **Code that ought to stay out of Raku's standard library ** - there are some packages that we can reasonably expect to be widely used but that, for one reason or another, don't seem like a good fit for Raku's standard library; `_` could provide a home for those (or at least any that are small/simple enough to meet `_` rules).  Just as the previous bullet had overlap with `use experimental`, this category shares a lot with Raku's [Core modules](https://docs.raku.org/language/modules-core).  And, again, `_` could have a role as a sort of testing ground for modules that might one day be added as a Core module.
* **Code that is already in Raku(do)'s standard library but shouldn't be used ** – Raku makes fairly strong guarantees about spec'd code. But, in return, it asks us _not_ to rely on code that it didn't guarantee.  Unfortunately we, as a community, aren't all that great at keeping up our end of that bargain – it's so easy to think "well, this function is already installed and does _just_ what I need.  And it's in Rakudo, so I know it's decently well-written.  So what if it's marked with `is implementation-detail`, I'm sure it'll be _fine_".  I'm not judging those thoughts – I've had them myself – but the fact is that it's **not** fine.  When we, as a community, ignore signposts like `is implementation-detail`, the [inevitable negative result](https://github.com/Raku/6.d-prep/blob/master/d-docs/New-Features-Policy.md) is we force Rakudo developers to chose between not changing that implementation detail or breaking user code.  Even if they're "allowed" to break that code under the terms of the agreement that we're ignoring, none of the Rakudo devs enjoy breaking things.  Even worse, a desire to prevent use of implementation details sometimes makes Rakudo devs reluctant to fully document those details – which exacerbates the problem of tacit knowledge (sometimes called "[tribal knowledge](https://en.wikipedia.org/wiki/Tribal_knowledge)") which, in turn, makes it more challenging for new developers to understand how they can improve the main language implementation.  One goal for `_` is to head this problem off by providing alternatives to any of Rakudo's `implementation-detail`s that might tempt developers to depend on them.

So, let's see: a package is a good fit for `_` if it's one that should be in the standard library but isn't, of if it shouldn't be in the standard library, or it is in the standard library but shouldn't be used.  I think that covers all possible packages except for those that are in the standard library and should be used – so I'm not sure that really narrowed it down!  I suppose we'll just have to find out together as `_` grows.  But maybe taking a look at `_`'s initial packages will provide some examples. 

## Current status
####  submodules

Currently (that is, as of , `_` includes the following submodules.  You can find more information about each one in
the `README` file in its directory.

  * `Self::Recursion` - provides `&_` as an alias for `&?ROUTINE`

#### Dependency management

## Future plans

#### Version control

#### Paths in and paths out

#### Handling existing micro packages

## What problem is `_` solving?

I want to build reliable software – software that works well, delights its users, and that isn't
subject to major security flaws.  To that end, I have two beliefs (well, ok, I have _lots_ of
beliefs, but two that I'd like to focus on now):

    * Software is more reliable when it's composed of small pieces, each of which is responsible for
      [only one task](https://en.wikipedia.org/wiki/Unix_philosophy)

    * Software is difficult to reason about – and therefore dificult to build well – when it has too
      many moving parts or systems become too big

In many instances, these two beliefs complement one another – keeping things simple will reduce the
number of pieces it takes to build software _and_ will lower the complexity of each piece.  But
there are obviously times when these two values trade off against each other.  We sometimes have to
decide whether to one pretty big software "thing" or to combine many smaller and individually less
complex alternatives.

One area where this comes up a lot is in selecting the dependencies (libraries, modules, etc) to use
in a project.  At one extreme, you can try to keep each dependency as small as possible, accepting
that this will lead to many dependencies.  Or you can focus more on relying on fewer dependencies,
even if that means some of them will be too large for you to deeply understand.

This isn't a theoretical question – different developers strike that balance in very different
ways.  So do different programming language communities.

A [2020
report](https://i.blackhat.com/USA-20/Wednesday/us-20-Edwards-The-Devils-In-The-Dependency-Data-Driven-Software-Composition-Analysis.pdf)
found that the typical JavaScript application has 377 dependencies on open source libraries – and
that 10% have over 1,400. That doesn't mean that JavaScript developers are manually installing
hundreds of libraries; most of those were transitive dependencies, not direct ones. In a way,
though, that makes it even worse: to fully understand that sort of application, the developer needs
to not only understand every package they _chose_ to depend on but hundreds of others they didn't.

On the other hand, the JavaScript packages are admirably small and single-purpose.  That same report
showed that several of the most-depended-on packages JavaScript packages are tiny – one that 86% of
JS programs use is [just four lines](https://github.com/juliangruber/isarray/blob/master/index.js)
(its a polyfill for old browsers).  Pretty much anyone can look at those four lines and be sure that
they don't contain any major bugs.

At the other end of the spectrum, the language with the fewest dependencies had an average of
just 4.  Before we get too excited about that, though, I should note that the language in question
is [Swift](https://en.wikipedia.org/wiki/Swift_(programming_language)) and that the report only
covered _open source_ dependencies.  I don't have a citation, but I don't think it's a stretch to
believe that the vast majority of Swift programs depend on a large volume of Apple code, much of
which we can't look at even if we wanted to.

So it looks like we're faced with a spectrum of options, and both extremes are pretty frightening.
At one extreme, you can end up with easy-to-comprehend libraries – but in an overwhelming quantity;
at the other, a you get a manageable number of dependencies, but each one is giant enough to be
pretty impenetrable without dedicated study.  Of course it's possible to avoid both extremes and
settle somewhere in the middle.  But that risks a worst-of-both worlds outcome, where you have too
many dependencies to realistically track *and* your individual dependencies are too large to fully
comprehend.

`_` is my attempt to help the Raku ecosystem strike a better balance between too-many-small
libraries and libraries that are too large to deeply understand.  My hope is that aggregating many
small and still independent libraries into `_` will play a role in reducing the average dependencies
in a typical Raku program without adding anything so large that it defies easy understanding.

## Not a new idea

Of course, creating this sort of utility library is hardly a new idea; I think programmers have been
keeping a `./utils` directory for pretty much as long as they've had directories.  And, in
particular, the same report I cited before also showed that 88% of JavaScript libraries depend on
the [Lodash](https://lodash.com/) utility library.  (I'm aware of the similarity in name, though
calling this `_`/Lowbar is less about homage to Lodash and more a case of convergent evolution; when
a library isn't _about_ any one thing, it just makes sense to use the one non-alphabetic character
available.  And, besides, the other obvious name, 'Utils', is [somewhat
taken](https://github.com/Util)).

As Lodash proves, a utility library like this is no panacea – JavaScript have a widely used utility
library and _still_ has an explosion of other dependencies.  I'm well aware that it will take much
more than `_` to have the low-dependency Raku ecosystem we'd like.

But still, I'm optimistic that `_` can do bit more than Lodash and similar utility libraries for
three reasons.  First, Lodash and other JS utility libraries have to work from the fairly small
JavaScript standard library; many (most?) of the utilities they provide already built in with Raku.
Our larger standard library frees libraries like this to have a bit broader of a focus, which should
help increase the number of dependencies we can replace.

Second, because many utility libraries are attempting to supplement the standard library, they
typically put a lot of emphasis on developing a standard and coherent API – they're building a
single library designed to be used as one coherent whole.  Since we're operating at a bit higher
level – Raku's standard library is great; `_` is mostly about things that don't belong in Core – we
have the freedom to let each sublibrary be a bit more individual.

And, finally, we have the secret weapon of any Raku project – Raku itself.  I've said that `_`
submodules should be under 70 lines.  That's so that each one can fit on a single page; you can
literally look at all the code at one time.  That sort of global visibility is hugely empowering,
but the brevity can also be limiting – there are, of course, limits to what you can achieve in a
single page of code.  It's my belief that Raku's unrivaled expressiveness will let us fit far more
onto a single, clearly written page of code than we could if writing in any other programming
language.  If I'm right about that, then the range of problems that `_` can solve without losing
it's comprehensibility is correspondingly expanded as well.

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTAzNjUxMjc3NF19
-->