+++
title = "Raku's surprisingly good Lisp impression"
date = 2021-09-22
+++

Lisp[^1] is famous for having pretty much no syntax.  [Structure and Interpretation of Computer Programs](https://en.wikipedia.org/wiki/Structure_and_Interpretation_of_Computer_Programs) – arguably the most well known intro to programming in Lisp – presents pretty much the entirety of the syntax [in its first hour](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/1a-overview-and-introduction-to-lisp/).  And that's by no means the only thing SICP does in that hour.

Raku, on the other hand, has a bit more syntax.

Ok, that's an understatement.  Raku is syntactically maximalist to exactly the same degree that Lisps are syntactically minimalist.  Forget “[syntax that fits on a postcard](https://richardeng.medium.com/syntax-on-a-post-card-cb6d85fabf88)”; Raku's syntax struggles to [fit on an A4 sheet of paper](https://raw.githubusercontent.com/Raku/mu/master/docs/Perl6/Cheatsheet/cheatsheet.txt).  Raku has the type of syntactic riches that inspire Rakoons to classify its operators into beautiful (though now sadly dated) [Periodic Tables](http://www.ozonehouse.com/mark/periodic/).

<!-- more -->

I'm not saying that Raku has _too much_ syntax; I think it has an amount perfectly suited to its design goals.  Raku embraces the power of syntax; it's learned from natural languages that the ability to chose between different ways of articulating the same basic thought gives languages expressive power – and no small amount of beauty.  Raku's syntactic profusion is a big driver of its flexibility: Raku [has been described as](https://www.evanmiller.org/a-review-of-perl-6.html) “multi-paradigm, maybe omni-paradigm”, and its syntax sure helps make it so.

And, though I don't make a secret of how powerful I find Raku's maximalist approach, I also wouldn't say that Lisps have _too little_ syntax.  There's something wonderful about working through [The Little Schemer](https://mitpress.mit.edu/books/little-schemer-fourth-edition) and [growing a language](https://archive.org/details/GrowingALanguageByGuySteeleAhvzDzKdB0) one step at a time.  More practically, starting from a minimal base makes the practice of building your own language on top – aka, [Language Oriented Programming](https://beautifulracket.com/appendix/why-lop-why-racket.html) – all the more tractable. 

So I'm not really arguing for Lisp's syntactic minimalism or for Raku's maximalism.  I'm just pointing out that they're _very_ different aesthetics.  If there's a spectrum, Lisp and Raku are on pretty much opposite sides of it. 

---
And yet.

And yet it's possible to write Raku in a style that looks tremendously like Lisp – much more like Lisp than most languages could manage.  To see what I mean, lets start with some especially Lispy code.  Here's a toy program (pulled from the [Racket docs](https://docs.racket-lang.org/reference/let.html#%28form._%28%28lib._racket%2Fprivate%2Fletstx-scheme..rkt%29._letrec%29%29)) that recursively calculates whether a positive integer is odd.

```scheme
(letrec ([is-even? (lambda (n)
                       (or (zero? n)
                           (is-odd? (sub1 n))))]
         [is-odd? (lambda (n)
                      (and (not (zero? n))
                           (is-even? (sub1 n))))])
    (is-odd? 11))
#t
```

What makes this code so distinctively Lispy?  Lets count:
1. mutually recursive definitions – we use `letrec` to define `is-even?` in terms of `is-odd?`, and also to define `is-odd?` in terms of `is-even?`; neither can be completely defined without the other.
2. Prefix precedence – even operations (like subtraction or `and`) that would involve infix operators in other languages are done with prefix function calls.
3. Recursion all the way down – this code never defines "even" with anything as simple as "is divisible by 2"; it just walks our `n` down to 0, and then resolves the nested recursion to get an answer.
4. [Semantic indentation](https://metaredux.com/posts/2020/12/06/semantic-clojure-formatting.html) – lines aren't indented by a fixed amount (like 4 spaces per block), but rather are indented to line up in semantically meaningful way with the line above.
5. Last but not least, parentheses.  So many parentheses.  (Admittedly, in Racket some of them are square, but that doesn't actually matter; `[…]` is interchangeable with `(…)`.)

So, let's see how Raku looks if it embraces that style.  This is about matching the aesthetic, so we're not interested in nearly built-in "solutions" like `11 !%% 2`.   Just to have everything together, here's the Lisp again:

```scheme
(letrec ([is-even? (lambda (n)
                       (or (zero? n)
                           (is-odd? (sub1 n))))]
         [is-odd? (lambda (n)
                      (and (not (zero? n))
                           (is-even? (sub1 n))))])
    (is-odd? 11))
#t
```

And here's the Raku:

```raku
(sub (:&is-even = (sub (\n)
                    {([or] ([==] 0, n),
                           (is-odd (pred n:)))}),
      :&is-odd =  (sub (\n)
                    {([and] (not ([==] 0, n)),
                            (is-even (pred n:)))}))
   {is-odd 11})()
# returns «True»
```

Now, I'm not sure about you, but to _my_ eyes, that code looks quite a bit more like Lisp than like the Raku code I'm used to reading.  I don't want to get bogged down in **every** trick that code uses, but here are a few highlights, along with links for the curious.

* The `[…]` [reduction](https://docs.raku.org/language/operators#index-entry-[+]_(reduction_metaoperators)) operator pulls double duty, letting us call infix operators act as prefix ones.
* Similarly, `pred n:` uses [indirect invocation syntax](https://docs.raku.org/language/objects#index-entry-indirect_invocant_syntax) (the `:`) to call a method like a function – that is, in prefix position.
* Our stand-in for Lisp's `letrec` is that old standby, the [Immediately Invoked Function Expression](https://developer.mozilla.org/en-US/docs/Glossary/IIFE).  We combine the IFFE with Raku's ability to declare optional named arguments to effectively create scope-limited variables, exactly the power that Lisp's various `let` constructs typically provide.
* Many of the parentheses are optional, thrown in for fun.  But some of them are functional.  In Raku, you need to provide enough info to prevent ambiguity about which arguments go with which functions, but there's no rule that says you need to use the postfix `(…)` syntax to do so.  For example, say you want to call `f` with `1` and `2` and then call `say` with both `f`'s return value and `'foo'`.  To do that, most Rakoons would write `say f(1, 2), 'foo'`.  That works, unlike `say f 1, 2, 'foo'` – which ends up passing all three arguments to `f`.  But you're also free to place your parens the way a Lisper might: `say (f 1, 2), 'foo'`, which _also_ makes it clear which args go with which function.  (Or even `(say (f 1, 2), 'foo')`, if you just really love [the elegance of a good parenthesis](https://m.xkcd.com/297/).

#### So what?

Is the bottom line that Rakoons should all switch to Lisp syntax?  No, not at all.  In fact, by my own lights, I'd probably toss out the code above in favor of something like the below (assuming we want to keep the same recursive implementation):

```raku
sub (:&is-even = sub ($n) {$n == 0 or $n.pred.&is-odd  },
     :&is-odd =  sub ($n) {$n ≠ 0 and $n.pred.&is-even })
{ is-odd 11}()
```

This not only throws out many of the Lispy features we had above, it actually inverts some of them: `$n.pred.&is-odd` leans strongly into postfix notation.

And, in the end, that's exactly my point and exactly Raku's strength.  With a Lisp, you'll always have prefix notation, which lends your code predictability.  With Raku, you'll always have choices, which lends your code expressive power.  Do you want to say `is-odd $n.pred`, or `(pred $n:).&is-odd`, or `$n.pred.&is-odd`, or `(with $n {is-odd .pred})`, or something else altogether?  To the computer, they all mean the same thing, but each shifts the emphasis.  And, depending on what you want to say, a different choice might be a better fit.

Rakoons don't need to imitate the syntax of Lisp, APL, or C – even though the language is up to the task.  But it is helpful to remember that we have the option to embrace a wide variety of styles and to make a conscious choice about how to best express ourselves. 






[^1]: I’m using  “Lisp” broadly in this post, and am including the whole [Lisp family of languages](https://en.wikipedia.org/wiki/List_of_Lisp-family_programming_languages), from the most minimal of schemes all the way to the baroque majesty of Common Lisp.
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTY5NjI2NjkyNF19
-->