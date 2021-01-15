# Homepage generation

This repository is used to generate my personal homepage.

It uses [Franklin.jl](https://github.com/tlienart/Franklin.jl), in the [Julia language](https://julialang.org).

The style was based on the [basic Franklin template](), but modified to my taste.

The basic template was initiated with

```julia
using Franklin

newsite("website"; template="basic")
```

Then, the css files were properly modified and the contents were updated with the desired info.

For a live local preview of the page, serve from the `website/` folder with

```julia
cd("webpage)

serve()
```
