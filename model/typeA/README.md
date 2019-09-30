# TypeA
## このディレクトリについて
ここでTypeAのモデルを管理する。


## ファイルについて
* main.m : Matlabのメインファイル。パラメータファイルに記述されているフィルータを使ってFeedBackループを入力し、閉じた状態での振り子の状態空間モデルを出力する。
* susmodel.mat : 振り子の状態空間モデル。
* controlmodel.slx : 制御モデル。
* main.py : Pythonのメインファイル。Matlabのメインファイルで出力された状態空間モデルを元に、プロットをする。

> **補足**
> 
> [SVN](https://granite.phys.s.u-tokyo.ac.jp/svn/LCGT/trunk/VIS/SuspensionControlModel/script/TypeA/)2337のファイルを以下の通りに変更した。
> 
>* TypeA_20_180429mdl.mat -> susmodel.mat
>* TypeA_siso180515.slx -> controlmodel.slx
>* TypeA_paramNoCtrl180517.m -> param_noctrl.m
>
> 2019/08/24現在、"/kagra/Dropbox/Personal/Fujii/"にある、ファイルを以下の通りに変更した。
> 
>* TypeA/simulation/TypeAsimctrl_190821.slx -> controlmodel_ver2.slx


### 入力ファイル
* ./param/param_noctrl.m : どこも制御していない状態
* ./param/param_ipdcdamp.m :  IPLのみ制御している状態

### 出力ファイル
* ./linmod/ipdcdamp.mat : IPLのループが閉じた時の状態空間モデル
* ./linmod/ipdcdamp_oltf.mat : OLTFを調べるための状態空間モデル
* ./linmod/noctrl.mat : 制御なしの状態空間モデル
* ./servo/servoIPL.mat : IPLのサーボフィルター
* ./figure/ : 画像。
