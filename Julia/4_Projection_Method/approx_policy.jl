function approx_policy(coef, eval)
    """
    政策関数を多項式によって近似する
    
    # インプット
    `coef`: 多項式の係数
    `eval::Vector:選点
    
    # アウトプット
    `next_a::Matrix`:2期における資産水準
    """
    
    dim_app = length(coef) -1 
    nw = length(eval)
    XX = zeros(nw, dim_app+1)
    for i in 0:dim_app
        XX[:,i+1] = eval.^i
    end 
    next_a = XX*coef
    return next_a
end