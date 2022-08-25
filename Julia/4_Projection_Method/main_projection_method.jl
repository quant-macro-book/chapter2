#%% 2.6.2節：射影法で2期間モデルを解く

# 必要なパッケージを最初に読み込む
using LeastSquaresOptim
using Plots
pyplot()

# structや外部の自作関数を読み込む
include("define_struct.jl")
include("calibration.jl")
include("approx_policy.jl")
include("resid_projection.jl")
include("MyEconFcn.jl")
using .MyEconFcn

# パラメータやグリッドを呼び出す
params = calibration()

"""
射影法によって2期間モデルを解く

# インプット
`m::Models`: パラメータを含む構造体
`coef_init::Vector{Float64}`: 係数の初期予想

# アウトプット
`res.minimizer`: 非線形最小二乗法によって得られた係数
`res.converged::Bool`: 最小二乗法が収束したかを示す変数
`next_a`: 射影法によって得られる政策関数
"""
function projection(params::Models, θ_init = [0.1, 0.35])

    resid_projection!(coef) = resid_projection(coef, params)

    res = LeastSquaresOptim.optimize(resid_projection!, θ_init, LevenbergMarquardt())

    next_a = approx_policy(res.minimizer, params.grid_w)

    return res.minimizer, res.converged , next_a
end

# 関数の実行&実行時間の計測
@time res = projection(params)

# 解析解
coef1 = (params.β*(1.0+params.rent))^(-1.0/params.γ)
coef2 = 1.0/(1.0+coef1*(1.0+params.rent))
a_cfs = coef2*params.grid_w

# 図を描く
plt = plot(params.grid_w, res[3],
    color = :blue,
    marker = :circle,
    legend = :topright,
    xlims = (0, 1.0),
    ylims = (0, 0.5),
    label = ("射影法"),
    title = ("射影法から導出した政策関数"),
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
savefig("Fig2_pol_projection_method.pdf")
