#%% 2.5節：Optimを使って2期間モデルを解く

# 必要なパッケージを最初に読み込む
using Optim
using Plots
pyplot()

# structや外部の自作関数を読み込む
include("define_struct.jl")
include("calibration.jl")
include("obj_two_period.jl")
include("MyEconFcn.jl")
using .MyEconFcn

#自作モジュールの中のパラメータやグリッドを呼び出す
params = calibration()

# 政策関数を求めるための関数
"""
政策関数を最適化を用いて求める

# インプット
`m::Models`:パラメータを含む構造体
# アウトプット
`a_gs::Vector`政策関数
"""
function optimization(params::Models)
    a_gs = zeros(params.nw)

    for i = 1:params.nw
        w_val = params.grid_w[i]
        obj_two_period!(a) = obj_two_period(a, w_val, params)
        res = optimize(obj_two_period!, w_val*0.01, w_val*2.0, GoldenSection())
        a_gs[i] = res.minimizer
    end

    return a_gs
end

# 関数の実行&実行時間の計測
@time a_gs = optimization(params)

# 解析解
coef1 = (params.β*(1.0 + params.rent))^(-1.0/params.γ)
coef2 = 1.0/(1.0+coef1*(1.0 + params.rent))
a_cfs = coef2*params.grid_w

# 図を書く
plt = plot(params.grid_w, a_gs,
    color = :blue,
    marker = :circle,
    legend = :topright,
    xlims = (0, 1.0),
    ylims = (0, 0.5),
    label = ("最適化"),
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
plot!(params.grid_w, a_cfs, linewidth = 2, color = :red, label="解析的解" )
savefig("Fig2_pol_optimization.pdf")
