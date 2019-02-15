+++
title = "Announcing pass-gen"
date = 2018-06-07T16:44:57-04:00
description = "A CLI for generating secure, easy-to-type passwords"
+++
As I mentioned [last time](https://www.codesections.com/blog/fixing-the-one-problem-with-password-managers/), I think many password managers have a serious flaw: they don't have a way for you to generate a secure, memorable passphrase.  That means that, if you ever have to type your password in, you're stuck typing in something like `{!]&Sk)r"ss|$K40:]PP''3k-`—and nobody wants to type `{!]&Sk)r"ss|$K40:]PP''3k-`.  

I also said that I've been using [hsxkpasswd](https://www.bartbusschots.ie/s/publications/software/xkpasswd/) to solve that issue and generate usable passphrases.  I like hsxkpasswd a lot, but there's one thing I hate about it—it's written in Perl.  It's the only Perl program I have on my current computer, and it feels really burdensome to install an entire programming language just to generate a simple passphrase.  So, after being bugged by that, I finally decided to do something about it.

I've written pass-gen, a pure bash password generator.  I just used it to generate a password, and I got `UPTURNED!`&#8203;`gone!`&#8203;`DASH!`&#8203;`renewable!`&#8203;`GUIDE!`&#8203;`joystick!524`—hopefully much easier to type.  I had several goals for pass-gen:
<!-- more -->

*  No dependencies.  The whole idea was to get away from Perl, so I don't want to pull in Python, Node, or anything else that isn't part of a bare Linux install. 
*  Security.  I want pass-gen to be at least as secure as hsxkpasswd.  (I think I well exceeded this goal; based on my calculations, pass-gen should provide 93 bits of entropy using default settings, thanks largely to finding some better wordlists). 
*  Customizability.  One of the features I love about hsxkpasswd is how customizable it is, and I want pass-gen to be just as customizable, if not more so.

I believe I've achieved these goals with the initial v0.0.1 release, and would love to have any thoughts or feedback.  The current version has essentially achieved feature parity with hsxkpasswd—the only feature I'm missing is the ability to report on the entropy of generated passwords. 

It also has what I hope will be a large advantage compared to hsxkpasswd in the security department.  This is largely due to the great work done by the Electronic Freedom Foundation, which has put together [several wordlists](https://www.eff.org/dice) designed to be used for dice-generated passwords.  Because pass-gen isn't limited to physical dice, it uses a custom wordlist that combines all three of the EFF lists.  Since this list is much larger than the default hsxkpasswd wordlist, pass-gen provides far better out-of-the-box security.

Of course, both tools allow you to use custom wordlists.  And pass-gen ships with well over a dozen potential wordlists, many of which are vastly longer than even the combined EFF list and thus could provide even better security—though at the cost of not having been vetted for usability.

In the spirit of any good Linux/Unix/FOSS tool, pass-gen ships with an extensive man page, in addition to supporting a `--help` command and having a README.  Additionally, I'm happy to answer any questions about it, either here or on [Mastodon](https://fosstodon.org/@codesections).

The source code is available at both [GitLab](https://gitlab.com/codesections/pass-gen) and [GitHub](https://github.com/dsock/pass-gen), though I expect to primarily use GitLab going forward. 

If you have any ideas for improvements, please let me know and I'll add them to the roadmap (I already have ideas!).  If you like the project as it is, I'd greatly appreciate your sharing it with others; I think this could be an easy way for people who make good use of the command line to improve the usability of their passwords without any cost to security. 
