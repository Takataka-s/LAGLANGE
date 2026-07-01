using NCDatasets
using JLD2

# NetCDFを開く
ncfile = joinpath(@__DIR__, "../../data/0106.nc")
ds = Dataset(ncfile)

# 必要な変数だけ取得
lon   = ds["lon"][:]
lat   = ds["lat"][:]
p = ds["p"][:]
time  = ds["time"][:]

u = Float32.(ds["u"][:])
v = Float32.(ds["v"][:])
w = Float32.(ds["w"][:])

close(ds)

# 保存先
outfile = joinpath(@__DIR__, "../../data/0106.jld2")

# JLD2へ保存
jldsave(outfile;
    lon,
    lat,
    p,
    time,
    u,
    v,
    w,
)

println("Saved to $outfile")