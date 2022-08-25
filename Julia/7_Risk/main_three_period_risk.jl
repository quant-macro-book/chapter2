#%% 2.9節：3期間モデル+リスクを解く

# 必要なパッケージを最初に読み込む
using Interpolations
using LinearAlgebra
using Plots
pyplot()
using Roots

# structや外部の自作関数を読み込む
include("define_struct.jl")
include("calibration.jl")
include("resid_three_period2.jl")
include("resid_three_period1.jl")
include("MyEconFcn.jl")
using .MyEconFcn

# パラメータやグリッドを呼び出す
params = calibration()

# 関数を定義する
"""
ゼロ点探索によって3期間モデルを解く

# インプット
`m::Models`: パラメータを含む構造体

# アウトプット
`a1_nl::Vector`: 第1期の政策関数
`a2_nl::Vector`: 第2期の政策関数
"""
function three_period_model(params::Models)

    a1_nl = zeros(params.na, params.ny)
    a2_nl = zeros(params.na, params.ny)

    # 2期目の政策関数を計算
    for i = 1:length(params.endow), j = 1:params.na
        a2_val = params.grid_a[j]
        # 1変数のfunctionにする
        resid_three_period2!(a3) = resid_three_period2(a3, a2_val, i, params)
        # 0.01はゼロ点を探す際の初期値
        a2_nl[j, i] = find_zero(resid_three_period2!, 0.01)
    end

    # 1期目の政策関数を計算
    for i = 1:length(params.endow), j = 1:params.na
        a1_val = params.grid_a[j]
        # 1変数のfunctionにする
        resid_three_period1!(a2) = resid_three_period1(a2, a1_val, i, a2_nl, params)
        # 0.01はゼロ点を探す際の初期値
        a1_nl[j, i] = find_zero(resid_three_period1!, 0.01)
    end

    return a1_nl, a2_nl

end

# 関数の実行&実行時間の計測
@time a1_nl, a2_nl = three_period_model(params)

# 図を描く
plt = plot(params.grid_a, a2_nl[:, 1],
    color = :blue,
    marker = :circle,
    legend = :topleft,
    xlims = (0, 2.0),
    ylims = (0, 2.0),
    label = ("y2=低"),
    xlabel = ("中年期の資産：a2"),
    ylabel = ("中年期の貯蓄：a3"),
    linewidth = 4,
    markersize = 8,
    titlefont = font("HackGen35Nerd", 12),
    guidefont = font("HackGen35Nerd", 12),
    tickfont = font("HackGen35Nerd", 8),
    legend_font_family = ("HackGen35Nerd"),
    legendfontsize = 12,
    framestyle = :semi
)
plot!(params.grid_a, a2_nl[:, 2], markershape=:utriangle, markersize = 8, linestyle = :dot, linewidth = 4, color = :red, label="y2=中")
plot!(params.grid_a, a2_nl[:, 3], markershape=:rect, markersize = 8, linestyle = :dash, linewidth = 4, color = :green, label="y2=高")
savefig("Fig2_pol_three_period23_risk.pdf")

plt = plot(params.grid_a, a1_nl[:, 1],
    color = :blue,
    marker = :circle,
    legend = :topleft,
    xlims = (0, 2.0),
    ylims = (0, 2.0),
    label = ("y1=低"),
    xlabel = ("若年期の資産：a1"),
    ylabel = ("若年期の貯蓄：a2"),
    linewidth = 4,
    markersize = 8,
    titlefont = font("HackGen35Nerd", 12),
    guidefont = font("HackGen35Nerd", 12),
    tickfont = font("HackGen35Nerd", 8),
    legend_font_family = ("HackGen35Nerd"),
    legendfontsize = 12,
    framestyle = :semi
)
plot!(params.grid_a, a1_nl[:, 2], markershape=:utriangle, markersize = 8, linestyle = :dot, linewidth = 4, color = :red, label="y1=中")
plot!(params.grid_a, a1_nl[:, 3], markershape=:rect, markersize = 8, linestyle = :dash, linewidth = 4, color = :green, label="y1=高")
savefig("Fig2_pol_three_period12_risk.pdf")
