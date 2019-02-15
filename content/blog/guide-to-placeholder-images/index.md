+++
title = "Generating placeholder images with Pixabay, jq, and curl"
date = 2018-11-13
+++

Just recently, I found myself in need of several hundred pictures.  I'm working on a fairly large-scale app, and I want to be able to test its server infrastructure under load.  In my case, that means uploading a decent number of images to Amazon's S3 servers and testing how the app's performs holds up.

So, where to get several hundred reasonably decent pictures, preferably with as little work as possible?

## Licensing Difficulties
I asked around, and several of my colleagues recommended [Unsplash](https://unsplash.com/).  In a lot of ways, that would be perfect—they have gorgeous photos, and an easy-to-use API.  There's just one problem: The Unsplash API [expressly requires](https://medium.com/unsplash/unsplash-api-guidelines-hotlinking-images-6c6b51030d2a) all images to be hotlinked back to their servers.  As they explain:

> Downloads and views are one of the main motivations for many Unsplash contributors. By opening up the Unsplash API to 3rd party applications their photography is seen and used by more users which inspires them to contribute more, new contributors to join, and an even better library for you and your community of creatives.
>
> When displaying Unsplash images, you should use the urls property returned by the API on all of the API photo objects.

That makes a certain amount of sense.  (I suspect they might also be harvesting the data for advertising purposes too, based on a closer reading of their ToS—but, either way, it's their product and they make the rules.)

So, if Unsplash is out, what does that leave us with?

## Other Options
Well, there's always [placekitten](placekitten.com/).  But, just for the sake of argument, let's assume that we'd like somewhat realistic data in our app and that we're building an app that *isn't* kitten-centric (I know, what is the Internet coming to!).

I investigated a few other options, but none of them quite worked.  I looked at [Wikimedia Commons](https://tools.wmflabs.org/magnus-toolserver/commonsapi.php) (limited API, no way to programmatically filter based on license); [Pexels](https://www.pexels.com/) (no public access to API—only after requesting access); [Flicker CC](https://www.flickr.com/creativecommons/) (API is exclusively non-commercial); [PlaceImage](http://placeimg.com/) and [LoremPixel](http://lorempixel.com/) (Good APIs but very limited image selection).

## The Best Choice
After sorting through the contenders, I finally found a site that would work perfectly: [Pixabay](https://pixabay.com/), which has a great (although not 100% user-friendly) API and allows full use of their images on external server.  And everything there is perfectly open-source.  Thanks to [Thomas Pfeiffer](https://fosstodon.org/@colomar) for pointing me in the right direction, by the way.

Having settled on the source of our images, how do we actually go about pulling some down?  Let's code!

<!-- more -->

## How To Use Pixabay
First, we need to grab a Pixabay API key as described in [their docs](https://pixabay.com/api/docs/).  This does require registering for a (free) account, but shouldn't take more than a minute.

Next, we'll query the API, and return some JSON describing our images.  To do this, we'll use the `https://pixabay.com/api/` route with the `curl` command.  For example, you could do this:

```bash
curl "https://pixabay.com/api/?key=YOUR_API_KEY&image_type=photo&category=buildings&per_page=200&page=1" > response.json
```

As you can probably tell, that query filters based on the "building" category.  You can filter on whatever category you'd like, or even perform a search if you want more detailed results.  Check out the [API docs](https://pixabay.com/api/docs/) for full details on the available fields.

That will save a fairly long string of JSON to your the `response.json` file.  It gives you all the data you need to pull the images, but it's a bit much to work with. 

Fortunately, there's a great command-line tool called [jq](https://stedolan.github.io/jq/) that can help you filter this response—if you don't already know about it, now's a great time to learn.

Jq has several powerful filters, but right now we'll just be using a basic one:
we want the `webformatURL` value for each of the images, and we want to save that into a separate file.  To do this, all we need is:

```bash
jq '.hits[]webformatURL' < images.json > urls.json
```

This gets us a file full of lines like:
```
"https://pixabay.com/get/ea32b70e2df5043ed1584d05fb1d4796e57fe6d01eb40c4090f4c378a2e9b1b1df_640.jpg"
```

Each line links to a particular image just like this one:

![Placeholder image](img.jpg)

For our next step, however, we'll need the bare URLs, so let's quickly strip out the quotation marks.  Just open up your favorite text editor and remove the quotes—in my case that means firing up Vim and running `:%s/"//g`, but use whatever you're comfortable with.

After all that, we just need to loop through the list and make a curl request for each line—and then save each file with a unique name.  We can do that with a bit of bash:

```bash
i=0;
while read LINE;
  do curl "$LINE" > img$1.jpg;
  i=$(($i+1));
done < urls.json
```

And that should get you 200 files—rinse and repeat for as many files as as you need!

And, with just a few minutes and a few lines of code, you have a full selection of placeholder images on whatever topic you'd like.
