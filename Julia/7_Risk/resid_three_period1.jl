"""
3期間モデルの1階条件の残差を求める：1期目と2期目

### インプット
`a2::Float64`: 2期(1期末)の貯蓄水準
`a1::Float64`: 1期(1期期初)の貯蓄水準
`e1::Int64`: 1期の所得の状態
`a1_nl::Float64`: 2期の貯蓄関数
`params::Models`: パラメータを含む構造体

### アウトプット
残差
"""
function resid_three_period1(a2::Float64, a1::Float64, e1::Int64, a2_nl::Matrix{Float64}, params::Models)

    # オイラー方程式の左辺：若年期の限界効用
    # 予算制約の右辺に基づいて手持ちの現金(cash on hand)を定義
    coh = a1 + params.y1*params.endow[e1]
    if coh - a2 > 0.0 # 消費が正値
        mu1 = mu_CRRA(coh - a2, params.γ)
    else
        mu1 = 10000.0
    end

    mu2 = zeros(params.ny)
    for i = 1:params.ny
        # 中年期の消費：線形補間：毎回係数を計算するのは時間の無駄なので本当は関数の外に出したほうがよい！
        interp1 = LinearInterpolation(params.grid_a, a2_nl[:, i], extrapolation_bc=Line())
        a3_approx = interp1(a2)
        cons = (1 + params.rent)*a2 + params.y2*params.endow[i] - a3_approx

        # 中年期の限界効用
        mu2[i] = mu_CRRA(cons, params.γ)
    end

    # 残差(residual)
    exp_val = dot(params.tran[e1, :], mu2)
    return params.β*(1 + params.rent)*(exp_val/mu1) - 1.0

end
