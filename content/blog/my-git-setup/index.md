+++
title = "My (Paranoid) Git Setup"
date = 2018-06-10T07:55:24-04:00
+++

Until recently, I had a very simple git workflow: I worked in a local repository, and then pushed my changes to a single remote, which lived at GitHub.  In the case of the [code for this site](https://www.gitlab.com/codesections/codesections-website), pushing to GitHub would automatically trigger a rebuild of the website and publish the changes live to the Internet. (Thanks, [Netlify](https://www.netlify.com)!)

This setup had the virtue of simplicity, but it had three important drawbacks:

* I had no backups of any changes I'd made but not published.  For example, if I had a draft blog post, it lived *only* on my laptop, and thus could easily be lost.  This isn't *that* big of a deal with my current workflow—unlike some [some](https://fosstodon.org/@h4ck3r9/100174544939337521) bloggers, I don't tend to keep a ton of posts as drafts.  Still, though, I'd like to not lose what I do have, and I always might keep more drafts in the future. 
* I was relying heavily on GitHub to publish updates to my site.  If GitHub were down or locked me out of my account or something, I would have no *easy* way to make posts to my blog.  I could migrate to a different git host or manually update Netlify, but it wouldn't be seamless.
* I had only one backup of the site, and that was on GitHub.  If anything happen to my computer, I'd be 100% relying on GitHub for all of my site content.

So, over the past week, I decided to fix all of these issues.  With my new setup, I have:

1. A git server on a Raspberry Pi on my home LAN.
2. A git server on a cheep shared host.
3. A GitHub-hosted repository.
4. A GitLab-hosted repository.

And here's my new workflow: As I'm working on content locally, I commit my changes and then `git push`, which is configured to push my changes *only* to the Pi.  When I'm ready to publish changes, run `git push all`, which pushes to all four remote repos, and triggers Netlify to rebuild the site.  (I also switched to using GitLab as the main repository that Netlify builds off of, but that was more of a reaction to the GitHub acquisition than a change related to the above.)

This means that I have a local backup of everything on the Pi and that I have three additional backups of the published content.  What's more, if I ever lose access to GitLab, I could seamlessly switch back to GitHub and tell Netlify to build off of that repo, which eliminates a point of failure. 

I'm very happy with this new workflow, but it took a bit of figuring to get it all set up.  The rest of this post provides a guide for how to set up a similar workflow.  This may be old hat for people with a bit more git experience, but it took me some googling to figure out, so I thought it might be helpful to others. 

## How to set up a similar workflow

### 1. Initialize a local git repo and make your initial commit

(If you already have a local git repo set up, you can skip this step.)

From within the directory that contains your project, run `git init`, which creates a new repository.  Then run `git add .` to begin tracking all the files in the directory, and `git commit -am "Intial commit"` to commit the current state of your repository locally.

### 2. Push your changes to the Raspberry Pi (or other server for backup)

First, SSH into the server you intend to use for backup of unpublished content—in my case, the local Pi.  For my setup, this means running `ssh pi@192.168.0.102`, but your command will differ depending on the username and IP address. 

From the server, run `git init --bare <name_of_project>`.  The `--bare` flag tells git that there isn't a local working directory, which will prevent it from viewing the lack of files as a problem.

Then, end the SSH session and run `git remote add origin <username>@<IP>:<path/to/project>`.  In my case, when setting up the repo for this site, I ran `git remore add origin pi@192.168.0.102:/home/pi/projects/codesections`. 

Run `git push --set-upstream master` to push to the server.

### 3.  Add the remote servers for production deployment

Up through this point, we've been using very basic git commands.  Here's where it gets (slightly) more advanced.

In this example, we'll be setting up three additional servers: one remote sever, a GitHub one, and a GitLab one.  But you could omit one or two of these severs if desired. 

If you are running three, first SSH into the remote server and initialize the bare repo (the same process from step 2, above).  Then create new GitHub and GitLab repos using their web interface. 

Finally, run the following commands:

* `git remote add all <gitlab-git-url>`.  (So, in my case `git remote add all git@gitlab.com:codesections/codesections-website`.)
* `git remote set-url all <github-git-url>`. (So, in my case `git remote set-url git@github.com:dsock/codesections`.)
* `git remote set-url all <remote-server-url>`.
* `git remote set-url all <pi-git-url>`. (In my case, `git remote set-url pi@192.168.0.102:/home/pi/projects/codesections`.)

Now, you can run `git push all` to push your changes to all the remote repos.  

