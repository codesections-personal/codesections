+++
title = "If you want to label your code, consider Label-ing your code"
date = 2021-09-16
+++

When organizing a program of any size, you'll obviously need to break your code up into smaller chunks.  Often, it makes sense for these chunks to be factored out into their own functions – especially if they're good candidates for reuse.  But it's possible to take this urge to factor out [too far](https://overreacted.io/goodbye-clean-code/) and it's often a better call to leave the code inline.  Doing so makes it clear that the code isn't being reused anywhere else, and keeps your program's control flow more linear.

Indeed, [John Carmack](https://en.wikipedia.org/wiki/John_Carmack) wrote an influential [post](http://number-none.com/blow/john_carmack_on_inlined_code.html) a few years ago describing how he has shifted from a coding style that looked a lot like

```c
void MinorFunction1( void ) {…}
 
void MinorFunction2( void ) {…}
 
void MinorFunction3( void ) {…}
 
void MajorFunction( void ) {
        MinorFunction1();
        MinorFunction2();
        MinorFunction3();
}
```

to one that looks more like 

```c
void MajorFunction( void ) {
        // MinorFunction1
 
        // MinorFunction2
 
        // MinorFunction3
}
```
I'm not trying to argue that this style is _always_ better, but it is a good option to have.

When organizing my code like that, though, I don't tend to use `// MinorFunction1` comments.  Instead, I'm more likely to write a [Label](https://en.wikipedia.org/wiki/Label_(computer_science)), so it'd look more like `minor_function:`.  You might benefit from using  labels too, if your language includes them – and if it's at all a C/Algol family language, it probably does.  Labels are supported in at least [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/label), [C/C++](https://www.c-programming-simple-steps.com/goto-statement.html), [Perl](https://code-maven.com/slides/perl/labels), [golang](https://golang.org/ref/spec#Labeled_statements), and my own language of choice, [Raku](https://docs.raku.org/language/control#LABELs).
<!-- more -->
That long list might come as a bit of a surprise, given how rarely used labels are.  Backing up, what is a label, and why do so many programming languages have them?  Well, as you might figure, labels label code.  The original purpose (and still a valid use in some languages) is to label a specific location in your code as a target for a `goto`.  Given that `goto`s [aren't that common anymore](https://homepages.cwi.nl/~storm/teaching/reader/Dijkstra68.pdf) (and aren't even implemented in some of the languages listed above), nowadays labels are most frequently discussed as a way to [break out of nested loops](https://en.wikipedia.org/wiki/Label_(computer_science)#Javascript).

Now, I don't know about you, but if I ever have so many nested loops that I need to disambiguate between them with labels, I'd take that as a clear sign that I need to refactor that bit of code.  As a result, I pretty much never use labels for control flow, nor do I see them used for control flow in code I read.  So, for most coders, labels are a vestigial piece of syntax, taking up room in the language specification without really pulling their weight.

I'd rather put them to use: I use labels to label code, replacing comments like the ones in Carmack's sample above.  Here are few reasons I like labels better than comments:

### Comments are overworked
Comments have to play a bunch of different roles.  Sometimes they're commenting out code.  Sometimes they're explaining something tricky, or why you didn't take a seemingly obvious approach.  They might be a doc comment, a `// TODO`, or a `# FIXME`.  They might be pseudocode for not-yet-implemented functionality, or might be a cross-reference to a lengthy discussion in a bug tracker.  They might even be a [joking-not-joking warning left long ago](https://stackoverflow.com/a/482129/10173009).

Without actually *reading* a comment in full, it's hard to know what role that comment has.  Slowing down to figure that out may not take much time or effort, but every bit of cognitive load we can avoid is a win.

And, because of the many roles we ask comments to play, people configure their editors to display them in all sorts of different ways.  Depending on your/your reader's editor setup, they might jump out with more importance than the rest of the code, or might be faded practically into the background.  (At least [one theme out there](https://www.benkuhn.net/syntax/) has a toggle to switch between these two ways of displaying comments, depending on whether you're working on "projects where the comments are not deceit and lies.")

In contrast, a label has exactly one function: it labels code.  And its form follows that function – it's nearly always displayed about like any other identifier.

### Labels play well with blocks

When you do have a chunk of code you'd like to label, there's a good chance that it makes sense to put it inside a block.  This lowers cognitive load on the reader, by clarifying that the code isn't creating variables that hang around for the duration of the function.  (Assuming you have access to block scope, of course – if you're stuck writing pre-ES6 JS, this doesn't apply to you (and my condolences)).  With a label, that's easy:

```javascript
fetch_user_data: {
   // something
}
```
but with comments, you'd need to spend a whole line on a `// line comment` or do something like
```javascript
/* fetch user data */ {
  // something
}
```
Not a huge change, but the `/*  */` adds an extra six characters of pure noise.  And that's especially annoying because…

### Comments are prose; labels are identifiers
If I were writing a comment, I'd pretty much never write `/* fetch user data */`.  And I _certainly_ wouldn't write `// fetchUserData` – if I saw that, my first thought would be that someone had commented out a function call. 

My comments tend to be a bit more descriptive: I generally agree with [those who say](https://github.com/rust-dev-tools/fmt-rfcs/blob/master/guide/guide.md#comments) that "comments should usually be complete sentences [that] start with a capital letter [and] end with a period".  So, if I were commenting code,	I'd probably write something like `/* Fetch the user data from the API server as JSON. */`. And once you get to that point, it starts to be significantly harder to scan.

Conversely, labels are basically [iffies](https://en.wikipedia.org/wiki/Immediately_invoked_function_expression) that don't take any arguments, so you name them in exactly the same style you use for functions.  (Well, almost, anyway.  I tend to put labels in `snake_case`, even when I'm writing in a language that typically uses `camelCase` (js) or `kebab-case` (Raku) for functions.  I personally find that the slight difference helps prevent me from ever pausing to wonder if the label might be a function or variable name.)

---
So, there you have it.  I like to label code with `label:`s.  It's a little thing, a detail really.

But, as they say, [software **is** details](https://gotopia.eu/2020/sessions/1449/software-is-details), and little choices add up quickly.  Next time you need to label a block of code, I encourage you to pause to consider whether a label would do the trick.
 

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwNTQ4MDUwNiwxOTI1NTM5MTY5LDE3MT
gwMjI4ODVdfQ==
-->