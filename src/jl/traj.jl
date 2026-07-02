module Trajectory

using Dates
incklude("interp.jl")
using .Interp
export trajectory

const R = 6_371_000.0 # Earth radius [m]

"""
    step_petterssen(field, lon, lat, p, t, dt)

Petterssen法による1ステップ積分
"""
function step_petterssen(field, lon, lat, p, t, dt)

    Δt = Dates.value(dt)  # 秒

    # ---------- Predictor ----------
    u1, v1, w1 = velocity(field, lon, lat, p, t)

    dlat = (v1 * Δt) / R * 180 / π
    dlon = (u1 * Δt) / (R * cosd(lat)) * 180 / π
    dp   = w1 * Δt

    lon_mid = lon + dlon / 2
    lat_mid = lat + dlat / 2
    p_mid   = p   + dp   / 2
    t_mid   = t + Millisecond(round(Int, Δt * 500))

    # ---------- Corrector ----------
    u2, v2, w2 = velocity(field, lon_mid, lat_mid, p_mid, t_mid)

    dlat = (v2 * Δt) / R * 180 / π
    dlon = (u2 * Δt) / (R * cosd(lat_mid)) * 180 / π
    dp   = w2 * Δt

    return (
        lon + dlon,
        lat + dlat,
        p   + dp,
        t + dt,
    )
end


function trajectory(
    field,
    lon0,
    lat0,
    p0,
    t0;
    dt = Minute(-10),
    duration = Hour(72),
)

    nstep = Int(abs(duration ÷ dt))

    lon = Vector{Float64}(undef, nstep + 1)
    lat = similar(lon)
    p   = similar(lon)
    time = Vector{DateTime}(undef, nstep + 1)

    lon[1] = lon0
    lat[1] = lat0
    p[1] = p0
    time[1] = t0

    for i in 1:nstep
        lon[i+1], lat[i+1], p[i+1], time[i+1] =
            step_petterssen(
                field,
                lon[i],
                lat[i],
                p[i],
                time[i],
                dt,
            )
    end

    return (
        lon = lon,
        lat = lat,
        p = p,
        time = time,
    )
end

end