# TypeA
## このディレクトリについて
ここでTypeAのモデルを管理する。


## ファイル構成
VISのモデル計算には、Mathematica, Matlab, Python を使う。振り子の剛体モデル計算には Mathematica の SUMCONをつかい、制御トポロジーの設計は Matlab のSimulink をつかう。振り子モデルは状態空間モデルで表現され、"susmodel.mat" ファイルで出力される。制御モデルは  "controlmodel.slx" で配線が定義される。そして、これらモデルをつかって、Matlab で閉ループの状態空間モデルを再計算し（main.m）、制御時の振り子のモデルを計算する。伝達関数などのプロットには Python をつかう。（ゆくゆくはすべてPythonで閉じたい。）

使用ファイルは リビジョンが 2337 の [SVN](https://granite.phys.s.u-tokyo.ac.jp/svn/LCGT/trunk/VIS/SuspensionControlModel/script/TypeA/)にあったものをコピーした。

| ファイル | 説明 |
| --- | --- |
| **./etmx.mat**|'ETMXwoHLmdl_realparams.mat'からコピーした。ETMXに関係する実際のパラメータが格納されている。|
| **./controlmodel.slx** | 'typeAsimctrl_NB.slx' からコピーした。制御モデル。|
|**./main.m** | 閉ループ伝達関数を出力する。./param/param_*.mat ファイルに記述されているフィルターの情報を制御モデルに代入し、制御ループを閉じた状態でのABCD行列を計算し、./linmod 以下に mat ファイルを保存する。ちなみに、param_noctrl.m は TypeA_paramNoCtrl180517.m からコピーした。|
| **./main.py** | Pythonのメインファイル。 main.m で生成されたABCD行列を元にしてプロットするだけの関数。|


## 振り子の状態空間モデル(susmodel.mat)

(状態変数は何とか、説明)


