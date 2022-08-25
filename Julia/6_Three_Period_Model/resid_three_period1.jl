"""
3期間モデルの1階条件の残差を求める：1期目と2期目

### インプット
`a2::Float64`: 2期(1期末)の貯蓄水準
`a1::Float64`: 1期(1期期初)の貯蓄水準
`a1_nl::Float64`: 2期の貯蓄関数
`params::Models`: パラメータを含む構造体

### アウトプット
残差
"""
function resid_three_period1(a2::Float64, a1::Float64, a2_nl::Vector{Float64}, params::Models)

    # オイラー方程式の左辺：若年期の限界効用
    # 予算制約の右辺に基づいて手持ちの現金(cash on hand)を定義
    coh = (1 + params.rent)*a1 + params.y1
    if coh - a2 > 0.0 # 消費が正値
        mu1 = mu_CRRA(coh - a2, params.γ)
    else
        mu1 = 10000.0
    end

    # 中年期の消費：線形補間：毎回係数を計算するのは時間の無駄なので本当は関数の外に出したほうがよい！
    interp1 = LinearInterpolation(params.grid_a, a2_nl)
    cons = interp1(a1)

    # 中年期の限界効用
    mu2 = mu_CRRA(cons, params.γ)

    # 残差(residual)
    return params.β*(1.0 + params.rent)*(mu2/mu1) - 1.0

end
