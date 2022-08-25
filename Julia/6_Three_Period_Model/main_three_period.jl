#%% 2.8節：3期間モデルを解く

# 必要なパッケージを最初に読み込む
using Interpolations
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
`params::Models`: パラメータを含む構造体

# アウトプット
`a1_nl::Vector`: 第1期の政策関数
`a2_nl::Vector`: 第2期の政策関数
"""
function three_period_model(params::Models)

    a1_nl = zeros(params.na)
    a2_nl = zeros(params.na)

    # 2期目の政策関数を計算
    for i = 1:params.na
        a2_val = params.grid_a[i]
        # 1変数のfunctionにする
        resid_three_period2!(a3) = resid_three_period2(a3, a2_val, params)
        # 0.01はゼロ点を探す際の初期値
        a2_nl[i] = find_zero(resid_three_period2!, 0.01)
    end

    # 1期目の政策関数を計算
    for i = 1:params.na
        a1_val = params.grid_a[i]
        # 1変数のfunctionにする
        resid_three_period1!(a2) = resid_three_period1(a2, a1_val, a2_nl, params)
        # 0.01はゼロ点を探す際の初期値
        a1_nl[i] = find_zero(resid_three_period1!, 0.01)
    end

    return a1_nl, a2_nl

end

# 関数の実行&実行時間の計測
@time a1_nl, a2_nl = three_period_model(params)

# 図を描く
plt = plot(params.grid_a, a2_nl,
    color = :blue,
    marker = :circle,
    legend = :none,
    xlims = (0, 2.0),
    ylims = (0, 3.0),
    label = ("EGM"),
    title = ("第2期の政策関数"),
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
savefig("Fig2_pol_three_period23.pdf")

plt = plot(params.grid_a, a1_nl,
    color = :blue,
    marker = :circle,
    legend = :none,
    xlims = (0, 2.0),
    ylims = (0, 3.0),
    label = ("EGM"),
    title = ("第1期の政策関数"),
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
savefig("Fig2_pol_three_period12.pdf")
