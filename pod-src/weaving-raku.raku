=begin pod
+++
=begin comment
The extra line breaks here are currently needed to prevent Pod from collapsing
the text into a single line, breaking the TOML formatting for zola frontmatter.
Once the S<…> block from S26 is implemented (https://design.raku.org/S26.html#Space-preserving_text)
we can/should switch to that. 
=end comment
title = "Weaving Raku: semiliterate programming in a beautiful language"

date = 2020-09-05T07:55:24-04:00

+++

The other day (er, ok, month) Brian Wisti wrote an excellent blog post about
L<tangling code using
Raku|https://randomgeekery.org/post/2020/07/tangling-code-from-hugo-content-with-raku/>.

<aside>

In case you're not familiar with it, the term "tangling" comes from the
L<literate programming|https://en.wikipedia.org/wiki/Literate_programming>
movement.  In literate programming, you write a single file containing B<both> source
code and extensive, narrative documentation and then process that file in two
ways: you I<weave> the file into documentation designed for human consumption
and you I<tangle> the file into code designed to be executed.  The idea is that
you can use this technique to write a program the way you'd write an essay (or a
blog post): explain your thoughts as you go, and carry the reader along your
thought process.</aside>

=head2 Inverse inspiration 

My first thought when reading that post was that I want exactly what it describes.  My
B<second> thought, however, is that I don't – I actually want the exact I<inverse> of what
the post describes.

Brian wants to start by writing documentation and then to tangle code out of that file and
into one or more executable programs.  In his example, Brian starts by writing a Markdown
file, and then processes it to produce multiple executable files in multiple programming
languages.

On the other hand, I want to start by writing some code – specifically, some Raku code –
and then to weave documentation out of that file.  Like Brian, I want to write one file
that both tells a story and produces machine-executable code; unlike Brian, I want to
start a bit closer to the code, and generate the documentation.

=head2 Wait, isn't that just Pod6?

At first, this could sound like I'm just describing Pod6, Raku's L<excellent tool for
writing and formatting documentation|https://docs.raku.org/language/pod>.  Using Pod6,
it's already easy to write clear, well-formatted documentation directly in-line with your
code.  And you can then L<render the
documentation|https://docs.raku.org/language/pod#Rendering_Pod> as Markdown, HTML, plain
text, or L<any other output format|https://modules.raku.org/search/?q=pod%3A%3Ato> you'd
like.  Isn't that exactly what I said I wanted?

Well, no, not exactly.  A Raku file with Pod blocks is cleanly divided into
I<documentation> (everything inside Pod blocks) and I<code> (everything outside Pod
blocks).  When you render output documentation, the code is ignored; when you run the
code, the documentation is ignored.

This works great for many typical Pod use cases, but it doesn't really let us do the sort
of thing Brian was talking about: we can't use Pod to write code and to I<display that
code as part of our documentation>.  That's a little abstract, so maybe an example is in
order.

<!-- more -->

Imagine you write a Raku file with Pod blocks and then generate a C<README.md>
from the file.  You'll probably put examples in Pod L<code
blocks|https://docs.raku.org/language/pod#Code_blocks>, and those examples will be nicely
formatted inside Markdown's C<```> code fences.  But – and this is the important bit –
those examples won't be run.  Conversely, the code that I<is> run won't appear in the
Markdown output at all.

This is often exactly what you want.  If the README has a few examples of how to use your
library, you wouldn't I<want> those examples to be executed.  And, with that sort of
README, you wouldn't want readers to be bothered with the executable code, which isn't
relevant to teaching them how to use the program's API.  If they want that level of
detail, then they can always turn to the source code itself.  So, for many READMEs, this
way of dividing code and documentation is a perfect fit.

The only problem is that it's not a good fit at all for the literate-programming-inspired
style we're going for here.  In this style, the idea is that you interweave the actual,
executed code with documentation; the reader reads both the code I<and> the documentation
with the goal of understanding how the program works (not just how to use it).  If you
wanted to use Pod to write documentation in this sort of style, you'd need to write every
line of code I<twice>: once to be formatted for the reader, and once to be executed.
(And, of course, you'd then face the hassle of keeping those versions in sync).

Put more concisely: Pod works great for writing documentation I<about> a program, but it
doesn't support writing documentation that I<is> a program.

At least not until now.

=head2 Weaving Markdown documentation from Raku

So, let's fix that.  Let's write a Raku program that processes Raku source code and
produces Markdown output drawn from both the Pod documentation in the file and the code
itself (nicely formatted).  And let's do so in the very blog post you're reading.

Since we're going to be working with Pod and generating Markdown, lets start by C<use>ing
a couple of relevant modules:
=end pod
use Pod::Load;
use Pod::To::Markdown;

=begin pod
Next, we'll want to be able to parse our source file.  Let's build a
L<grammar|https://docs.raku.org/language/grammars>!
=end pod
grammar Weave {
=begin pod
But what should our grammar do?  Well, at the most basic level, we need to be able to
parse our file into C<pod> and C<code>. So, our grammar's top level is
=end pod
    token TOP { [ <pod> | <code> ]* }

=begin pod
Then it's pretty simple to define pod blocks: anything between a C<=begin $block-name>
statement and the C<=end> statement for the same block-name.
=end pod
    token pod  { ^^  '=begin' <.ws> (\w+)
                 .*? '=end'   <.ws> $0 \N* \n}
=begin pod
And C<code> is similarly easy: it's just one or more lines that don't start with C<=>
=end pod
    token code { [ ^^ <![=]> \N* \n]+ }
}
=begin pod
<aside>

This won't work for I<maximally> perverse input.  For example, someone could use
a L<heredoc|https://docs.raku.org/language/quoting#Heredocs:_:to> to start a
line with C<=> without beginning a pod block.  But we're going for a
proof-of-concept here, so not handling obscure edge cases seems fine.
</aside>

Now that we have a grammar, what's next?  Well, we should set up a CLI interface
that accepts a parameter indicating whether we should tangle the file (that is,
produce just the code) or weave it (produce the documentation).  Our CLI should
also expect the name of the file we'll be processing and provide the user with a
helpful usage message.  Fortunately, Raku makes this L<absurdly
easy|https://docs.raku.org/language/create-cli>:

=end pod

#| Weave Markdown documentation from Raku code
sub MAIN($file,
         Bool :t(:$tangle),
         #= Tangle the file instead of weaving it (the default)
    ) {
=begin pod

There, sorted.  If a user runs our program without any arguments, they'll get a
usage message that looks like this:

=begin code :lang<sh>
Usage:
  pod-weave [-t|--tangle] <file> -- Weave Markdown documentation from Raku code
  
    -t|--tangle    Tangle the file instead of weaving it (the default)
=end code

Now that we have our CLI set up, it's time to parse our file.
=end pod
    my $parsed-input = Weave.parsefile($file.IO);
=begin pod

After parsing, we iterate through the captures we received and transform each as
needed, depending on whether we're weaving or tangling.  Let's start with tangling,
because it's trivial: We throw away the C<pod> blocks, keep the C<code> blocks, and print
everything as a single string.  

=end pod

    when $tangle {
        $parsed-input.caps.map({
            when .key eq 'pod'  { '' }
            when .key eq 'code' { ~.value }
        }).join.print
    };
=begin pod

Our processing for weaving is almost as trivial.  Here, we keep the C<pod>
blocks and wrap our C<code> blocks inside Pod's C<code> blocks.  When we do so,
we can also specify the language for syntax highlighting. 

=end pod
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
=begin pod

Printing the output of our weave is also easy, thanks to the two modules we're
using.  All we need to do is to join them into a single string, parse that as a
Pod block (using a function from the C<Pod::Load> module), turn the
Pod into Markdown (using the I<other> module we imported, C<Pod::To::Markdown>)
and print the Markdown.

=end pod
        ==> load()
        ==> pod2markdown()
        ==> print()
    };
}

=begin pod

All done, and in well under 40 lines of code – in fact, L<these 38 lines of
code|pod-weave.txt>, the output of C<pod-weave --tangle>.

=head2 Done? We barely started

I'm tempted to end the same way L<Brian did|
https://randomgeekery.org/post/2020/07/tangling-code-from-hugo-content-with-raku/#done-you-barely-started>:
by noting that this is just a proof-of-concept/good start.  In particular, it's missing
the ability to present code in a different order from the one in which it's executed.
Many fans of literate programming would consider this failure tantamount to missing the
point entirely.  And the proof of concept we built in this blog post doesn't even try to
handle multiple programming languages, another key advantage according to literate
programming partisans.

But here's the secret: I'm not B<really> interested in literate programming.  I'm not
interested in having every program I write be one that can be read as an essay.  Literate
programming may be great for I<explaining> code, even for clarifying your thoughts about a
problem.  But there's a reason it never spread that widely and, 9 times out of 10, I'd
rather have tight, concise, readable source.  For code I'm actually deploying and
maintaining, I'd rather have the tangled code than the woven essay.

What I am interested in, as this post's title might have given away, is B<semiliterate>
programming.  I'm interested in writing blog posts about code – something the Raku
community has L<excelled|https://raku-advent.blog/> at L<for|
https://perl6advent.wordpress.com/> a L<very|
http://blogs.perl.org/users/damian_conway/2019/09/to-compute-a-constant-of-calculusa-treatise-on-multiple-ways.html>
long L<time|https://perl6advent.wordpress.com/2009/12/>.  And when writing a blog post
about programming, you don't want fancy bells and whistles that make the code in your post
significantly different than the source code your readers will write.  You want (or, at
least, I<I> want) something almost exactly like what we have here: a simple way to write
about a program, nicely formatted, at the same time that you're writing the program
itself.

So, sure, our simple weaving implementation might not check all the boxes for truly
literate programming.  But, by keeping it simple and close to the actual source code,
we've written a tool that's perfect for blogging about Raku code.

=head2 Announcing pod-weave and pod-tangle v0.0.1

And, in that spirit, I'm releasing the code for this post B<both> as woven documentation
B<and> as a set of distributions.  The woven documentation is, of course, the blog post
you're reading right now, which was built from L<Raku code available on GitHub|
https://github.com/codesections-personal/codesections/blob/master/pod-src/weaving-raku.raku>.
That code genuinely is valid Raku, and can genuinely run on itself to produce the
L<Markdown output|
https://github.com/codesections-personal/codesections/blob/master/content/blog/weaving-raku/index.md>
for the page you're reading.

However, that's not the code I plan to use, maintain, and develop going forward.  Instead,
I plan to maintain L<pod-weave|https://github.com/codesections/pod-weave> and
L<pod-tangle|https://github.com/codesections/pod-tangle/> instead.  These two CLIs are
extremely similar to the code from this blog post.  But they're more modular, easier to
install, and allow you to weave your output into Markdown, HTML, or plaintext.  In short,
they work better I<as programs> at the same time they don't work as well I<as explanations
of themselves>.

And that's the model I, as a semiliterate programmer, plan to follow: I'll use
C<pod-weave> to help build literate blog posts, building on the power of Pod.  And for my
regular Raku coding, I'll focus on keeping code clear, concise, and comprehensible.

=end pod
