# Website generation

This repository is for generate my personal website, containing both work and non-work related stuff.

It uses [Franklin.jl](https://github.com/tlienart/Franklin.jl), in the [Julia language](https://julialang.org).

The style was based on the [basic Franklin template](https://tlienart.github.io/FranklinTemplates.jl/templates/basic/index.html) of the many [Franklin templages available](https://tlienart.github.io/FranklinTemplates.jl/), but I adapted it to my taste.

The basic template was initiated with

```julia
using Franklin

newsite("website"; template="basic")
```

Then, I modified the original `css` files and add the desired contents.

For a live local preview of the page, serve it from the `website/` folder with

```julia
serve()
```

This generates the static website and opens up the default browser with the locally generated site. Any change made in the source files are automatically reflected in the generated site.
