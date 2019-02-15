+++
title = "Thinking about moving the site away from Netlify"
date = 2019-02-12
+++

I'm very strongly considering moving this site away from Netlify.  In fact, I'd go so far as saying that I'm planning to unless writing this post—or hearing from y'all—changes my mind.

Before I launch into why, though, I want to clarify: I've been very happy with Netlify.  They've delivered exactly what they promised: fast, free, static hosting backed by a global CDN.  Deploying is as easy as running `git push` in the terminal; if you're thinking about using them, you probably shouldn't let this post dissuade you.

So, given all those positives, why am I still thinking about migrating the site?
<!-- more -->

## The Problem: My Complexity Budget
Basically, I'm starting to feel that my site is more complex than is justified by how simple my goals are.  Serving this simple, static site involves three separate CDNs: Netlify has their own CDN, they use the Akamai CDN, and they serve images from Amazon's Cloudfront CDN.  That's a lot of interconnected systems to depend on, and I could see it making debugging performance issues harder.

(On the other hand, I haven't *had* any performance issues, so maybe I'm borrowing trouble by thinking through debugging them?)

Somewhat relatedly, I'm not *thrilled* with the idea that Amazon is involved in serving my site—there's not a *ton* they can do with data from serving images (there aren't any cookies on my site, for example) but it does still feed a bit more data their way.

Perhaps more concretely, the complexity inherent in Netlify's setup means that I can't access simple server logs.  I'm a bit curious about how many readers my various posts get, but I've been reluctant to add any JavaScript tracking to my site.  I flatly refuse to add Google Analytics—the privacy implications are just too extreme.  I've considered adding [Fathom](https://usefathom.com/), but Fathom [still uses cookies](https://github.com/usefathom/fathom/issues/40) and has tagged the issue requesting a change with `wontfix`.  Besides, self-hosting Fathom actually be *more* complex than just hosting the site itself: their recommended installation procedure involves installing Fathom, Postgres, and Nginx.  (In contrast, since the site is built into flat files, it can be hosted without a database—all it would need is Nginx).

That's just one example, of course, but it brings something into focus: using Netlify for hosting means buying in to their system—if something (here, accessing logs) isn't supported by their API, then there's just not anything you can do about it.  And there's no long-term guarantee that their API won't change in ways that might impact me; after all, I'm not a paying customer.  I wouldn't even blame them if they change their service in a way that hurts me at the expense of the people actually paying to keep the lights on (or, more to the point, paying to deliver the sort of returns their venture-capitalist investors expect).

## The Solution: A Simple VPS
The solution to all this is simple (or, The solution to all this is simplicity).  Since the site is just static files, I could throw it up behind a super simple Nginx server on basically any VPS.  (I'd probably go with Digital Ocean, but the point is that I could move it anywhere if DO didn't work out—it'd be simple enough to work with any server rather than tied into a specific API).  I could even roll my own server in Rust, which I've tested as providing [similar performance to Nginx](https://www.reddit.com/r/rust/comments/a82w9b/can_a_rust_web_server_beat_nginx_in_serving/).  Though if I went that route, I'd need to add in my own logging).

## The Problem with The Solution: Global Speed
I really love the idea of moving to simplicity, but there's one hangup.  All those CDNs Netlify was running my site through *did* have a purpose—they allow my site's assets to be served globally.  This doesn't much matter for visitors located near me—ironically enough, running `tracepath` showed that my site is *already* served from Digital Ocean servers for visitors from my location, so it wouldn't matter *at all*.  But my site currently (according to [webpagetest.org](https://www.webpagetest.org/), anyway) has essentially the same performance in Mumbai that it has in the U.S.  And I'd give that up if I hosted from a single server.

Of course, there are ways I could add a CDN back into my site—but that would be adding back in some of the complexity that I'm stripping away.  And doing so in a privacy-respecting way would probably get a bit pricy.

So, at least for the short term, I think I'd probably just accept that ditching Netlify would mean accepting slower site speeds for visitors that are half a world a way.  I *think* that trade off is worth it, but I feel bad saying so given that *I* wouldn't be the one dealing with the slower load times.

Anyway, that's what I'm thinking at the moment.  But I'm open to changing my mind—please let me know if I'm thinking about this all wrong.

