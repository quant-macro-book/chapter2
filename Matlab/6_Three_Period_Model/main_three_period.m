%% メインファイル:
% 3期間モデルを解く.

clear;
clear global;
close all;
format short;

% グローバル変数：resid_three_period1.mと変数を共有
global beta gamma rent a1 a2 y1 y2 y3 grid_a a2_nl

%% *** カリブレーション ***
beta  = 0.985.^20;     % 割引因子
gamma = 2.0;           % 相対的危険回避度
rent  = 1.025.^20-1.0; % 純利子率
y1    = 1.0;           % 若年期の所得
y2    = 1.2;           % 中年期の所得
y3    = 0.4;           % 老年期の所得
%======================================

% *** パラメータ ***
na    =  21;   % 貯蓄グリッドの数
a_max = 2.0;   % 貯蓄グリッドの最大値
a_min = 0.0;   % 貯蓄グリッドの最小値
%==================================

%% 求根アルゴリズムを使って2期間モデルを解く

tic % 計算時間をカウント開始

disp(' ');
disp('-+-+-+- Solve three period model using nonlinear equation solver -+-+-+-');

% グリッドポイントを計算
grid_a = linspace(a_min, a_max, na)';

%% 中年期と老年期の間の意思決定

a2_nl = zeros(na, 1);

% 2期目の政策関数を計算
for i = 1:na
    a2 = grid_a(i);
    % 0.1は初期値：詳細は"help fzero"
    a2_nl(i) = fzero(@resid_three_period2, 0.01);
end


%% 若年期と中年期の間の意思決定

a1_nl = zeros(na,1);

% 1期目の政策関数を計算
for i = 1:na
    a1 = grid_a(i);
    % 0.1は初期値：詳細は"help fzero"
    a1_nl(i) = fzero(@resid_three_period1, 0.01);
end

toc % 計算時間をカウント終了

%% 図を描く

figure;
plot(grid_a, a2_nl, '-o', 'color', 'black', 'MarkerEdgeColor', 'k', 'MarkerSize', 12, 'linewidth', 3);
xlabel('中年期の資産：a2', 'Fontsize', 16);
ylabel('中年期の貯蓄：a3', 'Fontsize', 16);
xlim([0.0, 2.0]);
ylim([0.0, 2.0]);
set(gca,'Fontsize', 16);
grid on;
saveas (gcf,'Fig2_pol_three_period23.eps','epsc2');
saveas (gcf,'Fig2_pol_three_period23.pdf','pdf');

figure;
plot(grid_a, a1_nl, '-o', 'color', 'black', 'MarkerEdgeColor', 'k', 'MarkerSize', 12, 'linewidth', 3);
xlabel('若年期の資産：a1', 'Fontsize', 16);
ylabel('若年期の貯蓄：a2', 'Fontsize', 16);
xlim([0.0, 2.0]);
ylim([0.0, 2.0]);
set(gca,'Fontsize', 16);
grid on;
saveas (gcf,'Fig2_pol_three_period12.eps','epsc2');
saveas (gcf,'Fig2_pol_three_period12.pdf','pdf');

return;
