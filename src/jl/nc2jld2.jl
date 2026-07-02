module NC2JLD2

using NCDatasets
using JLD2

export nc2jld2

function nc2jld2(
    infile::AbstractString,
    outfile::AbstractString,
)
    Dataset(infile) do ds
        lon   = ds["lon"][:]
        lat   = ds["lat"][:]
        p     = ds["p"][:]
        time  = ds["time"][:]

        u = (ds["u"][:])
        v = (ds["v"][:])
        w = (ds["w"][:])

        jldsave(outfile;
            lon,
            lat,
            p,
            time,
            u,
            v,
            w,
        )
    end
end

end # module