include("../src/jl/nc2jld2.jl")
using .NC2JLD2

nc2jld2(
    joinpath(@__DIR__, "../data/0106.nc"),
    joinpath(@__DIR__, "../data/0106.jld2"),
)