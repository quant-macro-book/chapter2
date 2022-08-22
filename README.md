# 北尾早霧・砂川武貴・山田知明『定量的マクロ経済学と数値計算』日本評論社

## 第2章：2期間モデルと数値計算の概観

* Juliaを初めて使う人は、是非、順番に読むようにしてください。モデルを解くために必要になる知識をステップ・バイ・ステップで説明をしながら、講義形式で計算していっています(実際に講義でも使っていました)。
  * Tipsを読みながら勉強してください。
* ある程度Juliaコードの解読に自信がある人には、Jupyter Notebookはやや冗長に感じるかもしれないので、`XX.jl`というJuliaコードを直接読むことをお勧めします。

* **3.2 状態変数と操作変数が共に離散の場合**の結果を再現するファイル -> main_discretization.、CRRA.m
* **4. 操作変数を連続にする：最適化**の結果を再現するファイル -> main_optimization.m、obj_two_period.m、CRRA.m
* **5.1 非線形方程式のゼロ点を探す**の結果を再現するファイル -> main_root_finding.m、resid_two_period.m、mu_CRRA.m
* **5.2 射影法**の結果を再現するファイル -> main_projection_method.m、resid_projection.m、approx_policy.m、mu_CRRA.m

## 注意
* 書籍のすべての結果について、MATLABとJuliaで再現をすることが可能です。
  * Pythonでは一部、書けている箇所があります。これはPythonでは再現ができないという訳ではありません。
  * FortranとRはグリッドサーチのみです。
* MATLABではfminsearch、fminbnd、fzeroなどの関数を使っているため、インストールされているライブラリによっては動かない可能性があります。
* Pythonではnumpy、scipy、matplotlibを呼び出しています。Anaconda経由でPythonを利用していれば。
* Juliaではいくつかのパッケージを利用しています。もし実行できない場合はREPLで`]`を押したのち、`add package name`を実行しインストールしてください。
