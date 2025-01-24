+++
title = "Write clearer code by putting it in order"
date = 2023-10-31
draft = true
+++

Intro & About Me
================

Order matters
=============

Order matters in writing
------------------------

#### Emphasize first elements
She could never forgive deceit or treachery.
Deceit or treachery she could never forgive.

#### Keep subjects and verbs close together
A dog, if you fail to discipline him, becomes a household pest.
Unless disciplined, a dog becomes a household pest.

#### Keep relative pronouns near their antecedents 
There was a stir in the audience that suggested disapproval.
A stir that suggested disapproval swept the audience.

#### Group related phrases
He noticed a large stain in the rug that was right in the center.
He noticed a large stain right in the center of the rug.


"Green", I said.
I said "green".

"Green", that's the color we should paint the wall.
The color we should paint the wall is "Green".

Order matters in code
---------------------

### Zoom Out (outline level)
 - Grouping/splitting code into modules
 - Size of function
   - Tiny?
   - Large enough to be deep?
 - Order of function/variable definitions
 - Where to place documentation – inline, or separate?
 
### Zoom Medium (paragraph level)
 - What conditional structures to use
     - prefix-if postfix-if, ternary
 - order of conditions
 - placement of error checking/error handling
 - Use of early return

### Small details (sentence level)
 - Expression level
   - order of terms within an expression
   - specifically: order of `&fn` and 1+ args
 
Order across programming languages
==================================

Examples: 
 * Lisp      (function, argument, argument)
 ```clojure
 ;; Clojure
 (split "The quick brown fox" #" ")
 ;; ["The" "quick" "brown" "fox"]
 ```

 ```elisp
 ;; Emacs Lisp
 (split-string "The quick brown fox" " ")
 ;; ("The" "quick" "brown" "fox")
 ```
 
 But wait!
 ```common-lisp
 ;; Common Lisp
 (str:split " " "The quick brown fox")
 ;; ("The" "quick" "brown" "fox")
 ```
 
 Smalltalk (argument function, argument)
 ```smalltalk
 ;; Pharo smalltalk 
 'The quick brown fox' splitOn: ' '
 ;;#('The' 'quick' 'brown' 'fox')
 ```

 ```ruby
 # Ruby
 "The quick brown fox".split(" ")
 # ["The" "quick" "brown" "fox"]
 ```

 * Fourth    (argument, argument, function)
 ```Factor
 "The quick brown fox" " " split .
 ; { "The" "quick" "brown" "fox"}
 ```
 * The mushy middle (???, but not up to you)
 ```javascript
 "The quick brown fox".split(" "); // like Smalltalk
 (42).toString;              // still like Smalltalk
 isNaN(42);                  //   now like Lisp?
 ```
 * Raku?
 
Order in Raku
=============

Unpacking our toolbox
---------------------

#### Fundamentals: Named arguments

```
unique @list, :&as, :&with;
unique @list, :&with, :&as;
unique :&with, @list, :&as;
unique :&as, @list, :&with;
unique :&as, :&with, @list;
unique :&with, :&as, @list;
```

Plus, good syntax for defining and using (no `my-fn(arg => $arg)`)


#### Method call
```
$invoccant.method: $arg;
```

#### Function call with method syntax

```
  $arg1.&subroutine: $arg2;
# subroutine $arg1,  $arg2;
```

#### Function call
```
subroutine $arg1, $arg2;
```

#### Indirect invocant method call
```
  method $invocant: $arg;
# $invocant.method: $arg;
```

#### Push single args to function
```
$arg ==> subroutine();
```

#### Push multiple args to function
```
$arg1, $arg2 ==> { subroutine |$_ }();
```

### Altogether now:

```
# arg fn arg
$invoccant.method: $arg;
$arg1.&subroutine: $arg2;

# fn arg arg
subroutine $arg1, $arg2;
method $invocant: $arg;

# arg+ fn
$arg ==> subroutine();
$arg1, $arg2 ==> { subroutine |$_ }();
```


```raku
elems permutations <function delimiter string>
# 6
```

```
# ① Function, delimiter, string (like Common Lisp)
split ‘ ’, ‘The quick brown fox’;
# ② Function, string, delimiter (like Clojure)
split ‘The quick brown fox’: ‘ ’;

# ③ String, function, delimiter (like Smalltalk)
‘The quick brown fox’.split: ‘ ’;
# ④ Delimiter, function, string
‘ ’.&split: ‘The quick brown fox’;

# ⑤ String, delimiter, function (like Fourth)
‘The quick brown fox’ R, ‘ ’ ==> {split(|$_)}();
# ⑥ Delimiter, string, function 
‘ ’, ‘The quick brown fox’   ==> {split(|$_)}();

```

Let's put ⑤ and ⑥ aside.

Why and how??
===========

* Function, delimiter, string
  - `split ‘ ’, ‘The quick brown fox’;`
  - "Split on every space in the string 'The quick brown fox'"
* Function, string, delimiter
  - `split ‘The quick brown fox’: ‘ ’;`
  - "Split the string 'The quick brown fox' on every space"
  - NOTE: calls String.split **method** via indirect invoccant syntax
  - also emphasizes action (_functional_ programming)
  - reads most naturally for &split
  
* String, function, delimiter
  - `‘The quick brown fox’.split: ‘ ’;`
  - `‘The quick brown fox’ ==> split(‘ ’);`
  - "Start with the string 'The quick brown fox' and split it on every space"
  
* Delimiter, function, string
  - `‘ ’.&split: ‘The quick brown fox’;`
  - `‘ ’ [&split] ‘The quick brown fox’;`
  - `‘ ’ ==> {‘The quick brown fox’.split($_)}()`
  - "Using spaces, split the string 'The quick brown fox'"
  - NOTE: calls &split **subroutine** using `.&` operator
  - Probably not the best here, but often one of my favorites 
  
Another example
---------------

"Map this function over this list"

    map &f, $l

- emphasize action (_functional_ programming)
- Works nicely with lisp-style right-to-left dataflow:
- data last
```raku 
(sort (grep /<[PE]>/, (map &tc, <people of earth>)))
# ("Earth", "People")
```

"Map over this list using this function"
- also emphasizes action (_functional_ programming)
- Works well with short list, long function
Compare: 
```raku
map @users: {
  given .age { 
      when * ≥ 40      { say "Have a nice day." }
      when 21 ≤ * < 40 { say "I'll need to see some ID."  }
      when * < 21      { say "Sorry, you're not allowed." }
  }
}
```
with

```raku
map {
  given .age { 
      when * ≥ 40      { say "Have a nice day." }
      when 21 ≤ * < 40 { say "I'll need to see some ID."  }
      when * < 21      { say "Sorry, you're not allowed." }
  }
}, @users; 
```

"Take this list and map it using this function"
$l.map: &f
$l &[map] &f

- Data first
- Follows data flow
- Object oriented programming


"Using this function, map over this list"
> &f.&map: $l
&f &[map] $l



"Using this function and this list, apply map"
> (&f, $l) ==> {map |$_}()
  &f, $l ==> (&map∘|*)()
"Using this list and this function, apply map"
> ($l R, &f) ==> {map |$_}()
  $l, R, &f ==> (&map∘|*)()
  
 




         
<!-- more --> 


 ```clojure
 ;; clojure
 (join "-" ["The" "quick" "brown" "fox"])
 ```
 ```emacslisp
 ;; emacs lisp
 (string-join '("The" "quick" "brown" "fox") " ")
 ```
