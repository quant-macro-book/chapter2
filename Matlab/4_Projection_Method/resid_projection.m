function resid = resid_projection(coef)
% Function resid_projection
%  [residual] = resid_projection(coef)
%
% 目的:
% 選点(collocation)に基づいて、オイラー方程式の残差を返す関数.
%
% 引数:
% 多項式の係数theta: 1 x 2
%
% 戻り値:
% residual: nw x 1
%
% グローバル変数: w, beta, gamma, rent

global grid_w beta gamma rent

% 係数thetaを使って政策関数を計算
a = approx_policy(coef, grid_w);

% 各wにおける1期の消費水準を計算
c1 = grid_w - a;

[r,c] = size(c1);
ng    = max(r,c);

% 1期における限界効用
mu1 = zeros(ng,1);
for i = 1:ng
    if c1(i) > 0.0
        mu1(i) = mu_CRRA(c1(i), gamma);
    else
        % 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
        mu1(i) = 10000.0;
    end
end

% 2期の消費水準
c2 = (1.0+rent).*a;

% 2期における限界効用
mu2 = zeros(ng,1);
for i = 1:ng
    if c2(i) > 0.0
        mu2(i) = mu_CRRA(c2(i), gamma);
    else
        mu2(i) = 10000.0;
    end
end

% 残差
resid = beta*(1.0+rent)*(mu2./mu1) - 1.0;

return;

