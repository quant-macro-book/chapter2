function calibration()

    # パラメータはここで設定をする
    β = 0.985^30
    γ = 2.0
    rent = 1.025^30 - 1.0
    nw = 10
    w_max = 1.0
    w_min = 0.1
    na = 40
    a_max = 1.0
    a_min = 0.025

    grid_w = collect(LinRange(w_min, w_max, nw))
    grid_a = collect(LinRange(a_min, a_max, na))

    return Models(β, γ, rent, nw, w_max, w_min, grid_w, na, a_max, a_min, grid_a)

end
