"""
目的:
状態変数と操作変数を離散化して2期間モデルを解く.
@author: Tokuma Suzuki
"""

#パラメータやグリッド、効用関数を定義した自作モジュールを読み込む
include("MyModule.jl")
using .MyModule
using Plots


#自作モジュールの中のパラメータやグリッドを呼び出す
model = Construct()


# 2期の効用関数をプロットしてみる(最終的な結果には不要な計算)

util2 = model.β*CRRA.((1.0+model.rent)*model.grid_a, model.γ);

# 効用関数の図を描く
plt1 = plot(model.grid_a,util2, color=:blue,marker=:circle, legend = false)
ylims!((-14,0))
xlabel!("asset at period 2")
ylabel!("utility at period 2")
#savefig("Fig2_utility_at_period2.pdf")
display(plt1)

# 離散化によって問題を解く関数を定義
function discretize(m::Models)
    """
    2期間モデルを離散化によって解く

    # インプット
    `m::Models`::パラメータの構造体

    # アウトプット
    `obj::Vector`::価値関数
    `pol::Vector`::政策関数
    """

    #配列をあらかじめ定義しておく
    obj = zeros(m.na, m.nw)
    pol = zeros(m.nw) #政策関数

    #あらゆる(w,a)の組み合わせについて生涯効用を計算
    @inbounds for i in 1:m.nw
        @inbounds for j in 1:m.na
            cons = m.grid_w[i] - m.grid_a[j]
            if cons > 0.0
                obj[j, i] = CRRA(cons, m.γ) + m.β*　CRRA((1.0+m.rent)*m.grid_a[j], m.γ)
            else
                # 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
                obj[j,i] = -10000.0
            end
        end
    end

    #各wについて生涯効用を最大とするようなaを探す
    @inbounds for i in 1:m.nw
        maxv, maxl = findmax(obj[:,i]);
        pol[i] = m.grid_a[maxl];
    end

    return obj,pol
end

# 関数の実行
obj, pol = discretize(model);

# 計算時間の計測
@time discretize(model)

# 図を描く

plt2 = plot(model.grid_a, obj[:,5], marker=:circle, label = "w = 0.5")
plot!(model.grid_a, obj[:,8], marker=:circle, label = "w = 0.8")
plot!(model.grid_a, obj[:,10], marker=:circle, label = "w = 1.0")
title!("life time utility")
ylabel!("life-time utility")
xlabel!("saving at period 1")
ylims!((-10.0, 0.0))
#savefig("Fig2_utility_max.pdf")
display(plt2)

plt3 = plot(model.grid_w,pol, marker=:circle,label="Discretization")
title!("policy function")
ylims!((0,0.5))
xlabel!("income at period 1")
ylabel!("saving at period 1")
#savefig("Fig2_pol_discr.pdf")
display(plt3)
