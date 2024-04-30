"""
選点に基づいてオイラー方程式の残差を返す

### インプット
`coef::Vector{Float64}`: 多項式の係数
`m::Models`: パラメータを含む構造体

### アウトプット
`residual::Vector`: 残差
"""
function resid_projection(coef::Vector{Float64}, params::Models)

    a = approx_policy(coef, params.grid_w)

    c1 = params.grid_w - a
    c2 = (1.0 + params.rent)*a

    mu1 = zeros(params.nw)
    mu2 = similar(mu1)
    resid = similar(mu1)

    for i = 1:params.nw
        if c1[i] > 0.0
            mu1[i] = mu_CRRA(c1[i], params.γ)
        else
            mu1[i] = 10000.0
        end

        if c2[i] > 0.0
            mu2[i] = mu_CRRA(c2[i], params.γ)
        else
            mu2[i] = 10000.0
        end
        resid[i] = params.β*(1.0 + params.rent)*(mu2[i]/mu1[i]) - 1.0
    end

    return resid
end
