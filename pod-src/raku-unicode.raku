=begin pod
+++
=begin comment
The extra line breaks here are currently needed to prevent Pod from collapsing
the text into a single line, breaking the TOML formatting for zola frontmatter.
Once the S<…> block from S26 is implemented (https://design.raku.org/S26.html#Space-preserving_text)
we can/should switch to that. 
=end comment
title = "A deep dive into Raku's Unicode support"

date = 2020-09-18T07:55:24-04:00

+++

Yesterday, I got curious about a simple question that sent me down a bit of a rabbit
hole. But now I've emerged from the hole, and want to share what I've learned.  (Should
that be "share the rabbits I caught"?  I think I'll just drop this analogy before we end
up with any dead rabbits.)

This journey will take us deep into the internals of Raku, Rakudo, Not Quite Perl, and
even Moar.  But don't worry – this will still be relevant to our everyday use of Raku,
even if you (like me!) aren't in the habit of writing any NQP.

Here was the question: What's the cleanest way to match the alphabetic ASCII characters in
a Raku regex?  Simple enough, right?

My first thought was something like this:

=end pod

say ‘Raku's mascot: »ö«’ ~~ m:g/<[A..Za..z]>+/;
    # OUTPUT: «(｢Raku｣ ｢s｣ ｢mascot｣)»

=begin pod

And that works and is admirably concise.  But it suffers from (what I view as) a fatal
flaw: it looks I<exactly> like the code someone would write when they want to match all
alphabetic characters but forgot that they need to handle Unicode.  One rule I try to
stick with is that correct code shouldn't I<look> buggy; breaking that rule is a good way
to spend time "debugging" functional code.  If I did use the syntax above, I'd probably
feel the need to add an explanatory comment (or break it out into a named regex).

That's all pretty minor, but it got me curious.  So I decided to see what people thought
on the L<#raku IRC channel|https://raku.org/community/irc> – always a good source of
advice.  After some helpful comments, I wound up with this:

=end pod


say ‘Raku's mascot: »ö«’ ~~ m:g/[<:ASCII> & <.alpha>]+/;
    # OUTPUT: «(｢Raku｣ ｢s｣ ｢mascot｣)»

=begin pod

That's a whole lot better.  It's slightly longer, but much more explicit.

But – hang on! – what is that C«<:ASCII>» character class?  That's not in L<the
docs|https://docs.raku.org/language/regexes#Unicode_properties>!  Is it missing from the
documentation?  If so, I could add it – I've been trying to do my part with updating the
docs.

Well, no, it isn't missing.  Raku supports querying B<all> Unicode character properties,
and you can access a large number of them in a regex using the C<:property_name> syntax.

But I'm getting ahead of myself: this post is about the journey of figuring out the
answers to three questions:

1. What Unicode properties does Raku actually support? (spoiler: all of them, sort of)

2. How does Raku enable its Unicode support?

3. What additional power does this give us when writing Raku code?

So, how do we start?

<!-- more -->

=head2 Diving in with &uniprop

Well, that same section of the docs mentions L«C<&uniprop>|
https://docs.raku.org/routine/uniprop», so let's start there.

=end pod

say 'a'.uniprop('ASCII');
    # OUTPUT: «Basic Latin»

=begin pod

Ok, that's promising – and also a bit surprising.  The fact that C<'ASCII'> is a valid
argument to C<&uniprop> is a pretty good clue that we're on the right track, although at
this point I was expecting that we'd get something like C<True> instead of C<Basic Latin>.

Well, what's actually going on when with C<&uniprop>?  To L<the source code
|https://github.com/rakudo/rakudo/blob/master/src/core.c/Cool.pm6#L622>, Robin!

=head2 Cool::uniprop

Right off, we're confronted with a rather long hash declaration that I<looks> like it'll
end up solving our puzzle.

=begin code :lang<Raku>
my constant $prefs = nqp::hash(
    'AHex', 'B', 'ASCII_Hex_Digit', 'B', 'Age', 'S',
    'Alpha', 'B', 'Alphabetic', 'B', 'Bidi_C', 'B',
    'Bidi_Class', 'S', 'Bidi_Control', 'B', 'Bidi_M', 'B',
    #`(many more key-value pairs, in alphabetical order));
=end code

My first thought when seeing this code block was that it contained a full list of all the
Unicode properties that Raku supports.  That'd mean that Raku does I<not> support all
Unicode properties, just the few listed here – and, in that case, we probably ought to add
this list to the documentation.

But that turns out not to be right.  The clue is that this list does I<not> include
C<ASCII> – and we already know that C<ASCII> works.  That means that Rakudo can handle
items that aren't in that hash; things aren't quite as simple as they seemed at first.

Looking just below the hash declaration, we can figure out exactly what Rakudo is doing.
When a key isn't present in the hash, Rakudo hits this bit of code:

=begin code :lang<Raku>
nqp::stmts(
    (my $result := nqp::getuniprop_str($code,$prop)),
        nqp::if(
            nqp::istrue($result),
            nqp::stmts(
                nqp::bindkey($prefs, $propname, 'S'),
                $result), #`(else clause omitted)))
=end code

Even without any familiarity with NQP, it's pretty clear what that does: it calls
C<&getuniprop_str> and, if that returns a truthy value, updates the hash and returns the
value.  That means that the real work is being done in an NQP function.

=head2 Actually, nope

When we get to the relevant line of the L<NQP source code|
https://github.com/Raku/nqp/blob/master/src/vm/moar/QAST/QASTOperationsMAST.nqp#L2558>,
however, we find this:

=begin code :lang<Raku>
QAST::MASTOperations.add_core_moarop_mapping(
    'getuniprop_str', 'getuniprop_str'
);
=end code

This code basically punts on implementing C<&getuniprop_str>.

NQP says that, instead of doing anything to get Unicode properties, it'll just delegate to
the respective VMs and expect them to handle the actual lookup.  The line above is the
code for MoarVM, but the L<JavaScript
|https://github.com/Raku/nqp/blob/master/src/vm/js/Operations.nqp#L1896> and L<JVM
|https://github.com/Raku/nqp/blob/master/src/vm/jvm/runtime/org/raku/nqp/runtime/Ops.java#L7317-L7319>
virtual machines both delegate in similar ways (though, in the JVM's case, it's just a
stub – it looks like the relevant feature is Not Yet Implemented in the JVM runtime).

=head2 On to MoarVM

If you're a more experienced hacker – particularly if your experience includes hacking on
virtual machines written in C – you might be able to follow the trail a bit more easily.
Personally, however, my proficiency with C is hovering at about the "used C for the first
half of a CS course and worked through K&R" level, and the closest I've come to
implementing a VM was the L<Intcode computer| https://esolangs.org/wiki/Intcode> from last
year's Advent of Code challenge.

Fortunately for us, MoarVM is well documented, even if some of the documentation hasn't
been updated all that recently.  Grepping through the docs directory for "Unicode" quickly
gets us to MoarVM's L<initial Revelation
|https://github.com/MoarVM/MoarVM/blob/master/docs/reveal.md>.

<aside>

I would normally call this document MoarVM's release announcement, but the document
explicitly says "this is not a release announcement".  Ok, then.  The file name is
C<reveal.md>, so "Revelation" it is.  Anyway, that fits with Raku's theme of
L<Apocalypses, Synopses and Exegeses |https://design.raku.org/>.

</aside>

The Revelation tells us that MoarVM has

> B<Unicode strings>, designed with future NFG support in mind. The VM includes the Unicode
Character Database, meaning that character name and property lookups, case changing and so
forth can be supported without any external dependencies.

Oooh, "includes the Unicode Character Database"!  That sounds promising.  But, before we
run off to our Internet search engine of choice to find out what that is, let's try
grepping again, now with that as our search term.  Grepping for "Unicode Character
Database" brings us to
L«C<unicode_db.c>|https://github.com/MoarVM/MoarVM/blob/master/src/strings/unicode_db.c>».

You can read through that file if you'd like, but I'll warn you in advance that it's a bit
long.  Specifically, it's 115,540 lines long – so long that GitHub refuses to even display
it.

<aside>

I think it's a bit ridiculous that GitHub's web UI can't show large files.  Sure, it's
pretty big, but it's still just text, and when your UI is complicated enough that you
can't render text, it seems like you have a pretty serious problem.  This is I<especially>
annoying when the content in question is HTML, which has really terrific support for
L<streaming content| https://jakearchibald.com/2016/fun-hacks-faster-content/>, making it
easy for users to interact with the page while it's still loading.  It's pretty much
enough for me to conclude that we should all move to a L<simpler, faster, and lighter
weight| https://sourcehut.org/blog/2020-04-20-prioritizing-simplitity/> host for our
code.  But I digress.
</aside>

I'll save you the trouble of looking through that file: all you really need is the first
two lines, anyway:

=begin code :lang<C>
/*   DO NOT MODIFY THIS FILE!  YOU WILL LOSE YOUR CHANGES!
This file is generated by ucd2c.pl from the Unicode database.
=end code

(Although, if you I<do> have an easy way to browse/search large files, you might notice
the snippet C<{"ASCII", 6}>, which provide nice confirmation that we're closing in on our
goal.)

Let's follow the hint we were just given, and check out L«C<ucd2c.pl>|
https://github.com/MoarVM/MoarVM/blob/master/tools/ucd2c.pl».  Once again, the most
important info for us is in a leading comment rather than in any of the code:

=begin code :lang<perl>
# Before running, downloading UNIDATA.zip from
# http://www.unicode.org/Public/zipped/ and extract them
# into UNIDATA in the root of this repository.
=end code

Let's follow these direction – conveniently, we can even use the companion file
L«C<UCD-download.p6>| https://github.com/MoarVM/MoarVM/blob/master/tools/UCD-download.p6>»
to do so.  This gives us… well, quite a lot actually.  But, most importantly, (as revealed
by, once again, trusty old grep) it gives us a file called C<PropertyValueAliases.txt>
with the following line:

=begin code :lang<sh>
blk; ASCII                            ; Basic_Latin
=end code

This, though we may not quite realize it yet, is the end of the line: we now have looked
at everything we need to know to fully understand how Raku/Rakudo/MoarVM deal with Unicode
properties.

=head2 Backing up, and summing up

Ok, I<now> – now that we've found all the relevant files, and have all the pieces of the
puzzle – it's time for that Internet search I mentioned earlier.  Just what is the Unicode
Character Database that we've been downloading, and how does it fit in with Raku?

Well, it's (exhaustively) L<documented|
http://www.unicode.org/reports/tr44/#Introduction>, of course.  But here's the short
version: the Unicode Character Database is S<all of Unicode>.  The files we downloaded
include every character, every property, every script – everything about Unicode and how
all of it's categories relate to one another is now in that folder.  And the C<ucd2c.pl>
file does exactly what it's name suggests: it converts the UCD to a C file.  Specifically,
to the 100k+ line C<unicode_db.c> file we saw earlier.  And then, when you compile MoarVM,
that file gets compiled into a complete copy of the Unicode Character Database,
available right there at runtime.  Yep, MoarVM bundles I<all of Unicode>.

When I first realized this, I was pretty surprised.  To the best of my knowledge, no other
language embeds the UCD in its runtime.  Perl offers the UCD as L<a (core) module|
https://metacpan.org/pod/Unicode::UCD>; Rust has a L<(well-maintained) crate|
https://github.com/open-i18n/rust-unic>; most C, C++, and Java programs link against the
operating system's copy of the L<ICU library| http://site.icu-project.org/>.  Even Swift –
a language with a full runtime and which is well-known for its strong Unicode support – doesn't
embed the UCD in it's runtime (there was apparently a L<proposal to do so|
https://forums.swift.org/t/pitch-unicode-named-character-escape-sequence/18396/18> but as
far as I can tell it never went anywhere).

I'm not saying that I<no> other languages embed the Unicode Character Database in their
runtime – there are a lot of languages out there and I bet one of you can tell me about
one I don't know of – but it's definitely rare enough that I was pretty surprised when I
figured out what MoarVM was up to.  After giving the matter a bit more thought, though, I
realized that embedding the UCD has several large advantages:

1. It gives Raku code run-time access to all Unicode properties without any performance
penalty.  

2. It allows Raku code to encode, decode, and normalize Unicode I<extremely>
quickly.  This would be helpful for any language, but is absolutely essential for Raku,
because we normalize strings as soon as they're created – i.e., very frequently.

3. It ensures that a given version of Raku will always use the same version of Unicode.

<aside>

This last point might not seem like a big deal, but it's worth dwelling on because it
unlocks one of Raku's super powers: absolutely amazing strings.  I don't have space to go
into details now – if you're interested, you can check out jnthn's L<presentation |
https://jnthn.net/papers/2015-spw-nfg.pdf> or L<blog post|
https://6guts.wordpress.com/2015/04/12/this-week-unicode-normalization-many-rts/>; the
relevant docs (both L<for Raku|https://docs.raku.org/language/unicode> and L<for MoarVM|
https://github.com/MoarVM/MoarVM/blob/master/docs/strings.asciidoc>) are also worth a
read.  But the short version is that Raku is basically the B<only> language that actually
knows how long a string is.

For example, consider 🤦🏼‍♂️ .  Different languages will, L<rather famously|
https://hsivonen.fi/string-length/> report different lengths for that string.  Answers
include 20, 17, 14, 7, and 5.  Raku is, to my knowledge, alone in consistently reporting
that this string is 1 character long.

Swift B<almost> gets it right: it will I<often> report that the length of the string is
1.  But it sometimes fails, and that failure occurs precisely because Swift doesn't
bundle the UCD and thus doesn't always use the same version of Unicode.  You see, instead
of compiling in the UCD like Raku, Swift L<links against whatever version of ICU is
installed on the system| https://hsivonen.fi/string-length/>.  (ICU is the Unicode library
I mentioned a couple of paragraphs up as being used by many C, C++, and Java programs.)
But this means that Swift is entirely dependent on external update schedules for ICU and,
in many LTS Linux distros, "external update schedules" can be very slow – and Windows, of
course, is even worse.  The upshot of all of this is that the I<same> version of Swift can
report I<different> lengths for a string, depending on what external libraries happen to
be on the system. 

This might seem like a minor point.  "Oh, sometimes the length is off by one, how amusing,
maybe someone will make a L<WAT| https://www.destroyallsoftware.com/talks/wat> video about
it".  But it's actually a much bigger deal than that: knowing (sub) string length is a
prerequisite to being able to accurately index into a string, and uncertainty about
character length is a big reason many modern languages have given up on accurately
counting characters and have settled for counting "codepoints" instead.

There's a lot more we could say about how awesome Raku's strings are – we haven't even
mentioned Raku's innovative Normal Form Grapheme approach or the way it cleverly uses
L<ropes| https://en.wikipedia.org/wiki/Rope_(data_structure)> as part of its strings.  But
the point is, Raku's handling of strings absolutely I<depends> on getting Unicode right,
and bundling the UCD is what lets Raku guarantee that.

</aside>

After that long aside about Unicode versions and string lengths, I want to return to point
1 from the list above: including the UCD gives Raku code nearly-free runtime access to all
Unicode character properties.  But what are "all Unicode character properties"?  Well, a
lot – so many, in fact, that there doesn't seem to be a global list anywhere.

To start with, it lets you use C<&uniprop>, C<&uniprops>, and C<&unimatch> to query all of
the properties listed in Unicode's L<Property Index|
https://www.unicode.org/reports/tr44/#Property_Index>.  In the simplest case, this will
return a Boolean indicating whether the character had the property you asked about:

=end pod

say '—'.uniprop('Dash');    # OUTPUT: «True»
say '-¯—'.uniprops('Dash'); # OUTPUT: «(True, False, True)»
say '—'.unimatch('True', 'Dash'); # OUTPUT: «True»

=begin pod

Other properties return something more detailed information instead of a simple C<Bool>;

=end pod

say 'a'.uniprop('Block');          # OUTPUT: «Basic Latin»
say 'a'.unimatch('Basic Latin', 'Block'); # OUTPUT: «True»

say 'Ⅴ'.uniprop('Numeric_Value');         # OUTPUT: «5»
say 'Ⅴ'.unimatch('5', 'Numeric_Value');   # OUTPUT: «True»
say '±'.uniprop('Name');       # OUTPUT: «PLUS-MINUS SIGN» 


=begin pod

Note that, somewhat surprisingly, C<&unimatch> always returns a stringified version of the
return value, even when C<&uniprop> returns a numerical value.  Some of the more advanced
Unicode properties include C<Uppercase_Mapping> (helpful for addressing odd edge cases,
such as when multiple lower-case letters upper case to the same value) and
C<Bidi_Mirroring_Glyph>, which displays the matching pair, if any, for a given character:

=end pod

say 'a'.uniprop('Uppercase_Mapping');        # OUTPUT: «A»
say 'ςρσ'.comb.map({
    .unimatch('Σ', 'Uppercase_Mapping')
});                           # OUTPUT: «(True False True)»
say '('.uniprop('Bidi_Mirroring_Glyph');      # OUTPUT: «)»

=begin pod

Additionally, you can use any of the (many, many) L<Property Value Aliases|
https://www.unicode.org/Public/UCD/latest/ucd/PropertyValueAliases.txt> that Unicode
defines (mostly shorthands for accessing languages) – or, at least, you can I<sort of> use
them.  Specifically, you can call them, but MoarVM will only run the first item in the
query, not the whole thing.  For example, as we saw above, C<ASCII> should be an
abbreviation for checking that C<Block> equals C<Basic Latin>, but C<&uniprop> will only
run the C<Block> query.  Thus it will I<return> C<Basic Latin> rather than C<True>, as one
might expect.

I B<believe> that this is a bug in MoarVM, but I am not 100% positive – as I mentioned, I'm
not confident in my reading of MoarVM's C code.  If anyone is sure, please let me know!



=end pod

# Alias for Block; Basic Latin but runs Block
say 'f'.uniprop('ASCII'); # OUTPUT: «Basic Latin»
say 'Σ'.uniprop('ASCII'); # OUTPUT: «Greek and Coptic»
=begin pod
                          
With that, we have figured out quite a lot about how Raku handles Unicode.  The ability to
query the Unicode Character Database is a secret superpower for Raku, and helps us write
code that says what we mean, instead of what we B<almost> mean.

<aside>

If you're particularly observant, you may have noticed that this post ended with an
explanation of how C<'a'.uniprop('ASCII')> worked, even though it B<started> by asking
about something more like C«'a' ~~ /<:ASCII>/».  There's actually a reason for that
discrepancy: I started digging into C<&uniprop> on the assumption that C<Regex>es were
implemented by calling C<&uniprop> or C<&unimatch> under the hood.  But, when I got to the
bottom of this particular rabbit hole, I discovered that this isn't the case: a Regex
doesn't call C<&uniprop> at all.  I'm sure that Regexes are still querying the built-in
UCD, but they do so directly rather than by going through C<&uniprop>.

As a result, Regexes are subject to a somewhat different set of constraints than
C<&uniprop> is.  For instance, C«/<:ASCII>/» matches C<'a'> – even though, based on
C<&uniprop> we might have expected to need C«/<:ASCII('Basic Latin')>/».  On the other
hand, C«/<:Uppercase_Mapping('A')>/» does I<not> match C<'a'>, as we might have expected.
On yet a third hand, C«/<:Numeric_Value(5)>/» does match C<'Ⅴ'> (the Roman numeral 5).

I am honestly not yet entirely sure what the exact rules are – or even if these
distinctions are driven by design decisions or are a result of bugs.  And not being able
to figure that out has really been driving me crazy.  If and when I do, you can expect
another blog post from me on the topic.  In the meantime, the good news is that you can
call Raku code from inside a Regex, so you can always use C<&unimatch> if you need to.
For example, we could duplicate the Σ C<Uppercase_Mapping> example from above inside a
Regex with code such as C«'ςρσ' ~~ m:g/[. <?{ $/.Str.unimatch('Σ', 'Uppercase_Mapping') }>]/».
That's may not have quite the elegance that I expect from Raku, but definitely gets the job done.
</aside>

=end pod
