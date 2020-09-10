+++

title = "Weaving Raku: semiliterate programming in a beautiful language"

date = 2020-09-05T07:55:24-04:00

+++

The other day (er, ok, month) Brian Wisti wrote an excellent blog post about [tangling code using Raku](https://randomgeekery.org/post/2020/07/tangling-code-from-hugo-content-with-raku/).

<aside>

In case you're not familiar with it, the term "tangling" comes from the [literate programming](https://en.wikipedia.org/wiki/Literate_programming) movement. In literate programming, you write a single file containing **both** source code and extensive, narrative documentation and then process that file in two ways: you *weave* the file into documentation designed for human consumption and you *tangle* the file into code designed to be executed. The idea is that you can use this technique to write a program the way you'd write an essay (or a blog post): explain your thoughts as you go, and carry the reader along your thought process.</aside>

Inverse inspiration 
--------------------

My first thought when reading that post was that I want exactly what it describes. My **second** thought, however, is that I don't – I actually want the exact *inverse* of what the post describes.

Brian wants to start by writing documentation and then to tangle code out of that file and into one or more executable programs. In his example, Brian starts by writing a Markdown file, and then processes it to produce multiple executable files in multiple programming languages.

On the other hand, I want to start by writing some code – specifically, some Raku code – and then to weave documentation out of that file. Like Brian, I want to write one file that both tells a story and produces machine-executable code; unlike Brian, I want to start a bit closer to the code, and generate the documentation.

Wait, isn't that just Pod6?
---------------------------

At first, this could sound like I'm just describing Pod6, Raku's [excellent tool for writing and formatting documentation](https://docs.raku.org/language/pod). Using Pod6, it's already easy to write clear, well-formatted documentation directly in-line with your code. And you can then [render the documentation](https://docs.raku.org/language/pod#Rendering_Pod) as Markdown, HTML, plain text, or [any other output format](https://modules.raku.org/search/?q=pod%3A%3Ato) you'd like. Isn't that exactly what I said I wanted?

Well, no, not exactly. A Raku file with Pod blocks is cleanly divided into *documentation* (everything inside Pod blocks) and *code* (everything outside Pod blocks). When you render output documentation, the code is ignored; when you run the code, the documentation is ignored.

This works great for many typical Pod use cases, but it doesn't really let us do the sort of thing Brian was talking about: we can't use Pod to write code and to *display that code as part of our documentation*. That's a little abstract, so maybe an example is in order.

<!-- more -->

Imagine you write a Raku file with Pod blocks and then generate a `README.md` from the file. You'll probably put examples in Pod [code blocks](https://docs.raku.org/language/pod#Code_blocks), and those examples will be nicely formatted inside Markdown's ```` ``` ```` code fences. But – and this is the important bit – those examples won't be run. Conversely, the code that *is* run won't appear in the Markdown output at all.

This is often exactly what you want. If the README has a few examples of how to use your library, you wouldn't *want* those examples to be executed. And, with that sort of README, you wouldn't want readers to be bothered with the executable code, which isn't relevant to teaching them how to use the program's API. If they want that level of detail, then they can always turn to the source code itself. So, for many READMEs, this way of dividing code and documentation is a perfect fit.

The only problem is that it's not a good fit at all for the literate-programming-inspired style we're going for here. In this style, the idea is that you interweave the actual, executed code with documentation; the reader reads both the code *and* the documentation with the goal of understanding how the program works (not just how to use it). If you wanted to use Pod to write documentation in this sort of style, you'd need to write every line of code *twice*: once to be formatted for the reader, and once to be executed. (And, of course, you'd then face the hassle of keeping those versions in sync).

Put more concisely: Pod works great for writing documentation *about* a program, but it doesn't support writing documentation that *is* a program.

At least not until now.

Weaving Markdown documentation from Raku
----------------------------------------

So, let's fix that. Let's write a Raku program that processes Raku source code and produces Markdown output drawn from both the Pod documentation in the file and the code itself (nicely formatted). And let's do so in the very blog post you're reading.

Since we're going to be working with Pod and generating Markdown, lets start by `use`ing a couple of relevant modules:

```raku
use Pod::Load;
use Pod::To::Markdown;
```

Next, we'll want to be able to parse our source file. Let's build a [grammar](https://docs.raku.org/language/grammars)!

```raku
grammar Weave {
```

But what should our grammar do? Well, at the most basic level, we need to be able to parse our file into `pod` and `code`. So, our grammar's top level is

```raku
    token TOP { [ <pod> | <code> ]* }
```

Then it's pretty simple to define pod blocks: anything between a `=begin $block-name` statement and the `=end` statement for the same block-name.

```raku
    token pod  { ^^  '=begin' <.ws> (\w+)
                 .*? '=end'   <.ws> $0 \N* \n}
```

And `code` is similarly easy: it's just one or more lines that don't start with `=`

```raku
    token code { [ ^^ <![=]> \N* \n]+ }
}
```

<aside>

This won't work for *maximally* perverse input. For example, someone could use a [heredoc](https://docs.raku.org/language/quoting#Heredocs:_:to) to start a line with `=` without beginning a pod block. But we're going for a proof-of-concept here, so not handling obscure edge cases seems fine. </aside>

Now that we have a grammar, what's next? Well, we should set up a CLI interface that accepts a parameter indicating whether we should tangle the file (that is, produce just the code) or weave it (produce the documentation). Our CLI should also expect the name of the file we'll be processing and provide the user with a helpful usage message. Fortunately, Raku makes this [absurdly easy](https://docs.raku.org/language/create-cli):

```raku
#| Weave Markdown documentation from Raku code
sub MAIN($file,
         Bool :t(:$tangle),
         #= Tangle the file instead of weaving it (the default)
    ) {
```

There, sorted. If a user runs our program without any arguments, they'll get a usage message that looks like this:

```sh
Usage:
  pod-weave [-t|--tangle] <file> -- Weave Markdown documentation from Raku code

    -t|--tangle    Tangle the file instead of weaving it (the default)
```

Now that we have our CLI set up, it's time to parse our file.

```raku
    my $parsed-input = Weave.parsefile($file.IO);
```

After parsing, we iterate through the captures we received and transform each as needed, depending on whether we're weaving or tangling. Let's start with tangling, because it's trivial: We throw away the `pod` blocks, keep the `code` blocks, and print everything as a single string. 

```raku
    when $tangle {
        $parsed-input.caps.map({
            when .key eq 'pod'  { '' }
            when .key eq 'code' { ~.value }
        }).join.print
    };
```

Our processing for weaving is almost as trivial. Here, we keep the `pod` blocks and wrap our `code` blocks inside Pod's `code` blocks. When we do so, we can also specify the language for syntax highlighting. 

```raku
    when !$tangle {
        $parsed-input.caps.map({
            when .key eq 'pod'  { ~.value }
            when .key eq 'code' { qq:to/EOF/ }
                =begin pod 
                =begin code :lang<raku> 
                {.value}
                =end code
                =end pod
                EOF
        }).join("\n")
```

Printing the output of our weave is also easy, thanks to the two modules we're using. All we need to do is to join them into a single string, parse that as a Pod block (using a function from the `Pod::Load` module), turn the Pod into Markdown (using the *other* module we imported, `Pod::To::Markdown`) and print the Markdown.

```raku
        ==> load()
        ==> pod2markdown()
        ==> print()
    };
}
```

All done, and in well under 40 lines of code – in fact, [these 38 lines of code](pod-weave.txt), the output of `pod-weave --tangle`.

Done? We barely started
-----------------------

I'm tempted to end the same way [Brian did](https://randomgeekery.org/post/2020/07/tangling-code-from-hugo-content-with-raku/#done-you-barely-started): by noting that this is just a proof-of-concept/good start. In particular, it's missing the ability to present code in a different order from the one in which it's executed. Many fans of literate programming would consider this failure tantamount to missing the point entirely. And the proof of concept we built in this blog post doesn't even try to handle multiple programming languages, another key advantage according to literate programming partisans.

But here's the secret: I'm not **really** interested in literate programming. I'm not interested in having every program I write be one that can be read as an essay. Literate programming may be great for *explaining* code, even for clarifying your thoughts about a problem. But there's a reason it never spread that widely and, 9 times out of 10, I'd rather have tight, concise, readable source. For code I'm actually deploying and maintaining, I'd rather have the tangled code than the woven essay.

What I am interested in, as this post's title might have given away, is **semiliterate** programming. I'm interested in writing blog posts about code – something the Raku community has [excelled](https://raku-advent.blog/) at [for](https://perl6advent.wordpress.com/) a [very](http://blogs.perl.org/users/damian_conway/2019/09/to-compute-a-constant-of-calculusa-treatise-on-multiple-ways.html) long [time](https://perl6advent.wordpress.com/2009/12/). And when writing a blog post about programming, you don't want fancy bells and whistles that make the code in your post significantly different than the source code your readers will write. You want (or, at least, *I* want) something almost exactly like what we have here: a simple way to write about a program, nicely formatted, at the same time that you're writing the program itself.

So, sure, our simple weaving implementation might not check all the boxes for truly literate programming. But, by keeping it simple and close to the actual source code, we've written a tool that's perfect for blogging about Raku code.

Announcing pod-weave and pod-tangle v0.0.1
------------------------------------------

And, in that spirit, I'm releasing the code for this post **both** as woven documentation **and** as a set of distributions. The woven documentation is, of course, the blog post you're reading right now, which was built from [Raku code available on GitHub](https://github.com/codesections-personal/codesections/blob/master/pod-src/weaving-raku.raku). That code genuinely is valid Raku, and can genuinely run on itself to produce the [Markdown output](https://github.com/codesections-personal/codesections/blob/master/content/blog/weaving-raku/index.md) for the page you're reading.

However, that's not the code I plan to use, maintain, and develop going forward. Instead, I plan to maintain [pod-weave](https://github.com/codesections/pod-weave) and [pod-tangle](https://github.com/codesections/pod-tangle/) instead. These two CLIs are extremely similar to the code from this blog post. But they're more modular, easier to install, and allow you to weave your output into Markdown, HTML, or plaintext. In short, they work better *as programs* at the same time they don't work as well *as explanations of themselves*.

And that's the model I, as a semiliterate programmer, plan to follow: I'll use `pod-weave` to help build literate blog posts, building on the power of Pod. And for my regular Raku coding, I'll focus on keeping code clear, concise, and comprehensible.
