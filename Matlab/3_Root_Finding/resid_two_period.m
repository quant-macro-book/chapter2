function resid = resid_two_period(a)
% Function resid_two_period
%  [residual] = resid_two_period( a )
%
% 目的:
% 2期間モデルの一階条件の残差を返す関数.
%
% グローバル変数: w, beta, gamma, rent

global w beta gamma rent

% 1期の限界効用
if w - a > 0.0
    mu1 = mu_CRRA(w - a, gamma);
else
    % 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
    mu1 = 10000.0;
end

% 2期の限界効用
mu2 = mu_CRRA((1.0+rent)*a, gamma);

% 残差
resid = beta*(1.0+rent)*(mu2/mu1) - 1.0;

return;
