+++
title = "Sending Keybase Chats Using Vim"
date = 2018-08-24
description = "A guide for using vim to send chat messages through the keybase.io client"
+++

I cannot spell.  Like, was-sent-to-special-classes-as-a-child-and-they-gave-up-on-me cannot spell.  Luckily, this isn't an issue 99% of the time as an adult, because I'm never asked to operate in an environment without a spellcheck.  Except … I just started using keybase.io's chat program, and it doesn't check spelling.  Clearly, this needed to be fixed.

I found a way to fix it: I now write my chat messages in Vim and then pipe them to keybase chat.  I thought this would be a pretty rare use case (how many other people *really* care about spelling, or want to edit one-line chat messages in Vim?)  But a number of people expressed interest, so I decided to write this post as a how-to.

I'll give you the tl;dr how-to version quickly, and then I'll walk though what we're doing in a little more detail and talk about how you could customize it for your use-case.

<!-- more -->

## How To
First, you'll need to have the keybase app installed, which will automatically install their command-line client.  If you don't have it, you can get it from [their website](https://keybase.io/download). And you'll obviously need vim/neovim installed too.

Next, add this bit of code to your `.vimrc` file (or `~/.config/nvim/init.vim` file for Neovim users).

```vim
augroup keybase
  autocmd!
  autocmd BufNewFile,BufRead *keybase-outbox* let conversation = expand('%:e')
  autocmd BufNewFile,BufRead *keybase-outbox* inoremap <CR> <esc>:w<CR>:!keybase chat send <C-R>=conversation<CR> < %<CR>ddi
  autocmd BufNewFile,BufRead *keybase-outbox* nnoremap <leader><CR> :w<CR>:!keybase chat send <C-R>=conversation<CR> < %<CR>ddi
augroup END
```

Then, to send a chat message to a keybase use vim to open a file with the filename `keybase-outbox.<USERNAME>` (so, if you wanted to message me, you'd type `vim keybase-outbos.codesections`).

Type your message and then (while still in insert mode) hit enter to send it (just like you would in a chat client).  Or, if you're in normal mode, hit `<leader>` and then enter.  This will send your chat, clear the file, and drop you back into insert mode, ready to type your next message.

{% aside() %}
Note that this doesn't display your chat messages in vim/the terminal.  I'm sure you could do that if you really want to live in the terminal (using the `keybase chat read` in a loop should do the trick) but that's not the exercise here.  I still have the keybase app up in a split-screen window with Vim next to it.
{% end %}

## The Details
How does this work?  Well, I don't claim to be a vimsrcipt master (I'm still halfway through [Learn Vimscript the Hard Way](http://learnvimscriptthehardway.stevelosh.com/) and probably won't get around to finishing it for quite some time).  But here's what's going on:

First, we create a group of commands to be run automatically, and we tell Vim to run those commands whenever the filename includes the string "keybase-outbox".

What does this command do?  Well, first, the command looks at the current file (`%`) and grabs its extension (`:e`).  It then saves this extension to the variable `conversation`.

Next, these commands cause Vim to remap enter in insert mode and `<leader>` enter in normal mode.  Each of these keys now saves the current file (`:w<CR>`) and then runs a terminal command (`:!`).  That terminal command invokes the keybase cli and tells it to send a chat message (`keybase chat send`).

At this point, we need to specify the target of the chat message.  To do that, we
need to get at the variable we've saved—but we can't access it directly within the ex command we're running.  So, instead, we invoke the [expression register](http://vimcasts.org/episodes/simple-calculations-with-vims-expression-register/) (`<C-R>=`) and give it the name of our variable.

Finally, we pipe in the contents of the current file (`< %`) and enter our command.  This sends the message.

After this, we're just dealing with some cleanup.  We clear the current line (`dd`) and drop back into insert mode (`i`) so that we can send our next message.

## Potential Tweaks
This setup is optimized for sending one-line chat messages: since we've remapped enter in insert mode, it's very difficult to send multi-line messages. If you prefer to send longer messages, you might want to remove the insert-mode mapping and change the script to delete the whole message instead of just the current line. (`ggdG` should do the trick).

Conversely, you might want to keep your sent message until you manually delete it, in which case you can just cut the part of autocmd that deletes the current line.

## Notes
A few important notes.  Less importantly: because this command saves the file, it will leave behind a file with the name you gave it.  This doesn't bother me; I just keep them in a `keybase-chat` directory and can then tab-complete to open them again later.  But if they annoy you, just remember to delete them.

More importantly, depending on your threat model, their could be security risks to using this approach.  Keybase doesn't lack a spellcheck because the devs are *lazy*—they kept it out because they were concerned about security risks of sending keystrokes outside the program.  Here, we're definitely doing that, and even keeping them in Vim's swap files (if you haven't changed that setting).  So, if you're at all concerned about the security of your local machine, this may not be the best approach for sensitive content.

But, with those caveats, this should let you use Vim to edit your chat messages.  Hope this is helpful!

