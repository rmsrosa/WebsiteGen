# Computing time average bounds for the Van der Pol oscillator in Julia

@def title = "Computing time average bounds for the Van der Pol oscillator in Julia"
@def authors = "R. Rosa"
@def published = "22 February 2021"
@def pt_lang = false
@def rss_pubdate = Date(2021, 2, 22)
@def rss = "Computing time average bounds for Van der Pol oscillator in Julia"
@def rss_description = """We compute time-average bounds for the Van der Pol oscillator using both the time-evolution of the differential equation and convex minimization with Sum of Squares. We use the Julia language and the SciMl and Flux ecosystems."""
@def hasplotly = true
@def hascode = true
@def hasmath = true

{{ published }} | **{{ authors }}**

## Introduction

We addressed, in the previous [Time average bounds via Sum of Squares](/blog/2021/02/time_ave_bounds_SoS/) post, the problem of estimating the asymptotic limit of time averages of quantities related to the solutions of a differential equation.

Here, the aim is to consider an example, namely the Van der Pol oscillator, and use two numerical methods to obtain those bounds: via time evolution of the system and via a convex semidefinite programming using Sum of Squares (SoS), both discussed in the previous post.

This example is addressed in details in [Fantuzzi, Goluskin, Huang, and Chernyshenko (2016)](https://epubs.siam.org/doi/abs/10.1137/15M1053347). My main motivation is to visualize the auxiliary function that yields the optimal bound via SoS. That is the main reason to choose a two-dimensional system.

That bound depends on the chosen degree $m$ for the auxiliary function appearing in the SoS method. Here are the results for specific values of $m$:

\textoutput{sosvdpVplots}

We discuss, below, the details leading to these result and how to appreciate the plots above. (Notice you can rotate, pan and zoom the previous and subsequent images!)

## The Van der Pol oscillator

The [Van der Pol oscillator](https://en.wikipedia.org/wiki/Van_der_Pol_oscillator) originated in the study of eletric circuits and appears in several other phenomena, from control, to biology and seismology.

In its simplest, and nondimensional, form, the equation reads
$$ {\displaystyle {d^{2}x \over dt^{2}} - \mu (1-x^{2}){dx \over dt}+x=0,}
$$
where $\mu>0$. This equation has the stationary solution $x(t)=0$, $\forall t\in \mathbb{R}$, and all other solutions converge to a limit cycle that oscillates around the origin. The form of the limit cycle and the convergence rate to the limit cycle change according to the value of the parameter $\mu$.

Below you will find the evolution of both $x=x(t)$ and its derivative $x'=dx(t)/dt$ for different values of $\mu$, and with the initial conditions $x(0)=4.0$ and $x'(0)=6.0$. Notice that, for small $\mu$, the solution converges faster to the limit cycle, which is nearly a sinusoidal wave; while for large $\mu$, the solution converges slightly slower and the solution develops spikes, as if firing up some signal information (think neurons in biological applications).

\textoutput{vanderpolsolt}

Another common representation of the dynamics of an autonomous system is that of a phase portrait, in which we draw the orbit, or trajectory, in the phase space of the system. In this case, the phase space is $xy$, where $y=dx/dt$. We rewrite the second-order differential equation as a system of first order equations
$$ \label{vanderpolsystem}
\begin{cases}
x' = y, \\
y' = μ(1 - x^2)y - x.
\end{cases}
$$

The same trajectories above, in the two extreme values for $\mu$, are seen below in phase space.

\textoutput{vanderpolphasesp}

## Estimating time averages

The post [Time average bounds via Sum of Squares](/blog/2021/02/time_ave_bounds_SoS/) addressed the problem of estimating the time-average
$$ \bar\phi(u_0) = \limsup_{T\rightarrow} \frac{1}{T} \int_0^T \phi(u(t))\;\textrm{d}t,
$$
for the solutions $u=u(t), t\geq 0$, $u(0)=u_0$, of a differential equation
$$ \frac{\textrm{d} u}{\textrm{d}t} = F(u),
$$
where $\phi:X\rightarrow \mathbb{R}$ is continuous; $F:X\rightarrow X$ is some locally Lipschitz function acting in some finite-dimensional space $X=\mathbb{R}^n$, $n\in\mathbb{N}$; and assuming the solutions generate a continuous semigroup $\{S(t)\}_{t\geq 0}$, where $S(t)u_0=u(t)$.

We exemplify this here with the Van der Pol system \eqref{vanderpolsystem} and with the quantity
$$\phi(x,y) = x^2 + y^2.
$$

## Bounds via direct computation of the trajectory and its time average

The most direct way to numerically estimate the bound is via a numerical evolution of the system, for a sufficiently long time, and taking the corresponding time average. Since the system has a globally attracting limit cycle (except for the unstable fixed point at the origin), we may simply consider a single trajectory for the estimate.

\textoutput{timeintegration}

Notice we integrated for a very long time to have a proper convergence of the time average. Alternatively, knowning that a fixed fraction of the time integral over the time period converges to zero, we could start integrating at a later time and avoid the initial large values, due to the transient behavior, and the initial bumps, due to the periodic spikes in the solution and its derivative:
$$ \lim_{T\rightarrow \infty} \frac{1}{T}\int_0^T \phi(u(t))\;\textrm{d}t = \lim_{T\rightarrow \infty} \frac{1}{T}\left(\int_0^{T_*} \phi(u(t))\;\textrm{d}t + \int_{T_*}^T \phi(u(t))\;\textrm{d}t\right) \\ = \lim_{T\rightarrow \infty} \frac{1}{T}\int_{T_*}^T \phi(u(t))\;\textrm{d}t = \lim_{T\rightarrow \infty} \frac{T-T_*}{T}\frac{1}{T-T_*}\int_{T_*}^T \phi(u(t))\;\textrm{d}t \\
= \lim_{T\rightarrow \infty} \frac{1}{T-T_*}\int_{T_*}^T \phi(u(t))\;\textrm{d}t = \lim_{T\rightarrow \infty} \frac{1}{T}\int_0^T \phi(u(T_*+t))\;\textrm{d}t.
$$

In general, however, we may not have such a clear understanding of the dynamics so as to start from specific points or at specific times.

## Bounds via convex semidefinite programming with Sum of Squares

We now estimate the upper bound via optimization. As we have seen in [Time average bounds via Sum of Squares](/blog/2021/02/time_ave_bounds_SoS/), since $\phi$ and $F$ are polynomials, an upper bound is given by
$$ \label{optimprob}
  \sup \bar\phi \leq \inf\{C; \; (C,V)\in \mathbb{R}\times\mathrm{P}_m(X), \;C−ϕ−F⋅∇V = \texttt{SoS}\},
$$
where $\mathrm{P}_m(X)$ denotes the set of real polynomials on $X$ with degree at most $m$, and where, in this case, $X=\mathbb{R}^2$. We expect the bound to become sharper as we increase the degree $m$. Recall, as discussed in the previous post, the degree has to be even, otherwise it has no chance of being nonnegative.

Below is the result of the estimate, for some choices of $m$:

\textoutput{sosvdpboundtable}

Here is a corresponding plot, but skipping $m=4$, for scaling reasons:

\textoutput{sosvdpbounds}

## Visualizing the auxiliary function

Looking at \eqref{optimprob} and its feasibility condition
$$ C−ϕ−F⋅∇V = \texttt{SoS} \geq 0,
$$
we see that $C$ is smaller, the greater the term $-F\cdot\nabla V$, i.e. the "closer" $F$ points to $-\nabla V$, or, in other words, the faster the orbit descends along $V$, whenever possible.

The best situation is in a gradient flow, but that is not always the case. It may not even be possible to have $F$ descend along $V$ all the time; just think of a periodic orbit, with a nontrivial auxiliary function $V$, such as in our case. Nevertheless, the longer the orbit descends along $V$, the better.

With that in mind, you may go back to the visualizations of the auxiliary function given in the beginning of the post. Notice how the condition just described (of the orbit to attempt to descend along the optimal $V$) improves as the degree of $V$ is allowed to increase. You can rotate, pan, and zoom the figures as you wish, to better observe this behavior of the limit cycle with respect to $V$.

## Computation comparison

We show below a simple performance comparison between the time integration method done in the function `get_means_vdp()` and the SoS optimization method done in `get_bound_vdp_sos()` (see the codes in Section [Julia codes](#julia-codes)). For that, we use the [JuliaCI/BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl) package. Keep in mind the functions being compared have not been optimized and this is not a thorough assessment of both methods.

For the time-integration, instead of integrating from $t=0$ to $t=T_{\text{max}}$, with $T_{\text{max}}=5000$, as done in one of the plots above, we only go up to $T_{\text{max}}=610$, which is enough to get to the same bound as that given by the SoS method with the auxiliary function with degree $m=10$. Here is the result of `@btime`.

```julia
julia> using BenchmarkTools

julia> @btime get_means_vdp($u0, $μ, $ϕ, 610)[2][end]
  768.929 ms (3115182 allocations: 77.89 MiB)
5.021851906510364

julia> @btime get_bound_vdp_sos($μ, $ϕ, 10)[2]
  5.324 s (68842 allocations: 5.75 MiB)
5.0219594820626305
```

For this simple system, with a globally attracting limit cycle (except for the unstable fixed point at the origin), in which we can take a single trajectory to estimate the upper bound, it is computationally more efficient to do the time integration. However, in situations in which there are many different basins of attractions and "hidden" attractors, a single trajectory will not be sufficient for a global bound, and a Monte Carlo Method, integrating over tens, maybe hundreds, of solutions, is necessary. In this case, computing a global bound via SoS might be more efficient. We plan to illustrate this situation in a future post.

## Julia codes

We present, below, the codes used in this post. You may download the full code with the Download button at the end.

We use [The Julia Programming Language](https://julialang.org) for the numerical computations. For the interactive plots, we use [plotly/PlotlyJS.jl](https://github.com/JuliaPlots/PlotlyJS.jl), which is Julia's interface to the [plotly.js](https://plot.ly/javascript) visualization library.

For solving the differential equation, we use the [SciML/DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl) package. The following snippet of code is used to solve the system of equations and plot the solutions over time.

```julia:vanderpolsolt
using PlotlyJS
using DifferentialEquations
use_style!(:ggplot)

function vdp_du(du,u,params,t)
    x, y = u
    μ, = params
    dx = y
    dy = μ*(1 - x^2)*y - x
    du .= [dx, dy]
end

u0 = [4.0, 6.0]
Tmax = 80.0
tspan=(0.0,Tmax)

μ_range=(0.2,1.0,2.0,4.0)

vdp_sol = [DifferentialEquations.solve(ODEProblem(vdp_du,u0,tspan,[μ], saveat=0.0:0.1:Tmax)) for μ in μ_range]

vdp_sol_times = 0.0:0.1:Tmax

plt_mu = [
    PlotlyJS.plot(
        [PlotlyJS.scatter(;x=vdp_sol_times, y=map(u->u[1], vdp_sol[j].(vdp_sol_times)), line_width=1, name="dx(t)/dt", showlegend=true*(j==1), mode="lines", line_color="orange"),
        PlotlyJS.scatter(;x=vdp_sol_times, y=map(u->u[2], vdp_sol[j].(vdp_sol_times)), line_width=3, name="x(t)", showlegend=true*(j==1),mode="lines", line_color="steelblue")],
        Layout(;xaxis_title = "t", yaxis_range=[-7.0,7.0], title="μ=$(μ_range[j])")
        )
    for j in 1:length(μ_range)
    ]

plt_comb = [plt_mu[1] plt_mu[2]; plt_mu[3] plt_mu[4]]

# display(plt_comb) # hide - for VSCode or the REPL 
fdplotly(json(plt_comb), style="width:680px;height:500px") # hide - for Franklin
```

With the solution at hand, we also plot the corresponding orbits, for two values of $\mu$, with the following code.

```julia:vanderpolphasesp
plt_phsp = [
    PlotlyJS.Plot(
        PlotlyJS.scatter(;x=map(u->u[1], vdp_sol[j].(vdp_sol_times)), y=map(u->u[2], vdp_sol[j].(vdp_sol_times)), line_width=2, name="(x(⋅),y(⋅))", showlegend=true*(j==1), mode="lines", line_color="steelblue"),
        Layout(;xaxis_title = "x", yaxis_title = "y", xaxis_range=[-7.0,7.0],yaxis_range=[-7.0,7.0], title="Phase portrait μ=$(μ_range[j])")
    )
    for j in (1:3:4)
]

plt_ps = [plt_phsp[1] plt_phsp[end]]
# display(plt_ps) # hide - for VSCode or the REPL 
fdplotly(json(plt_ps), style="width:680px;height:350px") # hide - for Franklin
```

For integrating over time, since the solution of the differential equation is not simply an array, but their values can be properly calculated at any time by interpolation, we use the [JuliaMath/QuadGK.jl](https://github.com/JuliaMath/QuadGK.jl) for a better time integration. Such a package is designed for one-dimensional quadrature methods.

```julia:timeintegration
using QuadGK

μ=4.0
u0 = [4.0, 6.0]
Tmax = 5000.0

ϕ(u) = sum(u.^2)

function get_means_vdp(u0, μ, ϕ, Tmax)
    tspan=(0.0,Tmax)

    vdp_sol_long = DifferentialEquations.solve(ODEProblem(vdp_du,u0,tspan,[μ]))

    ϕ_times = Tmax/100:Tmax/100:Tmax
    ϕ_mean_partialsums = [quadgk(t -> ϕ(vdp_sol_long(t)), j == 1 ? 0 : ϕ_times[j-1], ϕ_times[j], rtol=1e-8)[1] for j in 1:length(ϕ_times)]
    ϕ_mean = [sum(ϕ_mean_partialsums[1:n])/ϕ_times[n] for n = 1:length(ϕ_times)]
    return ϕ_times, ϕ_mean
end

ϕ_times, ϕ_mean = get_means_vdp(u0, μ, ϕ, Tmax)

plt_int = PlotlyJS.plot(
    PlotlyJS.scatter(;x=ϕ_times, y=ϕ_mean, line_width=2, name="ϕ_mean(T)", mode="lines", line_color="red"),
    Layout(;yaxis_range=[4.0,8.0], xaxis_title = "T", yaxis_title = "x²+y²", title="Evolution of the time average ϕᵤ(T) = (1/T)∫₀ᵀ ‖u(t)‖² dt;\nbound Φ̄ ≤ $(round(ϕ_mean[end],digits=3))"
    )
)

# display(plt_int) # hide - for VSCode or the REPL 
fdplotly(json(plt_int), style="width:680px;height:350px") # hide - for Franklin
```

For the optimization method, we use [jump-dev/SumOfSquares.jl](https://github.com/jump-dev/SumOfSquares.jl), which is the package for the Sum of Squares Programming. This is used in conjunction with [JuliaAlgebra/DynamicPolynomials.jl](https://github.com/JuliaAlgebra/DynamicPolynomials.jl), which defines a "dynamic polynomial" that works as an unknown polynomial looked upon for yielding a sum of squares form for the feasibility condition. For the SoS optimization method itself, we use the [ericphanson/SDPAFamily.jl](https://github.com/ericphanson/SDPAFamily.jl) which is an interface to several [SDPA](http://sdpa.sourceforge.net)-type optimization methods (SDPA standing for Semi-Definite Programming Algorithm). Such methods turn out to be the ones that work for the current problem (see [Fantuzzi, Goluskin, Huang, and Chernyshenko (2016)](https://epubs.siam.org/doi/abs/10.1137/15M1053347), who used similar MATLAB toolboxes).

```julia:sosvdp
using DynamicPolynomials
using SumOfSquares
using SDPAFamily

function get_bound_vdp_sos(μ, ϕ, Vdeg)
    @polyvar x y

    f = [y, μ*(1 - x^2)*y - x]

    u = [x, y]
    X = monomials([x, y], 1:Vdeg)

    solver = optimizer_with_attributes(SDPAFamily.Optimizer{Float64}, MOI.Silent() => true)
    model = SOSModel(solver)

    @variable(model, V, Poly(X))

    @variable(model, γ)
    # set_start_value(γ, 6.0) # MathOptInterface VariablePrimalStart() is not supported with SDPAFamily.Optimizer{Float64}

    dVdt  = sum(differentiate(V, u) .* f) 

    @constraint(model, γ - ϕ(u) - dVdt >= 0)

    @objective(model, Min, γ)

    JuMP.optimize!(model)

    return V, objective_value(model)
end

μ=4
ϕ(u) = sum(u.^2)
Vdeg_range = 4:2:10
optim = [get_bound_vdp_sos(μ, ϕ, Vdeg) for Vdeg in Vdeg_range]

bounds = [optim[j][end] for j in 1:length(optim)]

plt_sos = PlotlyJS.plot(
    PlotlyJS.scatter(;x=Vdeg_range[2:end], y=bounds[2:end], yaxis_log=true, line_width=2, name="bound", mode="lines+markers", line_color="green"),
    Layout(;yaxis_range=[4.0,6.0], xaxis_title = "degree of auxiliary polynomial V", yaxis_title = "bound", title="Bounds on Φ̄ for different degrees for V"
    )
)
```

```julia:sosvdpboundtable
#hideall
using PrettyTables

formatter = (v,i,j) -> j == 1 ? Int(v) : round(v, digits=3)
# pretty_table(hcat(Vdeg_range, bounds), ["degree" "bound"], header_crayon=crayon"yellow bold", formatters=formatter) # hide - - for VSCode or the REPL, instead of the following
io = IOBuffer()
pretty_table(io, hcat(Vdeg_range, bounds), ["degree" "bound"], backend=:html, standalone=false, formatters=formatter)
println("~~~", String(take!(io)), "~~~")
```

```julia:sosvdpbounds
#hideall
# display(plt_sos) # hide - for VSCode or the REPL 
fdplotly(json(plt_sos), style="width:680px;height:350px") # hide - for Franklin
```

The visualization of the auxiliary function and the corresponding orbits (both in the $xy$ plane and lifted to the auxiliary function) is done as follows.

```julia:vdpVaux
Tmax = 50.0
vdp_sol_times = 0.0:0.01:Tmax
plt_composite = []
for j=1:length(optim)
    xmesh = -4.2:0.2/j:4.2;
    ymesh = -10:0.2/(j+2):10;
    xgrid = fill(1,length(ymesh))*xmesh';
    ygrid = ymesh*fill(1,length(xmesh))';
    V = optim[j][1]
    Vmin = minimum([value(V)(x,y) for x in xmesh for y in ymesh])
    v(x,y) = log(1 + value(V)(x,y) - Vmin)
    vdp_sol_x = map(u->u[1], vdp_sol[end].(vdp_sol_times))
    vdp_sol_y = map(u->u[2], vdp_sol[end].(vdp_sol_times))
    vgrid = v.(xgrid,ygrid)
    tracesurf = PlotlyJS.scatter(;x=xgrid, y=ygrid, z = vgrid, type="surface", name="auxiliary function")
    traceline0 = PlotlyJS.scatter(;x=vdp_sol_x, y=vdp_sol_y, z=0.0*vdp_sol_x, line_width=6, line_color="orange", mode="lines", type="scatter3d", name="orbit")
    tracelinevxy = PlotlyJS.scatter(;x=vdp_sol_x, y=vdp_sol_y, z=v.(vdp_sol_x,vdp_sol_y), line_width=6, line_color="green", mode="lines", type="scatter3d", name="lifted orbit")
    push!(plt_composite, PlotlyJS.Plot([tracesurf,traceline0,tracelinevxy], Layout(;xaxis_title = "x", yaxis_title = "y", zaxis_title="z=ln(1+V-min(V))", legend_x=0.0, legend_y=1.0, title="Auxiliary function V=V(x,y) with degree m=$(Vdeg_range[j]) and bound $(round(bounds[j],digits=3))")))
end
nothing # hide - needed not to show anything with \show{vdpVaux}
```

\show{vdpVaux}

```julia:sosvdpVplots
#hideall
for j=(1,2,4)
    # display(plt_composite[j]) # hide - for VSCode or the REPL 
    fdplotly(json(plt_composite[j]), style="width:680px;height:350px") # hide - for Franklin
end
```

{{ fullcodedownload }}

## Acknowledgements

There are many people to thank for, in getting to this point, but I specifically want to thank [Chris Rackauckas](http://www.chrisrackauckas.com), for pointing me to use [JuliaMath/QuadGK.jl](https://github.com/JuliaMath/QuadGK.jl); [Eric Hanson](https://ericphanson.com), for helping me in using his package [ericphanson/SDPAFamily](https://github.com/ericphanson/SDPAFamily.jl); and [Thibaut Lienart](https://tlienart.github.io) for helping me with many of the features in his package [tlienart/Franklin.jl](https://github.com/tlienart/Franklin.jl).

## References

* [G. Fantuzzi, D. Goluskin, D. Huang, and S. I. Chernyshenko, Bounds for Deterministic and Stochastic Dynamical Systems using Sum-of-Squares Optimization, SIAM J. APPLIED DYNAMICAL SYSTEMS, Vol. 15 (2016), No. 4, pp. 1962–1988, doi.org/10.1137/15M1053347](https://epubs.siam.org/doi/abs/10.1137/15M1053347).

{{ blogcomments }}
