module MyEconFcn

#=
Collect functions used in Economics.
=#

export CRRA

"""
CRRA(cons::Float64, γ::Float64)

Purpose:
CRRA utility function.

Input:
cons → current consumption level,
γ → relative risk aversion (or inverst of the intertemporal elasticity of substitution).

Output:
util → utility level.
"""
function CRRA(cons::Float64, γ::Float64)
    if γ != 1.0
        return cons^(1.0 - γ) / (1.0 - γ)
    else
        return log(cons)
    end
end

end