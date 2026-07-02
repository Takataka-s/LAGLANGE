module Loader

using JLD2

export load_field

"""
    load_field(file)

1つのJLD2ファイルを読み込む。
"""
function load_field(file::AbstractString)
    data = load(file)

    return WindField(
        data["lon"],
        data["lat"],
        data["p"],
        data["time"],
        data["u"],
        data["v"],
        data["w"],
    )
end

"""
    load_field(file1, file2)

2つのJLD2ファイルを時間方向に結合して読み込む。
"""
function load_field(
    file1::AbstractString,
    file2::AbstractString,
)
    f1 = load_field(file1)
    f2 = load_field(file2)

    return WindField(
        f1.lon,
        f1.lat,
        f1.p,
        vcat(f1.time, f2.time),
        cat(f1.u, f2.u; dims=4),
        cat(f1.v, f2.v; dims=4),
        cat(f1.w, f2.w; dims=4),
    )
end

end