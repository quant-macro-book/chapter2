"""
政策関数を多項式によって近似する

### インプット
`coef::Vector{Float64}`: 多項式の係数
`eval::Vector{Float64}`: 選点

### アウトプット
`next_a::Vector{Float64}`: 2期における選点上の資産水準
"""
function approx_policy(coef::Vector{Float64}, colloc::Vector{Float64})
    dim_app = length(coef) - 1
    nw = length(colloc) # paramsを引数としていないのでnwを関数内で確認
    poly = zeros(nw, dim_app+1)
    for i = 0:dim_app
        poly[:, i+1] = colloc.^i
    end
    next_a = poly*coef
    return next_a
end
