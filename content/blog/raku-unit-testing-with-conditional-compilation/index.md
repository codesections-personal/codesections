+++
title = "Raku testing and conditional compilation"
date = 2020-08-25T07:55:24-04:00
+++

I've been really falling in love with the [Raku](https://raku.org)
programming language – it's powerful, expressive, has great support
for introspection, strong pattern matching, and **extremely** good
support for metaprogramming.  I'm pretty much sold on using it for any
project where I don't need raw performance.  (When I do need raw
performance, I still reach for Rust).

That said, there are a few niceties and patterns I miss from Rust.
Fortunately, Raku is powerful enough to make nearly all of them
possible, usually with just a few lines of code.

Today, I'd like to talk about one example: Writing unit tests in the
same file as the code under test, without any runtime cost thanks to
conditional compilation.

<!-- more -->

## Organizing tests

Putting code and unit tests together in the same file is generally
_not_ standard procedure in Raku.  Instead, as explained in the [Test
docs](https://docs.raku.org/language/Testing), you typically put all
tests in a `/t` directory, and name each file with the same name as
the code under test – except with a `.t` extension instead of a
`.rakumod` or `.pm6` extension.  So, if you're testing the code in a
`fibonacci.pm6` file, you'd put the tests in `/t/fibonacci.t`.

This _works_, and if you prefer it, you should certainly feel free to
stick with that method.  It can be a clean way to organize your code,
especially if you tend to write longer modules (which can make the
module+test combination unmanageably large).

On the other hand, I really like [Rust's approach to organizing unit
tests](https://doc.rust-lang.org/stable/book/ch11-03-test-organization.html):
put each test in the same file as the code being tested.  This has a
few pretty large advantages:

 * It's easy to see what tests apply to a function/tell when something
   is untested.
 * Writing tests involves fewer context-switches.
 * Tests can access private functionality of the module under test
   ([opinions](https://stackoverflow.com/questions/105007/should-i-test-private-methods-or-only-public-ones) strongly
   [differ](https://henrikwarne.com/2014/02/09/unit-testing-private-methods/)
   about whether testing private methods/functions is good practice.
   But, in my experience, at least having the _option_ frequently
   helps write simpler code.)
   
## The typical downsides of tests in the same file

Given these advantages, why do so many languages default to organizing
their tests outside of the file/module/package/namespace containing
the code under test?  In short, performance.

In most interpreted languages (and more than a few compiled ones),
adding test code to the main file would have a significant run-time
cost.  Even if the test code isn't _executed_ at run time, it's still
present in the file; it still needs to be parsed before the program
can be run (or, for a compiled program, it still bloats the binary).

#### Rust's solution

How does Rust get around this?  As performance-focused as Rust is,
there's no way it would pay a runtime cost for its tests.  And,
indeed, it doesn't: it uses conditional compilation to compile test
code _only_ when running tests.  The standard way to write tests in
Rust looks like this:

```rust
#[cfg(test)]
mod test {
    use super::*;
    
    #[test]
    fn first_test() {}
}
```

In case you don't speak Rust, the `#[cfg(test)]` on the first line is
an attribute that tells the Rust compiler to _only_ compile the
following block when it's running a test.  If you compile that project
without passing the `test` argument, you'll get **exactly** the same
binary you would have gotten without writing a single line of test
code.  Rust achieves what it's always looking for: the zero-cost
abstraction.

#### Bringing this solution to Raku

Raku doesn't have conditional compilation in the same way Rust does
(at least not yet, anyway!).  But it _does_ have a sophisticated
notion of compile-time programming that's powerful enough to give us
the equivalent – though, as we'll see, it's _so_ powerful that we'll
have to be careful to get exactly what we want at the truly zero cost
that Rust provides.  

<aside>
The next few sections walk through my logic for
how we can bring this functionality to Raku, but the impatient can
<a href="#putting-it-all-together">skip to the bottom</a>.
</aside>

At the most basic level, how can we get started with compile-time
programming in Raku?  Well, we can begin with a
[`BEGIN` block](https://docs.raku.org/language/phasers#BEGIN) (or a
[`CHECK` block](https://docs.raku.org/language/phasers#CHECK)).
Both of these blocks execute code _only_ at compile time, with `BEGIN`
executing at the beginning of compile time, while `CHECK` executes at the
end.  So, imagine you have code like this:

```perl
CHECK { say 'compiling' }
say 'running';
```

If you invoke this file with `raku -c`, you'll compile it without
running it, and you'll get "compiling" as your output.  If you run
this file with `raku`, you'll both compile and run it, and you'll
get both "compiling" and "running" as output.

<aside>
Hold on, <strong>both</strong> compile and run?  Wasn't the whole point of doing
something at compile time to be able to <em>avoid</em> doing it at runtime?
So why are we compiling this file every time we run it?

Because we haven't created a module.  When you write a module, Rakudo
will compile it to bytecode, and will only recompile the bytecode if
the underlying source has changed.  However, when you don't write a
module, Rakudo will re-compile the source each time you run the
program.  We'll shift to using a module for this exact reason in a few
minutes.
</aside>


#### CHECK blocks aren't good enough

Using `CHECK` blocks, however, won't quite get us where we want to
be.  If you split this out into its own module, and compile it, you'll
notice that it does _not_ produce the same bytecode as the file
without the `CHECK` block.  That is, this code:


```perl
unit module Example;
say 'running';
```

and this code


```perl
unit module Example;
CHECK { say 'compiling' }
say 'running';
```

don't produce the same bytecode.  Specifically, the first version
produces only 24 KiB of bytecode, while the second produces 52 KiB.
For a long time, I couldn't figure out what caused this discrepancy –
but [Johnathan Worthington](https://jnthn.net/) was kind enough to
[explain it to
me](https://stackoverflow.com/questions/63598552/why-does-non-executed-compile-time-code-increase-rakus-byetcode-size-does-it-s/63599466):
Raku has the concept of _nested_ compile times and runtimes, which
means that the bytecode needs to include some output for the inner
compile time (even though it doesn't get executed in the run time we
really care about).

Now, this isn't really a big deal at all–as Johnathan also explained,
Rakudo is _very_ good at minimizing the cost of bytecode that's never
run.  But we're going for **zero** cost, so we'll need to do better.

#### Switching to DOC

The key to doing so lies in the [`DOC`
block](https://docs.raku.org/language/phasers#DOC_phasers) – the block
Raku provides to execute code when generating documentation.  Like the
`CHECK` and `BEGIN` phasers, `DOC` blocks aren't invoked during
runtime; unlike those blocks, `DOC` blocks avoid creating a nested
runtime inside the compile time.  With that in mind, let's update our
code:

```perl
unit module Example;
DOC CHECK { say 'compiling' }
say 'running';
```

Great, now we're back to the 24 KiB we'd have had without any compile
time code.

#### Using tests without `use test`

This _almost_ gets us to a perfect solution – but not quite.  If we
add a `use Test;` line to our code, we're right back to seeing our
bytecode size shoot up (this time, all the way to 88 KiB).  What's going on?

Once again, [Johnathan had the
answer](https://stackoverflow.com/questions/63598552/why-does-non-executed-compile-time-code-increase-rakus-byetcode-size-does-it-s/63599466):

> So far as use goes, its action is performed as soon as it is
> parsed. Being inside a DOC CHECK block does not suppress that - and
> in general can not, because the use might bring in things that need
> to be known in order to finish parsing the contents of that block.

Ok, so `use` statements are special and will add to our bytecode even
when they live inside a `DOC CHECK` block.  How can we fix that? Easy,
just don't use `use`.  Ok, next question: how can we test anything
without a `use Test` line?

We can take advantage of another Rakudo option, `-M`.  This flag
loads a module immediately before running the program – if we invoke
our module with `raku -MTest`, then we can call all test functions we
want without ever needing to `use Test`.

#### Compiler fight

So, we have our test code working perfectly, but Rakudo isn't at all
happy with our non-test code.  When we run our code without `-MTest`,
Rakudo complains that whatever Test functions we're using are
`Undeclared routine`s – even though they're inside `DOC CHECK` blocks
and won't get executed.  At this point in figuring this all out, I was
just about ready to swear at Rakudo: yes, the routine is undefined
_now_, but it won't be when you need to call it!  Grrrrr.

<aside>
I <strong>think</strong> this behavior is a bug – it really seems that
Rakudo shouldn't look for undefined symbols in blocks that it's not
allowed to execute at the moment.  But I'm not <em>quite</em> sure
enough to open an issue on the Rakudo repository.  I'd be very
interested in hearing other's thoughts, though.
</aside>

Fortunately for this blog post and my sanity, Raku offers us an easy
out: to use the `is` method from `Test`, we add a single line: `multi
is(|) { callsame }`.  This satisfies Rakudo with a placeholder `&is`
symbol for the times that we're _not_ loading `Test`, while still
letting us invoke the _actual_ `is` function when we have loaded
`Test`.  (If you haven't come across `callsame` or the cool things you
can do with it before, then [the relevant
docs](https://docs.raku.org/language/functions#Re-dispatching) are
well worth a read.)

## Putting it all together

Despite the length of this post, all of this results in just a few
lines of code.  Here's what testing a simple Fibonacci function would
look like:


```perl
# ./bin/fibonacci
use v6d;
use Fibonacci;

#| Print the first N Fibonacci numbers
sub MAIN(Int $N) { say fibonacci($N).join("\n") }
```

```perl
# ./lib/Fibonacci.pm6
use v6d;
unit module Fibonacci;

#| Return a list of the first $n Fibonacci numbers
sub fibonacci(Int $n --> List) is export { 
    state @fib = 1, 1, * + * … ∞;
    @fib[^$n]
} 

DOC CHECK { multi is-deeply(|) { callsame }
   fibonacci(1).&is-deeply((1,), 'Fibonacci of 1');
   fibonacci(5).&is-deeply((1,1,2,3,5), 'Fibonacci of 5');
}
```

With that code, you can test with `raku --doc -c -MTest
lib/Fibonacci`, which produces

```txt
ok 1 - Fibonacci of 1
ok 2 - Fibonacci of 2
Syntax OK
```

And you can run it with `raku -Ilib bin/fibonacci` which produces

```txt
Usage:
  bin/fibonacci <N> -- Print the first N Fibonacci numbers
```

(I still can't get over how easy Raku makes producing nice usage
output!).  Or, for actual output, with `raku -Ilib bin/fibonacci 5`:

```txt
1
1
2
3
5
```

And – perhaps best of all! – our byte code is only 40 KiB.  And that's
**exactly** the same size as if we'd omitted the tests entirely.  A
true zero cost abstraction, in a single line of code.

## Summing up

This may not be %100 seamless.  In particular, if your tests use a lot
of functions from `Test`, declaring the `multi`s could get annoying.
But, in a single line of code, we were able to build a powerful
feature and one I've been missing from Rust.  And _that's_ a small
taste of what I love so much about Raku.

If you have any thoughts about this post, especially including any
ways to make this even better, I'd love to hear them.  You can email
me, find me on the [#raku IRC
channel](https://raku.org/community/irc), or post to [this post's
thread on r/rakulang](https://www.reddit.com/r/rakulang/comments/ih8tc9/unit_testing_in_raku_with_conditional_compilation/?).
