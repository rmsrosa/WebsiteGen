# Website Generator

This repository is for generating my personal website, containing both work and non-work related stuff, and currently hosted at [rmsrosa.github.io](https://rmsrosa.github.io).

It uses [Franklin.jl](https://github.com/tlienart/Franklin.jl), in the [Julia language](https://julialang.org).

The css (cascading style sheet) was based on the ["basic" Franklin template](https://tlienart.github.io/FranklinTemplates.jl/templates/basic/index.html), one of the many [Franklin templages available](https://tlienart.github.io/FranklinTemplates.jl/), but which I adapted to my taste.

The basic template was initiated with

```julia
using Franklin

newsite("website"; template="basic")
```

Then, I modified the original `css` files and added the desired contents.

## Notes to myself

For a live local preview of the page, serve it from the `website/` folder with

```julia
serve()
```

This generates the static website, under `__site`, and opens up the default browser with the locally generated site. Any changes made in the source files are automatically reflected in the generated site.

## Publishing the generated website

Currently, with the site hosted at [rmsrosa.github.io](https://rmsrosa.github.io), one should make `__site` a git repo to sync with [rmsrosa.github.io](https://rmsrosa.github.io). If this has not been done yet, then, `cd` to the folder `__site` and proceed with

If starting afresh,

```zsh
git init
git checkout -b main
git remote add origin https://github.com/rmsrosa/rmsrosa.github.com.git
git add -A
git commit -m "initial commit"
git push -u origin main
# git push --set-upstream origin main
```

After that, whenever you want to update the site with changes, just do

```zsh
git add -A
git commit -m "commit message"
git push
```

## Copying website/README.md to __site

`README.md` is ignored by Franklin, for a good reason, since it should not be processed to `README/index.html`.

But I wanted a `website/README.md` to be copied as is to `__site`, so it eventually gets synced to the github-pages repository.

Following the help of @tlienart, I created the following `hfun_cpfiletosite` function in `utils.jl`:

```julia
function hfun_cpfiletosite(filenamevec)
    cp(filenamevec[1], joinpath("__site", filenamevec[1]))
    return nothing
end
```

Then, I call this function in `index.md` with `{{cpfiletoside README.md}}`. That's it!

## Blog comments

Franklin generates static sites, so it is not possible to have blog comments directly with it. However, there are several comment engines that can be included in a static site via javascript or iframe. Here is a list of some of them: [utterances](https://utteranc.es), [StaticMan](https://staticman.net), [IntenseDebate](https://intensedebate.com), [Isso](https://posativ.org/isso/), [Remark42](https://github.com/umputun/remark42), [Talkyard](https://www.talkyard.io), [GraphComment](https://graphcomment.com/en/), [Muut](https://muut.com), [Commento](https://commento.io), and [Disqus](https://disqus.com). Some are free, some are paid, and some paid ones have limited free plans. Some are open source and some are closed source. I opted for [utterances](https://utteranc.es), since it is free, open-source, pretty easy to install, and all the comments are directly accessible in another github repo (or the same as the website repo, if you like).

## Videos and animated gifs

Followed [StackExchange: How do I convert a video to GIF using ffmpeg, with reasonable quality?](https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality)

The periodic NSE simulation animation was reformatted with

```zsh
ffmpeg -ss 0 -t 9 -i movie01xx.mp4 -vf "fps=10,scale=448:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 nsepersim.gif
```

The salt-layer evolution movie was reformatted with

```zhs
ffmpeg -ss 0 -i potencial_ms_cropped.mp4 -vf "fps=15,scale=512:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 1 potencial_ms_cropped.gif
```
