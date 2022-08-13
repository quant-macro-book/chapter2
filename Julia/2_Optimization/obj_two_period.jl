function obj_two_period(a, w_val, m::Models)
    """
    所得wを所与として、2期間モデルの生涯効用を返す
    @author Tokuma Suzuki 
    
    # インプット
    `a::Real`: 貯蓄水準
    `w_val::Real`: 所得水準
    `m::Models`: パラメータを含む構造体
    
    # アウトプット
    生涯効用:
    """
    #1期目の効用
    if w_val - a > 0.0 
        util_y = CRRA(w_val - a, m.γ)
    else
        util_y = -1000000.0 #負の消費に対するペナルティ
    end
    
    # 2期目の割引効用
    util_o = m.β*CRRA((1.0+m.rent)*a, m.γ)
    
    # optimizeが最小値を探すので、マイナスを書けることで最適な値を求める。
    return  -1.0*(util_y + util_o)
end