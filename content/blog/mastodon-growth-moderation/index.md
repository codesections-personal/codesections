+++
title = "Placeholder"
date = 2018-09-01
+++

{% aside() %}
This post is a focused on issues of community governance within [Mastodon](https://www.joinmastodon.org) and the fediverse more broadly.  If you're not involved in the fediverse, this might not be as relevant to you.
{% end %}

The fediverse recently had an incident after a minor celebrity joined an instance.  I very much do **not** want to talk about the details/merits of that incident¸ but I do want to use it as a prompt for thinking about how the fediverse should deal with some related issues.

<!-- more -->

Here are the *very* basics of what happened, just as context: the celebrity was the target of many people who reported the celebrity, alleging that the celebrity was engaging/had engaged in inappropriate conduct.  The instance administrator felt that these allegations were untrue, but nevertheless decided to ask the celebrity to leave the instance because the administrator could not deal with the volume of reports.  If you would like more details about the facts, I refer you to the [media coverage](https://www.theverge.com/2018/8/31/17801404/mastodon-harassment-wil-wheaton-mobs-twitter).

Now, I have *absolutly* no interest in getting into the merits of this particular case—maybe the administrator was wrong to view the reports as unfounded; maybe they were right.  Maybe it's good that the celebrity is off Mastodon; maybe it's bad.  No interest in getting into any of that at all.

What I **do** want to get in to is the meta issue: How should we set up the fediverse so that instance admins can make decisions on their merits, and not be *forced* into certain actions because they are overwhelmed by outside pressures?

## Stating the problem more clearly
Here's the problem: at the moment it's pretty easy for a coordinated group of individuals to file numerous reports and otherwise harass an individual (such as by sending them messages with the `@` function).  The group can generate such a high volume of reports and @ messages that it overwhelms the resources of the recipient's instance admins.  Overwhelmed admins might then either allow the situation to continue without being able to protect their users or—as happened in this case—might ask the targeted user to leave the instance.

So, how can we prevent instance admins from being overwhelmed in cases like this?

## A big problem with (at least) three parts to the solution
Solving a problem this large will likely require a solution that comes at the issue from multiple directions.  I can think of at least three ways to prevent admins from being overwhelmed by outside groups.

**First**, we can give the admins more powerful moderation software that allows a small group of administrators/mods to deal with a large number of accounts at once.  This might include allowing the moderators to take action related to a group of accounts at once, or opining up the moderation API to third-party apps that might be more powerful.  Whatever form this takes, the basic idea is to magnify the power of admins/mods through better software tools.  [A number of people have already discussed this strategy](https://nolanlawson.com/2018/08/31/mastodon-and-the-challenges-of-abuse-in-a-federated-system/) and I suspect it's already being worked on.

**Second**, we can take steps to reduce the ability of outside groups to generate a huge volume of work for admins in the first place through some sort of rate limit on messages.  There are technical challenges to implementing a rate limit in ways that wouldn't impose too much work on the instance servers, but [people are already coming up with creative solutions](https://superfloppies.tk/writeup/on-rate-limiting-and-abuse/) for workable ways to impose rate limits.  This seems like it could play a key role in the solution.

**Third**, we should take steps to make sure that moderators aren't stretched too thin to begin with.  If a moderator or admin is *right* at the edge of their capacity to handle more traffic, then it's easy for an outside group to push them over the edge.  We should thus take steps to avoid a situation in which admins are right at the edge of their capacity.

I haven't seen as much discussion of this third point, so it's what I want to talk about here.

## Preventing moderators from being stretched too thin
The first thing we should recognize is that moderators vary *tremendously* in how busy they currently are, but there's *absolutly* no visibility into that from the outside.  If we measure business as how many moderators there are per registered user, then instances vary tremendously.  Take a look at this chart:

| Instance              | Users | Mods | Users per Mod |
|-----------------------|-----------------:|-----------:|--------------------:|
| [fosstodon.org](https://fosstodon.org/about)     |   1,138 |  4  |     285  |
| [toot.cafe](https://toot.cafe)                   |   2,033 |  1  |   2,033  |
| [mastodon.cloud](https://mastodon.cloud/about)   |  48,939 |  1  |  48,939  |
| [mastodon.social](https://mastodon.social/about) | 225,831 |  4* |  56,458  |

*mastodon.social is a bit of a special case, because it—unlike the other instances on this chart—pays its moderators.  So it's reasonable to think that they could handle a slightly larger number of users.

As you can see, some instances are *already* asking moderators to deal with 100× more users than other instances are—some moderators are stretched much more thinly than others are.

I wish I could make that point with a longer chart, but I can't—there's absolutely no public information about the number of moderators per instance.  

In a way, the brevity of this chart makes my point for me: users should be able to determine how many moderation resources an instance has *before* they join an instance.  An instance with 100 users/mod will provide a very different environment than an instance with 100,000 users/mod—and the instance-picking UI should give users the ability to determine what sort of instance they might be joining *before* they sign up for an account.

This wouldn't be hard: the Mastodon software already "knows" how many mods an instance has—it give mods a nice little badge on their profile page.  All it would need to do is add this info to the About page for each instance.  And that's exactly what I propose:

{% aside() %}
**Proposal:** The About page for each instance should be modified to show the current number of moderators underneath the current number of registered users.  This would help vulnerable users select instances that have sufficient moderation resources available.
{% end %}

## Dealing with growth
The change suggested above would go a long way to helping direct users to instances with a greater ability to moderate their community.  However, it wouldn't address the issue of communities that simply outgrow their current moderation ability.

However, growth in the community can—and should—lead to growth in the community's ability to self-regulate, at least in most cases.  For example, my home instance ([fosstodon.org](https://fostodon.org)) has grown from ~300 users when I joined to over 1,100 users now. But, during that same time, we also increased from 2 mods to 4 (each in a significantly different timezone).

I don't want to praise my home instance **too** much, but I believe that this provides a good model for how growth ought to be handled—an increase in the population of the instance ought to also increase the number of responsible users who will volunteer to serve as instance moderators.

But there's a huge flaw in this model: what if the instance doesn't grow because there's a gradual increase in users (some of whom will become mods)?  What if the instance grows because a *single* user joins the instance, but that user has a huge number of followers?  Specifically, what happens when (not if) celebrities decide to join relatively small fediverse instances?

I believe that instance should all give some thought to that issue, because the answer might be different for each one.  Some instances might be large enough—or interested enough in growth—that they'd welcome celebrities.  Others might be so small or niche that they would prefer celebrities chose another instance.  It that *is* the case, then the instance should clearly state in the Code of Conduct that high-follower accounts are not supported by their instance.

I suspect that many instances might be in a middle ground: they would be open to celebrities *if* those celebrities recognize that they're creating more work and are willing to contribute in some way—either financially or otherwise.

This leads to my second proposal:

{% aside() %}
**Proposal**: Instances should add language such as the following to their Code of Conduct:
> **High-Follower Accounts**:  Moderating this instance requires significant expenditures of time and effort from our moderators and administrators, all of whom are volunteers.  Moreover, the amount of effort moderation requires is a function not only of the number of users on this instance but also a function of the number of followers those users have.  Accordingly, any users who have a disproportionately high number of followers (e.g., significantly more followers than the total number of users in this instance) will be asked to contribute to the health of the instance.  High follower users who cannot or will not contribute to the health of the instance may be asked to leave the instance.
{% end %}
