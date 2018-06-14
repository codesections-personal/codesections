---
title: "Why Static Site Generators Are Great"
date: 2018-06-03T11:37:56-04:00
---
   
<p>What makes static site generators so great?  And what is a static site generator, anyway?</p>

<p>To answer that, let’s take a step back and think about how a website works.  Skipping over some (interesting and important!) details not relevant here, to display a website all you need to do is to send visitors of the website an HTML document.</p>

<p>As an example, take this stripped-down version of the current <a href="https://www.codesections.com">CodeSections</a> homepage.  To keep things simple, I’ve striped out all the CSS and the parts of the HTML related to how the page would look, which leaves us with just the basic HTML.
</p>

<!--more-->

<pre><code>&lt;nav&gt;
  &lt;div&gt;
    &lt;div&gt;&lt;a href="/"&gt;Home&lt;/a&gt;&lt;/div&gt;
    &lt;div&gt;&lt;a href="/about"&gt;About&lt;/a&gt;&lt;/div&gt;
    &lt;div&gt;&lt;a href="/writing"&gt;Writing&lt;/a&gt;&lt;/div&gt;
    &lt;div&gt;&lt;a href="/projects"&gt;Projects&lt;/a&gt;&lt;/div&gt;
  &lt;/div&gt;
&lt;/nav&gt;

&lt;section&gt;
  &lt;h1&gt; I'm Daniel, a web developer who started coding in 
  an odd way:  I was a lawyer in New York, when my firm needed a coding lawyer.&lt;/h1&gt;
  &lt;p&gt;Lawyers and programmers are both incredibly logical, but somehow they 
  don't always speak the same language.  My goal is to bridge that gap by 
  being skilled in both domains—and the first step in doing that is leveling 
  up my programming skills.&lt;/p&gt;
  &lt;p&gt;As part of that process, I've built this site to provide a home for the 
  &lt;a href="/projects.html"&gt;projects&lt;/a&gt; I'll build along the way—and to take 
  the opportunity to build a &lt;a href="/projects/this-website/"&gt;website that 
  is like Richard Feynman's radios&lt;/a&gt;.&lt;/p&gt;
&lt;/section&gt;

&lt;footer&gt;
  &lt;div&gt;
    &amp;copy; 2018 | &lt;a href="../license/"&gt;Some Rights Reserved&lt;/a&gt;
  &lt;/div&gt;
  &lt;div&gt;
    &lt;a href="https://github.com/dsock"&gt;Github&lt;/a&gt; |
    &lt;a href="https://www.linkedin.com/in/daniel-sockwell/"&gt;LinkedIn&lt;/a&gt; |
    &lt;a href="mailto:daniel-public-email@codesections.com"&gt;Email&lt;/a&gt;
  &lt;/div&gt;
&lt;/footer&gt;
</code></pre>

<p>Even if you’re not familiar with HTML, you can probably tell what’s going on
with that code: we’ve got one section up top that sets up the navigation menu, then a block of code for the main content of the page, and finally a block of code that structures the footer.  That code is enough to set up the whole page (again, skipping over CSS and JavaScript for now), and all you need to do is get that code to the visitors of your website.  So, how do you get it to them?</p>

<p>To answer that, we need a bit of history.</p>

<h3 id="internet-the-early-years">Internet: The Early Years</h3>

<p>Well, there are three basic ways.  First, you can just have file on your computer with that exact content.  Then, whenever someone tries to visit www.codesections.com, you send them that HTML file.</p>

<p>This method, known as a “static website”, has the virtue of being very simple, and very fast—all you have to do is send a single file, and it doesn’t get any faster than that.  In the very early days of the Internet, this was exactly how sites got built.</p>

<p>However, this simple system has a few major drawbacks, too.  Take a look at that code sample again.  As we talked about, it has three sections—and only one of them is specific to the home page.  The navigation menu and the footer need to appear on every page, which means that you need that exact same code on every page.  So, if you’re coding like it’s 1994, then you’ll need to copy and paste that code into every page.</p>

<p>Worse, if you ever decide to change that code (say, you decide you want to add a new item to the navigation menu), then you’ll have to make that change on every single page you copied the code into. That’s pretty annoying when you have a site with dozens of pages, but becomes downright overwhelming if you’re trying to maintain a site with hundreds or thousands of pages.</p>

<p>Even worse, there are a lot of website features that are either very annoying or basically impossible to include with a static website.  Take something as simple as a basic blog.  Here’s what you want: a homepage that displays the ten most recent posts, with a link to the next page with the next ten posts, which links to the next page, and so on.  Well, with a purely static site, you’d have a real chore ahead of you every time you added a new post: you’d need to update the homepage by adding the new post and deleting what is now the eleventh post, and then you’d need to update page two.  And then three.</p>

<p>Clearly, the modern web wouldn’t be possible if people were coding sites by hand like that.</p>

<h3 id="static-sites-and-the-rise-of-php">Static Sites and the Rise of PHP</h3>

<p>So, in the mid-90s, a guy named Rasmus Lerdorf came up with a better system to power his personal home page, which eventually grew into PHP.  The basic idea behind PHP is to dynamically generate a website whenever a visitor navigates to a page.  Here’s how that would work with our example site:  instead of having a single file for the home page, you’d have a file with the home page content, another file with the navigation menu, and a third with the footer.  Then, you’d have some PHP code that basically says “whenever someone asks for the homepage, build that page by inserting the navigation menu, then the content for the home page, and finally the footer”.  Or, if you were building a blog, you could have PHP that says “build the blog home page by inserting the navigation menu, then the ten most recent posts, and then the footer”.</p>

<p>Despite some well-deserved criticism, PHP represented a huge improvement, and it powered the explosion of dynamic websites in the late 90s and early 2000s.  If you were building a website around the turn of the century, a dynamic website built with PHP was definitely the way to go.  Sure, it wasn’t <em>quite</em> as fast (or as cheap) to get your content to users, since you had to run some logic on your computer every time a visitor requested a page.  But computing power was cheap, and getting even cheaper—and, besides, it was far more costly to pay programmers to maintain a sprawling static site than to have it done automatically with PHP.</p>

<p>But, as great as dynamic sites were a decade ago, they’re no longer the best way to build a site.  To understand why not, we need to talk about a couple of technologies that have taken off in the last fifteen or so years.</p>

<p>In the next post, I’ll explain what those technologies are, how they’ve transformed the demands placed on modern websites, and why they mean that static site generators are the best way to build websites for the modern web.</p>

