+++
date = 2018-07-23
title = "How to avoid SEO penalties when using Netlify"
+++

## The Problem
I've been really happy with my Netlify hosting.  It's fast, free, and deploys 
my site on a global CDN.  Even better, Netlify has all sorts of advanced 
deploy previews and other features that I'm only starting to play with.

All that said, today I realized that one consequence of how Netlify does things
is that sites could end up penalized by Google and other search engines.  
Specifically, because Netlify makes multiple versions of your site available, 
your site could be penalized for having "duplicate content"—the same penalty
that search engines apply to content mills that steal other people's work and
repost it as their own.

<asside>
I have no interest in playing SEO games or trying to get my site ranked
more highly than it organically would be.  I basically figure that the way
to get more readers is to write things that people want to read.  Plus, it's
not like I'm planing to add ads to the site or profit off my readers in any
way.  At the same time, however, I don't want simple mistakes to make my 
content harder to find for those who are interested in it.
</asside>

What is the problem, exactly?  Well, with default settings Netlify makes
every page available as a page on your domain *and* as a page in a subdomain
inside Netlify.com.  So, for example, the page you are reading right now
would be available by default at both
[www.codesections.com/blog/netlify](https://www.codesections.com/blog/netlify) and at
[codesections.netlify.com/blog/netlify](https://codesections.netlify.com/blog/Netlify);
since it shows up at both locations, it would be counted as duplicate
content. 

In fact, the problem is even worse than that: Netlify may also (depending on 
your settings) publish different branches of your site to different URLS (even
with the same content) and will create "deploy-previews" that allow you to 
test live deploys before publishing them to your primary domain.  These features
are **really** great, and I make use of both of them.  (In fact, branch deploys
are what let me easily have
[passgen.codesections.com](https://passgen.codesections.com) as a subdomain
in my site).  But they mean that you could end up with more than just two
copies of each page on your site—way more, in fact.

## The Solution
Fortunately, the solution is very simple.  You to entirely avoid this issue,
you need to take two steps.

<!-- more -->

First, tell Netlify to redirect traffic from your Netlify subdomain to your 
primary domain.  This is a simple matter of setting the appropriate 
`_redirects` file in the root of your site.  What you need to do is to tell
Netlify to redirect all traffic from the `.netlify` subdomain back to your
site.  Here's what mine looks like:

```bash
# Redirect default Netlify subdomain to primary domain
https://codesections.netlify.com/* https://www.codesections.com/:splat 301!
```

Just replace `codesections` with your base url, and save that file as 
`_redirects` in your site root.  Once you've done that, you'll have solved
the bigger half of the problem.

To solve the second half, you'll need to add `rel="canonical"` tags to all
the pages for your site.  Depending on how you build your site, that could
be easy or painful.  I use [Gutenberg](https://www.getgutenberg.io/), 
which makes this process incredibly easy.  (Exactly as I'd expect from such
a powerful static site generator.)

All I need to do is to create a new variable in my `config.toml` file
that's equal to my base url, and then add it to my templates.

Specifically, I add this line to the `[extra]` section of my `config.toml`
file:

```toml
live_base_url = "https://www.codesections.com"
```

and then add this line to each of my templates inside the `<head>` section:

```j2
<link rel="canonical" href="{{ config.extra.live_base_url }}{{ current_path }}">
```

(Why are we using our own `live_base_url` instead of Gutenberg's built-in 
`base_url`?  Because you may want to [change the 
base_url](https://www.getgutenberg.io/documentation/deployment/netlify/) if 
you use Netlify's deploy previews, and we don't want to limit ourselves from
using that very helpful feature.)

And that's it!  Your site now has no duplicate content, and won't be unfairly
lumped in with sites that have scraped content.

If you have any questions, feel free to reach out to me in any of the ways
listed on [my contact page](./about/index.md#contact)—I'd be happy to help.
