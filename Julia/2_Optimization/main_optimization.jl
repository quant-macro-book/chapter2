"""
目的:
最適化(最小化)関数を利用して2期間モデルを解く.
@author: Tokuma Suzuki
"""


#パラメータやグリッド、効用関数を定義した自作モジュールを読み込む
include("MyModule.jl")
include("obj_two_period.jl") # 所得wを所与として、2期間モデルの生涯効用の値を返す関数を読み込む
using .MyModule
using Plots
using Optim

#自作モジュールの中のパラメータやグリッドを呼び出す
model = Construct()

# 政策関数を求めるための関数
function optimization(m::Models)
    """
    政策関数を最適化を用いて求める
    
    # インプット
    `m::Models`:パラメータを含む構造体
    # アウトプット
    `a_gs::Vector`政策関数
    """
    a_gs = zeros(m.nw)
    
    # 各wについて目的関数を最大にするような貯蓄水準を求める
    for (w_ind, w_val) in enumerate(m.grid_w)
        obj_two_period!(a) = obj_two_period(a, w_val, m)
        #黄金分割法により計算
        res = optimize(obj_two_period!, w_val*0.01, w_val*2.0, GoldenSection()) 
        a_gs[w_ind] = res.minimizer
    end
    return a_gs
end

# 関数の実行
a_gs = optimization(model)
@time optimization(model) #実行時間の計測

# 解析解
coef1 = (model.β*(1.0+model.rent))^(-1.0/model.γ);
coef2 = 1.0/(1.0+coef1*(1.0+model.rent));
a_cfs = coef2*model.grid_w;

# 図を書く
plot(model.grid_w, a_gs, color = :blue, marker=:circle, label="optimization")
plot!(model.grid_w, a_cfs, color = :red, label="closed form solution" )
ylims!((0, 0.5))
xlabel!("income at period 1")
ylabel!("saving at period 1")
savefig("Fig2_optimization_comp.pdf")