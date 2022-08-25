function resid = resid_three_period1(a2)
% Function resid_three_period1
%  [residual] = resid_three_period2( a2 )
%
% 目的:
% 3期間モデルの一階条件の残差を返す関数：1期目と2期目
%
% グローバル変数: beta gamma tran endow rent a1 e1 y1 y2 grid_a a2_nl

global beta gamma tran endow rent ny a1 e1 y1 y2 grid_a a2_nl

% オイラー方程式の左辺：若年期の限界効用
% 予算制約の右辺に基づいて手持ちの現金(cash on hand)を定義
coh = a1 + y1*endow(e1);
if coh - a2 > 0.0 % 消費が正値
    mu1 = mu_CRRA(coh - a2, gamma);
else
    mu1 = 10000.0;
end

mu2 = zeros(ny, 1);

for i = 1:ny
    % 中年期の消費：線形補間：毎回係数を計算するのは時間の無駄なので本当は関数の外に出したほうがよい！
    a3_approx = interp1(grid_a, a2_nl(:, i), a2, "linear", "extrap");
    cons = (1 + rent)*a2 + y2*endow(i) - a3_approx;

    % 中年期の限界効用
    mu2(i) = mu_CRRA(cons, gamma);
end

% 残差(residual)
exp_val = dot(tran(e1, :), mu2);
resid = beta*(1.0 + rent)*(exp_val/mu1) - 1.0;

return;
