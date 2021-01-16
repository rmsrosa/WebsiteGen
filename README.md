# Website generation

This repository is for generating my personal website, containing both work and non-work related stuff.

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

This generates the static website and opens up the default browser with the locally generated site. Any change made in the source files are automatically reflected in the generated site.

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
