"""
3期間モデルの1階条件の残差を求める：2期目と3期目

### インプット
`a3::Float64`: 3期(2期末)の貯蓄水準
`a2::Float64`: 2期(2期期初)の貯蓄水準
`params::Models`: パラメータを含む構造体

### アウトプット
残差
"""
function resid_three_period2(a3::Float64, a2::Float64, params::Models)

    # オイラー方程式の左辺：中年期の限界効用
    # 予算制約の右辺に基づいて手持ちの現金(cash on hand)を定義
    coh = (1 + params.rent)*a2 + params.y2
    if coh - a3 > 0.0 # 消費が正値
        mu2 = mu_CRRA(coh - a3, params.γ)
    else
        mu2 = 10000.0
    end

    # 老年期の限界効用
    mu3 = mu_CRRA((1 + params.rent)*a3 + params.y3, params.γ)

    # 残差(residual)
    return params.β*(1.0 + params.rent)*(mu3/mu2) - 1.0

end
