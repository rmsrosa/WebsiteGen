# Greetings

@def title = "Greetings"
@def authors = "R. Rosa"
@def published = "6 February 2021"
@def rss_pubdate = Date(2021, 2, 6)
@def rss = """Greetings"""

This is an introductory post. I used to have a blog about homebrewing, initiated in 2006, in a time where not much information was available, so I guess mine turned out to be of some value. Since then, I was happy to see the homebrewing community grow so large in Brazil.

This time, I want to revive the blog, but open up the focus, including math and coding. And it is for this reason that I decided, reluctantly, to write some posts in English, including this one.

For a long time, my personal homepages were all in pure html, sometimes with a little javascript. About two years ago, I revamped it in Python/Flask. Last year, though, I realized the power of [the Julia language](https://julialang.org) and decided now to rewrite my website in Julia/Franklin. 

[Franklin](https://franklinjl.org) is a static-site generator written purely in Julia. It is so much easier than Flask and good enough for me since I didn't really need the power of Flask as a dynamic site. In fact, I would build a static site out of it before publishing it.

With Franklin, the only thing that was bothering me was that I wouldn't be able to have comments on the blogs, since it is a static site. However, I ended up learning that there are a number of tools and apps to embed a comment section in static sites with  javascripts or iframe. With that, Franklin is just perfect for what I need.

Deploying the site is as simple as pushing the changes to a github repo. For the comments, there are paid and free apps, open and closed source. I chose to use [utterances](https://utteranc.es), a free, open-source no-fuss solution that keeps all the comments in another github repo (one can use the same as that for the website, but I chose to use a different one, for more independence) and is pretty easy to install.

Anyways, that is it for the Introduction.

Cheers!

{{ blogcomments }}