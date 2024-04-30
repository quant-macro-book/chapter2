"""
2期間モデルの1階条件の残差を求める

### インプット
`a::Float64`: 貯蓄水準
`w_val::Float64`: 所得水準
`m::Models`: パラメータを含む構造体

### アウトプット
残差
"""
function resid_two_period(a::Float64, w_val::Float64, params::Models)

    # オイラー方程式の左辺：若年期の限界効用
    if w_val - a > 0.0
        mu1 = mu_CRRA(w_val - a, params.γ)
    else
        mu1 = 10000.0
    end

    # 老年期の限界効用
    mu2 = mu_CRRA((1.0 + params.rent)*a, params.γ)

    # 残差(residual)
    return params.β*(1.0 + params.rent)*(mu2/mu1) - 1.0

end
