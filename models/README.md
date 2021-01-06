# Models
## このディレクトリについて
Modelsディレクトリでは、振り子の剛体モデルとそれを制御する制御モデルを管理している。


## ファイル構成

| ファイル/ディレクトリ | 説明 |
| --- | --- |
| **./example.m** | 剛体モデルと制御モデルに制御パラメータを代入して伝達関数を求める実行ファイル。 |
| **./controlmodel** | 制御モデル置き場。それぞれのサスペンションタイプごとのファイルを保存している。|
|**./parameters** | 制御パラメータ置き場。タイプにごとに４つの状態(safe, isolated, damped, aligned)に対応するパラメータを保存している。|
| **./sumcon** | 剛体モデル置き場。剛体計算に必要な機械パラメータは./sumcon/saveにあり、状態空間モデルをMatlabのスクリプトファイルに変換したファイルは./sumcon/matlabにある。これら２つの種類のファイルは両方とも拡張子が ”ｍ”だが、前者はMathematicaで後者はMatlabなので注意が必要。|
| **./make_susbox.m** | SUMCONが出力したMatlabのスクリプトファイル(.m)をSimulinkモデル(.slx)に変換するための実行ファイル。 |

### その他のファイル

* SetActGain.m : 
* SetRealGain.m : 
* sumcon2mdlconst_typeA.m : 