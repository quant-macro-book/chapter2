# 北尾早霧・砂川武貴・山田知明『定量的マクロ経済学と数値計算』日本評論社

## 第2章：2期間モデルと数値計算の概観

### Julia
* Juliaを初めて使う人は、是非、Jupyter Notebookを順番に読むようにしてください。
  * モデルを解くために必要になる知識をステップ・バイ・ステップで説明をしながら、講義形式でコードを実行します。
  * Tipsとして、Juliaの仕様についても、簡単に説明をしています。
  * Jupyter Notebookを開くのが大変な人に向けて、HTML版も用意してあります。ただし、こちらは内容を読むだけで実行は出来ません。
* ある程度Juliaコードの解読に自信がある人には、Jupyter Notebookはやや冗長に感じるかもしれないので、`XX.jl`というJuliaコードを直接読むことをお勧めします。
  * 内容はJupyter Notebookとまったく同じです。

### MATLAB
* 各節のコードを順番に置いてあります。

### Python
* Juliaと同じく、Jupyter Notebookで丁寧に説明をしています。

### Fortran&R
* 2.4節で解説をしたグリッドサーチ用コードのみ


## 注意
* 書籍のすべての結果について、JuliaとMATLAB、Pythonで再現をすることが可能です。
  * FortranとRはグリッドサーチのみです。
* MATLABではfminsearch、fminbnd、fzeroなどの関数を使っているため、インストールされているライブラリによっては動かない可能性があります。
* Pythonではnumpy、scipy、matplotlibを呼び出しています。
* Juliaではいくつかのパッケージを利用しています。もし実行できない場合はREPLで`]`を押したのち、`add package name`を実行してインストールしてください。
