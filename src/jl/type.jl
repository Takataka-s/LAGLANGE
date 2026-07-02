struct WindField
    lon::Vector{Float32}
    lat::Vector{Float32}
    p::Vector{Float32}
    time::Vector{DateTime}
    u::Array{Float32,4}
    v::Array{Float32,4}
    w::Array{Float32,4}
end
