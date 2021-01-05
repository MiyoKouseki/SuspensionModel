# TypeA
## このディレクトリについて
ここでTypeAのモデルを管理する。


## ファイル構成
VISのモデル計算には、Mathematica, Matlab, Python を使う。振り子の剛体モデル計算には Mathematica の SUMCONをつかい、制御トポロジーの設計は Matlab のSimulink をつかう。振り子モデルは状態空間モデルで表現され、"susmodel.mat" ファイルで出力される。制御モデルは  "controlmodel.slx" で配線が定義される。そして、これらモデルをつかって、Matlab で閉ループの状態空間モデルを再計算し（main.m）、制御時の振り子のモデルを計算する。伝達関数などのプロットには Python をつかう。（ゆくゆくはすべてPythonで閉じたい。）

使用ファイルは リビジョンが 2337 の [SVN](https://granite.phys.s.u-tokyo.ac.jp/svn/LCGT/trunk/VIS/SuspensionControlModel/script/TypeA/)にあったものをコピーした。

| ファイル | 説明 |
| --- | --- |
| **./susmodel.mat** | 振り子の状態空間モデル。"TypeA20180429mdl.mat" からコピーした。|
| **./controlmodel.slx** | Simulinkの制御モデル。"TypeA_siso180515.slx" からコピーした。|
|**./main.m** | 閉ループ伝達関数を出力する。./param/param_*.mat ファイルに記述されているフィルターの情報を制御モデルに代入し、制御ループを閉じた状態でのABCD行列を計算し、./linmod 以下に mat ファイルを保存する。ちなみに、param_noctrl.m は TypeA_paramNoCtrl180517.m からコピーした。|
| **./main.py** | Pythonのメインファイル。 main.m で生成されたABCD行列を元にしてプロットするだけの関数。|

### slx, mat
svn 3026

* ./check_exportvsmake.m : SUMCONが出力したABCD行列をSimulinkモデルに変換して、それが手作りのモデルと一致するか確認する。
*  ./ETMY_exporttest.m : SUMCONが出力したABCD行列。
*   ./hoge.slx : ./ETMY_exporttest.m から生成したSimulinkモデル。input 81, output 162 の剛体モデルの箱。 
* ./ETMX.slx : input81,output162 の剛体モデルの箱。これも自動生成したと思われる。  
* ./ETMX.mat：?
* TypeA_siso180515_export.slx : SVN にはなかったが、Dropboxにはあった。入力135、出力270の剛体モデルの箱。 HLができてる。
* 


## 振り子の状態空間モデル(susmodel.mat)

(状態変数は何とか、説明)


