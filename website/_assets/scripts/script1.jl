using LinearAlgebra # HIDE
using Random:seed!  # HIDE
seed!(0)            # HIDE
                    # HIDE
x = Random.randn(5)
y = Random.randn(5)

for i in 1:5
    println(rpad("*"^i, 10, '-'), round(dot(x, y), digits=1))
end
