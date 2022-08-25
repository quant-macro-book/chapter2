"""
所得wを所与として、2期間モデルの生涯効用を返す関数

### インプット
`a::Float64`: 貯蓄水準
`w_val::Float64`: 所得水準
`m::Models`: パラメータを含む構造体

### アウトプット
生涯効用
"""
function obj_two_period(a::Float64, w_val::Float64, params::Models)

    # 1期目の効用
    if w_val - a > 0.0 # c=w-a>0でないと効用は計算できない点に注意
        util_y = CRRA(w_val - a, params.γ)
    else
        util_y = -1000000.0 #負の消費に対するペナルティ
    end

    # 2期目の割引効用
    util_o = params.β*CRRA((1.0 + params.rent)*a, params.γ)

    # Juliaのoptimizeは最小値を探すので、マイナスをかけることで最適な値を求める。
    return -1.0*(util_y + util_o)

end