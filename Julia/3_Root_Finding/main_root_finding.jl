"""
目的:
非線形関数の根を求める関数を利用して2期間モデルを解く.
@author: Tokuma Suzuki
"""

#パラメータやグリッド、効用関数を定義した自作モジュールを読み込む
include("MyModule.jl")
include("resid_two_period.jl") # 所得wを所与として、2期間モデルの生涯効用の値を返す関数を読み込む
using .MyModule
using Plots
using Roots

#自作モジュールの中のパラメータやグリッドを呼び出す
model = Construct()

# 関数を定義する
function Root_find(m::Models)
    """
    ゼロ点探索によって2期間モデルを解く

    # インプット
    `m::Models`:パラメータを含む構造体

    # アウトプット
    `a_nl::Vector`:政策関数
    """
    a_nl = zeros(m.nw);

    for (w_ind, w_val) in enumerate(m.grid_w)
        resid_two_period!(a) = resid_two_period(a, w_val, m)
        a_nl[w_ind] = find_zero(resid_two_period!, 0.01)
    end
    return a_nl
end

# 関数の実行
a_nl =Root_find(model)
@time Root_find(model) # 実行時間の計測

#解析解
coef1 = (model.β*(1.0+model.rent))^(-1.0/model.γ);
coef2 = 1.0/(1.0+coef1*(1.0+model.rent));
a_cfs = coef2*model.grid_w;

# 図を描く
plt1 = plot(model.grid_w, a_nl, color = :blue, marker=:circle, label="Root finding")
plot!(model.grid_w, a_cfs, color = :red, label="closed form solution" )
ylims!((0, 0.5))
xlabel!("income at period 1")
ylabel!("saving at period 1")
#savefig("Fig2_fzero_comp.pdf")
display(plt1)

# 残差をプロットしてみる　(最終的な結果には不要な計算)：図3
function resid_ex(m::Models)
    """
    本文中の残差についての図を書くための関数
    """

    resid = zeros(m.na,3)
    grid_zero = zeros(m.na)

    wlist = [0.5, 0.8, 1.0]
    for (w_ind, w_val) in enumerate(wlist)
        resid_two_period!(a) = resid_two_period(a, w_val, m)
        for j in 1:m.na
            resid[j,w_ind] = resid_two_period!(m.grid_a[j])
        end
    end
    return resid, grid_zero
end

resid, grid_zero = resid_ex(model)

plt2 = plot(model.grid_a, resid, label=["w=0.5", "w=0.8", "w=1.0"])
plot!(model.grid_a, grid_zero, label="0 reisidual")
xlims!((0.1, 0.5))
ylims!((-1.0, 1.0))
xlabel!("saving at period 1")
ylabel!("Residual")
#savefig("Fig_resid.pdf")
display(plt2)
