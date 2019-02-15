+++
title = "Comparing Rust and JavaScript Ergonomics with a Simple Linked List"
date = 2019-01-06
+++

My day-to-day work involves writing a fair bit of JavaScript but, lately, I've gotten really interested in Rust.

I'm into the idea of building lightweight programs that can run with lower resource consumption than is typically required for a JS runtime, and Rust's speed, memory safety, and [status as the most loved programming language](https://insights.stackoverflow.com/survey/2018/#most-loved-dreaded-and-wanted) was enough to get my attention.  Add in Rust's strong type system and support for many functional-programming features—both areas I've long wanted to dig into—and it's fair to say that I'm Rust-curious at the least.  Curious enough to work through the [Rust book](https://doc.rust-lang.org/book/index.html) and the first half of [Rust By Example](https://doc.rust-lang.org/rust-by-example/index.html) (both of which are great, by the way!).  I'm certainly enjoying the process so far.

But, the other day, I decided to take a slightly different approach: I decided to take a simple linked list program—the type can and do ask my students to implement in JavaScript in ~20 minutes—and re-implement it in Rust.  Specifically, I decided to build a queue implemented with a singly linked list.

Going in, I expected the Rust version to be much more verbose than the JavaScript version, far faster, and moderately difficult to write.  As it turns out, though, the Rust version is hardly any more verbose than the JavaScript version, but was virtually impossible to write—at least in safe Rust.  (I was right about it being faster, though).

<!-- more -->

In this post, I provide a function-by-function comparison of the two very similar programs and discuss the trade offs inherent in Rust's syntax.  Along the way, we'll learn about _unsafe_ Rust, and I'll write my very first unsafe block.

## The Code

### Setup
In either language, our first task is to set up our overall data structure:

```js
// JavaScript
const LinkedList = function() {
  this.head = null;
  this.tail = null;
};
```

```rust
/// Rust
#[derive(Debug)]
pub struct LinkedList {
    head: Option<Box<Node>>,
    tail: Option<*mut Node>,

}
#[derive(Debug)]
struct Node {
    value: i32,
    next: Option<Box<Node>>,
}

impl LinkedList {
  pub fn new() -> Self {
    LinkedList {
        head: None,
        tail: None,
    }
```
In some ways, this is the biggest difference between the two programs—and the biggest difference between the two languages.  In JavaScript, all wee need to do is tell the interpreter that we're building a data structure that will have a "head" field and a "tail" field.  In Rust, however, we also need to specify the types of those fields—here, we tell the compiler that the head will *either* be `None` (no value at all) or will be a `Node` allocated on the heap.  Since `Node` is also a custom type, we also tell the complier that a `Node` will have a numerical value and another field—which, itself will be either `None` or another heap-allocated `Node`.

Finally, we also need to tell the complier how to build a new `LinkedList`—something that JavaScript already knows with the `new` keyword.

### Adding a node to our tail
Now that we have a data structure, it'd be great if we could add a node to the end of our queue.  Here's how that looks in both languages:

```js
//JavaScript
LinkedList.prototype.addToTail = function(value) {
  const newTail = { value, next: null };

  if (this.tail) {
    this.tail.next = newTail;
  } else {
    this.head = newTail;
  }
  this.tail = newTail;
};
```
```rust
// Rust
pub fn add_to_tail(&mut self, value: i32) {
    let mut new_tail = Box::new(Node { value, next: None });
    let raw_tail: *mut _ = &mut *new_tail;

    if self.tail.is_some() {
       	unsafe { (*self.tail.unwrap()).next = Some(new_tail) };
    } else {
        self.head = Some(new_tail);
    }
    self.tail = Some(raw_tail);
}
```
This code was probably the biggest shock of the whole exercise.  First, I was surprised by just how _similar_ it is.  In both languages, we create a new tail node with the input value.  If the linked list already had a tail, we make that tail point to the new tail; if it didn't have an old tail, we get our list started by having the head point to the tail.  Either way, we update the tail pointer for our list to point to the new tail.  Other than a bit of superficial syntax, the whole thing looks pretty much identical across the two languages.

… with one giant exception—that `unsafe` block right in the middle of the Rust code.  What in the world is up with that? Why do we need unsafe code in the middle of what seems like a simple data structure, and how can we trust our code at all once part of it is unsafe?

These sort of questions actually held me up for quite a while—I was convinced that there must be a simple, performant way to write a linked-list-based queue in Rust that *didn't* need to be unsafe—and, as a beginner Rustacean, I was frightened enough of `unsafe` code that I was reluctant to write any.

After banging my head against this wall for a bit, I finally found my way to [Learning Rust With Entirely Too Many Linked Lists](https://cglab.ca/~abeinges/blah/too-many-lists/book/README.html) which—as the name suggests—is provides rather comprehensive coverage of linked lists for the Rust novice.  There, I learned that my little toy queue wasn't quite as simple as I was thinking: instead of being in Chapter 1 or 2, this sort of queue didn't make an appearance until Chapter _6_ (the second-to-last chapter of the book).

What's more, according to that book, [there simply _isn't_ a good way to implement this structure in safe Rust](https://cglab.ca/~abeinges/blah/too-many-lists/book/fifth-layout.html).  The way to go is to venture into unsafe Rust.

Specifically, what we do in that code up above is to store a raw pointer—that is, a pointer without any of Rust's normal safety guarantees—as our `tail` field.  Then, when we need to get at the contents of the `tail`, we dereference the raw pointer—which is what requires that `unsafe` block.

But isn't that `unsafe` block well, you know, *unsafe*?  As it turns out, no, not at all.  Yeah, sure, dereferencing raw pointers *can* be unsafe—Rust has reason to limit the times in which you can do so.  If the contents that pointer points to aren't initialized or have been dropped, you can wind up with exactly the sort of error that Rust's memory safety protects us from.

So, why isn't that an issue here—why is this `unsafe` code actually perfectly safe?  Well, let's take another look at that `unsafe` block:

```rust
// Rust
if self.tail.is_some() {
    unsafe { (*self.tail.unwrap()).next = Some(new_tail) };
}
```
We dereference the raw point in self.tail—which means we need to worry about two situations: 1) if the pointed-to memory hasn't yet been initialized, and 2) if the pointed-to memory has already been freed.  Let's take those one at a time:

On 1), we know that we set up `self.tail` to start off as `None`—and we wrap our dereference inside an `if self.tail.is_some()` block.  Accordingly, if we correctly initialize the memory `self.tail` points to at the same time we change `self.tail` to be `Some`, then we don't need to worry about dereferencing `self.tail` too early.  And that's exactly what we do inside this function: we initialize the memory that `self.tail` points to right before getting it to point there.  So 1) is taken care of.

For 2), we have to handle the flip side: we have to ensure that we don't have a raw pointer left in `self.tail` _after_ we've thrown away the pointed-to value.  So let's turn to that function now.

### Removing the head node
```js
// JavaScript
LinkedList.prototype.removeHead = function() {
  const currentHead = this.head;
  const newHead = this.head.next;
  if (newHead === null) {
    this.tail = null;
  }
  this.head = newHead;
  return currentHead ? currentHead.value : null;
};
```
```rust
// Rust
pub fn remove_head(&mut self) -> Option<i32> {
    if let Some(head) = &mut self.head {
        let old_value = Some(head.value);
            let new_head = head.next.take();
            if new_head.is_none() {
                self.tail = None;
        };
        self.head = new_head;
        old_value
    } else {
        None
    }
}
```
Finally, we're getting somewhere where the Rust and JavaScript implementations don't look like straight copy-paste jobs.  Let's walk though the two implementations and then we'll circle back to how the Rust version protects us from memory-safety issues.

First, the JavaScript:  we're saving the current value of the `head` field, then updating that field to point to the next node in our list.  If there _isn't_ a next node, that means our list is now empty and so we point our `tail` field to `null` as well.  Finally, we return the value of our head node, which we get either with the `value` field of a head node or by directly returning `null` if there _isn't_ a head node.

The Rust code approaches the same problem slightly differently:  First, if there is a head node, then it stores the former value of that node, points `head` to the next node in the list and, if the new head is `None`, points `tail` to `None` as well.  Otherwise—if `head` was `None` to begin with, it just returns `None` without doing anything at all. 

Two paths to the same point but, to my eyes at least, neither is clearer or more expressive than the other.  _Maybe_ JavaScript ekes out a technical victory by having equally expressive code in a couple fewer lines, but it's not by much.

But what about the `unsafe` block—how does this function relate to it?  (And _why_ does it relate, given that we don't have any `unsafe` blocks here?)

Well, as we said above, we only get into trouble with that `unsafe` code if we don't deal with our `tail` pointer correctly when we deallocate the memory it's pointing to.  This is the function that does that deallocation, so we need to be sure to deal with `tail` correctly here.

Fortunately, we do: as soon as `new_head` is `None`, we set `tail` to equal `None` as well.  This guarantees that we won't have any memory safety issues with our raw pointer; our `unsafe` code is rendered safe after all.

### Checking inside our linked list

Now that we have the basic API for our linked list, lets get a way to see whats in it.  Not only will this make our API more complete, it will also make it easier to test our first couple of methods.

```js
// JavaScript
LinkedList.prototype.contains = function(target) {
  let node = this.head;
  while (node) {
    if (node.value === target) {
      return true;
    }
    node = node.next;
  }
  return false;
};
```
```rust
// Rust
pub fn contains(&mut self, target: i32) -> bool {
    let mut node = &self.head;
    while let Some(old_node) = node {
        match &mut node {
       	    Some(node) if node.value == target => return true,
       	    _ => (),
	}
	node = &old_node.next;
    }
    false
}
```
And now we're back to nearly identical code.  In both cases, the code stores the value of the head node in a variable and then checks the value of that node to see if it's equal to the `target` node.  If it is, the function returns early with true; if not, it goes on to check the next node.  If the function runs out of nodes to check, it returns false.  Two languages, but basically the same code. 

### testing and benchmarking

The "test" code is nearly identical—the only difference is that Rust has full support for test code that's excluded from the compiled binary whereas JavaScript would need a separate test framework (like Jest or Mocha) to get the same results.  I'm not going to display that code here, but it's part of the full code I'll link at the end.

In terms of actually _using_ the API for benchmark purposes, the two languages are again pretty similar: 

```js
// JavaScript
const list = new LinkedList();
for (let i = 0; i < 250000; i++) {
  list.addToTail(i);
}
console.log(list.contains(300000));
```
```rust
// Rust
let mut list = LinkedList::new();
for i in 0..250_000 {
    list.add_to_tail(i);
}
println!("{:?}", list.contains(300_000));
```
The only meaningful difference is that Rust uses a range (`0..250_000`), the way Python and many other languages do, instead of the C-style for loop favored by JavaScript.  Well, that and that Rust allows non-significant `_` characters in its numbers, which help break up long numbers.

Of course, the **other** difference was the speed at which these two loops executed.  Rust took about 15 milliseconds to build a linked list with 250,000 nodes and then to search that list for a node that didn't exist.  In contrast, Node took around 75 milliseconds for the same task.

## Takeaways, Surprises, and Conclusions

### Rust is pretty
Of course, you might feel differently, but one of my biggest takeaways from all of this side-by-side code is that Rust is clear, expressive, and not nearly as verbose as I was afraid it might be.  The overall Rust program was a bit longer than the JavaScript one, but much of that length came from setting up the type system—many of the individual functions were nearly even with their JS counterparts.

All in all, this exercise definitely left me impressed with Rust's eloquence.

### Unsafe Isn't Scary
I came into this exercise thinking that `unsafe` was something I wouldn't touch for months, if at all, in my Rust experience.  I was thinking that it was something people might need in building deep, low-level code but not something I'd need (or be prepared to deal with!) in day-to-day programming.  I thought it was the sort of code only applicable to projects that could afford to have their code audited by reliable outsiders.

This simple exercise changed those thoughts.  Here, we wrote a single line of unsafe code (OK, two lines counting the test) and were able to build an entirely safe program by guarding the values that can interact with that `unsafe` code.  Even better, we wrote our API in such a way that no user of our code could ever cause memory-safety errors with the code we provided. What's more, if we dove a bit more into Rust's privacy rules, we could probably write an entirely safe public API so that users of our linked list never needed to write a single `unsafe` line.

Yes, I'm still going to think of `unsafe` as a tool of last resort, but it's one that I'm going to study and going to keep in my tool belt—and sooner rather than later.

### Bonus Lesson: Manual Memory Management Means Stack Management
I expected Rust to blow JavaScript away in the benchmark, as it did.  One thing I _didn't_ expect was that I'd need to limit the benchmark linked list to ~250,000 nodes because lists longer than that triggered a stack overflow in the Rust code.  Coming from a JavaScript, I've gotten used to seeing stack overflows pretty much just with infinite recursion.  More specifically, in JS you get a stack overflow when you have too many function calls on the stack—but that's it.  If you don't push too many functions only the call stack, you're not going to overflow the stack.

So I was initially a bit flummoxed when I ran into a stack overflow with no recursion in sight.

But then I remembered: Of course! Rust is different—in Rust, you decide whether a variable is stack allocated or heap allocated; if I use too much stack memory, then I'll overflow the stack—and it makes no difference at all that we're in a single function invocation.

Since that wasn't the point of this exercise, I just scaled back the size of the linked list in the benchmark and went on with my day, but it's a good lesson to remember for the future.  (Incidentally, if any more experienced Rustaceans can tell me how I'd avoid a stack overflow with this code, I'd love to hear it.  And, no, putting the whole linked list in a `box` isn't enough to solve it.)

{% aside() %}
**Edit**: Thanks to [Sergey Bugaev](https://mastodon.technology/@bugaevc) for pointing out that the stack overflow was caused Rust attempting to _resursivly_ drop all of the nodes in the linked list when the list goes out of scope.  I really should have caught this, since the Too Many Linked List book [covered it](https://cglab.ca/~abeinges/blah/too-many-lists/book/first-drop.html)—and even called out that the default implementation would lead to a stack overflow.

Fortunately, the fix is simple: just write our own non-recursive `drop` method:
{% end %}

```rust
fn drop(&mut self) {
    let mut node = self.head.take();
    while let Some(mut next_node) = node {
        node = next_node.next.take()
    }
}
```
{% aside() %}

And, just like that, no more stack overflows!  A revised benchmark shows that the Rust code can generate, search, and drop a 10-million item list in ~440 ms (with `--release` optimizations on, of course); the equivalent number for JavaScript is 800 ms.

{% end %}

## Conclusion
So, I hope y'all enjoyed this blow-by-blow comparison of Rust and JavaScript—at least with regards to this one toy problem.  I know I learned a lot, and pretty much everything I learned made me more enthusiastic about continuing to my journey with Rust.

Full code is on GitHub:
[JavaScript](https://gist.github.com/codesections/117a984f733d8d1ee4c3612e0307ab10) code;
[Rust](https://gist.github.com/codesections/bef7f95973ea5bb2d0046ab99270928b) code.

If you have any comments or suggestions, I'd love to hear from you.  You can reach me on [Mastodon](https://fosstodon.org/@codesections) or via any of the contact methods listed on my [About](https://www.codesections.com/about#contact) page.

