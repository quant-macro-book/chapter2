function next_a = approx_policy(coef, eval)
% Function approx_policy
%  [next_asset] = approx_policy(coef, eval)
%
% 目的:
% 政策関数を多項式近似.
%
% 引数:
% coef: 多項式の係数theta
% eval: 選点(collocation)
%
% 戻り値:
% next_a: 2期における資産水準
%
% グローバル変数: dim_app nw

global dim_app nw

XX = zeros(nw, dim_app+1);

for i = 0:dim_app
    XX(:,i+1) = eval.^i;
end

next_a = XX*coef';

return;
