"""
CRRA型効用関数の限界効用の逆関数

### インプット
`mu::Float64`: 限界効用
`γ::Float64`: 相対的危険回避度

### アウトプット
消費水準
"""
function inv_mu_CRRA(mu, γ)
    return mu^(-1/γ)
end
