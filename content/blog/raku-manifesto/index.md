+++
title = "A Raku Manifesto, Part 1"
date = 2020-09-27
+++
<div class="highlight">

1. **Expressive code         <small>over uniform code</small>**
2. **Rewarding mastery       <small>over ease of learnability</small>**
3. **Powerful code           <small>over unsurprising code</small>**
4. **Individual productivity <small>over large-group productivity</small>**
</div>

I'm not so sure that I'm a fan of agile software development (at least as it's commonly
practiced).  But I am sure that the [Agile Manifesto](http://agilemanifesto.org/) got one
thing _really_ right: It not only stated what values were important but also stated which
values (though important!) could be sacrificed.  That is, the Agile Manifesto was explicit
about what tradeoffs it was willing to make.

That's crucial because it's really easy to select some nice-sounding phrases and label
them as "priorities" – who wouldn't agree that "[readability
counts](https://www.python.org/dev/peps/pep-0020/)"?  But it's much harder to pick out
important values that you're willing to sacrifice.  And, because it's harder, it's also
much more revealing.  You'll often learn a lot more from knowing a project's non-goals
than from knowing its goals.

In that spirit, I'd like to present a similar manifesto for the [Raku programming
language](https://raku.org/).  Note: I said "**a**" manifesto, not "**the**" manifesto for
Raku.  I'm speaking only for myself; I'm sure many others would include different
dichotomies on their version of a Raku manifesto.  Additionally, this is very much a first
draft.  I've put considerable thought into this but haven't yet discussed my views broadly.
I also artificially limited myself to four pairs of values (following the form set by the
Agile Manifesto), and I could easily imagine changing my mind.  If you disagree or just have
a different perspective, I'd love to hear your thoughts on the
[r/rakulang](https://www.reddit.com/r/rakulang/comments/j0vq6u/a_raku_manifesto_part_1/?)
thread for this post on the [#raku IRC channel](https://raku.org/community/irc).

<aside>

In this post, I'll be contrasting Raku with other programming languages.  Nothing I'm
saying is intended as a criticism of the other languages I mention; they all have
strengths and are good for particular use cases.  My only goal in bringing them up at all
is to make the contrast with Raku more concrete and reflect on how languages are willing
to make tradeoffs that reflect their design goals.

In particular, I'll mention [Golang](https://golang.org/) pretty often.  This isn't because
I think Golang is a poorly designed language – quite the reverse, in fact.  I think Golang
is an extremely _well_ designed language, and one where the designers have been wonderfully
explicit about their design goals.  I also think that Golang's design goals are, in many
cases, the exact opposite of Raku's, which makes it a particularly useful contrast. 
</aside>

Before we get started, I want to remind you of a statement from the Agile Manifesto:

> That is, while there is value in the items on the right, we value the items on the left more.

I feel the same way.  All the items on the right side of the chart up above (the items that
come after "over") are still _really_ important.  So, in this series of posts, I'm going to
walk through the four value pairs in my Raku manifesto.  I'll discuss the first two pairs in
this post, and the next two in the second post.  For each pair, I'll say why the value on
the right side is important, and what Raku does to support it.  Then I'll say why, in my
view, the value on the left is even **more** important (for the language Raku is trying to
be, anyway), and how Raku prioritizes it in ways that require sacrificing the value on the
right.  After discussing all four value pairs, I'll close with a post on why I believe that
Raku's decision to prioritize the values on the left is absolutely the correct one.

<!-- more -->

## Expressive code over uniform code

Uniform code is great.  Tools like [prettier.js](https://prettier.io/),
[gofmt](https://golang.org/cmd/gofmt/), and [rustfmt](https://github.com/rust-lang/rustfmt)
are popular for a good reason: they let a team consistently apply a uniform style, without
any of the [holy wars](https://geometrian.com/programming/tutorials/tabsspaces/index.php)
that can accompany code formatting debates.  What's more, they let any programmer who is
fluent in those languages jump into a new codebase and feel right at home – no need to
adjust to the stylistic peccadilloes of a particular project or individual.

And, of course, code uniformity goes far beyond automatic code formatters.  For example,
Rob Pike [has said](https://talks.golang.org/2012/splash.article) that one of the reasons
Golang has a minimal syntax is to avoid the problem of "each programmer using a different
subset of the language".  That "subset" problem can be a real issue in languages with more
syntax: it's entirely possible for two programmers who nominally know the same language to
have extreme difficulty reading one another's code if they use sufficiently different
subsets.

### How Raku values uniformity

Raku values code uniformity, but it doesn't force it on you.  I keep coming back to the
following [quote from Larry Wall](https://theworld.com/~swmcd/steven/perl/linguistics.html):

> Style [is] not enforced except by peer pressure.  We do not all have to write like
> Faulkner, or program like Dijkstra.  I will gladly tell people what my programming style
> is, and I will even tell them where I think their own style is unclear or makes me jump
> through mental hoops.  But I do this as a fellow programmer, not as the Perl god.

That quote was from 1995, and Larry was talking about Perl – but it applies just as much
today and to Raku.  And, from this point of view, a tool that automatically rearranges
everyone's code into "better" style is just about the ultimate act of playing
language-god.

But I also want to focus on the "peer pressure" part of that quote.  While Raku doesn't
force uniform style on anyone, the community around the language does quite a bit to
(hopefully gently) encourage people to write uniform code.  For one thing, we try really
hard to ensure that Raku's documentation and the accompanying code examples model a
[single, uniform style](https://github.com/Raku/doc/blob/master/writing-docs/STYLEGUIDE.md).
Perhaps more notably, the Raku community has _enthusiastically_ embraced the [Perl & Raku
weekly challenge](https://perlweeklychallenge.org/) – it's not uncommon for the subreddit
and the [weekly Raku newsletter](https://rakudoweekly.blog/) to feature a half-dozen or so
solutions to the same programming puzzle every week.  Seeing so many different takes on the
same problem helps keep us all on the same page about what constitutes good style and helps
prevent Raku from splintering into mutually unintelligible dialects.

### How and why Raku sacrifices uniformity for expressivity

Given all the positives I just mentioned, why is Raku willing to sacrifice uniformity?
Because variety enhances expressivity.  This is abundantly clear in natural languages;
consider the following English sentences:

> - Variety enhances expressivity.
> - The ability to use a variety of near-synonyms allows you to more clearly express your
>   intent.
> - Expressivity – the amount of information you can express in a given unit of text – is
>   maximized by varying your words in response to the context in which you are
>   communicating.

Each of these sentences communicates more or less the same idea.  But they make different
tradeoffs between concision and clarity, and they place the emphasis on different ideas.
The ability to communicate the same basic idea in multiple ways is part of what makes
English (and other natural languages) so expressive.

Raku applies this same idea to code.  To start with a fairly trivial example, Raku lets you
call any function as a method.  That is, the two lines after `use Test` both mean the same
thing:

``` raku
use Test;
is($the-answer, 42);
$the-answer.&is(42);
```

The result is the same, but – just as in English – changing the order changes the emphasis
conveyed to the reader.  Depending on the context, one or the other might be clearer; having
the option to choose between the two forms makes Raku more expressive.

Generalizing a bit, Raku firmly embraces the
[TIMTOWTDI](https://en.wikipedia.org/wiki/There%27s_more_than_one_way_to_do_it): there's
nearly _always_ more than one way to do it, not matter what "it" happens to be.  This shows
up in the abundance of conditional keywords (prefix `if`, postfix `if`, `unless`, `when`)
and in the different Boolean operators (`?` vs `so`; `!` vs `not`).  Each one has a
different meaning, and using a different keyword or operator in the correct context can make
Raku code much more readable.

Zooming out, TIMTOWTDI also explains how emphatically multi-paradigm Raku is.  Raku offers
_extremely_ strong support for [object-oriented
programming](https://docs.raku.org/language/objects) – it's not at all an exaggeration to
say that everything is an object; at the same time, it's also possible to write Raku in a
strongly functional style (and I usually do!).  This flexibility greatly enhances Raku's
expressive power; after all, some problems are a natural fit for OOP, while others fit well
within a functional programming paradigm.  But this expressive power comes at the expense
of code uniformity – it really is possible to write Raku in a style that would look 
alien to a different Raku programmer who fully embraces a different paradigm.

To return to the first topic I mentioned, all of the expressivity/uniformity tradeoffs we've
discussed apply to code formatters.  Having line breaks between every method call in a
multi-line method chain certainly improves uniformity.  But it also limits a programmer's
expressive flexibility.  There's a tradeoff here, and I'm happy with Raku's decision to
favor expressive code over uniform code.

## Rewarding mastery over ease of learnability 

Many languages are expressly designed to be easy to learn.  Markdown is [explicitly
designed](https://daringfireball.net/projects/markdown/syntax) "to be as easy-to-read and
easy-to-write as is feasible".  Scheme has a syntax that's so minimal that it can be
learned, in its entirety, in the [first
lecture](https://archive.org/details/SICP_4_ipod/Lecture-1a.MP4) of a standard CS course.
Golang [was designed](https://talks.golang.org/2012/splash.article) to be easy enough to
learn that "programmers … early in their careers [could become] productive quickly in a new
language".

And the value in being easy to learn is obvious: No one is born knowing a programming
language – to attract new users, a language must convince programmers that spending their
time learning the language is a worthwhile investment.  The less time it takes to learn
the language, the easier it is to make this case.  And, indeed, languages that are more difficult
to learn, such as Rust, frequently cite their difficulty as an impediment to the language's
adoption.

### How Raku values ease of learning

Raku is designed to be a language you don't have to learn all at once.  From its [initial
announcement](https://raku.org/archive/talks/2000/als/larry-als.txt), Raku was envisioned as
a language that should be easy to learn at a "baby talk" level.  In other words, it should
be (and, now, is) easy for a programmer to come to Raku and program in the limited subset of
the language that they're already comfortable with.  Indeed, the Raku website maintains [ten
different migration guides](https://docs.raku.org/language.html) designed to help
programmers transition from other languages to the equivalent Raku subset.

### How and why Raku sacrifices ease of learning to reward deep mastery

As is probably obvious from our discussion of TIMTOWTDI, the Raku language is _big_.  Raku
has a lot of syntax, and those syntactical elements can be used together in a combinatorial
explosion of ways.  What's more, because Raku incorporates ideas from so many different
paradigms (including, incidentally, array programming) and introduces entirely novel
abstractions (like junctions), Raku's semantics present significant amounts of material,
even apart from its syntax.

But this complexity buys Raku immense power in the hands of an experienced user.  As
described in the same [announcement](https://raku.org/archive/talks/2000/als/larry-als.txt) that
mentioned the idea of "baby talk", Raku is "optimized for expressiveness, not
learnability" because you "learn it once, but you use it many times".  If you spend much
time at all reading about Raku, you'll [come
across](https://wimvanderbauwhede.github.io/articles/function-types/) numerous
[examples](http://blogs.perl.org/users/damian_conway/2019/09/to-compute-a-constant-of-calculusa-treatise-on-multiple-ways.html)
of
[advanced](https://perl6advent.wordpress.com/2016/12/08/how-to-make-use-and-abuse-perl-6-subsets/)
users
[demonstrating](https://perl6advent.wordpress.com/2016/12/11/day-11-perl-6-core-hacking-it-slipped-through-the-qasts/)
just [how
powerful](https://perl6advent.wordpress.com/2014/12/10/day-10-introspecting-the-symbol-tables/)
Raku can be in the right hands.

In my next post, I'll discuss the other two value pairs in my personal Raku manifesto.


