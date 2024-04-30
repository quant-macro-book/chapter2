#%% 2.7節：EGMを使って2期間モデルを解く

# 必要なパッケージを最初に読み込む
using Plots
pyplot()

# structや外部の自作関数を読み込む
include("define_struct.jl")
include("calibration.jl")
include("rhs_euler.jl")
include("inv_mu_CRRA.jl")
include("MyEconFcn.jl")
using .MyEconFcn

# パラメータやグリッドを呼び出す
params = calibration()

# 関数を定義する
"""
EGMによって2期間モデルを解く

# インプット
`m::Models`: パラメータを含む構造体

# アウトプット
`cons::Vector{Float64}`: 消費
`w::Vector{Float64}`: 所得
"""
function end_grid_method(params::Models)

    rhs = zeros(params.na)
    cons = zeros(params.na)

    for j = 1:params.na
        # オイラー方程式の右辺を計算
        rhs[j] = rhs_euler(params.grid_a[j], params)
        # 逆関数から若年期の消費を計算
        cons[j] = inv_mu_CRRA(rhs[j], params.γ)
    end

    w = zeros(params.na)
    for j = 1:params.na
        w[j] = cons[j] + params.grid_a[j]
    end

    return cons, w

end

# 関数の実行&実行時間の計測
@time cons, w = end_grid_method(params)

#解析解
coef1 = (params.β*(1.0+params.rent))^(-1.0/params.γ)
coef2 = 1.0/(1.0+coef1*(1.0+params.rent))
a_cfs = coef2*w

# 図を描く
plt = plot(w, params.grid_a,
    color = :blue,
    marker = :circle,
    legend = :topleft,
    xlims = (0, 1.5),
    ylims = (0, 0.5),
    label = ("EGM"),
    title = ("EGMから導出した政策関数"),
    xlabel = ("若年期の所得：w"),
    ylabel = ("若年期の貯蓄：a"),
    linewidth = 4,
    markersize = 8,
    titlefont = font("HackGen35Nerd", 12),
    guidefont = font("HackGen35Nerd", 12),
    tickfont = font("HackGen35Nerd", 8),
    legend_font_family = ("HackGen35Nerd"),
    legendfontsize = 12,
    framestyle = :semi
)
plot!(w, a_cfs, linewidth = 2, color = :red, label="解析的解")
savefig("Fig2_pol_egm.pdf")
