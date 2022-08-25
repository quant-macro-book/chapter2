module MyEconFcn

#=
Collect functions used in Economics.
=#

export mu_CRRA

"""
mu_CRRA(cons::Float64, γ::Float64)

Purpose:
Marginal utility of CRRA utility function.

Input:
cons → current consumption level,
γ → relative risk aversion (or inverst of the intertemporal elasticity of substitution).

Output:
marginal utility.
"""
function mu_CRRA(cons::Float64, γ::Float64)
    return cons^(-γ)
end

end