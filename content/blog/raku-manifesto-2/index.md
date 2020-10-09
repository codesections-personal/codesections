+++
title = "A Raku Manifesto, Part 2"
date = 2020-10-05
+++

If you recall from [part 1 in this series](/blog/raku-manifesto), we're talking about my
personal take on a Raku manifesto (modeled loosely after the [Agile
Manifesto](https://agilemanifesto.org/)):

<div class="highlight">

1. **Expressive code         <small>over uniform code</small>**
2. **Rewarding mastery       <small>over ease of learnability</small>**
3. **Powerful code           <small>over unsurprising code</small>**
4. **Individual productivity <small>over large-group productivity</small>**
</div>

In part 1, I discussed how and why I believe that Raku values expressive code over uniform
code and rewarding mastery over providing a fast learning curve.  Now,
we're ready to move on to the third value pair.

## Powerful code over unsurprising code

The [principle of least
astonishment](https://en.wikipedia.org/wiki/Principle_of_least_astonishment) is a
fundamental maxim of computer science that states code is far clearer when its behavior can
be easily predicted; code is far more head-scratchingly confusing when it triggers [spooky
action at a
distance](https://en.wikipedia.org/wiki/Action_at_a_distance_%28computer_programming%29).

<aside>

The "Action at a distance" Wikipedia page calls out just one example as particularly
emblematic of the anti-pattern it's describing: the `$[` operator from Perl 5, which it
cites to [Sins of Perl Revisited](https://www.perl.com/pub/1999/11/sins.html/).  I'm happy
to report that Raku (which, recall, was formerly known as Perl 6) has removed pretty much
all of these action-at-a-distance variables.  One of the [design
goals](https://www.perl.com/pub/2007/12/06/soto-11.html/) all along has been to "make
different mistakes" than Perls 1 through 5 – I guess this is one area where we've succeeded.
</aside>

Rust provides a particularly clear example of this principle in action: Rust doesn't let you
override existing operators for existing types; it doesn't let you declare a function
without fully defining the types; it doesn't let you have default arguments; it doesn't let
you call a macro without using the `!` character that sets that call apart from function
calls.  Rust is powerful enough that it _could_ let you break any of these rules, but it
doesn't – enforcing those rules keeps the language less surprising, and thus makes it much
easier to reason about.

And Rust is hardly alone in this regard.  Indeed, the majority of programming languages
don't allow [operator overloading](https://en.wikipedia.org/wiki/Operator_overloading) and
even fewer allow the programmer to define new operators.  Put differently, most languages
are willing to deny programmers the considerable power of user-defined operators to keep the
language less surprising.

### How Raku values unsurprising code

I've already mentioned one way Raku helps prevent nasty surprises: eliminating the
action-at-a-distance variables that were so sinful in Perl 5.  Raku has also thoroughly
embraced lexical scoping; even when you modify Raku's very syntax, your changes will be
limited to your current lexical block.  And, as I mentioned in [part
1](/blog/raku-maifesto), Raku strongly supports both object-oriented and functional
programming – each of which, in its own way, promotes predictable code.

<!-- more -->

In fact, part of Raku's support for functional programming includes fairly comprehensive,
language-level support for immutable data structures.  `Map`s, `Set`s, and `Bag`s are all
immutable, and the `:=` (bind) operator can be used to immutably bind values to variables.
All this immutability allows Raku code to be deeply predictable in many situations where
other more mutable languages would be difficult to reason about.

### How and why Raku sacrifices unsurprising code for powerful code

Despite valuing unsurprising code, Raku will basically never _stop_ you from
doing something in the name of preventing unpredictable behavior.  Some languages don't let
you define custom operators at all; others let you define custom operators but
[automatically assign precedence levels](https://docs.scala-lang.org/tour/operators.html) to
your new operators; [still
others](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html) let you
assign your own precedence level but only support infix, prefix, and postfix operators.
Raku is, to my knowledge, the only language that
[supports](https://docs.raku.org/language/functions#Defining_operators) all of the above
_plus_ circumfix and postcircumfix operators.

<aside>

In case you're not familiar with those terms, a circumfix operator surrounds its arguments.
For example, in the expression `[1, 2, 3]` the circumfix operator `[ ]` surrounds the
arguments `1, 2, 3`; in Raku, that operator transforms the List 1, 2, 3 into the Array 1, 2, 3. 

A postcircumfix operator is one that follows one argument and surrounds a second.  For
example, consider the expression `%hash<key>`.  In that expression `< >` is a postcircumfix
operator with a first argument of `%hash` and a second argument of `key`; in Raku, that
operator is used to implement Hash indexing.

As you can probably tell, being able to define new circumfix and postcircumfix operators can
be very handy for adding indexing-like semantics for custom types.
</aside>

Does this power, if abused, create the potential for awful, surprising, _evil_ code?  You
bet!  Emoji operators?  [Sure, why
not](http://blogs.perl.org/users/damian_conway/2019/09/to-compute-a-constant-of-calculusa-treatise-on-multiple-ways.html).
How about an invisible operator?  Raku will [let
you](https://perl6advent.wordpress.com/2017/12/01/the-grinch-of-perl-6-a-practical-guide-to-ruining-christmas/).
Would you like to overload an existing operator, function, or method to produce different
value when given certain arguments (but act normally for all other arguments)?  You can [do
that
too](https://perl6advent.wordpress.com/2016/12/08/how-to-make-use-and-abuse-perl-6-subsets/).

You might think that the last example is so far-fetched that it'd never actually be used,
but the standard library actually employs it, albeit to deliver an Easter egg.  Normally,
calling the `.WHY` method on an object provides the docstring for that object's class, or a
message stating that no docstring has been written.  Thus, this is totally expected:

```raku
say 'foo'.WHY;
# OUTPUT: «No documentation available for type 'Str'.
#          Perhaps it can be found at
#          https://docs.raku.org/type/Str»
```

However, some clever wag [added
code](https://github.com/rakudo/rakudo/commit/672c5d403cd3d608557839245ecff9d02cdf7f44)
using the overloading-for-a-specific-value trick described above.  As a result, you can get this:

```raku
say 'Life, the Universe and Everything'.WHY # OUTPUT: «42»
```

Obviously, Raku is more than willing to give you enough rope to hang yourself with – when
abused, Raku's features let you write code that isn't just surprising, but that's actually
shocking.  (And I haven't even mentioned the ability Raku provides for defining new terms or
switching to entirely separate sub-languages.)

Yet these same techniques, when used properly, allow you to write powerful, expressive, and
concise code.  For example, the exact same technique that enables the Easter egg mentioned
above allows you to write a Fibonacci function that very nearly reads as plain English:

```raku
multi sub fibonacci(0)  { 0 }
multi sub fibonacci(1)  { 1 }
multi sub fibonacci($n) {
    fibonacci($n - 1) + fibonacci($n - 2)
}
```

Raku gives you enough rope to hang yourself with, but you can also use that rope to build a
wonderful… um, something one builds out of rope.  Swinging bridge?  Rope ladder?… It's
really darn powerful is the point, ok?

## Individual productivity over large-group productivity
<aside>

In many ways, this is the absolute heart of (my version of) the Raku Manifesto.  Everything
that I've written up through this point is more or less a sub-point to this point: in my
view, the **single** goal that animates nearly every decision in the Raku language is the
desire to prioritize the productivity of individual programmers – even when those gains come
at the expense of productivity for huge teams of programmers.
</aside>

Language designers have [long
recognized](https://en.wikipedia.org/wiki/Programming_in_the_large_and_programming_in_the_small)
the tension between language features that make individual programmers as productive as
possible and those that make large teams of programmers as productive as possible.  It's
obviously [not the case](https://en.wikipedia.org/wiki/The_Mythical_Man-Month) that a team
of 10 programmers will be 10 times as productive as an individual programmer.  Instead, the
group's productivity will be determined _both_ by the individual productivity of each
programmer _and_ by how much productivity is lost by coordination difficulties arising
between the different programmers.

This means that a particular programming language might make every individual programmer on
a large team less productive – but still make the team as a whole more productive by
reducing the loss due to mistakes and other coordination difficulties.

This is basically the view Steve Yegge expressed in a [classic blog
post](https://sites.google.com/site/steveyegge2/tour-de-babel) from 2004 comparing C++ and
Java:

> But I'll still take Java over C++, even [though it's less powerful], because I know that
> no matter how good my intentions are, I will at some point be surrounded by people who
> don't know how to code, and they will do far less damage with Java than with C++.

The same sort of considerations informed the design of Golang.  As Rob Pike [put
it](https://talks.golang.org/2012/splash.article):

>  Go was designed to address the problems faced in software development at Google, which
>  led to a language that is not a breakthrough research language but is nonetheless an
>  excellent tool for engineering large software projects [i.e., the sort that] comprise
>  tens of millions of lines of code [and] are worked on by hundreds or even thousands of
>  programmers.

### How Raku values large-group productivity

Raku places an extremely high priority on reducing the friction that large groups face when
maintaining code together.  In fact, when someone who is used to programming in Perl 5 first
approaches Raku, one of the first changes they're likely to notice is Raku's type system.
Specifically, every value in Raku can optionally be given a type; Raku will ensure that
every value type checks correctly.

Adding a type system like that is one of the classic ways languages support large groups
working together.  A type system allows one programmer to write code that exposes only a
limited API and then let other programmers use that code without worrying (as much) about
how they might _misuse_ it.

For example, the untyped `fibonacci` function I defined above
could go wrong in a lot of different ways: to name just one, if called with `-1` or `2.2`,
the program will go into an infinite loop.  If you wrote that function in a large team,
you'd have to trust others to understand _not_ to call it like that.  But Raku's type system
allows you to require that function to take a non-negative integer (`sub fibonacci(UInt $n)
{...}`), which removes that whole class of bugs.  (Of course, this simple example hardly
scratches the surface of the benefits of a good type system.)

Indeed, TypeScript (which describes itself as "typed JavaScript") is [widely
viewed](https://www.infoworld.com/article/2614863/microsoft-augments-javascript-for-large-scale-development.html)
to have supporting software development by larger teams as one of its primary design goals –
and the primary way it achieves that goal is by adding a type system that bears more than a
little similarity to Raku's.  Similarly, the brand-new [version of
Ruby](https://www.ruby-lang.org/en/news/2020/09/25/ruby-3-0-0-preview1-released/) is adding
RBS, which adds similar support for types; again, this feature – though potentially helpful
for projects of all sizes – is most helpful for software written by large groups.

And Raku's type system is far from the only support it offers to programming by large teams.
Raku also offers first-class support for inline documentation in general and [documentation
strings](https://docs.raku.org/language/pod#Declarator_blocks) in particular (helpful for
any project, but most helpful in large projects).  Raku also features strong support for
[versioning code/APIs](https://docs.raku.org/type/Version) in a way that seems most helpful
for larger software projects.

### How Raku sacrifices large-group productivity for individual productivity

Given all of the many ways Raku's design supports large-group productivity, why do I say
that Raku values individual productivity more?  Because, as much as Raku puts a lot of
effort into large-group productivity, it will _never_ sacrifice individual productivity to
do so.

To a large extent, this just falls out of what we've already talked about: to best support
programming by large teams, a language should have uniform code (so that everyone on the
team can read one another's code and can code in a single style); it should have a fast
learning curve (in a large team, especially a large corporate team, people will constantly
be coming and going; _someone_ will always be new, and few will have worked on the project
long enough to develop true mastery); and it should provide unsurprising code (in a large
codebase, surprising code has the chance to trip up many more people before they understand
how it works).  Thus, by choosing expressive code over uniform code,
rewarding mastery over easy learnability, and powerful code over unsurprising code, Raku
_is_ choosing individual productivity over large-group productivity.

But Raku's embrace of individual productivity is more than just a sum of the other values
I've discussed.  Indeed, I believe Raku, as a whole, achieves a focus on individual
productivity that is more than the sum of its parts.  To explain how this is possible, I
need to take a slight step back.

One way Raku programmers like to describe the language is with the phrase `-Ofun` (that is,
it is "optimized for fun").  On its face, this is a pretty odd claim: Raku is a programming
language, a tool designed to get a job done, not that different from a power saw.  What
would it even mean for a power saw to be optimized for fun?  Would you want to use one that
was?

But here's a difference between programming languages and power saws: [nearly 80% of
professional
programmers](https://insights.stackoverflow.com/survey/2020#developer-profile-coding-as-a-hobby)
_also_ program as a hobby.  If programming languages are power saws, then they're not the
ones used by a construction crew to cut 2×4s – they're the saws used by woodworkers who
practice their craft both professionally and recreationally.  That is to say that the craft of
programming – like woodworking – is inherently both a skill and an expressive act.  Or, to
use less highfalutin language, there's enough creativity in writing code that programmers
can't yet be replaced by very small shell scripts (I'm indebted to Elizabeth Mattijsen for
this phrasing).

<aside>

I began this piece by mentioning the Agile Manifesto, but maybe I _should_ have started with
the [Manifesto for Software Craftsmanship](http://manifesto.softwarecraftsmanship.org/)
(which grew out of the Agile movement) instead.
</aside>

What does any of this have to do with individual productivity – or, for that matter, with
Raku being `-Ofun`?  I believe that what people mean when they say that Raku is `-Ofun` is
that it lets an individual programmer be more expressive.  Not just "more expressive" in the
sense of "expressing an idea more concisely", but also "more expressive" in the sense of "more
self-expression".  This doesn't come from any one aspect of Raku, but through the
combination of many small design decisions that combine to remove boilerplate and to let you
make many small yet meaningful choices about how to write your code.

This increased self-expression, I claim, not only makes writing Raku more fun but also
makes it much more productive.  When programmers can put more of themselves into their code,
they can write code that better matches their personal mental model and stay longer in the
highly productive [flow state](https://en.wikipedia.org/wiki/Flow_(psychology)) so conducive
to programming excellent software.  But, as with all things, there's a tradeoff: code that
more perfectly matches one programmer's idiosyncratic mental model is likely to be a _worse_
approximation of a different programmer's mental model.  That sort of self-expression can
easily reduce productivity in a large team.

In the final post in this series, I'll explain why I believe Raku's decision to prioritize
individual productivity over large-group productivity was 100% the right choice.

                                                                                   
