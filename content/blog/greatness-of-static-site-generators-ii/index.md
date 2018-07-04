+++
title = "Greatness of Static Site Generators, Part II"
date = 2018-06-03T11:40:46-04:00
+++

In the <a href="/blog/why-static-site-generators-are-great/">last post</a>, we talked about the history of website hosting and the rise of dynamic websites powered by PHP.  Now, we’re going to turn to more recent history and see how content delivery networks have changed the nature of the modern web.

<h3 id="content-delivery-networks-and-the-global-mobile-web">Content Delivery Networks and the Global, Mobile Web</h3>

<p>One of the biggest advantages of the Internet is how global it is—if your site is hosted in Atlanta, it might get visitors from down the block, but it just as easily might get visitors from New York, or London, or Tokyo.  And that’s pretty incredible.  But it also raises a fundamental problem:</p>

<!-- more -->
<p> To see your site, a visitor has to literally wait for data to be transmitted across the distance from your web server to their computer. And, because the world is a big place, and the speed of light is a bit slow, that can be a long wait (especially because the data likely won’t go in a straight line, but will <a href="https://en.wikipedia.org/wiki/Internet_backbone">instead bounce around in a fascinating way</a> as it makes its way across the globe).</p>

<p>How big of a problem is this, really?  Well, it depends.  It might hardly matter at all, if you have a text-only website that has a local audience who visits it from a desktop computer with a high-speed Internet connection.  On the other hand, if you want your site to have high-definition pictures or, even worse, video, then it’s likely going to be a concern.  And that goes double if you think that many of your visitors might be browsing your site over slower internet connections, like those on cellular networks.  With how popular mobile browsing is these days, pretty much <strong>everyone</strong> should be thinking about that.  So, it depends, but it’s pretty likely that it matters for your site.</p>

<p>Your Atlanta-hosted site might be blazingly fast in Rome, GA, but very slow in Rome, Italy.  If only there were a way for your visitors from Italy to get the same experience that your visitors in Georgia get.</p>

<p>Of course, there is: you can host a second copy of your website in Venice and redirect your Italian visitors to that site.  So then your Italian visitors will get the same experience as your Georgian visitors … unless, of course, we’re talking about the Georgia that boarders Russia, in which case they’ll still be out of luck.  To get those visitors a fast experience, you’ll need to host a copy of your website close to them, and then one (or several!) close to your visitors from Asia.  And, while we’re at it, California isn’t really that close to Atlanta, nor is London that close to Venice …</p>

<p>Clearly, if you really went down that route, you could quickly find yourself hosting dozens of copies of your site.  Is that really worth it, even if it makes your site vastly faster for many visitors?</p>

<p>Well, probably not for the simple example site we’ve been thinking about, but for Google, Amazon, or other huge global companies, absolutely.  And, as far back as the late 90s, other companies understood this need and started building Content Delivery Networks to provide it.  A CDN basically runs local copies of your website, and steers visitors to the closest available copy.</p>

<p>So, CDNs started out as a premium service for large sites.  (Indeed, the CDN that I use, Akamai, which is one of the largest and best CDNs, still largely does business exclusively with large companies.)  But it didn’t stay that way for long.  By the early 2010s, there were multiple CDNs offering services to consumer websites, with cheap or even free plans.  By 2018, if a site isn’t using a CDN, it basically can’t provide the sort of speed that its competitors can offer.</p>

<p>“But wait a second,” I hear you reasonably object.  “How can a CDN host dozens of copies of my site for free when it isn’t even free to host a single copy of my site?”  That’s a very good question, and to answer it, we’ll need to go into a bit more detail, and expose an oversimplification from the explanation above.</p>

<p>When first introducing CDNs, I gave the example of literally running copies of your site all over the globe.  That may sometimes be the way it’s done, but it’s typically not (at least for consumer CDNs).  Instead, a CDN will ask you to label content that isn’t likely to change, like images you post to particular pages.  The CDN will then host that content, and only that content.  For content that changes all the time (including all dynamically generated content) the CDN will direct your visitors back to your main server.</p>

<p>But that raises two questions.  First, even if the CDN is only hosting some of the files, how does that get it cheap enough that they can offer the prices that they do?  And, second, how do CDNs speed up the load times, if users have to wait for a response from the main server anyway?</p>

<p>The first answer turns on the distinction between static content and dynamic content we talked about back when we were discussing PHP.  Remember how I said it was much cheaper to host static content (like the flat HTML files from the 90s) than to host dynamic content (the dynamically generated pages produced by PHP from the early 2000s)?  That’s still true today, and is the reason CDNs work the way they do: because they don’t need to devote any processing power to deciding what to send back to a visitor, or to building a website based on PHP code.  Instead, it can just send back the resource, which is computationally cheap—so cheap that CDNs can offer the great prices that they do.</p>

<p>The answer to the second question is a little more complicated.  The length of time it takes to load a website will depend on <em>both</em> the amount of data transferred <em>and</em> the distance the data has to travel.  So, if your CDN-less Atlanta-hosted site has a visitor from Rome, GA, it will be incredibly fast to send them a small file (like the text of your page), and a bit slow to send them a large file (like a HD picture set as your background).  If your site has a visitor from Rome, Italy, it will be a bit slow even to send the small file (due to the distance), and <strong>very</strong> slow to send the HD picture.</p>

<p>A CDN helps in that situation, because it can handle hosting the image for you (since that’s one of those things that don’t change frequently that you can put on a CDN).  With a CDN, a visitor from Rome would still have to wait a bit for your text to load and (like everyone) they’d have to wait a bit for your large image to load.  But they’d avoid the excruciating wait for a large image being transmitted across a large ocean.</p>

<p>But they still wouldn’t get <em>quite</em> as good an experience as your visitors from Rome, GA—they’d still have to wait for the basic HTML/text content of your site to load across the ocean.  The only way to avoid that loading time would be to put your entire site onto the CDN, which isn’t possible … at least not with a dynamic site, built the way sites were built fifteen years ago.</p>

<h3 id="static-site-generators-the-speed-of-static-with-the-power-of-dynamic">Static Site Generators: The Speed of Static, with the Power of Dynamic</h3>

<p>With that context, we can at last see the problem that static site generators are built to solve: How can we build a site that has all the power of a dynamic site while also keeping the finished product static?  We want a tool that gives us the power to manage our content and reuse elements just like we can with a site built with PHP, but that also lets us host our entire site on a CDN.</p>

<p>And that’s exactly what a static site generator gives us.  How does it pull that off?</p>

<p>By flipping the order.  Instead of building a copy of the site every time a visitor comes to your site (which requires the web server to use it’s processor to apply the logic in PHP files), a static site generator builds the website on the developer’s computer—that is, on <em>your</em> computer as you’re coding the site.  Instead of writing a PHP file with templating logic (“first the navigation menu, <em>then</em> the content …”) and letting the web server apply that logic, you instead write a template file, and have the static site generator spit out a built file assembled from our separate pieces.  The end result is that you have exactly the same site that you would have had if you’d coded it all by hand like you would have in the early 90s—it’s incredibly fast, totally static, and can be hosted on an CDN for pennies (or even for free).  But, crucially, you didn’t need to build it all by hand, and can reuse (or update) different pieces by making changes to a single file and then updating the site.</p>

<p>This is <em>almost</em> the same as with PHP.  But with two crucial differences.  First, it’s done whenever you add content to the site, instead of every time someone visits the site (which means it’s done much less frequently).  And, second, it’s done on your own computer, which has plenty of processing power to spare that you’ve already paid for, instead of on a web server that you rent (and have to pay for processing power on).</p>

<p>And so that’s the best way to build a website in the late 2010s: write a dynamic website, with each component separated out and easily editable, and then use a static site generator to transform that dynamic site into a set of flat, static files that can be hosted on a CDN.  The power and flexibility of a dynamic site, with the speed and low cost of a static one.</p>

<p>I don’t want to make this sound perfect—there are a few downsides to a static site, and I’ll have more about what those are and how to overcome them soon.  And, even after deciding to use a static site, there’s still the matter of selecting a static site generator—and there are many!  But the basic point stands: these days, there’s no faster or cheaper way to build a website than by using a static site generator.</p>

