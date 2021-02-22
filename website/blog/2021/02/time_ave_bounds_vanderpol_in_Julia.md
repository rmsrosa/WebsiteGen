# Computing time average bounds for the Van der Pol oscillator in Julia

@def title = "Computing time average bounds for the Van der Pol oscillator in Julia"
@def authors = "R. Rosa"
@def published = "20 February 2021"
@def pt_lang = false
@def rss_pubdate = Date(2021, 2, 20)
@def rss = "Computing time average bounds for Van der Pol oscillator in Julia"
@def rss_description = """We compute time-average bounds for the Van der Pol oscillator using both the time-evolution of the differential equation and convex minimization with Sum of Squares. We use the Julia language and the SciMl and Flux ecosystems."""
@def hasplotly = true

{{ published }} | **{{ authors }}**

## Introduction

We've addressed in the previous post [Time average bounds via Sum of Squares](/blog/2021/02/time_ave_bounds_SoS/) the problem of estimating the asymptotic limit of time averages of quantities related to the solution of a differential equation.

Here, the aim is to consider an example equation, namely the Van der Pol oscillator, and use two numerical methods to obtain those bounds, namely via time evolution of the system and a convex semidefinite programming using Sum of Squares (SoS), both discussed in the previous post, in a theoretical sense. This example is addressed in details in [Fantuzzi, Goluskin, Huang, and Chernyshenko (2016)](https://epubs.siam.org/doi/abs/10.1137/15M1053347),

My main motivation, actually, is to visualize the auxiliary function that yields the optimal bound via SoS. That bound depends on the chosen degree $m$ for the auxiliary function. Here are the results for two values of $m$:

\textoutput{vdpVauxb}

We discuss, below, the details leading to these result.

## The Van der Pol oscillator

The [Van der Pol oscillator](https://en.wikipedia.org/wiki/Van_der_Pol_oscillator) originated in the study of eletrical circuits and appears in several other phenomena, from the frequency control in energy production networks, to biology and seismology.

In its simplest form, the equation reads
$$ {\displaystyle {d^{2}x \over dt^{2}} - \mu (1-x^{2}){dx \over dt}+x=0,}
$$
where $\mu>0$. This equation has the stationary solution $x(t)=0$, $\forall t\in \mathbb{R}$, and all other solutions converge to a limit cycle that oscillates symmetrically, and periodically, around the origin. The form of the limit cycle and the convergence rate to the limit cycle changes according to the value of the parameter $\mu$. Below you will find the dynamics of both $x=x(t)$ and its derivative $x'=dx(t)/dt$ for different values of $\mu$, and with the initial condition $x(0)=4.0$ and $x'(0)=6.0$. Notice that, for small $\mu$, the solution converges faster to the limit cycle, which is nearly a sinusoidal wave; while for large $\mu$, the solution converges slightly slower and the solution develops spikes, as if firing up some signal information (think neurons in biological applications).

```julia:vanderpolsolt
#hideall
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

plt_mu = [
    PlotlyJS.plot(
        [PlotlyJS.scatter(;x=vdp_sol[j].t, y=map(x->x[2], vdp_sol[j].u), line_width=1, name="dx(t)/dt", showlegend=true*(j==1), mode="lines", line_color="orange"),
        PlotlyJS.scatter(;x=vdp_sol[j].t, y=map(x->x[1], vdp_sol[j].u), line_width=3, name="x(t)", showlegend=true*(j==1),mode="lines", line_color="steelblue")],
        Layout(;xaxis_title = "t", yaxis_range=[-7.0,7.0], title="μ=$(μ_range[j])")
        )
    for j in 1:length(μ_range)
    ]

plt_comb = [plt_mu[1] plt_mu[2]; plt_mu[3] plt_mu[4]]

# display(plt_comb)
fdplotly(json(plt_comb), style="width:680px;height:500px")
```

\textoutput{vanderpolsolt}

Another common representation of the dynamics of a an autonomous system is that of phase portrait, in which we draw the orbit, or trajectory, in the phase space of the system. In this case, the phase space is $xy$, where $y=dx/dt$. We rewrite the second-order differential equation as a system of first order equations
$$ \label{vanderpolsystem}
\begin{cases}
x' = y, \\
y' = μ(1 - x^2)y - x.
\end{cases}
$$

The same trajectories above, in the two extreme values for $\mu$, are seen below in phase space.

```julia:vanderpolphasesp
#hideall
plt_phsp = [
    PlotlyJS.Plot(
        PlotlyJS.scatter(;x=map(x->x[1], vdp_sol[j].u), y=map(x->x[2], vdp_sol[j].u), line_width=2, name="(x(⋅),y(⋅))", showlegend=true*(j==1), mode="lines", line_color="steelblue"),
        Layout(;xaxis_title = "x", yaxis_title = "y", xaxis_range=[-7.0,7.0],yaxis_range=[-7.0,7.0], title="Phase portrait μ=$(μ_range[j])")
    )
    for j in (1:3:4)
]

plt_ps = [plt_phsp[1] plt_phsp[end]]
# display(plt_ps)
fdplotly(json(plt_ps), style="width:680px;height:350px")
```

\textoutput{vanderpolphasesp}

## Estimating time averages

The post [Time average bounds via Sum of Squares](/blog/2021/02/time_ave_bounds_SoS/) addressed the problem of estimating the time-average
$$ \bar\phi(u_0) = \limsup_{T\rightarrow} \frac{1}{T} \int_0^T \phi(u(t))\;\textrm{d}t,
$$
for the solutions $u=u(t), t\geq 0$, $u(0)=u_0$, of a differential equation
$$ \frac{\textrm{d} u}{\textrm{d}t} = F(u),
$$
where $\phi:X\rightarrow \mathbb{R}$ is continuous; $F:X\rightarrow X$ is some locally Lipschitz function acting in some finite-dimensional space $X=\mathbb{R}^n$, $n\in\mathbb{N}$; and assuming the solutions generate a continuous semigroup $\{S(t)\}_{t\geq 0}$, where $S(t)u_0=u(t)$.

We exemplify this here with the Van der Pol system \eqref{vanderpolsystem} and with the quantity $\phi(x,y) = x^2 + y^2$.

As we mentioned in the Introduction, the inspiration for using the Van der Pol oscillator comes from the work [Fantuzzi, Goluskin, Huang, and Chernyshenko (2016)](https://epubs.siam.org/doi/abs/10.1137/15M1053347), which explores the system in much more depth. The nice thing about it is that it is a two-dimensional system, so it makes it easier to see some properties of the SoS method.

## Bounds via direct computation of the trajectory and its time average

The most direct way to numerically estimate the bound is via a numerical evolution of the system for a sufficiently long time and taking the average. Since the system has a globally attracting limit cycle (except for the unstable fixed point at the origin), we may simply consider a single trajectory for the estimate. We use [The Julia Programming Language](https://julialang.org) for the numerical computations. More specifially, we use the [SciML/DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl) package for numerically solving the system of equations, the [JuliaMath/QuadGK.jl](https://github.com/JuliaMath/QuadGK.jl) for the one-dimensional quadrature method for computing the time-integration of the obteined solution, and the interactive [plotly/PlotlyJS.jl](https://github.com/JuliaPlots/PlotlyJS.jl), which is Julia's interface to the [plotly.js](https://plot.ly/javascript) visualization library.

```julia:timeintegration
#hideall
using QuadGK

μ=4.0
u0 = [4.0, 6.0]
Tmax = 5000.0
# tspan=(0.0,Tmax)

# vdp_sol_long = DifferentialEquations.solve(ODEProblem(vdp_du,u0,tspan,[μ]))

ϕ(u) = sum(u.^2)

# ϕ_times = Tmax/100:Tmax/100:Tmax
# ϕ_mean_partialsums = [quadgk(t -> ϕ(vdp_sol_long(t)), j == 1 ? 0 : ϕ_times[j-1], ϕ_times[j], rtol=1e-8)[1] for j in 1:length(ϕ_times)]
# ϕ_mean = [sum(ϕ_mean_partialsums[1:n])/ϕ_times[n] for n = 1:length(ϕ_times)]

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
    Layout(;xaxis_title = "T", yaxis_title = "x²+y²", title="Evolution of the time average ϕᵤ(T) = (1/T)∫₀ᵀ ‖u(t)‖² dt;\nbound Φ̄ ≤ $(ceil(1000*ϕ_mean[end])/1000)"
    )
)

# display(plt_int)
fdplotly(json(plt_int), style="width:680px;height:350px") # hide
```

\textoutput{timeintegration}

Notice we integrated for a very long time to have a proper convergence of the time average. Alternatively, knowning that a fixed fraction of the time integral over the time period converges to zero, we could start integrating at a later time and avoid the initial large values, due to the transient behavior, and the initial bumps, due to the periodic spikes in the solution and its derivative:
$$ \lim_{T\rightarrow \infty} \frac{1}{T}\int_0^T \phi(u(t))\;\textrm{d}t = \lim_{T\rightarrow \infty} \frac{1}{T}\left(\int_0^{T_*} \phi(u(t))\;\textrm{d}t + \int_{T_*}^T \phi(u(t))\;\textrm{d}t\right) \\ = \lim_{T\rightarrow \infty} \frac{1}{T}\int_{T_*}^T \phi(u(t))\;\textrm{d}t.
$$

For the value $\mu=4$, the estimate above yields $\bar\phi\leq 4.834$.

## Bounds via convex semidefinite programming with Sum of Squares

We now estimate the upper bound via optimization. As we have seen in [Time average bounds via Sum of Squares](/blog/2021/02/time_ave_bounds_SoS/), since $\phi$ and $F$ are polynomials, an upper bound is given by
$$ \label{optimprob}
  \sup \bar\phi \leq \inf\{C; \; (C,V)\in \mathbb{R}\times\mathrm{P}_m(X), \;C−ϕ−F⋅∇V = \texttt{SoS}\},
$$
where $\mathrm{P}_m(X)$ denotes the set of real polynomials on $X$,which in this case is $X=\mathbb{R}^2$. We expect the bound to become sharper as we increase the degree $m$. Recall, as discussed in the previous post, the degree has to be even, otherwise it has no chance of being nonnegative.

For solving the above problem, we use using the package [jump-dev/SumOfSquares.jl](https://github.com/jump-dev/SumOfSquares.jl), which is the package for Sum of Squares Programming. This is used in conjunction with [JuliaAlgebra/DynamicPolynomials.jl](https://github.com/JuliaAlgebra/DynamicPolynomials.jl), which defines a dynamic polynomial that works as a feasible polynomial to look for a sum of squares form for the objetive function. Finally, we use the [ericphanson/SDPAFamily.jl](https://github.com/ericphanson/SDPAFamily.jl) that is an interface to several [SDPA](http://sdpa.sourceforge.net)-type optimization methods, which turn out to be the ones that work for the current problem (see [Fantuzzi, Goluskin, Huang, and Chernyshenko (2016)](https://epubs.siam.org/doi/abs/10.1137/15M1053347)).

Below is the result of the estimate, for the degrees $m=4, 6, 8, 10$:

```julia:sosvdp
#hideall
using DynamicPolynomials
using SumOfSquares
using SDPAFamily

# """
#     function get_bound_vdp(μ, ϕ, Vdeg)
# 
# Get optimal auxiliary function and bound for the average of the given quantity `ϕ`, 
# with parameter `μ` degree `Vdeg` of the auxiliary function.
# """ # Franklin keeps warning about changing docstrings, so I commented it out
function get_bound_vdp(μ, ϕ, Vdeg)
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
optim = [get_bound_vdp(μ, ϕ, Vdeg) for Vdeg in Vdeg_range]
# model, V, status, γ = get_bound_vdp(μ, ϕ, Vdeg)

bounds = [optim[j][end] for j in 1:length(optim)]

plt_sos = PlotlyJS.plot(
    PlotlyJS.scatter(;x=Vdeg_range[2:end], y=bounds[2:end], yaxis_log=true, line_width=2, name="bound", mode="lines+markers", line_color="green"),
    Layout(;xaxis_title = "degree of auxiliary polynomial V", yaxis_title = "bound", title="Bounds on Φ̄ for different degrees for V"
    )
)
```

```julia:sosvdpboundtable
#hideall
using PrettyTables

formatter = (v,i,j) -> j == 1 ? Int(v) : round(v, digits=3)
io = IOBuffer()
pretty_table(io, hcat(Vdeg_range, bounds), ["degree" "bound"], backend=:html, standalone=false, formatters=formatter)
println("~~~", String(take!(io)), "~~~")
```

\textoutput{sosvdpboundtable}

Here we plot only of the values for $m=6, 8, 10$, for scaling reasons:

```julia:sosvdpplots
#hideall
# display(plt_sos)
fdplotly(json(plt_sos), style="width:680px;height:350px") # hide
```

\textoutput{sosvdpplots}

## Visualizing the auxiliary function

It is instructive to visualize the auxiliary function obtained for each degree. Looking at \eqref{optimprob} and its feasibility condition
$$ C−ϕ−F⋅∇V = \texttt{SoS} \geq 0,
$$
we see that $C$ is smaller, the greater $-F\cdot\nabla V$, i.e. the "closer" $F$ points to $-\nabla V$, or, in other words, the faster the orbit descends along $V$, whenever possible.

The best situation is in a gradient flow, but that is not always the case. It may not even be possible to have $F$ descend along $V$ all the time; just think of a periodic orbit, with a nontrivial auxiliary function $V$, such as in our case. Nevertheless, the longer the orbit descends along $V$, the better. With that in mind, observe the figures below. You can rotate and zoom the figure as you wish, to better observe the behavior of the limit cycle with respect to $V$. Notice how the condition just described improves as the degree of $V$ is allowed to increase.

```julia:vdpVaux
#hideall
xmesh = -4.2:0.02:4.2;
ymesh = -10:0.05:10;
xgrid = fill(1,length(ymesh))*xmesh';
ygrid = ymesh*fill(1,length(xmesh))';
plt_composite = []
for j=1:length(optim)
    V = optim[j][1]
    Vmin = minimum([value(V)(x,y) for x in xmesh for y in ymesh])
    v(x,y) = log(1 + value(V)(x,y) - Vmin)
    nstart = div(length(vdp_sol),2)
    vdp_sol_x = map(x->x[1], vdp_sol[end].u[nstart:end])
    vdp_sol_y = map(x->x[2], vdp_sol[end].u[nstart:end])
    vdp_sol_0 = 0.0*vdp_sol_x
    vdp_sol_vxy = v.(vdp_sol_x,vdp_sol_y)
    vgrid = v.(xgrid,ygrid)
    tracesurf = PlotlyJS.scatter(;x=xgrid, y=ygrid, z = vgrid, type="surface", name="auxiliary function")
    traceline0 = PlotlyJS.scatter(;x=vdp_sol_x, y=vdp_sol_y, z=vdp_sol_0, line_width=4, line_color="orange", mode="lines", type="scatter3d", name="orbit")
    tracelinevxy = PlotlyJS.scatter(;x=vdp_sol_x, y=vdp_sol_y, z=vdp_sol_vxy, line_width=4, line_color="green", mode="lines", type="scatter3d", name="lifted orbit")
    push!(plt_composite, PlotlyJS.Plot([tracesurf,traceline0,tracelinevxy], Layout(;xaxis_title = "x", yaxis_title = "y", zaxis_title="z=ln(1+V-min(V))", legend_x=0.0, legend_y=1.0, title="Auxiliary function V=V(x,y) with degree m=$(Vdeg_range[j]) and bound $(ceil(1000*bounds[j])/1000)")))
end

for j=1:length(plt_composite)
    # display(plt_composite[j])
    fdplotly(json(plt_composite[j]), style="width:680px;height:350px") # hide
end
```

\textoutput{vdpVaux}

```julia:vdpVauxb
#hideall
fdplotly(json(plt_composite[1]), style="width:680px;height:350px") # hide
fdplotly(json(plt_composite[end]), style="width:680px;height:350px") # hide
```

## Computation comparison

For this simple system, with a globally attracting limit cycle (except for the unstable fixed point at the origin), in which we can take a single trajectory to estimate the upper bound, it is computationally more efficient to do the time integration. We will illustrate, however, in a future post, that in situations in which there are many different basins of attractions and "hidden" attractors, computing a global bound via SoS might be more efficient than performing a Monte Carlo Method with hundreds of solutions.

## References

* [G. Fantuzzi, D. Goluskin, D. Huang, and S. I. Chernyshenko, Bounds for Deterministic and Stochastic Dynamical Systems using Sum-of-Squares Optimization, SIAM J. APPLIED DYNAMICAL SYSTEMS, Vol. 15 (2016), No. 4, pp. 1962–1988, doi.org/10.1137/15M1053347](https://epubs.siam.org/doi/abs/10.1137/15M1053347).

{{ blogcomments }}
