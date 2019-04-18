## 『経済セミナー』「定量的マクロ経済学と数値計算」

#### 連載第2回(2・3月号)：2期間モデルと数値計算の概観

* **3.2 状態変数と操作変数が共に離散の場合**の結果を再現するファイル -> main_discretization.、CRRA.m
* **4. 操作変数を連続にする：最適化**の結果を再現するファイル -> main_optimization.m、obj_two_period.m、CRRA.m
* **5.1 非線形方程式のゼロ点を探す**の結果を再現するファイル -> main_root_finding.m、resid_two_period.m、mu_CRRA.m
* **5.2 射影法**の結果を再現するファイル -> main_projection_method.m、resid_projection.m、approx_policy.m、mu_CRRA.m

#### 注意
* MATLABではfminsearch、fminbnd、fzeroなどを関数を使っているため、インストールされているライブラリによっては動かない可能性があります。
* Pythonではnumpy、scipy、matplotlibを呼び出しています。自分で逐一ライブラリをインストールすることも可能ですが、数値計算を行うのであれば[Anaconda](https://www.anaconda.com/)が便利です。
* Juliaではいくつかのパッケージを利用しています。もし実行できない場合はREPLで`]`を押したのち、`add package name`を実行しインストールしてください。
* MATLAB,Python,Fortran,Rについては山田知明、Juliaについては鈴木徳馬が作成しています。

#### 未完成
* **5.2 射影法**用のコードはMatlab,Juliaのみです。
* FortranとRは3.2節の状態変数と操作変数が共に離散の場合(discretization)のみです。
