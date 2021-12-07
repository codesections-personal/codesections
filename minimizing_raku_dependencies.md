
# Unix philosophy without left-pad pt. 2: Minimizing Dependencies with a utilities package

In [the previous post](https://raku-advent.blog/2021/12/06/unix_philosophy_without_leftpad), I made a case for why programming languages should have a utility library that provides small-but-commonly-needed functions.  Today I'm introducing a Raku package that I hope will fill that gap.

I'm going to start by giving you an overview of this new package as it exists today.  Then I'll turn to plans for the future and how I'd like to see this package (or a similar one) grow over time. 

## _

####	The name
First of all, the name: the utility package I've started is named `_` (pronounced/a.k.a. `lowbar` just like [in
the HTML spec](https://html.spec.whatwg.org/multipage/named-characters.html#named-character-references)).  I recognize that most people will view this name as a nod to JavaScript's [underscore](https://underscorejs.org/) and [lodash](https://lodash.com/) libraries, but it's not really meant as one.  Lodash is a good library, but our goals/contents are different enough that I don't feel any desire to reference them with `_`'s name

Instead, the name `_` just fell naturally out of Raku's topic variables: in Raku, if you want to refer to the current topic without giving it a specific name, you use the appropriate sigil followed by `_`: [`$_`](https://docs.raku.org/language/variables#The_$__variable) [`@_`](https://docs.raku.org/language/functions#Automatic_signatures), or [`%_`](https://docs.raku.org/language/functions#Automatic_signatures).  So it only follows that a utilities package – which, by its nature, can't really sum its functionality up in a name  – would use `_` (in this case without a sigil, since Modules don't use sigils).

Besides, if it wasn't named `_`, the other obvious name would be `util` – but that name is more-or-less occupied by a [fellow Rakoon](https://github.com/Util).  And, finally, this name gives us the helpfully short use statement of `use _` – a nice feature for quick prototyping if `_`  ends up being widely used.  (For production use, you might want to qualify that use statement, as I'll discuss later in this post.  But starting with a short name is _also_ helpful if our fully qualified use statement risks getting a bit long).

#### The goal
`_`'s purpose is to be meta utility package that lets Raku programs avoid rewriting the same helper functions without embracing the excessive use of micro packages in the Raku ecosystem.  When I say that `_` is a _meta_ utility package, I mean something analogous to the idea of a Linux distro [metapackage](https://help.ubuntu.com/community/MetaPackages). Specifically, I mean that unlike many utility packages, `_` is comprised of individual sub-packages.  Each sub-package has its own documentation/tests and is an independent unit.  My intent is that you can read the README for a `_` sub-package and then use (and fully understand!) that sub-package without needing to know anything about any other `_` sub-package.

Additionally, every sub-package in`_` makes three promises:

  1. To have zero dependencies (with a grudging exception for `_` files or [core
     modules](https://docs.raku.org/language/modules-core))
  2. To have all its code in a single file (not counting tests/docs)
  3. To keep that file to 70 or fewer lines 

If you have a package or script that meets those requirements and that you'd like to include, please
feel free to open a PR.  (Or even if it slightly exceeds the requirements; I'm willing to talk about how flexible `_` will be .)

#### Why those rules?

These rules might strike some of you as a bit odd.  In particular, why is `_` so focused on keeping the total code size down?  I talked a bit about the value of reducing lines of code a bit in the previous post, but I know that [not everyone was convinced](https://www.reddit.com/r/ProgrammingLanguages/comments/raau00/following_the_unix_philosophy_without_getting/hnhi5km/).  And it _is_ a reasonable question – if taken too far, writing concise code can [reduce readability](https://code.golf/), which is rather the opposite of our goal.

Here's the answer: `_` packages are short so you can fully understand them.  And, by understanding them, trust them.

My goal for `_` it that anyone fluent in Raku can open file for a `_` sub-package, read the code on their screen, and see 100% of the functionality that package implements.  (That's where the "70 lines" limit comes from – it's my best guess for the number of lines that can fit on a typical screen.)  Getting this global view will give you a very different level of confidence than we typically get from software – or at least that's my hope.

I believe that `_` can provide this much-higher-than-normal level of confidence because the three rules above cut sub-packages off from something our profession is absolutely enamored with: [black box abstraction](https://en.wikipedia.org/wiki/Black_box).  The idea of black box abstraction is that you can implement some complex functionality, box it up, and expose it to the outside world so carefully that the world can _totally ignore_ the implementation details and can care only about the inputs and outputs.

![An image depicting a function as a box that takes apples as input and produces bananas as output](https://codesections.com/photos/black_box.png)[caption: apples go in, bananas come out.  You can't explain that!]

Now, don't misunderstand me: I fully agree that it's a [phenomenally powerful tool](https://mitpress.mit.edu/sites/default/files/sicp/full-text/sicp/book/node13.html).  Without black box abstraction, there's simply no way that the vast majority of software in use today would be remotely possible.  There's certainly no chance that Raku itself would exist without piles and piles of black box abstraction.  Indeed, much of what makes programming in Raku so enjoyable is that Raku both provides very good abstractions and gives us powerful tools to create own own new abstractions  (tools which are themselves often more abstractions).  And I'm extremely excited for the [vast array of new abstractions](https://jnthn.net/papers/2020-cic-rakuast.pdf#page66R_mcid1) that Jonathan Worthington's Raku AST seems [poised to deliver](https://conf.raku.org/talk/147) soon-ish.

As programmers [like to say](https://stackoverflow.com/questions/2057503/does-anybody-know-from-where-the-layer-of-abstraction-layer-of-indirection-q), there's no problem that can't be solved by adding another layer of abstraction – and, as a profession, we sure have solved a lot of problems.  But we've also _created_ a lot of problems and I think one reason is that we often reach for black box abstraction a bit _too_ quickly; we don't put enough consideration into the not-inconsiderable costs of adding more abstraction. 

In particular, whenever code depends on a black box, that means that the author of that code chose to rely on code that, **by design**,  they didn't need to understand.  And they're claiming that you _also_ don't need to understand that black-box code.  But that means that you can never fully understand the code you're currently reading either; the very best you can do is reach a partial understanding subject to the disclaimer "assuming both that I correctly understood the black box's promises and that the black box keeps all its promises".

The slight flaw is that [black boxes **never** keep all their promises](https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/).  Well, ok, that might be too strong; software _sometimes_ works.  But, at the least, you can never guarantee that any black box will keep any particular promise.  As a result, anyone who relies on a black box will, sooner or later, need to open that box up and debug whatever's inside.  And, as anyone who has ever followed a deep callstack can attest, that often means discovering all the various black boxes nested inside the first box.  Which, in turn, means getting to play with your very own set of [software matryoshka dolls](https://www.toolbox.com/tech/it-strategy/blogs/the-matryoshka-principle-and-software-design-101711/).

[![A meme-style image of a set of matryoshka dolls with the caption "RUSSIAN DOLLS \n So full of themselves"](https://codesections.com/photos/nesting_dolls.png)](https://cheezburger.com/4767398656/theyre-total-egomatryoshkas-really)

In fact, you could say that the whole reason for `_` is that we can't fully trust black box abstraction.  If we had a way to guarantee that our black boxes would Just Work™, then having thousands of dependencies would hardly be a problem at all.  But, since that's one thing we can**not** guarantee, `_` is deeply committed to not adding additional abstraction.  And thus, `_` packages follow the three rules above, and present their entire codebase – dependencies and all – for you to view at once, on a single screen.

When viewing a `_` sub-package, you can look at a single file and, without needing any outside context or info, see whether the code in that file is correct – or at least that's the theory.  I'm sure that theory won't survive contact with practice 100% intact; no theory ever does.  But the lack of abstraction also means that you'll also be able to debug any issues that do come up without needing to understand any code or systems outside the text of that one file.  In other words, to [borrow a phrase](https://sway.office.com/b1pRwmzuGjqB30On) from Aaron Hsu, `_` embraces "transparency over abstraction".

(All of this these lofty promises implicitly ignore the previously mentioned piles and piles of abstractions that our Raku implementation depends on or provides.  Since I use Rakudo, this means that I'm implicitly assuming that every abstraction Rakudo provides is entirely leak-free – which, even setting aside theory,  [know isn't true](https://github.com/rakudo/rakudo/issues).  But we all [have to trust _some_ code](http://users.ece.cmu.edu/~ganger/712.fall02/papers/p761-thompson.pdf), and I'm choosing to implicitly trust Rakudo and the tech stack below it).

#### The scope

The rules we just talked about limit on what packages `_` can include – but they don't say give us any guidance about what `_` _should_ include.  Let's address that now.

`_`'s scope is easy enough to state in broad terms: `_` should include a package if that package fits in the constraints above and provides functionality that many Raku packages would get utility from.  If the package's scope is small enough that it can be implemented in 70 lines, then having it as an independent package would create a micro package; if that micro package would be useful in a bunch of Raku programs, then it would likely become a _widely used_ micro package.  Since `_`'s goal is to reduce limit the number of widely used micro-packages in the Raku ecosystem, any package that meets these two critera is a good candidate for `_`.

But all that basically boils down to "`_` should include packages that are (1) small and (2) useful".  While I doubt that many of you will disagree, knowing what "useful" means in practice is the hard part.  

And I'm not entirely sure what exact view of usefulness will be turn out to be the best fit for  `_`.   I do know that many utility libraries implement basic helper functions – `reverse`, `zipWith`, `sortBy`, etc – that wouldn't have any utility `_` because they're either already built in to Raku or a trivial combination of Raku builtins.  So `_` is free to (and should) include higher-level utilities than the ones most commonly found in utility libraries; I guess that we'll have to discover together what exactly that looks like.  If you have ideas for `_` packages, please let me know – or, even better, submit a PR!  

That said, I do have three general categories of packages that be good fit for `_`:

* **Code that should be in Raku's standard library (one day)** - in addition to reducing the pressure for micro packages,`_` can also help Rakoons to play around with packages that might be a good fit for Raku but that need a bit more user feedback/time to bake before Raku commits to adding them (and the [fairly strong backwards compatibility guarantee](https://github.com/rakudo/rakudo/blob/master/docs/language_versions.md#language-versioning) entailed by inclusion in Raku itself).  Raku's [`use experimental`](https://docs.raku.org/language/experimental) pragm already fills this role to a certain extent but `_` could provide a good home for any package that isn't quite ready for Raku, even with the shield that pragma provides.

* **Code that ought to stay out of Raku's standard library** - there are some small packages that we can reasonably expect to be widely used but that, for one reason or another, don't seem like a good fit for Raku's standard library; `_` could provide a home for those.  Just as the packages in the first category share a lot with packages behind`use experimental`, this category shares a lot with Raku's [Core modules](https://docs.raku.org/language/modules-core).  And, again, `_`'s role could be a testing ground of sorts for modules that might one day graduate to being added as a Core module.  Or it might not; I don't want to suggest that being a `_` sub-package is or should be a temporary status.  The vast majority of `_` sub packages will stay `_` sub-packages – and that's exactly as it should be.

* **Code that is already in Raku(do)'s standard library but that we shouldn't use** – Raku quite correctly makes [fairly strong guarantees](https://marketing.raku.org/id/1541379592/any) about not breaking spec'd code. But, in return, it asks us to _not_ rely on code outside that guarantee – that is, not to rely on implementation details.  Unfortunately Rakoons, [just like everybody else](https://www.hyrumslaw.com/), are fairly rubbish at keeping up our end of that bargain – it's all too easy to think "well, this function is already installed and does _just_ what I need.  And it's in Rakudo, so I know it's decently well-written.  So what if it's marked with `is implementation-detail`, I'm sure it'll be _fine_".  I'm not judging those thoughts – I've had them myself – but the fact is that it's **not** fine.  When we, as a community, ignore signposts like `is implementation-detail`, the [inevitable negative result](https://github.com/Raku/6.d-prep/blob/master/d-docs/New-Features-Policy.md) is that we force Rakudo developers to chose between not changing that implementation detail or breaking user code.  Even if they're "allowed" to break that code under the terms of the agreement that we're ignoring, none of the Rakudo devs enjoy breaking things. If changing an `implementation-detail` makes [blin runs](https://perl6advent.wordpress.com/2018/12/23/day-23-blin-its-christmas-soon/#project-blin--toasting-reinvented) start failing, then devs _will_ think twice about that change – even if it's a good change.  What's worse is that the (totally understandable!) desire to discourage users from depending on implementation details risks tempting Rakudo devs to [avoid fully documenting those details](https://github.com/Raku/problem-solving/issues/277) – which creates/exacerbates the problem of tacit knowledge (sometimes called "[tribal knowledge](https://en.wikipedia.org/wiki/Tribal_knowledge)") – that knowledge that many people in the community have, but which isn't written down or otherwise accessible to new people.  Tacit knowledge, in turn, creates barriers to new developers looking to understand how to improve the Raku's main language implementation.  And that hurts everyone.  Accordingly, one additional goal for `_` is to head this problem off by providing alternatives to any of Rakudo's `implementation-detail`s that developers might be tempted to depend on.

So, let's see: a package is a good fit for `_` if it's one that should be in the standard library but isn't, or if it shouldn't be in the standard library, or if it is in the standard library but shouldn't be used.  I think that covers all possible packages except for those that are in the standard library and should be used.  I guess that doesn't really narrow it down; maybe I should have just stuck with "if it has utility"!  I suppose we'll just have to find out together as `_` grows.  But maybe taking a look at `_`'s initial packages will provide some examples. 

## Current status

As of today (December 8, 2021), `_` includes 7 sub-packages and is in alpha status.  This status reflects the fact that not all of the current sub-packages are fully documented/tested.  Once the current sub-packages are documented and tested, I'll upgrade `_` to beta status and add it to the [fez](https://github.com/tony-o/raku-fez) ecosystem.  I believe that should happen some time later this week but, out of a sense of tradition, I'll say that `_` will be in beta and in the ecosystem by Christmas. 

During both alpha and beta periods, `_` explicitly makes **no** guarantees about backwards compatibility.  Because backwards compatibility is very important for a package like `_`, my goal is to reach 1.0.0 as soon as possible, with an exact date depending in part on what approach `_` takes to compatibility (more on that below). 

####  sub-packages

Currently `_` includes the following sub-packages.  You can find more information about each one in its `README` file

  * `Pattern::Match` - provides a `choose` sub that enables pattern matching using Raku's [signature destructuring](https://docs.raku.org/type/Signature#Destructuring_arguments) as a control-flow construct similar to [`given`/`when`](https://docs.raku.org/language/control#given).  `choose` can detect a pattern that is unreachable because it is fully   shadowed by a prior pattern; when it detects an unrechable pattern, it raises an exception.  It also raises an exception at runtime if input fails to match any pattern and no default option was provided.  (Fun fact: [musing](https://www.codesections.com/blog/pattern-matching-2/) about a function like `choose` but not wanting to create a micro package is what first started me on the trail towards `_`).
  
  * `Print::Dbg` - provides a `dbg` function designed to support more ergonomic print-debugging. `dbg` accepts any number of arguments and return the same values (i.e., effectively a no-op).  As a side effect, `dbg` prints (to stderr) the file and line on which it was invoked and a `.raku` representation of each argument; if any of `dbg`'s arguments are bound to a Scalar, `dbg` also prints the name of that Scalar.  Because `dbg` returns the values it was passed, it allows you to add debugging code without altering the behavior of the code being debugged.  An example: `my $new-var = $old1 + dbg($old2) + $old2`.  `dbg` was inspired by Rust's [`dbg!`](https://doc.rust-lang.org/std/macro.dbg.html) macro.  Compare with guifa's [`Debug::Transput`](https://github.com/alabamenhu/DebugTransput), which provides similar functionality.  
  
  *  `Self::Recursion` - provides `&_` as an alias for [`&?ROUTINE`](https://docs.raku.org/language/variables#index-entry-&%3FROUTINE) and thus provides a "topic function" that allows for convenient self-recursion.  Compare with APL's [∇ function](https://help.dyalog.com/14.0/Content/Language/Defined%20Functions%20and%20Operators/DynamicFunctions/Recursion.htm).
  
  * `Text::Paragraphs` - provides a `paragraphs` function analogous to Raku's [`lines`](https://docs.raku.org/routine/lines): that is, it splits a `Str` or text from a file into paragraphs.  It can detect paragraphs that are separated by blank lines and/or paragraphs that are only marked by the indentation of their first line.  It is also able to distinguish between the start of a new paragraph and the a bulleted or numbered list (which is _not_ a new paragraph).
  
  * `Text::Wrap` - provides `wrap-words`, a replacement for the Rakudo `implementation-detail` `Str.naive-word-wrapper`.  `wrap-words` is slightly less naive because it provides basic support for wide Unicode (supporting character width without knowing the font is [impossible in theory but works ok in practice](https://stackoverflow.com/questions/3634627)).  `wrap-words` respects the existing whitespace in between words so, unlike Rakudo's version, it doesn't need to have an opinion about how many spaces to put after a period (though, for the record, Rakudo's view that periods should be followed by [two spaces](https://github.com/rakudo/rakudo/blob/master/src/core.c/Str.pm6#L3646) it [the correct one](https://web.archive.org/web/20170926073154/http://bartlebysbackpack.com/2017/07/meta-contrarian-typography/)).  `wrap-words` uses the same greedy wrapping algorithm as Rakudo (though if anyone wants a challenge, I'd welcome a PR that implements the [Knuth & Plass line-breaking algorithm](http://defoe.sourceforge.net/folio/knuth-plass.html) … in under 70 lines of code – here's a JS implementation in [only ~300 lines](https://github.com/bramstein/typeset/blob/master/src/linebreak.js) to get you started)!  
  
  * `Test::Doctest::Markdown` - provides a `doctest` multi that tests Raku code contained in a Markdown file with the goal of testing example code in a `README` or other documentation.  (Nothing's worse than broken examples!) `doctest` tests each code block as follows:  If the code block has `OUTPUT: «…»` comments, `doctest` tests the code's output against the expected output; if the code block doesn't have `OUTPUT` comments, `doctest` tests whether the code can be `EVAL`ed ok.  `doctest` also supports adding configuration info by preceding the code block with a `<!-- doctest -->` comment; currently, the only config option is to provide setup code that's run as part of the test without being displayed in the Markdown file.  Inspired by [Rust's documentation tests](https://doc.rust-lang.org/rustdoc/documentation-tests.html).
  
  * `Test::Fluent` - provides a thin wrapper over Raku's Core [Test](https://docs.raku.org/type/Test) module that supports testing in a more fluent style as shown in the example below.  Most notably, this style supports providing test descriptions in pod6 declarator comments.  Inspired by the [Fluent Assertions](https://fluentassertions.com/) (.NET's) and [Chai](https://www.chaijs.com/) (JS) packages.
 
```raku
# with Raku's Test:
unlike escape-str($str), /<invalid-chars>/, "Escaped strings don't contain invalid characters";

# with Test::Fluent:
#| Escaped strings don't contain invalid characters
escape-str($str).is.not.like: /<invalid-chars>/;
```

#### sub-package selection

As I mentioned earlier, you can import all of `_`'s sub-packages with `use _`.  If you would like more control, you can pass a list of sub-package names to import.  For example, to import only the two text-processing sub-packages, you would write `use _ <Text::Paragraph Text::Wrap>`.  

## Future plans/questions

In addition to my immediate goal of finishing up the various `README`s and releasing a beta version of `_`, I have one medium-term goal for `_` and several questions I'm pondering (thoughts/ideas appreciated!).

#### Version control

The goal – and the largest blocker for a 1.0.0 release for `_` – is to figure out the best way for `_` to version sub-packages and to implement such a versioning system.  I'm still in the design phase for this part of `_`, but I'm imaging a system where users can select sub-package versions independently but where doing so is largely optional for most users.  I'm also trying to decide the best way for `_` to comply with [semantic versioning](https://semver.org/).  On the one hand, definitely want to comply with semver – one of `_`'s goals is to protect users against unexpected breaking changes, after all.  On the other hand, I'm not sure it makes sense to treat a breaking change in _any_ `_` sub-package as a breaking change in `_` as a whole.  The sub-packages are independent, after all, and announcing a `_` breaking change too often could lead to announcement fatigue – especially if, as `_` grows, most "breaking changes" exclusively involve changes to packages that you don't use.

There may be a way to resolve these issues or `_` might be one of the rare packages that should follow a non-semver versioning scheme.  Calendar versioning ([calvar](https://calver.org/)) may be worth considering – at the very least, having periodic scheduled `_` releases would give a natural way to bundle sub-package changes.

I also want to put some thought into sub-package version selection when the user doesn't fully specify a version.  I don't want to reinvent the wheel here or to be needlessly inconsistent with [zef](https://github.com/ugexe/zef).  At the same time, I'm not sure whether the dependency-resolution scheme that makes sense Raku Distributions will also make sense for `_` sub-packages.  In particular, I want to think more deeply about the arguments for/against [minimal version selection](https://research.swtch.com/vgo-mvs) – which seems like a potentially good fit for `_` sub-packages.

Finally, `_` needs to have a decent [responsible disclosure](https://en.wikipedia.org/wiki/Responsible_disclosure) process before I'd consider it 1.0.0 (maybe that's not technically a "versioning" issue, but it's close enough; a security bug would certainly lead to a new version!).  The inherent simplicity of `_` sub-packages _should_ make security flaws much less likely – but that phrase has "famous last words" written all over it, so `_` will definitely err on the side of caution.  I don't think there's a whole lot to decide here; it's just a matter of setting it up.

So, lots to think about, several decisions to make, and some implementation code to write.

#### Packages that outgrow `_`

Another question I'm mulling over is how `_` should act when a package is removed from `_`.  This seems like something that could happen either because the package grows to a size that's incompatible with `_`'s rules or because it "graduates" into Raku's standard library or Core modules.  (Or a package could be removed because it was a bad idea in the first place, but that's hopefully rare and can be handled as a normal breaking change).

If a sub-package is removed from `_` and a user tries to use one of its functions then, of course, they'd get an error by default.  If that sub-package still exists but just lives elsewhere, then `_` could import it and re-export it as a sub-package, which would prevent needlessly breaking user code.  However, this would mean that someone could _believe_ that they were use a `_` sub-package but actually be using an external package – which risks drastically weakening `_`'s guarantees.

I suspect that the best answer here is to re-export the old packages but to throw a deprecation warning.  But I'd like to give it a bit more thought.

#### Handling existing micro packages

Next, I'd like to put some thought into how (if at all) `_` should approach existing micro packages in the Raku ecosystem.  For the initial packages in `_`, I focused entirely on preventing new micro packages from becoming widely used dependencies.  In particular, I avoided knowingly duplicating any existing Raku packages (well, with the slight exception of guifa's [Debug::Transput](https://github.com/alabamenhu/DebugTransput), but that was based off an idea I mentioned to guifa on IRC anyway, so I figured that was fine).

But it might make sense for `_` to one day include the code from Raku packages (or slightly modified versions of them).  To keep its guarantees, `_` would need to create a sub-package based on the package's code, i.e. fork the package.  I would want to be _very_ careful about this – even though forking and re-distributing a free software package is entirely allowed by the license, it can sometimes come off as a bit rude.  And I don't want anyone to think of `_` as a package that's interested in taking credit for other people's work.

Despite those reservations, there's one really compelling reason to consider forking packages: `_`'s purpose is to reduce the number of widely-used micro package dependencies in the Raku ecosystem, and there's no better way to do that than to find packages that are _already_ widely used micro packages.  (Or, said differently, to find packages that are furthest upstream in the [Raku River](http://neilb.org/2015/04/20/river-of-cpan.html).)  And, fortunately, this sort of hard data for the Raku ecosystem is easy to get, either directly through `zef` or using the [ModuleCitation](https://github.com/finanalyst/ModuleCitation) module to generate a visual/interactive display similar to the Raku [Ecosystem Citation Index](https://finanalyst.github.io/ModuleCitation):

<p align="center"><img src="https://codesections.com/photos/top_deps.png" 
alt="A line chart with unlabeled lines depicting the most Raku modules with the most dependencies from January 2016 through January 2019.  The top line is at about 40%, and 6 others are above 20%" 
width="70%" ></p>

This sort of info would let us find modules that are small and widely depended on; in short, ones that are perfect candidates for adding to `_`. 

Given that we **can** do this, I'd like to put some thought into whether we should and, if so, what the best way to do so is.  I can already see a few options: we could look for modules that are high on that list and that seem like they'd benefit from re-writing (perhaps because they were written some time ago or with a different goal) and create sub-packages based on those (without forking them).  Or we could look for packages that might be abandoned and, if so, fork them as sub-packages.  Or try to work with package maintainers to have _them_ add (a version of) the package to `_`.  And I'm sure there are other approaches too; it's something I plan to put a bit more thought into.

(When writing this section, I realized that the ecosystem index hasn't been updated in a couple of years.  I sent in a [PR](https://github.com/finanalyst/p6-task-popular/pull/1) but, until that's merged/the site is updated, you can also see the recent top dependencies at [this gist](https://gist.github.com/codesections/155c74180fbbfe0291c7468f248937e4).)


#### Making `_` trustworthy 

Finally, I've been thinking a bit about how `_` can be as trustworthy as possible (even before the subject [came up](https://www.reddit.com/r/ProgrammingLanguages/comments/raau00/following_the_unix_philosophy_without_getting/hnhi5km/) last time).  The goal, of course, is for `_` to be as close to [zero trust](https://en.wikipedia.org/wiki/Zero_trust_security_model) as possible: because each sub-package is a single short, readable (I hope!) file with zero dependencies, you shouldn't _need_ to trust me – just read the code (and tests) and see for yourself.

That's a fine theory, but in practice there's still a big difference between "as close as possible to zero trust" and "actually zero trust".  And it's true that at least some aspects of `_` depend on its maintainers (i.e., right now, me) being trustworthy.  That works out well for me – I kind of have to trust myself anyway! – and I hope that many in the Raku community know me well enough that it's ok for them too.  But I can fully understand anyone who doesn't share that trust, and I'd like to put some thought into the best ways to add some additional safeguards (both against malicious code and against insecure code).

But that's definitely a someday-well-after-1.0.0 question – after all, maybe no one else will find `_` useful, and I'll be its only user.  If so, being trusted won't be an issue at all.




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
eyJoaXN0b3J5IjpbMTc1NjYwNTYxMF19
-->