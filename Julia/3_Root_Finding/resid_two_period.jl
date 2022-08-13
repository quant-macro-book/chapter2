function resid_two_period(a,w_val, m)
    """
    2期間モデルの1階条件の残差を求める

    # インプット
    `a::Real`: 貯蓄水準
    `w_val::Real`: 貯蓄水準
    `m::Models`: パラメータを含む構造体

    # アウトプット
    残差
    """
    if w_val - a > 0.0
        mu1 = mu_CRRA(w_val-a, m.γ)
    else
        mu1 = 10000.0
    end

    mu2 = mu_CRRA((1.0+m.rent)*a, m.γ)
    return m.β*(1.0+m.rent)*(mu2/mu1) - 1.0
end
