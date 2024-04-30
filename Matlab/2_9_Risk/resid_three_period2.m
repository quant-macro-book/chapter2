function resid = resid_three_period2(a3)
% Function resid_three_period2
%  [residual] = resid_three_period2( a3 )
%
% 目的:
% 3期間モデルの一階条件の残差を返す関数：2期目と3期目
%
% グローバル変数: beta gamma rent a2 y2 y3 e2

global beta gamma rent a2 w2 w3 e2

% オイラー方程式の左辺：中年期の限界効用
% 予算制約の右辺に基づいて手持ちの現金(cash on hand)を定義
coh = (1 + rent)*a2 + w2*e2;
if coh - a3 > 0.0 % 消費が正値
    mu2 = mu_CRRA(coh - a3, gamma);
else
    mu2 = 10000.0;
end

% 老年期の限界効用
mu3 = mu_CRRA((1 + rent)*a3 + w3, gamma);

% 残差(residual)
resid = beta*(1.0 + rent)*(mu3/mu2) - 1.0;

return;
