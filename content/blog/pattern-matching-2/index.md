+++
title = "Further thoughts on Raku pattern matching"
date = 2021-10-08
+++

Brains sure are funny things.  Or at least mine is; maybe I shouldn't speak for the rest of you.

Last night, I posted a few [thoughts on pattern matching in Raku](https://www.codesections.com/blog/try-some-pattern-matching/).  A bit later, I saw a [reply to that post](https://www.reddit.com/r/rakulang/comments/q3mn13/lets_try_some_pattern_matching_codesections/?) suggesting that it'd be nice to add better pattern matching syntax with a [Slang](https://docs.raku.org/language/variables#The_~_twigil).  I responded by saying that it probably wouldn't require a Slang, but that I'm not typically a fan of changing basic syntax purely for convenience (when Raku already gives us so much).

I didn't give the matter much more thought, at least consciously.  But my subconscious mind must have been noodling around with the idea because, somehow, I woke up this morning _absolutely convinced_ of three things.

1. A module should add support for better pattern matching.
2. It could do so with a regular `sub`, not a Slang or term.
3. Writing that `sub` would be easy.

And, for once at least, that all turned out to be true.  Here's the function I came up with:

<!-- more -->

```raku
sub match(*@fns where all .map: * ~~ Code) {
    my \topic = callframe(1).my<$_>;
    if @fns.first(*.cando: topic.List.Capture) -> &fn {
        fn(|topic)
    }
}
```

And here's that function in action:

```raku
# before
```raku
for (:add(1, 5), :sub(9, 8), :mult(7, 7)) {
    try -> :$add ($a, $b) { say "$a + $b is {$a+$b}" }(|$_)
}

# After
for (:add(1, 5), :sub(9, 8), :mult(7, 7)) {
    match -> :$add ($a, $b) { say "$a + $b is {$a+$b}" }
}
```

And, since `match` takes `*@fns` as a slurpy, it also lets you do this:

```raku
for (:add(1, 5), :sub(9, 8), :mult(7, 7)) {
    match -> :add($)  ($a, $b) { say "$a + $b is {$a+$b}" },
          -> :sub($)  ($a, $b) { say "$a - $b is {$a-$b}" },
          -> :mult($) ($a, $b) { say "$a × $b is {$a×$b}" } }
```

I haven't had my coffee yet, but I'm pretty sold on that as a function, at least in my own code.  After trying it out a bit (and reflecting a bit on it, post-coffee), I'll probably release that as a module – even though the idea of releasing a 6-line function as a "module" [pains me a bit](https://www.davidhaney.io/npm-left-pad-have-we-forgotten-how-to-program/), it seems like something that others could benefit from and an area where standardization wouldn't hurt.

But all of the above was based on waking up with some pretty odd convictions – so please feel free to tell me just how wrong you think I am!
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTM0OTY2OTFdfQ==
-->