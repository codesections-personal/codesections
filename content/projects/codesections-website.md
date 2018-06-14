---
title: "This Website"
date: 2018-06-03T13:42:25-04:00
---
<style>
.equal-display-element {
  display: inline;
}

.code-and-commentary {
  position: relative;
  left: calc(50% - 48.5vw);
  display: flex;
  width: 97vw;
}

.code-and-commentary__heading {
  text-align: center;
}

.code-and-commentary__code {
  width: 60%;
  margin-right: 1vw;
  background: #f5f2f0;
  border-radius: 6px;
}

.code-and-commentary__commentary {
  width: 39%;
  background-color: #f5f2f0;
  border: solid 2px #95b4d8;
  border-radius: 6px;
}

.commentary__pre {
  white-space: pre-wrap;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  color: #0D1E25; /*nearly black*/
  max-width:50%;
}

@media (max-width: 599px) { /*Phone only*/
  .code-and-commentary{
    font-size: .6em;
    word-break: break-word;
  }
}
</style>

  <p class="content-p">The website you're reading right now!  I tried to do things a bit differently with this website.  

  In building this website, I had three main goals.  I wanted the site to:<p></p>
  <ul>
    <li>have understandable source code,</li>
    <li>be self-sufficient, and</li>
    <li>be the <a href="https://hackernoon.com/10-things-i-learned-making-the-fastest-site-in-the-world-18a0e1cdf4a7">fastest site in the world</a>.</li>
  </ul>
  <p class="content-p">Here is my analysis of how well I managed to meet these goals.</p>

<!--more-->
  <h3>Understandable Source Code</h3>

  <p class="content-p">Why do I want to write a page with understandable source code?  To answer that, I want to first talk about Richard Feynman and transistor radios.</p>

  <p class="content-p">The Nobel-prize-winning physicist Richard Feynman wrote about his early childhood experience repairing transistor radios in the 1930s.  In case you haven't seen a transistor radio, they look like this:</p>

  <img src="/radio-min-20.jpg" width="100%" caption="Transistor radio; image credit: Wikipedia">

  <p class="content-p">By contrast, a modern radio receiver is so small that millions of people <a class="link" href="https://www.cnet.com/how-to/unlock-the-secret-fm-tuner-in-your-android-phone/">had one inside their cellphones and didn't even realize it.</a></p>

  <p class="content-p">Why am I talking about radios on a page about this website?  Because Feynman was able to learn and apply basic physics in a way that children today basically can't.  Radios have gotten too miniaturized, have had their complexity hidden away where no one can learn from it.  And I see the same thing happening with websites</p>

  <p class="content-p"> Here's a (slightly modified) copy of the markup from the beginning of <a class="link" href="http://info.cern.ch/hypertext/WWW/TheProject.html">an extremely early website</a>:</p>

  <div class="highlight" style="background: #f8f8f8"><pre style="line-height: 125%"><span></span>&lt;<span style="color: #008000; font-weight: bold">head</span>&gt;
  &lt;<span style="color: #008000; font-weight: bold">title</span>&gt;The World Wide Web project&lt;/<span style="color: #008000; font-weight: bold">title</span>&gt;
&lt;/<span style="color: #008000; font-weight: bold">head</span>&gt;

&lt;<span style="color: #008000; font-weight: bold">body</span>&gt;
  &lt;<span style="color: #008000; font-weight: bold">h1</span>&gt;World Wide Web&lt;/<span style="color: #008000; font-weight: bold">h1</span>&gt;

  &lt;<span style="color: #008000; font-weight: bold">p</span>&gt;The WorldWideWeb (W3) is a wide-area
  &lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">name</span><span style="color: #666666">=</span><span style="color: #BA2121">0</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"WhatIs.html"</span>&gt;hypermedia&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt;
  information retrieval initiative aiming to
  give universal access to a large universe
  of documents.&lt;/<span style="color: #008000; font-weight: bold">p</span>&gt;

  &lt;<span style="color: #008000; font-weight: bold">p</span>&gt;Everything there is online about W3 is
  linked directly or indirectly to this document,
  including an &lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"Summary.html"</span>&gt;executive
  summary&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt; of the project.&lt;/<span style="color: #008000; font-weight: bold">p</span>&gt;


  
</pre></div>

  <p class="content-p">Even if you've never read a word of markup before in your life, you can probably just about figure out what that does—that it creates a header (with a title for the page) and then creates a body of the document that consists of several paragraphs with some text and a few links to other html pages.</p>

  <p class="content-p">In contrast to that, consder this excerpt from the markup for a <a class="link" href="http://www.businessinsider.com/flashback-this-is-what-the-first-website-ever-looked-like-2011-6"> modern news article</a> <em>about</em> that early site.  The markup starts like this:</p>
  <div class="highlight" style="background: #f8f8f8"><pre style="line-height: 125%"><span></span><span style="color: #BC7A00">&lt;!DOCTYPE html&gt;</span>
&lt;<span style="color: #008000; font-weight: bold">html</span> <span style="color: #7D9029">lang</span><span style="color: #666666">=</span><span style="color: #BA2121">"en"</span> <span style="color: #7D9029">xmlns</span><span style="color: #666666">=</span><span style="color: #BA2121">"http://www.w3.org/1999/xhtml"</span> <span style="color: #7D9029">xml:lang</span><span style="color: #666666">=</span><span style="color: #BA2121">"en"</span> <span style="color: #7D9029">lang</span><span style="color: #666666">=</span><span style="color: #BA2121">"en"</span> <span style="color: #7D9029">xmlns:fb</span><span style="color: #666666">=</span><span style="color: #BA2121">"http://www.facebook.com/2008/fbml"</span> &gt;
&lt;<span style="color: #008000; font-weight: bold">head</span>&gt;
  &lt;<span style="color: #008000; font-weight: bold">meta</span> <span style="color: #7D9029">http-equiv</span><span style="color: #666666">=</span><span style="color: #BA2121">"X-UA-Compatible"</span> <span style="color: #7D9029">content</span><span style="color: #666666">=</span><span style="color: #BA2121">"IE=edge"</span> /&gt;
  &lt;<span style="color: #008000; font-weight: bold">meta</span> <span style="color: #7D9029">http-equiv</span><span style="color: #666666">=</span><span style="color: #BA2121">"content-type"</span> <span style="color: #7D9029">content</span><span style="color: #666666">=</span><span style="color: #BA2121">"text/html;charset=utf-8"</span> /&gt;
  &lt;<span style="color: #008000; font-weight: bold">script</span> <span style="color: #7D9029">type</span><span style="color: #666666">=</span><span style="color: #BA2121">"text/javascript"</span>&gt;
  (window.NREUM||(NREUM={})).loader_config={
    xpid:"UQ8EUVRACQAFVVdbAQk="
  };
  window.NREUM||(NREUM={})
  ,__nr_require=function(t,n,e){
    function r(e){if(!n[e]){var o=n[e]={exports:
      {}};t[e][0].call(o.exports,function(n){
        var o=t[e][1][n];return r(o||n)},o,o.exports)
      }return n[e].exports}if("function"==typeof __nr_require)
      return __nr_require;for(var o=0;o&lt;<span style="color: #008000; font-weight: bold">e.length</span><span style="border: 1px solid #FF0000">;</span><span style="color: #7D9029">o</span><span style="border: 1px solid #FF0000">++)</span><span style="color: #7D9029">r</span><span style="border: 1px solid #FF0000">(</span><span style="color: #7D9029">e</span><span style="border: 1px solid #FF0000">[</span><span style="color: #7D9029">o</span><span style="border: 1px solid #FF0000">]);</span>
      <span style="color: #7D9029">return</span> <span style="color: #7D9029">r</span><span style="border: 1px solid #FF0000">}</span>
</pre></div>


<p class="content-p">That is, with javascript that has been inlined an minified to the point of being gibberish, even to experienced programers. Even if we give the article the benefit of skipping past 502 lines (!) of inline javascript, we get to this: </p>

  <div class="highlight" style="background: #f8f8f8"><pre style="line-height: 125%"><span></span>&lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"masthead"</span>&gt;
    &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"container"</span>&gt;
        &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"row-fluid"</span>&gt;
            &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"span3 span3-mh"</span>&gt;
                                &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">data-hamburger</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"menu"</span>&gt;
                    &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"hamburger"</span>&gt;
                        &lt;<span style="color: #008000; font-weight: bold">span</span>&gt;&lt;/<span style="color: #008000; font-weight: bold">span</span>&gt;
                        &lt;<span style="color: #008000; font-weight: bold">span</span>&gt;&lt;/<span style="color: #008000; font-weight: bold">span</span>&gt;
                        &lt;<span style="color: #008000; font-weight: bold">span</span>&gt;&lt;/<span style="color: #008000; font-weight: bold">span</span>&gt;
                    &lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
                &lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
                                &lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/"</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"sprites logo"</span>&gt;&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt;
            &lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
            &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"span6 span6-mh"</span>&gt;

                        &lt;<span style="color: #008000; font-weight: bold">h2</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"vert-name ellipsis"</span>&gt;&lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"http://www.businessinsider.com/sai"</span>&gt;Tech Insider&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt;&lt;/<span style="color: #008000; font-weight: bold">h2</span>&gt;

                                                &lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
            <span style="color: #408080; font-style: italic">&lt;!-- links --&gt;</span>
            &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"span3 span3-mh links list-pipes list-right no-pipe"</span>&gt;
</pre></div>


<p class="content-p">All that is to say that html and css markup, at their best, can be like the transistor radio.  They can be a toy that anyone motivated and curious enough can pull apart and see how it works.  For so many of today's programers, who grew up with (or before) the Internet, that's exactly what html was.</p>

<p class="content-p">But I worry that today's html is much more like the tiny, miniaturized radio inside a cell phone—a marvel of engineering, perhaps, but so complex that it (seems to be) outside the realm of understanding for any non-expert.</p>

<p class="content-p">So, with this website, I'm pushing back against that trend.  I've built a highly performant, modern website—but one with markup that is just as understandable as the websites from 1991. Like the radios that Feynman repaired, this is a website that anyone can take apart to see how it works.</p>

<p class="content-p">To that end, I've left in the comments and have not minified any of the source.  This bloats the page a bit, because those comments get sent to your computer even if you don't read them.   Nevertheless, I've kept the page tiny and <em>fast</em>—the total page weight is still under 14kb, which means it loads in a single http request.</p>

<p class="content-p">Below, I have an annotated copy of the markup from the home page.  Anytime I do something non-standard or that is debatable, I'll provide a comment explaining why I made the choice I did and what I'm trying to achieve. If you disagree with any of my choices, feel free to let me know via email, twitter, or any of the contact methods in the site footer.  I'd love to discuss it with you.</p>


  <div class="code-and-commentary">
  <div class="highlight" style="background: #f8f8f8"><pre style="line-height: 125%"><span></span><span style="color: #BC7A00">&lt;!DOCTYPE html&gt;</span>
&lt;<span style="color: #008000; font-weight: bold">html</span> <span style="color: #7D9029">lang</span><span style="color: #666666">=</span><span style="color: #BA2121">"en"</span>&gt;
&lt;<span style="color: #008000; font-weight: bold">head</span>&gt;
	&lt;<span style="color: #008000; font-weight: bold">meta</span> <span style="color: #7D9029">name</span><span style="color: #666666">=</span><span style="color: #BA2121">"generator"</span> <span style="color: #7D9029">content</span><span style="color: #666666">=</span><span style="color: #BA2121">"Hugo 0.25.1"</span> /&gt;
&lt;<span style="color: #008000; font-weight: bold">meta</span> <span style="color: #7D9029">charset</span><span style="color: #666666">=</span><span style="color: #BA2121">"utf-8"</span>&gt;
&lt;<span style="color: #008000; font-weight: bold">meta</span> <span style="color: #7D9029">name</span><span style="color: #666666">=</span><span style="color: #BA2121">"viewport"</span> <span style="color: #7D9029">content</span><span style="color: #666666">=</span><span style="color: #BA2121">"width=device-width"</span>&gt;

&lt;<span style="color: #008000; font-weight: bold">title</span>&gt;&lt;/<span style="color: #008000; font-weight: bold">title</span>&gt;





&lt;<span style="color: #008000; font-weight: bold">link</span> <span style="color: #7D9029">rel</span><span style="color: #666666">=</span><span style="color: #BA2121">"apple-touch-icon"</span>
      <span style="color: #7D9029">sizes</span><span style="color: #666666">=</span><span style="color: #BA2121">"180x180"</span>
      <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/apple-touch-icon.png"</span>&gt;
&lt;<span style="color: #008000; font-weight: bold">link</span> <span style="color: #7D9029">rel</span><span style="color: #666666">=</span><span style="color: #BA2121">"icon"</span>
      <span style="color: #7D9029">type</span><span style="color: #666666">=</span><span style="color: #BA2121">"image/png"</span>
      <span style="color: #7D9029">sizes</span><span style="color: #666666">=</span><span style="color: #BA2121">"16x16"</span>
      <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/favicon-16x16.png"</span>&gt;
&lt;<span style="color: #008000; font-weight: bold">link</span> <span style="color: #7D9029">rel</span><span style="color: #666666">=</span><span style="color: #BA2121">"manifest"</span>
      <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/manifest.json"</span>&gt;
&lt;<span style="color: #008000; font-weight: bold">link</span> <span style="color: #7D9029">rel</span><span style="color: #666666">=</span><span style="color: #BA2121">"mask-icon"</span>
      <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/safari-pinned-tab.svg"</span>
      <span style="color: #7D9029">color</span><span style="color: #666666">=</span><span style="color: #BA2121">"#5bbad5"</span>&gt;
&lt;<span style="color: #008000; font-weight: bold">meta</span> <span style="color: #7D9029">name</span><span style="color: #666666">=</span><span style="color: #BA2121">"theme-color"</span>
      <span style="color: #7D9029">content</span><span style="color: #666666">=</span><span style="color: #BA2121">"#d9d9d9"</span>&gt;

&lt;<span style="color: #008000; font-weight: bold">link</span> <span style="color: #7D9029">rel</span><span style="color: #666666">=</span><span style="color: #BA2121">"prefetch"</span>
  <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/resources/css/prism-code-highlight.css"</span>&gt;
&lt;<span style="color: #008000; font-weight: bold">link</span> <span style="color: #7D9029">rel</span><span style="color: #666666">=</span><span style="color: #BA2121">"prefetch"</span>
  <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/resources/js/prism-code-highlight.js"</span>&gt;


&lt;<span style="color: #008000; font-weight: bold">style</span>&gt;


  
<span style="color: #408080; font-style: italic">/*==================================*\</span>
<span style="color: #408080; font-style: italic">  ##All CSS for this page</span>
<span style="color: #408080; font-style: italic">\*==================================*/</span>

<span style="color: #408080; font-style: italic">/*  Theme colors:</span>
<span style="color: #408080; font-style: italic"> *</span>
<span style="color: #408080; font-style: italic"> *  #fd0     yellow (menu bar)</span>
<span style="color: #408080; font-style: italic"> *  #cde     pastel blue (note boxes)</span>
<span style="color: #408080; font-style: italic"> *  #000     true black (site header)</span>
<span style="color: #408080; font-style: italic"> *  #223     near black (text &amp; logo)</span>
<span style="color: #408080; font-style: italic"> *  #fff     white (menu text)</span>
<span style="color: #408080; font-style: italic"> *  #07e     sky blue (links)</span>
<span style="color: #408080; font-style: italic"> */</span>

<span style="color: #408080; font-style: italic">/*==================================*\</span>
<span style="color: #408080; font-style: italic">  ##Global</span>
<span style="color: #408080; font-style: italic">\*==================================*/</span>
<span style="color: #008000; font-weight: bold">html</span> {
  <span style="color: #008000; font-weight: bold">font-family</span>: <span style="color: #666666">-</span>apple-system,
               BlinkMacSystemFont,
               <span style="color: #BA2121">'Segoe UI'</span>,
               Roboto,
               <span style="color: #BA2121">'Helvetica Neue'</span>,
               Arial, <span style="color: #008000; font-weight: bold">sans-serif</span>;
  <span style="color: #008000; font-weight: bold">color</span>: <span style="color: #666666">#223</span>; <span style="color: #408080; font-style: italic">/*near black*/</span>
}



  
<span style="color: #408080; font-style: italic">/*==================================*\</span>
<span style="color: #408080; font-style: italic">  ##Nav bar</span>
<span style="color: #408080; font-style: italic">\*==================================*/</span>
.<span style="color: #0000FF; font-weight: bold">nav-bar</span> {
  <span style="color: #008000; font-weight: bold">position</span>: <span style="color: #008000; font-weight: bold">fixed</span>;
  <span style="color: #008000; font-weight: bold">z-index</span>: <span style="color: #666666">1</span>;
  <span style="color: #008000; font-weight: bold">left</span>: <span style="color: #666666">0</span>;
  <span style="color: #008000; font-weight: bold">width</span>: <span style="color: #666666">100</span><span style="color: #B00040">%</span>;
  <span style="color: #008000; font-weight: bold">padding</span>: <span style="color: #666666">0</span>;
  <span style="color: #008000; font-weight: bold">background-color</span>: <span style="color: #666666">#fd0</span>; <span style="color: #408080; font-style: italic">/*yellow*/</span>
  <span style="color: #008000; font-weight: bold">box-shadow</span>: <span style="color: #666666">0</span> <span style="color: #666666">3</span><span style="color: #B00040">px</span> <span style="color: #666666">6</span><span style="color: #B00040">px</span> <span style="color: #008000">rgba</span>(<span style="color: #666666">0</span>, <span style="color: #666666">0</span>, <span style="color: #666666">0</span>, <span style="color: #666666">.3</span>);
}

.<span style="color: #0000FF; font-weight: bold">nav-bar--top</span> {
  <span style="color: #008000; font-weight: bold">top</span>: <span style="color: #666666">0</span>;
}

.<span style="color: #0000FF; font-weight: bold">nav-bar__container</span> {
  <span style="color: #008000; font-weight: bold">display</span>: <span style="color: #008000; font-weight: bold">flex</span>;
  <span style="color: #008000; font-weight: bold">max-width</span>: <span style="color: #666666">700</span><span style="color: #B00040">px</span>; <span style="color: #408080; font-style: italic">/*max comfortable line length*/</span>
  <span style="color: #008000; font-weight: bold">padding-left</span>: <span style="color: #666666">8</span><span style="color: #B00040">px</span>;
  <span style="color: #008000; font-weight: bold">padding-right</span>:<span style="color: #666666">8</span><span style="color: #B00040">px</span>;
  <span style="color: #008000; font-weight: bold">margin</span>: <span style="color: #008000; font-weight: bold">auto</span>;
  <span style="color: #008000; font-weight: bold">justify-content</span>: <span style="color: #008000; font-weight: bold">space-between</span>;
}

.<span style="color: #0000FF; font-weight: bold">nav-bar__button</span> {
  <span style="color: #008000; font-weight: bold">position</span>: <span style="color: #008000; font-weight: bold">relative</span>;
  <span style="color: #408080; font-style: italic">/*  This isn't needed for display of this element,</span>
<span style="color: #408080; font-style: italic">   *  but important for the :after pseudo element</span>
<span style="color: #408080; font-style: italic">   *  below. */</span>
  <span style="color: #008000; font-weight: bold">cursor</span>: <span style="color: #008000; font-weight: bold">pointer</span>;
  <span style="color: #008000; font-weight: bold">background-color</span>: <span style="color: #008000; font-weight: bold">inherit</span>;
}

.<span style="color: #0000FF; font-weight: bold">nav-bar__button</span>:<span style="color: #AA22FF">not</span><span style="color: #666666">(</span>.<span style="color: #0000FF; font-weight: bold">nav-bar__button--current-page</span><span style="color: #666666">)</span> {
  <span style="color: #008000; font-weight: bold">color</span>: <span style="color: #008000; font-weight: bold">white</span>;
}

.<span style="color: #0000FF; font-weight: bold">nav-bar__link</span> {
  <span style="color: #008000; font-weight: bold">color</span>: <span style="color: #008000; font-weight: bold">inherit</span>;
  <span style="color: #008000; font-weight: bold">text-decoration</span>: <span style="color: #008000; font-weight: bold">none</span>;
}

.<span style="color: #0000FF; font-weight: bold">nav-bar__link</span>::<span style="color: #AA22FF">selection</span> {
  <span style="color: #008000; font-weight: bold">background-color</span>: <span style="color: #008000; font-weight: bold">inherit</span>;
  <span style="color: #008000; font-weight: bold">color</span>: <span style="color: #008000; font-weight: bold">inherit</span>;
}

.<span style="color: #0000FF; font-weight: bold">nav-bar__link</span>:<span style="color: #AA22FF">after</span> {
  <span style="color: #008000; font-weight: bold">position</span>: <span style="color: #008000; font-weight: bold">absolute</span>;
  <span style="color: #008000; font-weight: bold">bottom</span>: <span style="color: #666666">-4</span><span style="color: #B00040">px</span>;
  <span style="color: #008000; font-weight: bold">left</span>: <span style="color: #666666">0</span>;
  <span style="color: #008000; font-weight: bold">width</span>: <span style="color: #666666">0</span>;
  <span style="color: #008000; font-weight: bold">height</span>: <span style="color: #666666">0</span>;
  <span style="color: #008000; font-weight: bold">content</span>: <span style="color: #BA2121">""</span>;
  <span style="color: #008000; font-weight: bold">transition</span>: <span style="color: #008000; font-weight: bold">all</span> <span style="color: #666666">0.4</span><span style="color: #B00040">s</span> <span style="color: #008000; font-weight: bold">ease</span>;
  <span style="color: #008000; font-weight: bold">border-top</span>: <span style="color: #666666">3</span><span style="color: #B00040">px</span> <span style="color: #008000; font-weight: bold">solid</span> <span style="color: #666666">#223</span>; <span style="color: #408080; font-style: italic">/*near black*/</span>
}

.<span style="color: #0000FF; font-weight: bold">nav-bar__button</span>:<span style="color: #AA22FF">not</span><span style="color: #666666">(</span>.<span style="color: #0000FF; font-weight: bold">nav-bar__button--current-page</span><span style="color: #666666">)</span>
  .<span style="color: #0000FF; font-weight: bold">nav-bar__link</span>:<span style="color: #AA22FF">hover</span>:<span style="color: #AA22FF">after</span> {
    <span style="color: #008000; font-weight: bold">width</span>: <span style="color: #666666">100</span><span style="color: #B00040">%</span>;
}

@<span style="color: #008000; font-weight: bold">media</span> <span style="color: #666666">(</span><span style="color: #008000; font-weight: bold">max-width</span><span style="color: #666666">:</span> <span style="color: #008000; font-weight: bold">599px</span><span style="color: #666666">)</span> { <span style="color: #408080; font-style: italic">/*Phone only*/</span>
  .<span style="color: #0000FF; font-weight: bold">nav-bar__button</span> {
    <span style="color: #008000; font-weight: bold">font-size</span>: <span style="color: #666666">1.382</span><span style="color: #B00040">em</span>;
    <span style="color: #008000; font-weight: bold">line-height</span>: <span style="color: #666666">3</span><span style="color: #B00040">em</span>;
    <span style="color: #408080; font-style: italic">/*  The goal is creating a larger target for</span>
<span style="color: #408080; font-style: italic">     *  touch navigation while also shrinking</span>
<span style="color: #408080; font-style: italic">     *  the amount of horizontal space devoted to</span>
<span style="color: #408080; font-style: italic">     *  the menu.*/</span>
  }
}

@<span style="color: #008000; font-weight: bold">media</span> <span style="color: #666666">(</span><span style="color: #008000; font-weight: bold">min-width</span><span style="color: #666666">:</span> <span style="color: #008000; font-weight: bold">600px</span><span style="color: #666666">)</span> {  <span style="color: #408080; font-style: italic">/*Tablet-portrait &amp; up*/</span>
  .<span style="color: #0000FF; font-weight: bold">nav-bar__button</span> {
    <span style="color: #008000; font-weight: bold">font-size</span>: <span style="color: #666666">2</span><span style="color: #B00040">em</span>;
  }
}


  
<span style="color: #408080; font-style: italic">/*==================================*\</span>
<span style="color: #408080; font-style: italic">  ##Main content</span>
<span style="color: #408080; font-style: italic">\*==================================*/</span>
.<span style="color: #0000FF; font-weight: bold">content-main</span>{
  <span style="color: #008000; font-weight: bold">margin-top</span>: <span style="color: #666666">75</span><span style="color: #B00040">px</span>;
  <span style="color: #008000; font-weight: bold">min-height</span>: <span style="color: #008000">calc</span>(<span style="color: #666666">100</span><span style="color: #B00040">vh</span> <span style="color: #666666">-</span> <span style="color: #666666">75</span><span style="color: #B00040">px</span> <span style="color: #666666">-</span> <span style="color: #666666">2.9</span><span style="color: #B00040">em</span>);
  <span style="color: #408080; font-style: italic">/*  This equals [fullscreen - (top margin) -</span>
<span style="color: #408080; font-style: italic">   *  (space for the 2-line footer, with margin)]*/</span>
  <span style="color: #008000; font-weight: bold">max-width</span>: <span style="color: #666666">700</span><span style="color: #B00040">px</span>; <span style="color: #408080; font-style: italic">/*  Match nav container width*/</span>
  <span style="color: #008000; font-weight: bold">margin-left</span>: <span style="color: #008000; font-weight: bold">auto</span>;
  <span style="color: #008000; font-weight: bold">margin-right</span>: <span style="color: #008000; font-weight: bold">auto</span>;
  <span style="color: #008000; font-weight: bold">font-size</span>: <span style="color: #666666">1.424</span><span style="color: #B00040">em</span>;
  <span style="color: #008000; font-weight: bold">line-height</span>: <span style="color: #666666">1.266</span><span style="color: #B00040">em</span>;
}

.<span style="color: #0000FF; font-weight: bold">site-header</span>{
  <span style="color: #008000; font-weight: bold">margin-bottom</span>: <span style="color: #666666">0</span>;
  <span style="color: #008000; font-weight: bold">text-align</span>: <span style="color: #008000; font-weight: bold">left</span>;
  <span style="color: #008000; font-weight: bold">font-size</span>: <span style="color: #666666">1.618</span><span style="color: #B00040">em</span>;
  <span style="color: #008000; font-weight: bold">font-weight</span>: <span style="color: #666666">400</span>;
  <span style="color: #008000; font-weight: bold">line-height</span>: <span style="color: #666666">.85</span>;
  <span style="color: #008000; font-weight: bold">color</span>: <span style="color: #666666">#000</span>;
}

.<span style="color: #0000FF; font-weight: bold">content-p</span> {
  <span style="color: #008000; font-weight: bold">color</span>: <span style="color: #666666">#223</span>; <span style="color: #408080; font-style: italic">/*near black*/</span>
  <span style="color: #008000; font-weight: bold">margin-top</span>: <span style="color: #666666">1</span><span style="color: #B00040">em</span>;
  <span style="color: #008000; font-weight: bold">margin-bottom</span>: <span style="color: #666666">0</span>;
}

.<span style="color: #0000FF; font-weight: bold">link</span> {
  <span style="color: #008000; font-weight: bold">color</span>: <span style="color: #666666">#07e</span>; <span style="color: #408080; font-style: italic">/*sky blue*/</span>
  <span style="color: #008000; font-weight: bold">text-decoration</span>: <span style="color: #008000; font-weight: bold">none</span>;
}

.<span style="color: #0000FF; font-weight: bold">note</span> {
  <span style="color: #008000; font-weight: bold">background-color</span>: <span style="color: #666666">#cde</span>; <span style="color: #408080; font-style: italic">/* Pastel blue*/</span>
  <span style="color: #008000; font-weight: bold">display</span>: <span style="color: #008000; font-weight: bold">block</span>;
  <span style="color: #008000; font-weight: bold">padding</span>: <span style="color: #666666">.5</span><span style="color: #B00040">em</span>;
  <span style="color: #008000; font-weight: bold">margin-top</span>: <span style="color: #666666">1</span><span style="color: #B00040">em</span>;
  <span style="color: #008000; font-weight: bold">color</span>: <span style="color: #666666">#0d1d25</span>; <span style="color: #408080; font-style: italic">/*near black*/</span>
  <span style="color: #008000; font-weight: bold">border</span>: <span style="color: #008000; font-weight: bold">solid</span> <span style="color: #666666">2</span><span style="color: #B00040">px</span> <span style="color: #666666">#0d1d25</span>; <span style="color: #408080; font-style: italic">/* Near black*/</span>
}

.<span style="color: #0000FF; font-weight: bold">highlight</span> {
  <span style="color: #008000; font-weight: bold">overflow</span>: <span style="color: #008000; font-weight: bold">auto</span>;
}

@<span style="color: #008000; font-weight: bold">media</span> <span style="color: #666666">(</span><span style="color: #008000; font-weight: bold">min-width</span><span style="color: #666666">:</span>  <span style="color: #008000; font-weight: bold">600px</span><span style="color: #666666">)</span> { <span style="color: #408080; font-style: italic">/*Tablet-portrait &amp; up*/</span>
  .<span style="color: #0000FF; font-weight: bold">site-header</span> {
    <span style="color: #008000; font-weight: bold">font-size</span>:  <span style="color: #666666">2.618</span><span style="color: #B00040">em</span>;
    <span style="color: #008000; font-weight: bold">padding-top</span>: <span style="color: #666666">4</span><span style="color: #B00040">vh</span>;
    <span style="color: #008000; font-weight: bold">padding-bottom</span>: <span style="color: #666666">1</span><span style="color: #B00040">vh</span>;
  }
}



  
<span style="color: #408080; font-style: italic">/*==================================*\</span>
<span style="color: #408080; font-style: italic">  ##Footer</span>
<span style="color: #408080; font-style: italic">\*==================================*/</span>
.<span style="color: #0000FF; font-weight: bold">footer</span> {
  <span style="color: #008000; font-weight: bold">margin-top</span>: <span style="color: #666666">1</span><span style="color: #B00040">em</span>;
  <span style="color: #008000; font-weight: bold">text-align</span>: <span style="color: #008000; font-weight: bold">center</span>;
}

&lt;/<span style="color: #008000; font-weight: bold">style</span>&gt;
&lt;/<span style="color: #008000; font-weight: bold">head</span>&gt;


&lt;<span style="color: #008000; font-weight: bold">body</span>&gt;

  &lt;<span style="color: #008000; font-weight: bold">nav</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"nav-bar nav-bar--top"</span>&gt;
  &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"nav-bar__container"</span>&gt;
    &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"nav-bar__button nav-bar__button--current-page"</span>&gt;&lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"nav-bar__link"</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/"</span>&gt;Home&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt;&lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
    &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"nav-bar__button"</span>&gt;&lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"nav-bar__link"</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/about"</span>&gt;About&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt;&lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
    &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"nav-bar__button"</span>&gt;&lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"nav-bar__link"</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/blog"</span>&gt;Blog&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt;&lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
    &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"nav-bar__button"</span>&gt;&lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"nav-bar__link"</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/projects"</span>&gt;Projects&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt;&lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
  &lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
&lt;/<span style="color: #008000; font-weight: bold">nav</span>&gt;




  &lt;<span style="color: #008000; font-weight: bold">section</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"content-main"</span>&gt;

  &lt;<span style="color: #008000; font-weight: bold">h1</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"site-header"</span>&gt; I’m Daniel, a web developer 
who started coding in an odd way:  I was a lawyer in
New York, when my firm needed a coding lawyer.&lt;/<span style="color: #008000; font-weight: bold">h1</span>&gt;

  &lt;<span style="color: #008000; font-weight: bold">p</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"content-p"</span>&gt;Lawyers and programmers are both
incredibly logical, but somehow they don't always speak
the same language.  My goal is to bridge that gap, by
being skilled in both domains—and the first step in
doing that is leveling up my programming skills.&lt;/<span style="color: #008000; font-weight: bold">p</span>&gt; 

  &lt;<span style="color: #008000; font-weight: bold">p</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"content-p"</span>&gt;As part of that process, I've built
this site to provide a home for the 
&lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"link"</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/projects.html"</span>&gt;
projects&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt; I'll build along the way—and
to take the opportunity to build a
&lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"/projects/this-website/"</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"link"</span>&gt;website
that is like Richard Feynman’s radios&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt;.&lt;/<span style="color: #008000; font-weight: bold">p</span>&gt;

&lt;/<span style="color: #008000; font-weight: bold">section</span>&gt;




&lt;<span style="color: #008000; font-weight: bold">footer</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"footer"</span>&gt;
  &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"footer_copyright"</span>&gt;
    © 2018 | &lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"link"</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"../license/"</span>&gt;
    Some Rights Reserved&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt;
  &lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
  &lt;<span style="color: #008000; font-weight: bold">div</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"footer_contact"</span>&gt;
    &lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"link"</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"https://github.com/dsock"</span>&gt;Github&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt; |
    &lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"link"</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"https://www.linkedin.com/in/daniel-sockwell/"</span> &gt;LinkedIn&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt; |
    &lt;<span style="color: #008000; font-weight: bold">a</span> <span style="color: #7D9029">class</span><span style="color: #666666">=</span><span style="color: #BA2121">"link"</span> <span style="color: #7D9029">href</span><span style="color: #666666">=</span><span style="color: #BA2121">"mailto:daniel-public-email@codesections.com"</span>&gt;Email&lt;/<span style="color: #008000; font-weight: bold">a</span>&gt;
  &lt;/<span style="color: #008000; font-weight: bold">div</span>&gt;
&lt;/<span style="color: #008000; font-weight: bold">footer</span>&gt;


  
</pre></div>

<pre class="commentary__pre">


Prevents phones from "zooming out" to display a window/​viewport into the page.  This behavior is helpful for sites that are not optimized for mobile presentation, but isn't helpful for this site because it contains mobile-specific css styles



















These next several lines link to various favicon icons (the little icon that shows up in your tab on most modern browsers.  Many sites just link to 1 favicon, but that results in either sending much too large of an icon to all browsers (reducing page speed) on in sending an icon that isn't optimized the the relevant browser.  This code instead sends just the correct icon for each browser.  See <a class="link" href="https://realfavicongenerator.net/">realfavicon​generator.net/</a>, (which is also the site I used to generate these icons) for more details.


















This is the CSS style for the site.  A few notes:

First, some people would consider it poor practice to inline all the CSS as I have instead of linking to an external file with the css. Linking to an external file has several advantages that make it much more widely used:

<ul><li>It is more maintainable.  Different pages on the site can all link to the same css file, which means that changing formatting for a particular element only requires changing the single css file.  In contrast, if I want to change, say, the color of the navigation bar, then I have to change that piece of css in all my files.</li>

<li>It is typically faster for repeat visitors (or people who visit the site more than once). Once someone has downloaded the css for the first time, the css file will be cached locally, and they won't need to request it from the server.  This means that subsequent requests will be able to load the local resource, which is faster.</li>

<li>It allows resources to be downloaded in parallel. Modern browsers can download multiple files at the same time, which means that the browser can download something else while it is downloading the first css file (such as an image or other css file).  In contrast, with inline css, the browser won't start downloading any resources until it has fully downloaded and parsed the html file.</li>

So, given all those arguments, why did I decide to inline the css for this page?  A few reasons. First of all, most of those arguments only apply to this site very slightly (if at all).  This site is small enough that editing multiple files isn't much of a burden, and I'm prioritizing speed and simplicity so much that each page of this site fits into the initial 14kb TCP request--so my speed penalty for repeat visitors for inline css is minimal (at most ~20ms, even on very slow systems).

There are also a few advantages to inlining my css.  Most importantly, it reduces load time for first-time visitors.  You only get one chance to make a first impression, and I want this it to be a fast one. Inlining all css (and keeping the page size below 14kb) means that we can load the page in a single round-trip from the server--the fastest possible scenario. (This isn't true for pages that have images, but most of my pages don't, and even when they do it still reduces the number of requests.)

Inlining the css also has advantages for my project of making this site as simple as Feynman's radios. It lets me have a single source file that I can point to and say, "There it is.  That file has all you need to know to understand that page on the site".  And I appreciate that simplicity.

Second, the css is written with the BEM (Block-Element-Modifier) methodology. See getbem.com/ //TODO expand on this.
      </ul></pre>
    </div>
  

  <h3>Self-Sufficient Website</h3>

  <p class="content-p">[Coming soon]</p>

  <h3>Fast</h3>

  <p class="content-p">[Coming soon]</p>

</section>
