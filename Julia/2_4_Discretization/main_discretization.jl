#%% 2.4節：グリッドサーチで2期間モデルを解く

# 必要なパッケージを最初に読み込む
using Plots
pyplot()

# structや外部の自作関数を読み込む
include("define_struct.jl")
include("calibration.jl")
include("MyEconFcn.jl")
using .MyEconFcn

# パラメータやグリッドを呼び出す
params = calibration()

# 計算速度向上のために、計算のメインを関数にまとめる
# 別のファイルにまとめて、includeで呼び出す形でもOK
"""
2期間モデルを離散化によって解く

# インプット
`m::Models`::パラメータの構造体

# アウトプット
`obj::Vector`::価値関数
`pol::Vector`::政策関数
"""
function discretize(params::Models)

    # 配列をあらかじめ定義しておく
    obj = zeros(params.na, params.nw)
    pol = zeros(params.nw) # 政策関数

    # あらゆる(w,a)の組み合わせについて生涯効用を計算
    for i in 1:params.nw, j in 1:params.na
        cons = params.grid_w[i] - params.grid_a[j]
        if cons > 0.0
            obj[j, i] = CRRA(cons, params.γ) + params.β*CRRA((1.0+params.rent)*params.grid_a[j], params.γ)
        else
            # 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
            obj[j,i] = -10000.0
        end
    end

    # 各wについて生涯効用を最大とするようなaを探す
    for i in 1:params.nw
        maxv, maxl = findmax(obj[:,i]);
        pol[i] = params.grid_a[maxl];
    end

    return obj,pol
end

# 関数を実行&計算時間の計測
@time obj, pol = discretize(params)

# 図を描く
plt = plot(params.grid_a, obj[:,5],
    color = :blue,
    marker = :circle,
    legend = :topright,
    xlims = (0, 1),
    ylims = (-10, 0),
    title = ("生涯効用"),
    xlabel = ("若年期の貯蓄(老年期の資産)"),
    ylabel = ("生涯効用"),
    label = ("w = 0.5"),
    linewidth = 4,
    markersize = 8,
    titlefont = font("HackGen35Nerd", 12),
    guidefont = font("HackGen35Nerd", 12),
    tickfont = font("HackGen35Nerd", 8),
    framestyle = :semi
)
plot!(params.grid_a, obj[:,8], lw = 4, markershape=:utriangle, markersize = 8, label = "w = 0.8")
plot!(params.grid_a, obj[:,10], lw = 4, markershape=:rect, markersize = 8, label = "w = 1.0")
savefig("Fig2_utility_max.pdf")

plt = plot(params.grid_w, pol,
    color = :blue,
    marker = :circle,
    legend = :none,
    xlims = (0, 1.0),
    ylims = (0, 0.5),
    title = ("貯蓄関数"),
    xlabel = ("若年期の所得：w"),
    ylabel = ("若年期の貯蓄：a = g(w)"),
    linewidth = 4,
    markersize = 8,
    titlefont = font("HackGen35Nerd", 12),
    guidefont = font("HackGen35Nerd", 12),
    tickfont = font("HackGen35Nerd", 8),
    framestyle = :semi
)
savefig("Fig2_pol_discr.pdf")
