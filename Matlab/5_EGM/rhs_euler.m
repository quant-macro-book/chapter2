function rhs = rhs_euler(asset)
% Function rhs_euler
%  [residual] = rhs_euler( a )
%
% 目的:
% オイラー方程式の右辺を計算.
%
% グローバル変数: beta, gamma, rent

global beta gamma rent

% 予算制約から消費を計算
cons = (1.0+rent)*asset;

% 老年期の限界効用
mu = mu_CRRA(cons, gamma);

% オイラー方程式の右辺
rhs = beta*(1.0+rent)*mu;

return;
