# Greetings

@def title = "Greetings"
@def authors = "R. Rosa"
@def published = "6 February 2021"
@def pt_lang = false
@def rss_pubdate = Date(2021, 2, 6)
@def rss = "Greetings"
@def rss_description = """Introductory post in my blog"""

{{ published }} | **{{ authors }}**

This is an introductory post. I used to have a blog about homebrewing, created in 2006, in a time where not much information was available in Brazil about homebrewing. So I guess my blog turned out to be of some value. Since then, I was happy to see the homebrewing community grow so large in Brazil.

Today, I decided to revive the blog, but open up the focus to include *more* math and coding (yes, there were math in the homebrewing blog since brewing involves many physicochemical processes amenable to mathematical modeling). And to broaden the audience, I also decided, although with some reluctance, to write some posts in English, including this introductory one.

For a long time, my personal homepages were all in pure html, sometimes with a little javascript. About two years ago, I revamped it in Python/Flask. Last year, though, I realized the power of [the Julia language](https://julialang.org) and decided to rewrite my website in Julia/Franklin.

[Franklin](https://franklinjl.org) is a static-site generator written purely in Julia, made by [Thibaut Lienart](https://github.com/tlienart). It is so much easier than Flask and good enough for me since I don't really need the power of Flask as building a dynamic site. In fact, in Flask, I ended up building a static site out of the dynamic one before publishing it.

With Franklin, the only thing that was bothering me was that it seemed to me that I wouldn't be able to have comments on the blogs, since it is a static site. However, I ended up learning that there are a number of tools and apps to embed a comment section in static sites with javascripts or iframe. With that, Franklin turned out to be just perfect for what I need.

Deploying the site is as simple as pushing the changes to a github repo. For the comments, there are paid and free apps, open and closed source. I chose to use [utterances](https://utteranc.es), a free, open-source, no-fuss solution, which is pretty easy to set up, and which keeps all the comments in another github repo (one can use the same repo as that for the website, but I chose to use a different one, for more independence). One drawback is that to post a comment, one needs to have a github account. But I hope that will turn out not to be of too much trouble.

Anyways, that is it for the Introduction.

Cheers!

{{ blogcomments }}
