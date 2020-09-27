+++
title = "A Raku Manifesto, Part 3"
date = 2020-10-09
+++

In [part 1](/blog/raku-manifesto) and [part 2](/blog/raku-manifesto-2) I discussed my
personal take on a Raku manifesto: 

<div class="highlight">

1. **Expressive code         <small>over uniform code</small>**
2. **Rewarding mastery       <small>over ease of learnability</small>**
3. **Powerful code           <small>over unsurprising code</small>**
4. **Individual productivity <small>over large-group productivity</small>**
</div>

In those posts, I explained how Raku prioritizes each of the values on the left over each of
the values on the right.  I also explained that, in my view, the final value pair –
prioritizing individual productivity over large-group productivity – is the most fundamental
value driving Raku's design.  All the other sets of priorities in my Raku manifesto play a
supporting role in prioritizing individual productivity over large-group productivity.  In
this post, I explain why I've convinced that Raku made the right call.

### Why Raku is correct to priorities individual productivity 

I mentioned earlier that language designers have recognized the tension between individual
productivity and large group productivity.  If you look at what has been written on the
topic – all the way from the original [Programming-in-the-Large Versus
Programming-in-the-Small](https://en.wikipedia.org/wiki/Programming_in_the_large_and_programming_in_the_small)
paper through today – you might get the impression that small scale programming is a solved
problem and that the only interesting/meaningful question is how we increase the
productivity of large software teams.  Certainly many of the programming languages that have
gained popularity recently seem to reflect that view:

| Language   | Developer | Purpose                       | 
|------------|:----------|:------------------------------|
| Golang     | Google    | build large software projects |
| Rust       | Mozilla   | build large software projects |
| TypeScript | Microsoft | build large software projects |
| Hask       | Facebook  | build large software projects |

Looking at that list, you might conclude that we clearly need a programming language for
large projects and that older languages do fine for smaller groups.

You might, but you shouldn't.

<!-- more -->

### Large companies have built languages for large teams

Let's take another look at the names on that list: Google, Mozilla, Microsoft, Facebook.
**Those** groups are confronting the problem of increasing the productivity of large
programming teams – the same teams of "hundreds or even thousands" that Rob Pike mentioned
as the target for Golang development.  But that doesn't mean teams like that are
particularly representative of the rest of the software world.  And it _especially_ doesn't
mean that teams like that are representative of the free/open source software world (the
part I care most about).

And, in fact, those huge groups aren't representative.  Let me tell you a secret most people
don't like to talk about that much: the median number of contributors to popular GitHub
repositories [is one or
two](https://www.researchgate.net/publication/308894462_What_is_the_Truck_Factor_of_popular_GitHub_applications_A_first_assessment).
To repeat, that's _popular_ repositories – in fact, just the top 133 repos.  The long tail
of unpopular (but, at times, still deeply useful within its niche) free software is even
more likely to be maintained by just one person.  So there's absolutely a lot of extremely
important software being written by small groups.

But maybe that just means that programming-in-the-small is pretty well served by existing
programming languages.  A ton of programming languages have been developed lately; do we
have an explanation for why so many of the ones that succeeded would be the ones that
targeted programming in the large?

Actually, we do: developing a good programming language is _really hard_.  You can build one
out by, hiring one of the best [VM
architects](https://en.wikipedia.org/wiki/Robert_Griesemer_(computer_programmer)) in the
world, and [two](https://en.wikipedia.org/wiki/Ken_Thompson) of the [best
known](https://en.wikipedia.org/wiki/Rob_Pike) and most experienced programmers alive today,
and then paying a team of
[hundreds](https://dave.cheney.net/2016/03/25/go-project-contributors-by-the-numbers) to
work on the language.  That worked for Google.  But if you're trying to solve the problems
of small teams, mostly comprised of free software developers, your plan should probably not
start with "hire the literal inventors of Unix".

In fact, it's hard to imagine how an open-source, community driven language could really
compete.  To even get started, you'd need someone with pretty serious language-design
chops.  And they're in pretty scarce supply – most of them are busy maintaining existing
languages, and it would be pretty hard to convince any of them to start a new language.  And
that's _especially_ true because, given the open-source nature of the endeavor, the project
would probably take many years, with no guarantee of success during that time.  You'd also
have to convince them to work for almost nothing, compared to the millions they could make
by spending those years as a [senior software
developer](https://www.levels.fyi/company/Google/salaries/Software-Engineer/).  And it only
gets worse from there: you wouldn't _just_ need to find this one magical language designer,
you'd need to attract a whole team around them, including both designers and implementers.
And they'd _all_ need to be very talented, and willing to work hard for little immediate
reward.

That's all pretty far-fetched.  New languages might come from developers who are [relatively
inexperienced when they start designing the
language](https://en.wikipedia.org/wiki/Yukihiro_Matsumoto#Work) or out of
[business](https://en.wikipedia.org/wiki/Swift_(programming_language)) or
[academia](https://en.wikipedia.org/wiki/Racket_(programming_language)).  But the idea of
the free software community producing a well-thought-out language from an experienced team
of language designers?  That'll never happen.

Except that it did, of course.

I don't know what stars aligned to result in Larry Wall, Damian Conway, and so many other
talented and experienced people building the language that grew into Raku.  But we need to
recognize that something really special took place.  Most other languages are, by design,
targeted at solving problems for the Google's of the world, because that's who can fund
language development.  Raku has a really special – maybe even unique – role, because it
_didn't_ start with that design goal.  Instead, it started with the goal of making the best
language possible, where "best" is measured at the level of the individual user of the
language.

I'm really glad it delivers on that design goal.
