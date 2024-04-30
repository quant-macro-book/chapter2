"""
オイラー方程式の右辺を計算して返す関数

### インプット
`a::Float64`: 貯蓄水準
`params::Models`: パラメータを含む構造体

### アウトプット
残差
"""
function rhs_euler(a::Float64, params::Models)

    # 老年期の限界効用
    mu = mu_CRRA((1.0 + params.rent)*a, params.γ)

    # オイラー方程式の右辺
    return params.β*(1.0 + params.rent)*mu

end
