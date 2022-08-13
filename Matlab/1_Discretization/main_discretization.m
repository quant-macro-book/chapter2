%% メインファイル:
% 状態変数と操作変数を離散化して2期間モデルを解く.

clear;
clear global;
close all;
format short;

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

tic % 計算時間をカウント開始

disp(' ');
disp('-+-+-+- Solve two period model using discretization -+-+-+-');

%% グリッドポイントを計算

grid_w = linspace(w_min, w_max, nw)';
grid_a = linspace(a_min, a_max, na)';


%% 2期の効用関数をプロットしてみる(最終的な結果には不要な計算)

util2 = beta.*CRRA((1.0+rent).*grid_a, gamma);

% 効用関数の図を描く
figure;
plot(grid_a,util2,'-o','color','blue','MarkerEdgeColor','b','MarkerSize',12,'linewidth',3);
xlabel('老年期の資産','Fontsize',16);
ylabel('老年期の効用','Fontsize',16);
xlim([a_min,a_max]);
set(gca,'Fontsize',16);
grid on;
saveas (gcf,'Fig2_utility_at_period2.eps','epsc2');

%% あらゆる(w,a)の組み合わせについて生涯効用を計算

obj = zeros(na, nw);

for i = 1:nw
    for j = 1:na
        cons = grid_w(i) - grid_a(j);
        if cons > 0.0
            obj(j, i) = CRRA(cons, gamma) + beta*CRRA((1.0+rent)*grid_a(j), gamma);
        else
            % 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
            obj(j, i) = -10000.0;
        end
    end
end

%% 効用を最大にする操作変数を探し出す：政策関数

pol = zeros(nw,1);

% 各wについて生涯効用を最大にするaを探す
for i = 1:nw
    [maxv, maxl] = max(obj(:,i));
    pol(i) = grid_a(maxl);
end

toc % 計算時間をカウント終了

%% 図を描く

figure;
plot(grid_a,obj(:, 5), '-o', 'color', 'blue', 'MarkerEdgeColor', 'b', 'MarkerSize', 12, 'linewidth', 3); hold('on');
plot(grid_a,obj(:, 8), '-.^', 'color', 'green', 'MarkerEdgeColor', 'g', 'MarkerSize', 12, 'linewidth', 3);
plot(grid_a,obj(:, 10), '--s', 'color', 'red', 'MarkerEdgeColor', 'r', 'MarkerSize', 12, 'linewidth', 3); hold('off');
xlabel('若年期の貯蓄(老年期の資産)：a', 'Fontsize', 16);
ylabel('生涯効用：U(c_{1},c_{2})', 'Fontsize', 16);
xlim([0.0, a_max]);
ylim([-10.0, 0.0]);
set(gca,'Fontsize', 16);
legend('w=0.5', 'w=0.8', 'w=1.0', 'Location', 'NorthEast');
grid on;
saveas (gcf,'Fig2_utility_max.eps','epsc2');

figure;
plot(grid_w,pol, '-o', 'color', 'blue', 'MarkerEdgeColor', 'b', 'MarkerSize', 12, 'linewidth', 3);
xlabel('若年期の所得：w', 'Fontsize', 16);
ylabel('若年期の貯蓄：a', 'Fontsize', 16);
xlim([0, 1]);
ylim([0, 0.5]);
set(gca, 'Fontsize', 16);
grid on;
saveas (gcf,'Fig2_pol_discr.eps','epsc2');

return;
