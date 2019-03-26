+++
title = "Cleaning your GitHub profile with a simple Bash script"
date = 2019-03-26
+++

I recently read Andrei Cioara's take on [the best way to organize GitHub repos](https://andreicioara.com/how-i-organize-my-github-repositories-ce877db2e8b6).  The short version is that GitHub's flat name-spacing leaves all your repos in a single, jumbled list—which is both annoying for you to deal with and makes it harder for anyone else to find your most useful projects.

In particular, if you're an active participant in the open-source world, you could easily have dozens of forks cluttering up your repo list, not to mention any old, half-finished projects you might have floating around.

Andrei suggests a clever solution: Create single-user organizations and move certain repositories over to those organizations. For example, I've created a `codesections-forks` organization to hold all the projects I've forked to make pull requests and a `codesections-playground` repo to hold my one-off experiments.  As a result, my main [repository page](https://github.com/codesections?tab=repositories) is now much cleaner—down to just 13 public repos, all of which I actively maintain.

But what Andrei **doesn't** explain is how to move all your repos.  If you do it through GitHub's UI, it's pretty painful—you have to click through several different pages and manually type in *both* the name of the repo you want to move *and* the target org.  And—since the only reason this is worth doing is if you have a bunch of repos you'd like to move—this ends up being a lengthy process.

Fortunately, there is a better way.

<!-- more -->

Instead of manually clicking and waiting and typing and waiting, we're going to move our repos using GitHub's famously flexible and powerful API.  Fortunately, their API has an endpoint specifically [designed for transferring repos](https://developer.github.com/v3/repos/#transfer-a-repository); unfortunately, it's still experimental.  But all that means is that we'll need to add in an extra header to our request.

So, what exactly do you do?  Well, first, grab an OAuth Personal Access Token if you don't already have one (you can generate a new one at [github.com/settings/tokens](https://github.com/settings/tokens).  Then, create whatever new organization or organizations you want to move some repos to—I went with just two, but Andrei suggests four; use your own judgment. Finally, use the following CURL command to move a target repo from your personal account to the newly created org:

```bash
curl -H "Authorization: token <OAUTH_PERSONAL_ACCESS_TOKEN>" \
-H "Accept: application/vnd.github.nightshade-preview+json" \
-H "Content-Type: application/json" \
-X POST https://api.github.com/repos/<USERNAME>/<REPO>/transfer \
-d '{"new_owner": "<NEW_ORG>"}'
```

(Be sure to fill in your own values for `<OAUTH_PERSONAL_ACCESS_TOKEN>`, `<USERNAME>`, `<REPO>`, and `<NEW_ORG>`.)

With that single command, you've fully transferred the repo, no confirmation or page reloads required.  And with just a few lines of Bash—something so trivial it's a bit of an overstatement to even call it a script.  And, to repeat for the next repo, just change the `<REPO>` name; everything else stays the same.

Of course, there's still plenty more we could do to automate this further.  In particular, it would be pretty trivial to query GitHub's API for all of our forks and then loop over them in a single pass.  I didn't do that, personally—I wanted to be able to see each repo I was operating on, and didn't have enough forks to really make that worthwhile.  (Well, especially considering that I used vim's keyboard macros to quickly paste in each repo name and copy the resulting CURL command).  But, if you have more forks, that would be the next obvious step.

At the end of the day, am I happy with the result?  Well, mostly.  I still wish GitHub would let us manually order the repos—in particular, I wish that I had [mnemonic](https://github.com/codesections/mnemonic) above the fold, since it's my most active project right now.  But [my repo list](https://github.com/codesections?tab=repositories) is definitely a lot cleaner, and using CURL was able to save me a lot of time.

... of course, I then went and spent at least as much time as I saved telling all y'all about it.  But, hey, maybe we can all save a bit of time together. 


