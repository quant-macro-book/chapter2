"""
射影法を用いて2期間モデルを解く.
@author Tokuma Suzuki
"""

#パラメータやグリッド、効用関数を定義した自作モジュールを読み込む
include("MyModule.jl")
include("resid_projection.jl")
include("approx_policy.jl")

using .MyModule
using Plots
using LeastSquaresOptim #射影法

#自作モジュールの中のパラメータやグリッドを呼び出す
model = Construct()

function projection(m::Models, coef_init=[0.1, 0.35])
    """
    射影法によって2期間モデルを解く

    # インプット
    `m::Models`: パラメータを含む構造体
    `coef_init::Vector`:係数の初期予想

    # アウトプット
    `res.minimizer`:非線形最小二乗法によって得られた係数
    `res.converged::Bool`:最小二乗法が収束したかを示す変数
    `next_a`:射影法によって得られる政策関数
    """

    # 多項式の次元を決定
    #dim_app = 1　今回のコーディングでは必要としない
    resid_projection!(coef) = resid_projection(coef, m)

    # レーベンバーグ・マルカート法で非線形最小二乗法を行う
    # LeastSquaresOptim.jl パッケージを利用 QuantEcon参照
    res = LeastSquaresOptim.optimize(resid_projection!,
                                     coef_init, LevenbergMarquardt())

    #ゼロ点探索によって得た係数を使って政策関数を求める
    next_a = approx_policy(res.minimizer, m.grid_w)

    return res.minimizer, res.converged , next_a
end

#関数の実行
res = projection(model)
@time projection(model) #実行時間の計測

#解析解
coef1 = (model.β*(1.0+model.rent))^(-1.0/model.γ);
coef2 = 1.0/(1.0+coef1*(1.0+model.rent));
a_cfs = coef2*model.grid_w;

#図を描く
plot(model.grid_w, res[3], color = :blue, marker=:circle, label="Projection")
plot!(model.grid_w, a_cfs, color = :red, label="closed form solution" )
ylims!((0, 0.5))
xlabel!("income at period 1")
ylabel!("saving at period 1")
savefig("Fig2_projection.pdf")
