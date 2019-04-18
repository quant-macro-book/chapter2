# メインファイル
# 状態変数と操作変数を離散化して2期間モデルを解く.

# environmentから変数をクリア
rm(list=ls())

source("CRRA.R")

# カリブレーション
beta  <- 0.985**30     # 割引因子
gamma <- 2.0           # 相対的危険回避度
rent  <- 1.025**30-1.0 # 純利子率

# パラメータ
nw <- 10 # 所得グリッドの数
na <- 40 # 貯蓄グリッドの数
w_max <- 1.0   # 所得グリッドの最大値
w_min <- 0.1   # 所得グリッドの最小値
a_max <- 1.0   # 貯蓄グリッドの最大値
a_min <- 0.025 # 貯蓄グリッドの最小値

# 計算開始
time_start <- proc.time()

cat('', "\n")
cat('-+- Solve two period model using discretization -+-', "\n")
cat('', "\n")

# グリッドポイントを計算
grid_w <- seq(from = w_min, to = w_max, length.out = nw)
grid_a <- seq(from = a_min, to = a_max, length.out = na)

# あらゆる(w,a)の組み合わせについて生涯効用を計算

# 初期化
obj <- matrix(data = 0.0, nrow = na, ncol = nw)

for (i in 1:nw) {
    for (j in 1:na) {
        cons   <- grid_w[i] - grid_a[j]
        if (cons > 0.0) {
            obj[j, i] <- CRRA(cons, gamma) + beta*CRRA((1.0+rent)*grid_a[j], gamma)
        } else {
            obj[j, i] <- -10000.0
        }
    }
}

# 効用を最大にする操作変数を探し出す：政策関数

# 初期化
pol <- matrix(data = 0.0, nrow = nw, ncol = 1)

# 各wについて生涯効用を最大にするaを探す
for (i in 1:nw) {
    maxl <- which.max(obj[1:na, i])
    pol[i] = grid_a[maxl]
}

# 計算時間をカウント終了
cat(" Time = ", proc.time() - time_start, "\n")
cat('', "\n")

# 図を描く

library("ggplot2")
library("extrafont")

# Figure 1: value function
df <- data.frame(grid = grid_w, policy = pol)

g1 <- ggplot()
g1 <- g1 + geom_line(data=df, aes(x = grid, y = policy), size=1.5)
g1 <- g1 + labs(title="Policy Function", x="Wage: w", y="Saving: a")
plot(g1)
ggsave(file = "Fig_pol_discr.eps", width = 8, height = 6)

