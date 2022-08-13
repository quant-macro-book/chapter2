%% メインファイル:
% 射影法を用いて2期間モデルを解く.
% 注意：Matlab関数"fsolve"を使っているため、環境によっては動かない可能性があります.

clear;
clear global;
close all;
format long;

% グローバル変数：approx_policy.m、resid_projection.mと変数を共有
global dim_app nw grid_w beta gamma rent

%% *** カリブレーション ***
beta  = 0.985.^30;     % 割引因子
gamma = 2.0;           % 相対的危険回避度
rent  = 1.025.^30-1.0; % 純利子率
%======================================

% *** パラメータ ***
nw    =  10;  % 所得グリッドの数
w_max = 1.0;  % 所得グリッドの最大値
w_min = 0.1;  % 所得グリッドの最小値
%===========================

%% 射影法で2期間モデルを解く

tic % 計算時間をカウント開始

disp(' ');
disp('-+-+-+- Solve two period model using projection method -+-+-+-');

% 選点(collocation)を決める
grid_w = linspace(w_min, w_max, nw)';

% 多項式の次元を決定
dim_app = 1;

% 係数の初期値を当て推量(initial guess)
coef_ini = [0.1, 0.35];

% debug
%next_a = approx_policy(coef, grid_a1);

% debug
%resid = resid_projection(coef_ini);

% fsolveの設定：(i)レーベンバーグ・マルカート法を使う、(ii)反復の最大回数を1000回に設定
options = optimoptions('fsolve', 'Algorithm', 'levenberg-marquardt', 'MaxFunctionEvaluations', 1000);

% fsolveを使って、選点上で残差がゼロに近くなる係数thetaを探す
% 注意：Student editionではfsolveが入っていないかも知れません.
coef = fsolve(@resid_projection, coef_ini, options);

disp(' ');
disp('approximated psi0');
disp(coef(1));
disp('approximated psi1');
disp(coef(2));

toc % 計算時間をカウント終了

%% 解析的解

coef1 = (beta*(1+rent))^(-1/gamma);
coef2 = 1.0/(1.0+coef1*(1+rent));

icept = 0.0;
slope = coef2;

disp(' ');
disp('true psi0');
disp(icept);
disp('true psi1');
disp(slope);

%% 図を描く

% fsolveを使って得た"coef"を使って政策関数を計算
next_a = approx_policy(coef, grid_w);

figure;
plot(grid_w,next_a,'-o','color','blue','MarkerEdgeColor','b','MarkerSize',12,'linewidth',3);
xlabel('若年期の所得','Fontsize',16);
ylabel('若年期の貯蓄','Fontsize',16);
xlim([0,w_max]);
ylim([0,0.5]);
set(gca,'Fontsize',16);
grid on;
saveas (gcf,'Fig2_projection.eps','epsc2');

return;
