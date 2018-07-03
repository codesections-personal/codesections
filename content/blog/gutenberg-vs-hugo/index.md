+++
title = "Gutenberg versus Hugo"
date = 2018-07-02
+++

I've recently decided to switch from the [Hugo](https://gohugo.io/) static
site generator(SSG) to the [Gutenberg](https://www.getgutenberg.io/) SSG.  I
think they're both great tools (I
[really love](https://www.codesections.com/blog/why-static-site-generators-are-great/)
[static site generators](https://www.codesections.com/blog/greatness-of-static-site-generators-ii/),
after all), and I'd be happy to recommend either one.  And, depending on your
use case, Hugo could be the better choice.  Nevertheless, I'm very happy that
I've made the switch to Gutenberg.

This post compares the two SSGs on five metrics: Speed, template syntax,
features, documentation/support, and hackability. 

## Speed

In some sense, this is the least important of the five metrics—both Hugo and
Gutenberg are fast.  Really fast.  So fast that, at least with small sites,
you'll likely never have a noticeable wait when using either program.

However, I'm still starting with speed because Hugo's tagline has always been
that it's "the world's fastest framework for building static sites", and I
really wanted to know if that's actually the case.  Hugo is constantly
bragging about it's speed, but Gutenberg is built in Rust which—at least to
hear the Rust partisans tell it—should give it a definite speed edge.  So,
who is the ultimate speed champion?

Well, it actually depends.  If you're generating a blog or other site 
**without** any code samples, then Gutenberg is the undisputed champion.  
When I ran a test on my blog with the most basic settings, Gutenberg built
the site in an average of 21.3 milliseconds, while Hugo took more than twice
as long, with a sluggish 54.5 milliseconds.  (See what I mean about both
being so fast that you'll never notice any difference?)

But, if I turn on syntax highlighting, Hugo edges to the lead again.
Syntax highlighting, you may recall, is what lets me have nicely colored
code samples like 

```html
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"
      lang="en" xmlns:fb="http://www.facebook.com/2008/fbml" >
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta http-equiv="content-type" content="text/html;charset=utf-8" />
  <script type="text/javascript">
(window.NREUM||(NREUM={})).loader_config={
  xpid:"UQ8EUVRACQAFVVdbAQk="
};
window.NREUM||(NREUM={})
,__nr_require=function(t,n,e){
  function r(e){if(!n[e]){var o=n[e]={exports:
    {}};t[e][0].call(o.exports,function(n){
      var o=t[e][1][n];return r(o||n)},o,o.exports)
    }return n[e].exports}if("function"==typeof __nr_require)
    return __nr_require;for(var o=0;o<e.length;o++)r(e[o]);
    return r}
```

without styling all those colors by hand.  That's an absolutely _key_ 
feature for me, or for any technical blog.  And (with the amount of
syntax highlighting I had before this post), it slowed Gutenberg down
to 95.1 ms, but only slowed Hugo down to 84.7 ms.  So, at least in my 
typical use case, Hugo's claim to be the fastest stands up—but just by a
whisker.

But there's a complicating factor: Gutenberg's syntax highlighting is not 
slower because it's poorly coded, it's slower because it's **better**, but
more about that when we get to the feature comparison. 

For now, I'll score this as a tie, and leave you with a full chart of my 
benchmark results.  

| Command | Mean [ms] | Min…Max [ms] |
|:---                                              |---:        |---:        |
| `gutenberg build` (without syntax highlighting)  | 21.3 ± 0.5 | 19.9…22.8  |
| `hugo` (without syntax highlighting)             | 54.5 ± 2.1 | 51.3…59.7  |
| `hugo` (with syntax highlighting)                | 84.7 ± 2.2 | 81.1…91.3  |
| `gutenberg build` (with syntax highlighting)     | 95.1 ± 5.0 | 90.3…109.2 |

Note that all of these benchmarks were taken with the
[Hyperfine](https://github.com/sharkdp/hyperfine) benchmarking tool, and
thus represent the average of multiple test runs.  Also note, of course, 
that these results are specific to both my site and my computer.  In
particular, my site currently has
[a lot](https://www.codesections.com/projects/codesections-website/) of
syntax highlighting, so it's entirely possible that Gutenberg might eek out
a win on a site with less syntax highlighting.

## Template Syntax

Hugo's syntax was one of it's major pain points for me, and Gutenberg's is a 
big improvement.  Apparently I'm not alone: frustration with Hugo's template
language is one of the [main reasons that Gutenberg was built in the first
place](https://vincent.is/announcing-gutenberg/).

The issue here is that Hugo relies on the Go templating syntax, which means 
it relies on numerous conventions that may be second-nature to someone coding
in Go every day, but that are pretty foreign to the rest of us. Conversely,
even though Gutenberg is written in Rust, it doesn't try to implement a 
Rust-specific template syntax.  Instead, it uses
[Tera](https://tera.netlify.com/).  As the Tera website says, "Used to Jinja2,
Django templates, Liquid or Twig? You will feel right at home"; Tera is
essentially a re-implementation of several popular and battle-tested 
templating languages.  As noted, this includes Liquid, which is the same 
templating language used by Jekyll, another static site generator known for
the ease of it's templating system.  So, we should expect Gutenberg to have
a strong edge here.

But let's make this a bit more concrete.  

Here's a simple template from Gutenberg:

```Jinja2
{% extends "base.html" %}

{% block content %}
  <h2>{{ page.title }}</h2>
  {{ page.content | safe }}
{% endblock content %}
```

And here's the same thing in Hugo:
```go
{{ define "main" }}
  <h1>{{ .Title }}</h1>
  {{.Content}}
{{ end }}
```


