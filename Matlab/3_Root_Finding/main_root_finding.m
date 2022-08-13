%% メインファイル:
% 非線形関数の根を求める関数を利用して2期間モデルを解く.

clear;
clear global;
close all;
format short;

% グローバル変数：resid_two_period.mと変数を共有
global w beta gamma rent

%% *** カリブレーション ***
beta  = 0.985.^30;     % 割引因子
gamma = 2.0;           % 相対的危険回避度
rent  = 1.025.^30-1.0; % 純利子率
%======================================

% *** パラメータ ***
nw    =  10;   % 所得グリッドの数
w_max = 1.0;   % 所得グリッドの最大値
w_min = 0.1;   % 所得グリッドの最小値
na    =  40;   % 貯蓄グリッドの数
a_max = 1.0;   % 貯蓄グリッドの最大値
a_min = 0.025; % 貯蓄グリッドの最小値
%==================================

%% 求根アルゴリズムを使って2期間モデルを解く

tic % 計算時間をカウント開始

disp(' ');
disp('-+-+-+- Solve two period model using nonlinear equation solver -+-+-+-');

% グリッドポイントを計算
grid_w = linspace(w_min, w_max, nw)';

%% 残差をプロットしてみる(最終的な結果には不要な計算)：図3

grid_a = linspace(a_min, a_max, na)';

resid1 = zeros(na, 1);
resid2 = zeros(na, 1);
resid3 = zeros(na, 1);

% w = 0.5
w = 0.5;
for i = 1:na
    resid1(i) = resid_two_period(grid_a(i));
end

% w = 0.8
w = 0.8;
for i = 1:na
    resid2(i) = resid_two_period(grid_a(i));
end

% w = 1.0
w = 1.0;
for i = 1:na
    resid3(i) = resid_two_period(grid_a(i));
end

grid_zero = zeros(na,1);

figure;
plot(grid_a, resid1, '-', 'color', 'blue', 'MarkerEdgeColor', 'b', 'MarkerSize', 12, 'linewidth', 3); hold('on');
plot(grid_a, resid2, '-.', 'color', 'green', 'MarkerEdgeColor', 'g', 'MarkerSize', 12, 'linewidth', 3);
plot(grid_a, resid3, '--', 'color', 'red', 'MarkerEdgeColor', 'r', 'MarkerSize', 12, 'linewidth', 3);
plot(grid_a, grid_zero,'-', 'color', 'black', 'linewidth', 1); hold('off');
xlabel('若年期の貯蓄：a', 'Fontsize', 16);
ylabel('残差：R(w)', 'Fontsize', 16);
xlim([0.1, 0.5]);
ylim([-1, 1]);
legend('w=0.5', 'w=0.8', 'w=1', 'Location', 'NorthEast');
set(gca,'Fontsize', 16);
grid on;
saveas (gcf,'Fig2_resid.eps','epsc2');

%% 非線形関数の根を探す関数を用いて残差をゼロにするaを探す

a_nl = zeros(nw,1);

for i = 1:nw
    w = grid_w(i);
    % 0.1は初期値：詳細は"help fzero"
    a_nl(i) = fzero(@resid_two_period, 0.01);
end

toc % 計算時間をカウント終了

%% 図を描く

figure;
plot(grid_w, a_nl, '-o', 'color', 'blue', 'MarkerEdgeColor', 'b', 'MarkerSize', 12, 'linewidth', 3);
xlabel('若年期の所得：w', 'Fontsize', 16);
ylabel('若年期の貯蓄：a', 'Fontsize', 16);
xlim([0, w_max]);
ylim([0, 0.5]);
set(gca, 'Fontsize', 16);
grid on;
saveas (gcf,'Fig2_fzero.eps','epsc2');

return;
