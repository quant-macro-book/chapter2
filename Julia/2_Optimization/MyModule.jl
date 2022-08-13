module MyModule
export Models, Constract, CRRA, mu_CRRA
using LinearAlgebra
   
struct Models{TI<:Int, TF<:AbstractFloat, TV<:Vector}
    #パラメータ
    β::TF #割引因子
    γ::TF #相対的危険回避度
    
    #要素価格
    rent::TF #純利子率
    
    #グリッド
    nw::TI #所得グリッドの数
    w_max::TF #所得グリッドの最大値
    w_min::TF #所得グリッドの最小値
    grid_w::TV #所得グリッド
    na::TI　#貯蓄グリッドの数
    a_max::TF　#貯蓄グリッドの最大値
    a_min::TF　#貯蓄グリッドの最小値
    grid_a::TV　#貯蓄グリッド
end

function Constract(;β=0.985^30,
                   γ=2.0, 
                    rent= 1.025^30 - 1.0, 
                    nw = 10, 
                    w_max = 1.0, 
                    w_min = 0.1, 
                    na = 40, 
                    a_max = 1.0, 
                    a_min = 0.025) 
        
    grid_w = collect(LinRange(w_min, w_max, nw))
    grid_a = collect(LinRange(a_min, a_max, na))
    
    return Models(β, γ, rent, nw, w_max, w_min, grid_w, na, a_max, a_min, grid_a)
end

function CRRA(cons,γ)
    """
    効用関数
    
    # インプット
    `cons::Real` 消費
    `γ::Real` 相対的リスク回避度
    
    # アウトプット
    効用
    """
    if γ != 1.0
       return cons^(1.0 -γ)/(1.0 -γ) 
    else
       return log(cons)
    end
end
    
function mu_CRRA(cons, γ)
    """
    限界効用関数
        
    # インプット
    `cons::Real`: 消費
    `γ::Real`: 相対的リスク回避度
    """
    return cons^(-γ)
end

end