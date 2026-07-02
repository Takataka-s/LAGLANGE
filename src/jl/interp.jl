module Interp

using Interpolations

export velocity

"""
    velocity(field, lon, lat, p, t)

4次元風速場から (u,v,w) を線形補間する。
時間は前後2時刻を用いた線形補間を行う。
"""
function velocity(field, lon, lat, p, t)

    # 時刻インデックス
    it = searchsortedlast(field.time, t)

    @assert 1 <= it < length(field.time)

    t0 = field.time[it]
    t1 = field.time[it+1]

    a = (t - t0) / (t1 - t0)

    # 空間補間器
    intu0 = interpolate(
        (field.lon, field.lat, field.p),
        field.u[:, :, :, it],
        Gridded(Linear()),
    )

    intu1 = interpolate(
        (field.lon, field.lat, field.p),
        field.u[:, :, :, it+1],
        Gridded(Linear()),
    )

    intv0 = interpolate(
        (field.lon, field.lat, field.p),
        field.v[:, :, :, it],
        Gridded(Linear()),
    )

    intv1 = interpolate(
        (field.lon, field.lat, field.p),
        field.v[:, :, :, it+1],
        Gridded(Linear()),
    )

    intw0 = interpolate(
        (field.lon, field.lat, field.p),
        field.w[:, :, :, it],
        Gridded(Linear()),
    )

    intw1 = interpolate(
        (field.lon, field.lat, field.p),
        field.w[:, :, :, it+1],
        Gridded(Linear()),
    )

    u = (1-a) * intu0(lon, lat, p) + a * intu1(lon, lat, p)
    v = (1-a) * intv0(lon, lat, p) + a * intv1(lon, lat, p)
    w = (1-a) * intw0(lon, lat, p) + a * intw1(lon, lat, p)

    return u, v, w
end

end