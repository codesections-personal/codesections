+++
title = "Let's try some pattern matching"
date = 2021-10-07
+++

Raku has _extremely_ strong support for pattern matching in function/method [signatures](https://docs.raku.org/type/Signature#Destructuring_arguments) – you can match on literals, types, names, or pretty much anything at all and can conveniently destructure the value you're matching on into a set of variables that fit your needs.

But Raku also has a second type of pattern matching (or at least something very much like pattern matching): the `~~` smartmatch powered by the [.ACCEPTS](https://docs.raku.org/routine/ACCEPTS) method.  This form of matching is also very convenient; is has a slightly different use case from matching on a signature, but it's no less powerful on the whole.  And, when it fits, it can be an even better/more lightweight solution to the same set of problems.  In fact, I'd bet that `when` (which is powered by this sort of matching) is one of the keywords that shows up most often in my Raku code.

#### The problem
Since these two forms of pattern matching are different, there are some problems that are easier to solve with signature matching and others that are easier to solve with smartmatching.  Fortunately, Raku makes it very easy to add smartmatching into a signature – you can easily smartmatch in a [where clause](https://docs.raku.org/type/Signature#index-entry-where_clause), for example.

I've typically found going the other direction a bit more cumbersome, however.  Consider the following code:
<!-- more -->

```raku
for (:add(1, 5), :sub(9, 8), :mult(7, 7)) {
    when .key eq 'add' { 
        say "{.value[0]} + {.value[1]} is {sum .value}" }
}
```
Smartmatching _works_ here, but it's not nearly as elegant as signature matching would be.  In particular, it doesn't let you easily destructure during the match, so we need to keep working with `:add(1, 5)` an a Pair instead of breaking it down into separate variables.  (This issue has been [discussed on Stack Overflow](https://stackoverflow.com/questions/66233465/haskell-like-pattern-matching-in-raku) in the past.)

#### Bringing out the heavy guns

Of course, you can use full signature matching here if you'd like to.  That would look something like this:

```raku
for (:add(1, 5), :sub(9, 8), :mult(7, 7)) {
    multi match(:add($) ($a, $b)) { say "$a + $b is {$a+$b}" }
    multi match(|) {}
    match |$_
}
```

That works, but I typically find it to be a bit heavy-weight, syntax wise.  It might be worth it if I'm matching against a large number of cases.  Part of what makes defining an extra multi a bit annoying is the need for the default `match(|) {}` case (to prevent errors when there's no match).  So matching against a lot of cases spreads the cost of that default `multi` out.  And, of course, if you _intend_ to ensure that the match is exhaustive, then you don't need the default `multi` at all – and any error you get are a feature.

But still, I've found that sort of pattern matching to be a bit more than I typically need (and there's something that bugs me about the need to give the function a name when it's used just this once).  So I stick with smartmatch-based `when` blocks most of the time, and save `multi`s for when I need a function for something other than pattern matching. 

#### A new approach

Earlier today, though, I decided to [try](https://docs.raku.org/language/exceptions#try_blocks) out a new approach: 

```raku
for (:add(1, 5), :sub(9, 8), :mult(7, 7)) {
    try -> :add($) ($a, $b) { say "$a + $b is {$a+$b}" }(|$_)
}
```

Even though I've just discovered this pattern, I'll say that my first impressions are pretty positive.  

That's not to say that I like _everything_ about this approach.  For one thing, using `try` like this is looks suspiciously like [using exceptions for control flow](https://softwareengineering.stackexchange.com/questions/189222/are-exceptions-as-control-flow-considered-a-serious-antipattern-if-so-why), generally a pretty bad idea.  It's not actually doing so, and I have no problems with lines like `(try some-fn) // $default)`, so this flaw doesn't put me off that much.

More seriously, I'm a bit worried that the need for the `(|$_)` could make this form slightly brittle.  In particular, I'm concerned about code blocks like the following pseudocode:

```raku
given $some-val {
   try -> $main-val { ... }(|$_);
   try -> $main-val, :$common-option { ... }(|$_);
   try -> $main-val, :$rare-option { ... };
   try -> $main-val, :$other-rare-option { ... }(|$_);
}
```

That would compile and run just fine, but the `:$rare-option` case will **never** get selected, due to the (buggy) omission of the `(|$_)`.  This sort of silent error is one of the most dangerous, especially since it's exactly the sort that a good-but-not-great set of tests might miss.  This is my biggest concern with the pattern I'm describing, and I plan to keep an eye out for it as I experiment some more with this approach.  I'm considering limiting the use of this sort of pattern matching to expressions that can fit on one line per case, which would make spotting the "missing `(|$_)` bug a lot easier.

I'll put a final "drawback" to this approach in quotes, since it's less of a problem than a difference: unlike `when` the `try`-based expression obviously doesn't cause the current block to return, and thus doesn't prevent the rest of the block from executing.  That's not really good or bad, but it is something to keep in mind.

So, after having just spent four paragraphs on why this approach to pattern matching isn't perfect, why am I still so excited to have stumbled into it earlier today?  Well, because it gives a concise and readable solution to a problem that's pretty common.

In terms of readability, the basic structure is `try -> $PATTERN { $ACTION-IF-MATCH}(|$_)`.  That's pretty much a plain-English description of what I want to do; I'm not sure I could improve on it in clarity of concision if I tried.   Working with Raku signatures for pattern matching is _really nice_ – after all, there's a reason that [Cro](https://cro.services/) makes signatures a key part of its API.

And, as I said, this fills a need.  The other day, I mentioned the old-but-still interesting blog post [A Review Of Raku](https://www.evanmiller.org/a-review-of-perl-6.html), and one of the (fairly few) issues that author had with Raku's syntax is the lack of pattern matching in `supply`/`react` blocks.

I've been writing some concurrent Raku this past week (more on that _very_ soon!) and I've got to say that I see that point.  It seems to be a [pretty common idiom](https://github.com/shuppet/raku-api-discord/blob/363102830ecef0fa93a82d2490277a9bd1375af1/lib/API/Discord/Connection.pm6#L95-L106) to have a `whenever` block that contains multiple `when` blocks, which means you really lean on the smartmatching properties of `when`. 

(This is even more true than I thought a few days ago – despite the similar names, `whenever` really does _not_ play a role that's analogous to `when`; it's much more like `for`, as I [learned recently](https://stackoverflow.com/questions/69475222/changing-the-target-of-a-whenever-block-from-the-inside).  This means that, like with `for`, you may very well want a `when` in `whenever`.)

When `when` is can match on the _type_ of the message it receives as it did in the code I linked above, the smartmatch semantics work beautifully.  But when you're sending untyped messages, adding destructuring to the mix is a _very_ welcome addition.

---

I'll leave it there, even though there's a lot of other options we could explore (including smartmatching against `signatures`, which are kind of like signature pattern-matching without binding).  But, rather than go into any of those details myself, I'll instead ask all of you:  What ways to pattern match do you particularly like in Raku?  I know there's more than one way to do it, so I'd love to hear your way.

Oh, and I'll close by showing the `try`-based pattern match one more time, this time with [formal named parameters](https://docs.raku.org/language/variables#The_:_twigil).  It really can be a pretty syntax in the right use case!

```raku
for (:add(1, 5), :sub(9, 8), :mult(7, 7)) {
    try { say "$:add[0] + $add[1] is $add.sum()"}(|$_)
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIxMzE5MDc5MjJdfQ==
-->