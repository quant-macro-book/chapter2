function value = obj_two_period(a)
% Function obj_two_period
%  [utility] = obj_two_period(a)
%
% 目的:
% 所得wを所与として、2期間モデルの生涯効用の値を返す関数.
%
% グローバル変数: w, beta, gamma, rent

global w beta gamma rent

% 1期の効用水準
if w - a > 0.0
    util_y = CRRA(w - a, gamma);
else
    % 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
    util_y = -1000000.0;
end

% 2期の効用水準
util_o = beta*CRRA((1.0+rent)*a, gamma);

% fminbndとfminsearchは共に"最小値"を探すため、マイナスをかけて反転させる
value = -1.0*(util_y + util_o);

return;
