#%% 2.6.1節：Rootsを使って2期間モデルを解く

# 必要なパッケージを最初に読み込む
using Roots
using Plots
pyplot()

# structや外部の自作関数を読み込む
include("define_struct.jl")
include("calibration.jl")
include("resid_two_period.jl")
include("MyEconFcn.jl")
using .MyEconFcn

# パラメータやグリッドを呼び出す
params = calibration()

# 関数を定義する
"""
ゼロ点探索によって2期間モデルを解く

# インプット
`m::Models`:パラメータを含む構造体

# アウトプット
`a_nl::Vector`:政策関数
"""
function Root_find(params::Models)
    a_nl = zeros(params.nw)
    for i = 1:params.nw
        w_val = params.grid_w[i]
        resid_two_period!(a) = resid_two_period(a, w_val, params)
        a_nl[i] = find_zero(resid_two_period!, 0.01)
    end
    return a_nl
end

# 関数の実行&実行時間の計測
@time a_nl = Root_find(params)

#解析解
coef1 = (params.β*(1.0+params.rent))^(-1.0/params.γ)
coef2 = 1.0/(1.0+coef1*(1.0+params.rent))
a_cfs = coef2*params.grid_w;

# 図を描く
plt = plot(params.grid_w, a_nl,
    color = :blue,
    marker = :circle,
    legend = :topright,
    xlims = (0, 1.0),
    ylims = (0, 0.5),
    label = ("求根アルゴリズム"),
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
plot!(params.grid_w, a_cfs, linewidth = 2, color = :red, label="解析的解")
savefig("Fig2_pol_root_finding.pdf")
