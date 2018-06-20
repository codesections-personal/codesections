---
title: "Hexo Review"
date: 2018-06-18T16:57:52-04:00
---

As I've [written about](https://www.codesections.com/blog/why-static-site-generators-are-great/) a [couple of times](https://www.codesections.com/blog/greatness-of-static-site-generators-ii/) 
already, I think static site generators are pretty great.  But that
still leaves picking the right static site generator.

As I've mentioned before, this site is built with [Hugo](https://gohugo.io/), and I'm currently very happy with the setup.  However,
I didn't start with Hugo.  My first experience with a static site
generator was actually with [Hexo](https://hexo.io/)—a static site
generator that I wanted to love but found that I just could not. 

This post is all about what drew me to Hexo in the first place.  And
then, part two of this review, I'll get into what ultimately pushed
me away from it.

<!--more-->

### What I loved about Hexo
Hexo has two huge advantages over Hugo (at least in my book).  First,
it's got a much better templating language.  When writing the files
that determine the layout or overall style of your site, Hugo forces
you to use a custom Hugo-specific syntax built on Go (a.k.a Golang), the language in which Hugo is written.  And—though this is perhaps 
subjective—it's just not the prettiest of languages.

On the other hand, Hexo gives you your choice of templating languages:
it supports Swig, EJS, Haml, or Pug (formerly known as Jade).  The
details of these don't matter too much—what matters is that you get
your choice of several well-regarded templating languages instead of 
being forced into one.

To be fair, this wouldn't matter that much to a lot of people.  It's
entirely possible to use either Hugo or Hexo without ever writing a 
single template: both of them have an abundance of themes to choose 
from.  Pretty much regardless of your taste, you can find something
that fits your style, and can easily tweak it to meet your needs.

However, for whatever reason (stubbornness? need for control? desire
to learn all the things?), I am determined to write my own 
theme for whatever static site generator I end up using.  (Which 
might explain why my site is currently as minimalist as it is, though
I keep making improvements).  

As a result, I knew I'd be spending a fair bit of time with the 
templating language of my chosen tool, and the better options Hexo 
provided were a clear point in its favor.

Second, and just as importantly, Hexo is written in JavaScript.  
JavaScript is a language I already know, and it's one that I plan
to continue to work heavily (even as I expand into other languages,
too).  This means that, if I ever encounter a bug or am *really* 
missing a particular feature, I would have a shot at coding up a patch
myself.  Plus, it would be nice to be able to contribute back to the
tool that I use for my site.

Conversely, Hugo is written in Go, a language that I don't know
and can't foresee spending any serious time with in the near future.

<asside class="note">What, exactly do I have against Go?  Well, that 
should probably be it's own post, but the short version is that I 
think Go is very good at solving Google's problems, but Google's 
problems aren't my problems, and they're probably not yours either.
<br><br>
If you read what the inventors of Go have said about the language, 
it's clear that they built it to solve three problems: Google had
massive programs that were taking forever to compile in C or C++ 
(so Go is built to have super-fast compile times); Google had large
teams need to work together but were hampered by the fact that 
different programmers used different subsets of the same language 
(so Go is built with only one way to accomplish any given goal 
instead of syntactical options), and Google relies on hiring large
numbers of very smart recent college graduates, and thus needs to 
train them quickly (so Go has a syntax very similar to C/C++ and
JavaScript, languages that recent grads are likely to have seen). 
<br><br>
Now, I don't have any of those problems—the compile time of my 
programmes is typically measured in milliseconds, not hours, I'm
mostly working in small teams or on solo projects, and I've got to 
plans to hire hoards of recent CS grads from MIT.  So, it just 
doesn't seem to be the right fit.
<br><br>
Now, none of that is to say that Go is a *bad* language.  In fact, 
it's still one I'd like to learn.  It's just lower on my list than… 
oh, at least a half-dozen others. (Rust, I'm coming for you soon!)</asside>

So, Hexo had two strong points in its favor: a better templating 
language and a better (for me) underlying language.  Those two 
advantages were enough to get me to try it out.  In part two of this
review, I'll talk about what hidden disadvantages made my stay with
Hexo a short one.
