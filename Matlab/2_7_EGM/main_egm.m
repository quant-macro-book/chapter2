%% メインファイル:
% 非線形関数の根を求める関数を利用して2期間モデルを解く.

clear;
clear global;
close all;
format short;

% グローバル変数：resid_two_period.mと変数を共有
global beta gamma rent

%% *** カリブレーション ***
beta  = 0.985.^30;     % 割引因子
gamma = 2.0;           % 相対的危険回避度
rent  = 1.025.^30-1.0; % 純利子率
%======================================

% *** パラメータ ***
na    =  11;   % 所得グリッドの数
a_max = 0.4;   % 所得グリッドの最大値
a_min = 0.0;   % 所得グリッドの最小値
%==================================

%% 求根アルゴリズムを使って2期間モデルを解く

tic % 計算時間をカウント開始

disp(' ');
disp('-+-+-+- Solve two period model using endogenous gridpoint method -+-+-+-');

% グリッドポイントを計算
grid_a = linspace(a_min, a_max, na)';

%% EGMのアルゴリズムに沿って計算

rhs = zeros(na, 1);
cons = zeros(na, 1);

for j = 1:na
    % オイラー方程式の右辺を計算
    rhs(j) = rhs_euler(grid_a(j));
    % 限界効用関数の逆関数
    cons(j) = inv_mu_CRRA(rhs(j), gamma);
end

w = zeros(na, 1);
for j = 1:na
    w(j) = cons(j) + grid_a(j);
end

toc % 計算時間をカウント終了

%% 解析的解

coef1 = (beta*(1+rent))^(-1./gamma);
coef2 = 1.0/(1.0+coef1*(1+rent));
a_cfs = coef2.*w;

%% 図を描く

figure;
plot(w, grid_a, 'o', 'MarkerSize', 12, 'linewidth', 3); hold('on');
plot(w, a_cfs, '-.', 'MarkerSize', 12, 'linewidth', 3); hold('off');
xlabel('若年期の所得：w', 'Fontsize', 16);
ylabel('若年期の貯蓄：a', 'Fontsize', 16);
xlim([0, 1.2]);
ylim([0, 0.5]);
legend('EGM','解析的解','Location','NorthWest');
set(gca, 'Fontsize', 16);
grid on;
saveas (gcf,'Fig2_pol_egm.eps','epsc2');
saveas (gcf,'Fig2_pol_egm.pdf','pdf');

figure;
plot(w, grid_a, 'o', 'color', 'black', 'MarkerEdgeColor', 'k', 'MarkerSize', 12, 'linewidth', 3); hold('on');
plot(w, a_cfs, '-.', 'color', 'black', 'MarkerEdgeColor', 'k', 'MarkerSize', 12, 'linewidth', 3); hold('off');
xlabel('若年期の所得：w', 'Fontsize', 16);
ylabel('若年期の貯蓄：a', 'Fontsize', 16);
xlim([0, 1.2]);
ylim([0, 0.5]);
legend('EGM','解析的解','Location','NorthWest');
set(gca, 'Fontsize', 16);
grid on;
saveas (gcf,'Fig2_pol_egm_bk.eps','epsc2');
saveas (gcf,'Fig2_pol_egm_bk.pdf','pdf');

return;
