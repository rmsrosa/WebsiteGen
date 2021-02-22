# Time average bounds via Sum of Squares

@def title = "Time average bounds via Sum of Squares"
@def authors = "R. Rosa"
@def published = "9 February 2021"
@def pt_lang = false
@def rss_pubdate = Date(2021, 2, 9)
@def rss = "Time average bounds via Sum of Squares"
@def rss_description = """A convex minimization approach and a minimax formula for obtaining optimal bounds for time averages of quantities of solutions of differential equations, and a Sum of Squares technique to approximate such bounds."""

{{ published }} | **{{ authors }}**

## Motivation

In many real-world problems, one is interested in estimating certain key quantities related to the problem. For instance, in fluid flows, quantities of interest involve kinetic energy, enstrophy, drag coefficient, energy dissipation rate, and so on. In other applications, one might be interested in mechanical stress, chemical concentration, infected population, pharmaceutical dosage, etc.

Many such problems can be resonably modeled by differential equations, which may, however, exibit complicate, perhaps chaotic dynamics. In those situations, the instantaneous value of certain quantities vary unpredictably in time, but very often their mean value is reasonably steady.

This mean value can be considered in different ways, e.g. as time average, as ensemble average, or as spatial average, and are thus more ameanable to analysis. This article considers ways to estimate time and ensemble averages of certain quantities.

## Problem setting

If a model for the problem is available in the form of an ordinary differential equation
$$ \frac{\textrm{d} u}{\textrm{d}t} = F(u),
$$
where $F:X\rightarrow X$ is some locally Lipschitz function acting in some finite-dimensional space $X=\mathbb{R}^n$, $n\in\mathbb{N}$, then, for each $u_0\in X$, there exists a unique solution $u=u(t)$ with $u(0)=u_0$. If we assume all solutions are defined globally in the futures, we obtain a continuous semigroup $\{S(t)\}_{t\geq 0}$ acting on $X$, with given by $S(t)u_0=u(t)$.

Given a function $\phi:X\rightarrow \mathbb{R}$ representing some "real" quantity we want to measure, the asymptotic superior limit of the time-average of $\phi(u(t))$ is given (and denoted) by
$$ \bar\phi(u_0) = \limsup_{T\rightarrow} \frac{1}{T} \int_0^T \phi(u(t))\;\textrm{d}t.
$$

The idea here is that we would like to find an upper bound for $\bar\phi(u_0)$, for all possible initial conditions $u_0\in B$, in some subset of interest $B\subset X$.

Assuming that $\phi$ is continuous, that $B$ is positively invariant (i.e. $u(0)\in B$ implies $u(t)\in B$, $\forall t\geq 0$.), and $B$ is compact, then $t\mapsto \phi(u(t))$ is bounded on $t\geq 0$, and the superior limit above is uniformily bounded in $u_0\in B$.

The problem, then, is to find the *best possible bound* C for $\sup_{u_0\in B}\bar\phi(u_0)$.

## Overview of some analytic and numerical methods

One way to bound $\phi(u_0)$ is to do what is called *energy-type* estimates, which amounts to multiplying the equation by appropriate terms aiming to obtain inequalities that eventually lead to an estimate for $\phi(u_0)$. Or by *variational* estimates, introducing an auxiliary function, within a special class of functions, and performing some minimization with respect to the auxiliary function.

Numerically, we can use a Monte-Carlo method and simulate the evolution of the equation in a computer, with randomly chosen initial conditions, and look for the time average over sufficiently long time intervals (sufficiently in the sense, for instance, that the finite-time average does not change much -- according to a given error -- by increasing the averaging time). Or one can vary the auxiliary function in the special class of functions and look for the best estimate.

More recently, however, a novel method is being used, which is a sort of variational technique, but in a different perspective and leading to an efficient numerical approach. There are some aspects I would like to discuss concerning this method:

1. It can be seen as a convex minimization problem;

1. When $F$ and $\phi$ are polynomials, the minimization problem can be relaxed to a P-complete problem by looking for a Sum of Squares (SoS) representation of an appropriate term, at the cost of obtaining a larger bound, but which is often near the optimal value;

1. The original convex minimization problem can be recast into a minimax problem and be showed to indeed yield the optimal estimate;

1. The optimality result above has been proved first in the finite-dimensional case and, more recently, myself and a co-author extended it to dissipative evolutionary partial differential equations.

## The Sum of Squares (SoS) problem

Looking for an expression for a nonnegative multivariate real polynomial $p=p(x)$ as a Sum of Squares (SoS) of other polynomials, i.e. $p(x) = \sum_{j=1}^k p_j(x)^2$ for other polynomials $p_j=p_j(x)$, is not a new problem. In 1885, the 21-year old Minkowski made his inaugural dissertation on quadratic polynomials conjecturing that there must exist homogeneous, nonnegative real polynomials of degree $m$ in $n$ variables, for arbitrary $m, n > 2$, which are not sums of squares of other homogeneous real polynomials. Hilbert initially attacked Minkowski's claim, but by the end of the presentation Hilbert was convinced that this might indeed be true at least starting with $n=3$. Three years later, at the age of 26, Hilbert himself proved that the claim is not true for $n=3, m=4$, but that for $n\geq 3, m\geq 6$ or for $n\geq 4, m\geq 4$, the set of nonnegative polynomials of degree $m$ in $n$ variables is indeed strictly larger than the set of sum of squares of polynomials.

Further work on the subject led him to formulate the 17th problem in his list of 23 problems presented in 1900: *must every nonnegative homogenous polynomial be expressed as a sum of squares of rational functions?*

Hilbert used tools from classical algebraic geometry at that time, without given explicit examples for the problem addressing Minkowski's dissertation. Explicit examples of homogenous polynomials which are not sum of squares of other polynomials were only given in the second half of the 20th century. One famous example is that of Motzkin:
$${\displaystyle f(x,y,z)=z^{6}+x^{4}y^{2}+x^{2}y^{4}-3x^{2}y^{2}z^{2}.}
$$
Hilbert's 17th problem was solved in the affimartive by Artin, in 1926. For further historical accounts related to Hilbert's 17th problem, see e.g. [Reznick (2000)](https://mathscinet.ams.org/mathscinet-getitem?mr=1747589).

More recently, a number of methods to actually test and find whether a given multivariate nonnegative polynomial is a sum of squares of polynomials have been devised (e.g. Shor 1980s, 1990s, Choi, Lam, Reznik 1990s). Then, [Parrilo (2000)](http://www.mit.edu/~parrilo/pubs/files/thesis.pdf) presented in his PhD thesis, and in subsequent articles (e.g. [Parrilo (2003)](https://link.springer.com/article/10.1007/s10107-003-0387-5)), several applications to differential equations, including the search for Lyapunov functions and control strategies. By the early 2000s, a number of MATLAB toolbox solvers were already available.

Applications to local stability of PDEs and, in particular to 2D fluid flows were given, respectively by Papachristodoulou and Peet (2006) and Yu, Kashima, Imura (2008).

Finally we get to the articles related to the main motivation for this pots, which is that of globally estimating quantities related to the problem at hand and the global stability of the model.

The first article which seems to exploit the technique of Sum of Squares to the global analysis of PDEs seem to be that of Goulart and Chernyshenko (2012), which considered, in particular, the global stability of fluid flows. This was soon followed by a number of works by various authors: Fantuzzi, Goluskin, Doering, Goulart, Chernyshenko, Huang, Papachristodoulou (2010s), among others (see e.g. [Chernyshenko, Goulart, Huang, and Papachristodoulou](https://royalsocietypublishing.org/doi/10.1098/rsta.2013.0350)). These culminated with the work of [Tobasco, Goluskin, and Doering (2018)](https://www.sciencedirect.com/science/article/pii/S0375960117312033?via%3Dihub) showing that the convex optimization problem can be written as a minimax problem, which can then be proved to yield an optimal result for the estimate of the asymptotic time averages mentioned earlier. In turn, this gives the expectation that relaxing the problem to use the sum of squares approach yields sharp bounds, close to the optimal one.

## The convex minimization problem

Now we begin to directly address the points raised above. Let us go back to the setting described earlier and see how the convex optimization problem appears.

One key aspect is to realize that, given any continuously differentiable function $V:X\rightarrow \mathbb{R}$, it follows, by the chain rule and integration, that the asymptotic time average of $F(u)\cdot \nabla V(u)$ satisfies

$$ \begin{aligned}
  \int_0^T F(u)\cdot \nabla V(u) \;\textrm{d}t & = \int_0^T \dot u\cdot \nabla V(u) \;\textrm{d}t \\
  & = \int_0^T \frac{\textrm{d}}{\textrm{d}t} V(F(u)) \;\textrm{d}t \\
  & = V(u(T)) - V(u(0)).
  \end{aligned}
$$

Since $B$ is assumed to be compact and positively invariant, then $V(u(t))$ is uniformly bounded in $t\geq 0$, so that
$$ \frac{1}{T} \int_0^T F(u)\cdot \nabla V(u) = \frac{V(u(T)) - V(u(0))}{T} \rightarrow 0,
$$
as $T\rightarrow \infty$. Hence, using that a bar denotes limit superior of the time-averages, we write
$$ \label{FdotnablaVvanishes} \overline{F\cdot\nabla V} = 0.
$$

Since \eqref{FdotnablaVvanishes} actually holds for the limit itself, not only the superior limit, then we may add it to $\bar\phi$ and have that
$$ \bar\phi \leq C \Leftrightarrow \overline{\phi + F\cdot\nabla V} \leq C,
$$
on $B$, for arbitrary continuously differentiable function $V$.

Since the above holds for arbitrary such $V$ and since the aim is to obtain the *best possible $C$*, in the sense of being the smallest possible one, we can write the problem of finding such bound $C$ for $\bar\phi$ as the minimization problem

$$ \sup \bar\phi \leq \inf_{(C,V)\in \mathbb{R}\times\mathcal{C}^1, \;\overline{\phi + (F\cdot \nabla V)} \leq C} C,
$$

However, if we had to check whether the time averages $\overline{\phi + (F\cdot \nabla V)}$ are smaller than or equal to $C$, for every initial condition $u_0$ in $B$, we would actually have much more work than simply checking whether $\bar\phi \leq C$. So, the idea is to require the much stronger condition that $\phi(u) + F(u)\cdot \nabla V(u) \leq C$, for every point $u$ in $B$. Notice this is not a dynamic condition. We are not solving any differential equation. The point $u$ is an arbitrary point in $B$. It is a pointwise bound, that certainly implies the time-average bound for any solution $t\mapsto u(t)$ starting at the positively invariant set $B$.

It may seem, at first, that, by requiring this stronger condition, we end up with a much worse bound. However, it turns out that the minimization process somehow compensates for that and end up yielding an optimal bound just like we would obtain by requiring only that the time-average be smaller than or equal to $C$. This magic is taken care of by the inclusion of the *auxiliary* function $V$, which is sometimes called the *reservoir* function. Notice that the time-average $\overline{F\cdot \nabla V}$ vanishes, but when considering $F\cdot \nabla V$ for arbitrary points in $B$, this term, for suitable $V$, can be negative to compensate when $\phi$ is large, and it is allowed to be positive, when $\phi$ is small, such that at the end we find a relatively small bound $C$.

Notice we don't expect $F\cdot \nabla V$ to be negative all the time, otherwise $V$ would be like a Lyapunov function, or a La Salle-type function, and the solutions would converge to the invariant set included in the set $\{V=0\}$. Some systems do have such a function, but this is not expected to exist in more complicate problems.

Now, by requiring that $\phi + F\cdot \nabla V\leq C$ holds pointwise in all $B$, instead of only along the time average of the trajectories $u(t)$, we arrive at the following minimization problem:
$$ \sup \bar\phi \leq \inf_{(C,V)\in \mathbb{R}\times\mathcal{C}^1, \;\phi + (F\cdot \nabla V) \leq C} C.
$$

We may rewrite this as
$$ \sup \bar\phi \leq \inf_{(C,V)\in \mathbb{R}\times\mathcal{C}^1, \;S_{C,V}(u)\geq 0, \forall u\in B} C, \label{convexminimizationprob}
$$
where $S_{C,V}(u) = C - \phi - (F\cdot \nabla V)$. This is a convex minimization problem, since the objetive function $(C,V)\mapsto C$ is linear, and the minimization is sought after within the set $S_{C,V}\geq 0$, which is convex since $(C,V)\mapsto S_{C,V}(u)$ is linear and the half plane is convex.

## Relaxing the minimization problem to a Sum of Squares minimization

The minimization problem \eqref{convexminimizationprob} can be NP-hard to compute. However, when the differential equation term $F$ and the quantity of interest $\phi$ are polynomials, the minimization problem can be relaxed to a P-complete convex minimization problem by restricting $V$ to be a polynomial of a given order, or some special type of polynomial, and requiring that the polynomial $S_{C,V}$ be SoS, which certainly implies the condition that it be nonnegative. That might not yield an optimal bound, but it's been show to yield pretty sharp estimates for a number of equations.

This formulation takes the precise form
$$ \sup \bar\phi \leq \inf_{(C,V)\in \mathbb{R}\times\mathrm{P}_m(X), \;S_{C,V}(u) = \texttt{SoS}} C,
$$
where above we denote by $\mathrm{P}_m(X)$ the set of real polynomials on $X$.

This problem can be regarded as a semidefinite programming. It is similar to linear programming, but in which the first orthant $x_i\geq 0$ is replace by the cone of positive semidefinite matrices $S\succeq 0$. More precisely, we may start with the *primal* problem:

$$ \text{Minimize } L\cdot S \text{ subject to } A_i\cdot S = b_i \text{ and } S \succeq 0,
$$

where $b\in \mathbb{R}^M$ is a given vector, $L$ and $A_i$ are given symmetric $N\times N$ matrices, and $S$ is the *decision* variable, also assume to be symmetric. The dot product for matrices is element-wise, i.e. $A_i\cdot A = (A_i)_{jk} A_{jk} = 0$, and $S\succeq 0$ means that $S$ is positive semidefinite, i.e. $\xi\cdot S \xi \geq 0$, for every $\xi\in \mathbb{R}^N$.

The minization problem above has the *dual* formulation
$$ \text{Maximize } b\cdot \eta \text{ subject to } \sum_{i=1}^M \eta_iA_i\preceq L,
$$
where $\eta\in\mathbb{R}^M$. Any solution of the dual problem is a lower bound for the primal problem, and, conversely, any solution of the primal problem yields an upper bound for the dual problem. In fact, this follows from
$$ L\cdot S - b\cdot \eta = L\cdot S - \sum_{i=1}^M \eta_iA_i\cdot S = (L - \sum_{i=1}^M \eta_iA_i)\cdot S \geq 0.
$$
Thus,
$$ b\cdot \eta \leq L\cdot S
$$
for any feasible $\eta$ and $S$ in each problem.

The question now is how to frame the Sum of Squares problem into a semidefinite programming one. As described in [Parrilo (2003)](https://link.springer.com/article/10.1007/s10107-003-0387-5), it is possible to write the sum of squares problem in either the primal form or the dual form. In theory, they are mathematically equivalent, but one formulation may be numerically more efficient than the other, depending on the dimension of the problem. For the sake of illustration, we describe below how to arrive at the primal problem.

So, suppose a multivariate real polynomial $p(x)$, $x\in \mathbb{R}^n$, of degree $m$ is given. It is easy to argue that, for $p(x)$ to have any chance of being a sum of squares, or just nonnegative, the degree $m$ of $p$ has to be even, say $m=2d$. It is also not difficult to argue that it can be written in the form
$$ p(x) = m(x)\cdot Sm(x), \label{mQmeq}
$$
for a symmetric matrix $S=(S_{jk})$, where
$$ \xi = \xi(x)=(1, x_1, \ldots, x_n, x_1x_1, \ldots, x_1^d, x_1^{d-1}x_2, \ldots, x_1x_n^{d-1}, x_n^d)$$
is the vector of all monomials in $x$ of degree up to $d=m/2$. The dimension of the space for $\xi(x)$ is $N=\left(\begin{matrix} n + d \\ d \end{matrix}\right)$.

For example, consider the polynomial
$$ p(x,y)= x^4 - 4x^3y - 6x^2y^2 -4xy^3 + y^4,
$$
in $(x,y)\in \mathbb{R}^2$, which we know is SoS since it is precisely $(x-y)^4$. Then, with $\xi(x,y)=(1, x, y, x^2, xy, y^2)$, we can take
$$ S = \left[
    \begin{matrix}
        0 & 0 & 0 & 0 & 0 & 0 \\
        0 & 0 & 0 & 0 & 0 & 0 \\
        0 & 0 & 0 & 0 & 0 & 0 \\
        0 & 0 & 0 & 1 & -2 & 0 \\
        0 & 0 & 0 & -2 & -6 & -2 \\
        0 & 0 & 0 & 0 & -2 & 1
    \end{matrix}
\right].
$$
Since the elements of $m$ are not algebraically independent (e.g. $x^2y^2 = (x^2)(y^2) = (xy)(xy))$, such $S$ is usually not unique. For instance, we can also take
$$ S = \left[
    \begin{matrix}
        0 & 0 & 0 & 0 & 0 & 0 \\
        0 & 0 & 0 & 0 & 0 & 0 \\
        0 & 0 & 0 & 0 & 0 & 0 \\
        0 & 0 & 0 & 1 & -2 & -3 \\
        0 & 0 & 0 & -2 & 0 & -2 \\
        0 & 0 & 0 & -3 & -2 & 1
    \end{matrix}
\right],
$$
or any convex combinations of the two.

Back to the general case \eqref{mQmeq}, if there exists a symmetric matrix $S$ which is positive semidefinite, then it can be diagonalizable with the elements $d_{ii}$ in the diagonal being all non-negative, i.e.
$$ \xi\cdot S\xi = \xi\cdot (Q^{-1}S Q)\xi = (Q\xi)\cdot D(Q\xi) = \zeta \cdot D \zeta = \sum d_{ii}\zeta_i^2 = \sum_i (\sqrt{d_{ii}}\zeta_i)^2,
$$
where $\zeta(x) = Q\xi(x)$ is a vector of polynomials in $x$. This yields that $p$ is a SoS.

Hence, the problem becomes to find a symmetric positive semidefinite matrix $S$ satisfying \eqref{mQmeq}. The polynomials $p(x)$ and $\xi(x)\cdot S\xi(x)$ are equal if, and only if, their coefficients are equal, which is a linear problem for $S$, with dimension $M=N^2 = \left(\begin{matrix} n + d \\ d \end{matrix}\right) \times \left(\begin{matrix} n + d \\ d \end{matrix}\right)$. If we define the coeficients of $p=p(x)$ by $b_i$ and those of $\xi\cdot S\xi$ by $A_i\cdot S$, $i=1,\ldots, M$, then the problem becomes to find a symmetrix matrix $S$ such that
$$ S \succeq 0, \qquad A_i S = b_i.
$$
If we further ask $S$ to minimize the quantity $L\cdot S$ for some desirable symmetric matrix $L$, then we end up with the primal semidefinite programming problem for $S$.

## The minimax formulation

The convex minimization problem \eqref{convexminimizationprob} can easily be rewritten in the minimax form

$$ \sup_{u_0\in B} \bar\phi(u_0) \leq \min_{V\in \mathcal{C}^1(B)} \max_{u\in B} \left\{\phi(u) + F(u) \cdot \nabla V(u)\right\}.
$$

With this formulation in mind, [Tobasco, Goluskin and Doering (2018)](https://www.sciencedirect.com/science/article/pii/S0375960117312033?via%3Dihub) gave a beautiful proof that the bound is actually optimal, and that the supremum at the left hand side above is achieved!:

$$ \max_{u_0\in B} \bar\phi(u_0) = \min_{V\in \mathcal{C}^1(B)} \max_{u\in B} \left\{\phi(u) + F(u) \cdot \nabla V(u)\right\}.
$$

The proof uses Ergodic Theory and a minimax principle. In a future opportunity we will go through its proof, as well as to detail the extension done to the infinite-dimensional setting, which is briefly discussed next.

## Extension to the infinite-dimensional setting

The proof in the finite dimensional case uses a few conditions that are delicate to extend to the infinite dimensional case:

1. The positively invariant set $B$ has to be compact;

1. The quantity of interest $\phi$ has to be a continuous function on the phase space $X$;

1. Borel probability mesure are Lagrangian invariant if and only if they are Eulerian invariant.

By *Lagrangian invariant* we mean the classical invariant condition $\mu(S(t)^{-1}E) = \mu(S(t)E)$, for any Borel set $E\subset X$, where $\mu$ is the Borel probability measure in question and $\{S(t)\}_{t\geq 0}$ is the semigroup generated by the equation. By *Eulerian invariant* we mean that $\mu$ has to satisfy $\int_X F(u)\cdot \nabla V(u) \;\textrm{d}\mu(u) = 0$, for all $V\in \mathcal{C}^1(X)$.

The assumption that $X$ be finite-dimensional is not a requirement per se, but it makes the above conditions hold in more generality. For instance, it suffices to have $B$ closed and bounded to have it compact. And this compactness is needed both for the passage from time average to ensemble average (i.e. average with respect to the invariant measure) and for the minimax principle.

Concerning the assumption of continuity of $\phi$, it is not a big deal in finite dimensions, but it is quite restrictive for partial differential equations. For instance, if the phase space is $L^2(\Omega)$, one cannot consider $\phi(u)$ involving derivatives of $u$. Even if we attempt to use extensions of the minimax principle, they require upper-semicontinuity of $\phi$, so even quantities like $\phi(u) = \sum_j |\partial_{x_j}u|^2$ would not work as is.

But at least for the case of a continuous quantity $\phi$ in the infinite-dimensional (e.g. kinetic energy on $L^2$), one can go around the requirement of $B$ being compact by considering dissipative systems which possess a compact attracting set.

The remaining delicate condition is the equivalence between Lagrangian and Eulerian invariance, which is by no means trivial in the infinite-dimensional case. In fact, I know of only two equations for which this has been proved: the two-dimensional Navier-Stokes equations and a globally modified Navier-Stokes equations obtained by truncating the nonlinear term. However, it is my belief that the key tool is simply that it be possible to approximate the system (any solution) by a right-invertible semigroup (e.g. Galerkin approximation or a hyperbolic/wave-type approximation) and exploit the usual a~priori estimates. It is an open field to prove this for other systems or to come up with an easily-applicable general statement.

It should be said that even the notion of Eulerian invariance needs to be relaxed to working for special types of functions $V$, which we call cylindrical test functionals. They are at the core of the notion of *statistical solution*.

As in the finite-dimensional case, we leave further details about the result in infinite dimensions to a future post. Meanwhile, the details can be found in [Rosa and Temam (arxiv 2020)](https://arxiv.org/abs/2010.06730)

**Selected References:**

* [S. I. Chernyshenko, P. Goulart, D. Huang, and A. Papachristodoulou, Philos. Trans. R. Soc. A 372 (2014), 1--18](https://royalsocietypublishing.org/doi/10.1098/rsta.2013.0350)

* [P. Goulart and S. I. Chernyshenko, Global stability analysis of fluid flows using sum-of-squares, Physica D 241 (2012) 692--704](https://www.sciencedirect.com/science/article/abs/pii/S0167278911003575?via%3Dihub)

* [P. A. Parrilo, Structured Semidefinite Programs and Semialgebraic Geometry Methods in Robustness and Optimization, PhD Thesis, CalTech 2000](http://www.mit.edu/~parrilo/pubs/files/thesis.pdf)

* [P. A. Parrilo, Semidefinite programming relaxations for semialgebraic problems, Math. Program., Ser. B 96 (2003): 293--320](https://link.springer.com/article/10.1007/s10107-003-0387-5)

* [B. Reznick, Some concrete aspects of Hilbert's 17th Problem. Real algebraic geometry and ordered structures (Baton Rouge, LA, 1996), 251--272, Contemp. Math., 253, Amer. Math. Soc., Providence, RI, 2000](https://mathscinet.ams.org/mathscinet-getitem?mr=1747589).

* [R. Rosa and R. Temam, Optimal minimax bounds for time and ensemble averages of dissipative infinite-dimensional systems with applications to the incompressible Navier-Stokes equations, arXiv:2010.06730 [math.AP], 2020](https://arxiv.org/abs/2010.06730)

* [I. Tobasco, D. Goluskin, and C. R. Doering, Optimal bounds and extremal trajectories for time averages in nonlinear dynamical systems, Physics Letters A, Volume 382 (2018), no. 6,  382--386](https://www.sciencedirect.com/science/article/pii/S0375960117312033?via%3Dihub)

{{ blogcomments }}
