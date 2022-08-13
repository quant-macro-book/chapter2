"""
目的:
最適化(最小化)関数を利用して2期間モデルを解く.
注意：このファイルは同名のMATLABファイルを"翻訳(直訳)"したもので、Pythonにとって最適な書き方になっていません。
@author: Tomoaki Yamada
"""

import time
import numpy as np
import matplotlib.pyplot as plt
import my_econ_fcn as eco
from scipy.optimize import fmin

# %% カリブレーション
beta = 0.985**30  # 割引因子
gamma = 2.0  # 相対的危険回避度
rent = 1.025**30-1.0  # 純利子率

# パラメータ
nw = int(10)  # 所得グリッドの数
w_max = 1.0  # 所得グリッドの最大値
w_min = 0.1  # 所得グリッドの最小値

# 計算時間をカウント開始
start = time.time()

print("")
print("-+-+-+- Solve two period model using optimization -+-+-+-")

# グリッドポイントを計算
grid_w = np.linspace(w_min, w_max, nw)

# %% Scipyの最適化関数を使って2期間モデルを解く

pol_a = np.zeros(nw)

for i in range(nw):
    arg = (grid_w[i], beta, gamma, rent, )
    # 0.00001は初期値
    pol_a[i] = fmin(eco.obj_two_period, [0.00001], args=arg)

# 計算時間をカウント終了
elapsed_time = time.time() - start

print('-+- computation time -+-')
print(elapsed_time)

# %% 図を描く

plt.figure()
plt.plot(grid_w, pol_a, marker='o', color='blue', label='policy')
plt.title("approximated policy function")
plt.xlabel("current asset")
plt.ylabel("next asset")
plt.ylim(0, 0.5)
plt.grid(True)
plt.savefig('Fig2_optimization.pdf')
plt.show()

# %% 解析的解

coef1 = (beta*(1+rent))**(-1/gamma)
coef2 = 1/(1+coef1*(1+rent))
a_cfs = coef2*grid_w

plt.figure()
plt.plot(grid_w, a_cfs, marker='o', color='blue', label='policy')
plt.title("analytical policy function")
plt.xlabel("current asset")
plt.ylabel("next asset")
plt.ylim(0, 0.5)
plt.grid(True)
plt.savefig('Fig2_closed_form.pdf')
plt.show()
