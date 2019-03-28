function resid_projection(coef, m)
    """
    選点に基づいてオイラー方程式の残差を返す

    # インプット
    `coef`:多項式の係数
    `m::Models`:パラメータを含む構造体

    # アウトプット
    `residual::Vector`:残差
    """

    a = approx_policy(coef, m.grid_w) #1期目の貯蓄

    c1 = m.grid_w - a #1期目の消費
    c2 = (1.0+m.rent)*a #2期目の消費
    ng = length(c1) # 次元を取り出す
    mu1 = zeros(ng) #1期における限界効用
    mu2 = similar(mu1) #2期における限界効用
    resid = similar(mu1) #残差
    for i in 1:ng
        if c1[i] > 0.0
            mu1[i] = mu_CRRA(c1[i], m.γ)
        else
            mu1[i] = 10000.0 #負の消費に対するペナルティ
        end

        if c2[i] > 0.0
            mu2[i] = mu_CRRA(c2[i], m.γ)
        else
            mu2[i] = 10000.0 #負の消費に対するペナルティ
        end
        resid[i] = m.β*(1.0+m.rent)*(mu2[i]/mu1[i]) - 1.0
    end

    return resid
end
