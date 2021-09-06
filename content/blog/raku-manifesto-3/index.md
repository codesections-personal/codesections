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
this post, I explain why I'm convinced that Raku made the right call.

### Why Raku is correct to prioritize individual productivity 

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

You _might_, but you shouldn't.

<!-- more -->

### Large companies have built languages for large teams

Let's take another look at the names on that list: Google, Mozilla, Microsoft, Facebook.
**Those** groups are confronting the problem of increasing the productivity of large
programming teams – the same teams of "hundreds or even thousands" that Rob Pike mentioned
as the target for Golang development.  But that doesn't mean those huge teams are
particularly representative of the rest of the software world.  And it _especially_ doesn't
mean that huge teams are representative of the free/open source software world (the
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
by hiring one of the best [VM
architects](https://en.wikipedia.org/wiki/Robert_Griesemer_(computer_programmer)) in the
world and [two](https://en.wikipedia.org/wiki/Ken_Thompson) of the [best
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
the free software community producing a well-thought-out language built by an experienced
team of language designers?  That'll never happen.

Except that it did, of course.

I don't know what stars aligned to result in Larry Wall, Damian Conway, and so many other
talented and experienced people building the language that grew into Raku.  But we need to
recognize that something really special took place.  Most other languages are, by design,
targeted at solving problems for the Googles of the world, because that's who can fund
language development.  Raku has a really special – maybe even unique – role, because it
_didn't_ start with that design goal.  Instead, it started with the goal of making the best
language possible, where "best" is measured at the level of the individual user of the
language.

The advantages Raku brings to the individual programmer don't (just) come from Raku being a
well-designed language.  They also come from Raku having a design that prioritizes
individuals/small groups in a way that most language designs simply don't aim for.

## So what?
Raku is designed to maximize productivity for small groups.  That's good for people involved
in small projects (which, as mentioned above, includes the vast majority of software on
GitHub).  But does it matter for anyone outside that group?

In my view, it matters immensely.

Let's do some back-of-the-napkin math: If a software project employs exactly 1,000 software
developers, and it spends $100,000 to compensate each one (a significant underestimate, but
fine for our napkin) then it has payroll costs of a hundred million dollars.  That means that any
software project employing thousands of developers will need a business model that can bring
in hundreds of millions of dollars of revenue – and, realistically, a lot more.

As Facebook, Amazon, and Google amply demonstrate, plenty of software projects can make
millions or even billions of dollars.  But plenty of others could never make that type of
money but would still make the world a better place.

In fact, I'd go a lot further than that: I think the examples of Facebook, Amazon, and
Google _also_ show that many of the ways to make that kind of money with software are…
deeply troubling, to say the least.  I'm troubled by the impact these companies have had on
user privacy, the open Internet, and the world in general.  In fact, despite the billions
they've made, I'm not at all sure that Facebook and its legions of software developers have
done more good than harm.  While large tech projects are certainly not all bad, I am
increasingly skeptical of the power of big tech companies – and thus correspondingly skeptical
of languages designed to solve the coordination problems of large tech companies, which will
only further entrench the existing giants.

And, on the flip side, I'm incredibly excited by languages like Raku that can help to level
the playing field a bit between large tech firms and their small, open source competitors.

## A pipe dream
A potential objection to all of this is that it's totally wishful thinking.  You might point
out that the Googles and Microsofts of the world have huge advantages; you might argue that
it'll take far more than just a more productive programming language to help smaller players
compete.

If you said that, I'd have a lot of responses, mostly centering on just how large the
coordination problems of large software development are and on how crippled big tech
companies are by their own toxic revenue models.  Maybe I'll go into that argument
in more depth in a future post.

For now, though, I'll just say that it's not only _possible_ for small, open source projects
to outcompete huge tech companies – it's already happening.

You might have thought it impossible for a small group to provide a better user experience
than the one provided by Twitter's army of developers; but
[Mastodon](https://joinmastodon.org/) shows it can be done.  You might have thought that
Microsoft's massive resources give GitHub an insurmountable advantage, but [Source
Hut](https://sourcehut.org/) – a one-employee project – is absolutely [crushing their
performance](https://forgeperf.org/).  You might have thought Google Chrome's scale would
prevent any serious challenger, but I'm much happier using a [different
browser](https://www.qutebrowser.org/) that has been built, essentially, by one person in
their spare time.

These projects – and many others I could mention – are very diverse, but they all have one
thing in common: None of them will ever make ten million dollars; none of them are built
around business models that would ever let them hire a thousand software engineers.  And
yet, because of the advantages that come from their small size, their less exploitative
business models, and the power of small-scale software development, each of them is going
head to head with much larger competitors.

These projects all have something else in common: none of them are built with Raku.  Of
course not; Raku is too young.  But, given the success that projects like these are
_already_ seeing, I'm incredibly excited to see what projects small teams are able to build
with a language that was designed from the ground up to maximize individual productivity.
I'm excited for Raku.
