struct Models
    # パラメータ
    β::Float64 #割引因子
    γ::Float64 #相対的危険回避度

    # 要素価格
    rent::Float64 #純利子率

    # 労働所得
    y1::Float64
    y2::Float64
    y3::Float64

    # リスク
    tran::Matrix{Float64}
    endow::Vector{Float64}

    # グリッド
    na::Int64 #貯蓄グリッドの数
    ny::Int64 #所得グリッドの数
    a_max::Float64 #貯蓄グリッドの最大値
    a_min::Float64 #貯蓄グリッドの最小値
    grid_a::Vector{Float64} #貯蓄グリッド
end
