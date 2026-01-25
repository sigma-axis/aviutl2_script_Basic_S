# Basic_S AviUtl ExEdit2 スクリプト

汎用的な基本効果や基本図形などをまとめた AviUtl ExEdit2 用のスクリプト集です．丸角四角形の生成や斜め軸での回転，回転中心のマウス操作移動や傾斜変形，内側シャドウや内側縁取りなどができます．

[ダウンロードはこちら．](https://github.com/sigma-axis/aviutl2_script_Basic_S/releases) [紹介動画．](https://www.nicovideo.jp/watch/sm45523651)

##  動作要件

- AviUtl ExEdit2

  http://spring-fragrance.mints.ne.jp/aviutl

  - `beta29` で動作確認済み．

##  導入方法

`Basic_S.anm2`, `Basic_S.obj2`, `Basic_S.tra2` の 3 つのファイルに対して，以下のいずれかの操作をしてください．

1.  AviUtl2 のプレビュー画面にドラッグ&ドロップ．

1.  以下のフォルダのいずれかにコピー．

    1.  スクリプトフォルダ
        - AviUtl2 のメニューの「その他」 :arrow_right: 「アプリケーションデータ」 :arrow_right: 「スクリプトフォルダ」で表示されます．
    1.  (1) のフォルダにある任意の名前のフォルダ

初期状態だと「オブジェクトを追加」や「フィルタ効果を追加」メニューの「Basic_S」以下に各種オブジェクトやフィルタ効果などが追加されています．
- 「オブジェクト追加メニューの設定」や「トラックバー移動メニューの設定」の「ラベル」項目で分類を変更できます．

### For non-Japanese speaking users

You may be able to find language translation file for this script from [this repository](https://github.com/sigma-axis/aviutl2_translations_sigma-axis). 
Translation files enable names and parameters of the scripts / filters to be displayed in other languages.

Although, usage documentations for this script in languages other than Japanese are not available now.

##  詳しい解説について

[Wiki](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki) に掲載しています．

##  追加されるオブジェクト

### 角丸矩形

<img width="720" height="480" alt="Various corner shapes." src="https://github.com/user-attachments/assets/1f8760e0-90ce-4eb6-817d-6d0b51ee449a" />

長方形や丸角四角形を生成します．縦横をピクセル単位で指定でき，上下左右揃えの指定もできます．

丸角の形状も複数種類から選べ，半径や縦横比も角ごとに独立に指定することもできます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/角丸矩形)

### 楕円

<img width="320" height="240" alt="Sample of an ellipse shape" src="https://github.com/user-attachments/assets/3a2ace4b-c95f-45e6-ae4d-2564f4d60006" />

標準図形の「円」を，縦横をピクセル単位で指定できるようにしたものです．上下左右揃えの指定もできます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/楕円)

### 菱形

<img width="320" height="240" alt="Sample of a rhombus shape" src="https://github.com/user-attachments/assets/057750a3-5043-43c1-b9c6-6773f73c432f" />

菱形を生成します．縦横をピクセル単位で指定でき，上下左右揃えの指定もできます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/菱形)

### スーパー楕円

<img width="720" height="480" alt="Samples of various superellipses" src="https://github.com/user-attachments/assets/b22c54bc-9a4e-41fa-9b16-039a0e2e055d" />

[スーパー楕円](https://ja.wikipedia.org/wiki/スーパー楕円)を生成します．[アステロイド](https://ja.wikipedia.org/wiki/アステロイド_(曲線))や菱形などもこの特殊形です．

縦横をピクセル単位で指定でき，上下左右揃えの指定もできます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/スーパー楕円)

### 別レイヤー

別レイヤーと同じ画像を読み込みます．座標や拡大率などの情報もある程度は復元できます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/別レイヤー)

##  追加されるフィルタ効果

### 四隅丸め

<img width="640" height="240" alt="Two samples of rounded corners" src="https://github.com/user-attachments/assets/04ba5c33-7286-48ef-9431-c042d25abd50" />

オブジェクトの四隅を円などの図形で丸めます．

角の形状も複数種類から選べ，半径や縦横比も角ごとに独立に指定することもできます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/四隅丸め)

### 背景角丸矩形

<img width="360" height="120" alt="Sample of a round rect background" src="https://github.com/user-attachments/assets/d80d9d36-268e-4a56-a00a-39596c80e577" />

オブジェクトの背景に角丸矩形を配置します．テロップバックや立ち絵の背景などに利用できます．

色を指定する代わりにパターン画像を指定することもできます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/背景角丸矩形)

### 背景楕円

<img width="360" height="120" alt="Sample of an ellipse background" src="https://github.com/user-attachments/assets/1400898a-c474-41ac-862d-75fbf92fc9b1" />

オブジェクトの背景に楕円を配置します．吹き出しやアイコンの背景などに利用できます．

色を指定する代わりにパターン画像を指定することもできます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/背景楕円)

### 背景菱形

<img width="560" height="120" alt="Sample of a rhombus background" src="https://github.com/user-attachments/assets/5e1999b9-dcd5-4751-8cec-c1d1712eae63" />

オブジェクトの背景に菱形を配置します．吹き出しやアイコンの背景などに利用できます．

色を指定する代わりにパターン画像を指定することもできます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/背景菱形)

### 透明度適用

オブジェクトの各ピクセルを指定した分だけ半透明化します．標準のフィルタ効果の「透明度」とは異なり，後続のフィルタ効果に影響する形で透明度を指定します．

> [!NOTE]
> 標準のフィルタ効果の「透明度」の効果が適用されるのは最後にフレームバッファに描画されるタイミングで，全てのフィルタ効果が適用された後です．内部的な「後に適用される透明度の数値」を操作しているだけなので高速な反面，後続のフィルタ効果 (標準描画など以外) にはまず影響しません．
>
> 「縁取り」や「反転」の「透明度反転」など一部のフィルタ効果に対して，半透明化したピクセルを意図して処理させたい場合には「透明度適用」が効果的です．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/透明度適用)

### 透明度二値化

透明度を二値化します．ぼかしの境界を明確にしたい場合などに利用できます．

正確には二値化ではなく，「一定のしきい値よりも透明なら完全透明，また別のしきい値よりも不透明なら完全不透明，その間は線形に補間」という処理を行います．従って半透明になる「ぼかし幅」があります．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/透明度二値化)

### 色調補正

標準の「色調補正」の機能追加版です．標準で利用されている YUV ([BT.601](https://ja.wikipedia.org/wiki/YUV)) 以外に [HSV](https://ja.wikipedia.org/wiki/HSV色空間) や [HSL](https://ja.wikipedia.org/wiki/HLS色空間), XYZ ([sRGB 規準](https://ja.wikipedia.org/wiki/SRGB)) などでの色調補正ができます．

> [!NOTE]
> XYZ や YUV での「色相」はそれぞれ，XZ-平面と UV-平面の偏角を操作するものですが，これらには光学的，視覚心理学的に有意義な意味合いはありません．便宜上の実装と捉えてください．
>
> 特に XYZ 色空間に関しては偏角操作などの便宜上，白点を XZ-平面の原点に対応させるなど内部的な色変換行列にも手を加えていて，独自性が強いことを付記しておきます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/色調補正)

### 色チャンネル入れ替え

各ピクセルの色成分，赤・緑・青・アルファ値を別の成分に差し替えたり，個別に反転したりできます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/色チャンネル入れ替え)

### 回転中心

オブジェクトの回転中心を移動します．標準のフィルタ効果の「座標」の回転中心版です．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/回転中心)

### 回転中心アンカー指定

オブジェクトの回転中心を，アンカーによるマウス操作で指定できます．ここで変更した回転中心は，後続のフィルタ効果にのみ影響します．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/回転中心アンカー指定)

### 上下左右揃え

オブジェクトの回転中心を，上下左右の端や中央に合わせます．後続フィルタで拡大縮小した場合，指定した中心を基準に拡大縮小するようになり，他オブジェクト間のレイアウトを揃えやすくなります．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/上下左右揃え)

### 直角回転

90°単位に画像を開店します．標準のフィルタ効果の「回転」とは異なり，後続フィルタに影響します．

- AviUtl (無印) にあったフィルタ効果の「ローテーション」の類似物です．

回転以外にも上下や左右に反転，斜め軸の反転など 8 種類 ($=\\#D_4$ [(二面体群)](https://ja.wikipedia.org/wiki/二面体群))の配置ができます．

> [!NOTE]
> 標準のフィルタ効果の「回転」の効果が適用されるのは最後にフレームバッファに描画されるタイミングで，全てのフィルタ効果が適用された後です．内部的な「後に適用される回転角度の数値」を操作しているだけなので高速な反面，後続のフィルタ効果 (標準描画など以外) にはまず影響しません．
>
> 「ドロップシャドウ」や「凸エッジ」など一部のフィルタ効果に対して，回転角度を影響させたい場合には「直角回転」が効果的です．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/直角回転)

### XYZ追加回転

標準のフィルタ効果の「回転」とは異なり，常に画面を基準とした X, Y, Z 軸の回転をします．

「描画する」でオブジェクトの回転結果を後続のフィルタ効果に影響させられるようにもなります．

> [!NOTE]
> 標準のフィルタ効果の「回転」は，それまでに適用された回転角度に加算する形で計算されているため，回転軸が現在の回転角度によって変わります．一方で「XYZ追加回転」は常に画面を基準とした X, Y, Z 軸で回転します．
>
> 加えて標準のフィルタ効果の「回転」の効果が適用されるのは最後にフレームバッファに描画されるタイミングで，全てのフィルタ効果が適用された後です．後続のフィルタ効果 (標準描画など以外) にはまず影響しません．「描画する」を ON にした場合，このフィルタ効果の時点で回転の効果が適用され，後続のフィルタ効果にも影響を与えられます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/XYZ追加回転)

### 任意軸追加回転

https://github.com/user-attachments/assets/8a0d6595-605f-49c5-9e05-739963d9c63a

アンカーで指定したラインに沿った軸でオブジェクトを立体回転させます．軸指定がアンカーな点以外は[XYZ追加回転](#xyz追加回転)と同様です．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/任意軸追加回転)

### 傾斜

![Demo of slant effect](https://github.com/user-attachments/assets/a9b55ccf-0dc7-4404-9624-cb3085424d21)

アンカーで指定した軸に沿った傾斜変形をします．傾斜量は角度と傾き (角度の $\tan$ 値) で指定できます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/傾斜)

### XY軸変形

https://github.com/user-attachments/assets/146133cf-f82f-4bc9-82ff-5dfc1b7d86d8

X, Y 軸方向に伸びたアンカーをマウス操作することで変形します．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/XY軸変形)

### 領域サイズ変更

標準のフィルタ効果の「クリッピング」と「領域拡張」を併せたフィルタ効果です．正の指定値で領域拡張，負の指定値でクリッピングの効果になります．

「領域拡張」にはない「中心の位置を変更」のオプションもあります．

- [領域サイズ指定](#領域サイズ指定)と名前が似ているので注意．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/領域サイズ変更)

### 領域割合サイズ変更

[領域サイズ変更](#領域サイズ変更)の割合指定版です．ピクセル数単位ではなくオブジェクトのサイズからの割合で指定します．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/領域割合サイズ変更)

### 領域サイズ指定

オブジェクトに対してクリッピングや領域拡張を適用して，指定した位置とサイズでオブジェクトを切り抜きます．予め切り取りたいサイズがわかっている場合に，アンカー操作で位置を指定してクリッピングするときなどに便利です．

- [領域サイズ変更](#領域サイズ変更)と名前が似ているので注意．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/領域サイズ指定)

### カットずらし

https://github.com/user-attachments/assets/6fc13047-fde8-4ec9-8984-2083661129f2

アンカーで指定したラインでオブジェクトを切り取って，ずらして配置します．ずらす移動量や方向もアンカーで操作できます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/カットずらし)

### 中抜きクリッピング

<img width="520" height="360" alt="Sample of midrange crop" src="https://github.com/user-attachments/assets/bce76075-2c82-40cc-919b-3a3442f09c8b" />

「クリッピング」や「領域拡張」に相当する操作を，オブジェクトの端ではなく中間部分で行います．大きな図表の中間部分を切り取って詰めたい場合に利用できます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/中抜きクリッピング)

### 小数ぼかし

標準の「ぼかし」とは異なり，小数点以下のピクセル数の精度で画像をぼかします．

AviUtl 標準の「ぼかし」にあった，小さい奇数ピクセルでの不具合も修正しています．

> [!NOTE]
> 標準の「ぼかし」には，奇数ピクセルを指定した場合の重み分布が正確な三角分布にはならない不具合があります．AviUtl (無印) でも同様の挙動です．
>
> 例えば 1 ピクセルのぼかしの場合，正確な三角分布は “25%, 50%, 25%” ですが，AviUtl 標準の「ぼかし」だと “33.3%, 33.3%, 33.3%” という分布になっています．3 ピクセルの場合だと，正確な分布 “6.25%, 12.5%, 18.75%, 25%, 18.75%, 12.5%, 6.25%” に対して “6.67%, 13.3%, 20%, 20%, 20%, 13.3%, 6.67%”.

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/小数ぼかし)

### 縁取りα

標準の「縁取り」に透明度を指定したり，中をくり抜いて縁だけにしたり，内側縁取りもできるようになります．縁部分にパターン画像の指定も可能．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/縁取りα)

### 四角縁取り

<img width="480" height="240" alt="Comparison of ordinary borders and rectangle borders" src="https://github.com/user-attachments/assets/b11ad429-a8b2-4d9f-89bb-e71ae4044974" />

AviUtl (無印) の「縁取り」と同様，角が四角になる縁取りです．特に長方形に対して縁取りをする場合などは，こちらのほうがいい場面もあると思います．

[縁取りα](#縁取りα)と同様，透明度の指定や内側縁取りなども可能です．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/四角縁取り)

### 内側シャドウ

<img width="280" height="280" alt="Sample of inner shadow effect" src="https://github.com/user-attachments/assets/e93b5e4f-a43e-416c-9341-db0b2df02950" />

オブジェクト自身に外側から影が落ちているような効果を描画します．パターン画像や合成モードの指定もできます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/内側シャドウ)

### 画像ファイル合成

標準のフィルタ効果の「画像合成」や，AviUtl (無印) にあった「画像ファイル合成」と同等のことができます．標準のものや無印版の機能に加えて画像の回転やアルファ値の指定，オブジェクトの範囲からはみ出しての合成などもできます．

- 動画ファイルは読み込めません．[動画ファイル合成](#動画ファイル合成)を使用してください．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/画像ファイル合成)

### 動画ファイル合成

AviUtl (無印) にあった「動画ファイル合成」と同等のことができます．[画像ファイル合成](#画像ファイル合成)の動画ファイル版です．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/動画ファイル合成)

### 別レイヤー同期

別レイヤーの座標や回転角度，拡大率や透明度を読み取って反映します．個別の項目ごとに影響度を % 単位で指定できます．

https://github.com/user-attachments/assets/65a2eb86-3b2a-406d-829b-ccdbaa29f123

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/別レイヤー同期)

##  追加されるトラックバー移動スクリプト

### 全体で時間制御

標準のトラックバー移動の「直線移動(時間制御)」と似ていますが，時間制御の縦方向の尺度が数値の変化量で重み付けされていないため，中間点の数値を動かしてもその数値になるタイミングがズレません．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/全体で時間制御)

### 区間ごとに時間制御

時間制御のグラフによる抑揚を，各中間点区間ごとに適用するトラックバー移動スクリプトです．

<img width="1000" height="480" alt="Demo of Interval-wise Time-Control" src="https://github.com/user-attachments/assets/eb4d50d8-f20d-4554-8f6a-f11b7383e059" />

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/区間ごとに時間制御)

### 正弦波 / 2次式 / 3次式 / 4次式 / N次式 / 指数関数 / 円形

標準的なイージング関数による緩急を加えるトラックバー移動スクリプトです．各中間点区間ごとにイージングが適用されます．

- [「区間ごとに時間制御」](#区間ごとに時間制御)の特殊化版です．時間制御のグラフを調整すれば，近似的に同様の移動を実現できます．
- 「加速」「減速」の設定で “ease-in” / “ease-out” / “ease-in/out” / “ease-out/in” の種類を切り替えられます．
- 「N次式」と「指数関数」は「設定」の数値で調整できます．
- 初期状態だと「Basic_S」 :arrow_right: 「基本緩急」以下に配置されています．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/基本緩急)

### 等速移動(秒) / 等速移動(フレーム)

オブジェクト開始時は左の値，「設定」で指定した時間後に右の値になるように，直線移動します．

- それぞれのスクリプトで，秒単位，フレーム単位で時間の指定をします．
- 標準のトラックバー移動方法「移動量指定」の拡張版で，細かい調整が利く他，常に 0 以上な設定項目 (「図形」の「サイズ」など) でも小さくなる方向に変化させられます．
- 「設定」に負数を指定すると，オブジェクト終了時に右の値になるような直線移動になります．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/等速移動)

### コマ落ち反復(秒) / コマ落ち反復(フレーム) / コマ落ち反復(Hz) / コマ落ち反復(BPM)

「設定」で指定した周期で，左の数値と右の数値を交互に繰り返します．

- それぞれのスクリプトで，秒単位，フレーム単位，[ヘルツ (Hz) 単位](https://ja.wikipedia.org/wiki/ヘルツ)，BPM 単位 (1分間あたりの回数) で周期の指定をします．
- 1 周期の開始点はオブジェクト開始点が基準になります．
- 「設定」に負数を指定すると，1 周期の開始点の基準がオブジェクトの終了点になります．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/コマ落ち反復)

### コマ落ちランダム(秒) / コマ落ちランダム(フレーム) / コマ落ちランダム(Hz) / コマ落ちランダム(BPM)

「設定」で指定した周期ごとに，左と右の数値の間のランダムな数値になります．

- それぞれのスクリプトで，秒単位，フレーム単位，[ヘルツ (Hz) 単位](https://ja.wikipedia.org/wiki/ヘルツ)，BPM 単位 (1分間あたりの回数) で周期の指定をします．
- ランダム分布は区間の範囲で一様です．
- 切り替わりのタイミングはオブジェクト開始点が基準になります．
- 「設定」に負数を指定すると，切り替わりタイミングの基準がオブジェクトの終了点になります．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/コマ落ちランダム)

### 時間制御繰り返し(秒) / 時間制御繰り返し(フレーム) / 時間制御繰り返し(Hz) / 時間制御繰り返し(BPM)

「設定」で指定した周期ごとに，時間制御のグラフで右から左の数値に変化します．

- それぞれのスクリプトで，秒単位，フレーム単位，[ヘルツ (Hz) 単位](https://ja.wikipedia.org/wiki/ヘルツ)，BPM 単位 (1分間あたりの回数) で周期の指定をします．
- **リズミカルイージング** [\[紹介動画\]](https://www.nicovideo.jp/watch/sm44336458) が発想元で，各拍子間の変化を自由にグラフで設定できるようにしたスクリプトです．
- 1 周期の開始点はオブジェクト開始点が基準になります．
- 「設定」に負数を指定すると，1 周期の開始点の基準がオブジェクトの終了点になります．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/時間制御繰り返し)

### 対数補間 / 対数補間(全体時間制御)

数値を線形補間 (直線移動) で変化させるのではなく，対数を線形補間するように変化させます．単位時間当たり定数倍になるような，指数関数的な変化になります．拡大率や音量など，比率系のパラメタに適用すると均一な変化に感じる場面があります．

- 変化前と変化後の数値が 0 でない，同符号の数値である必要があります．そうでない場合は線形補間します．
- 時間制御のグラフの抑揚を適用できます．
  - 無印のは中間点区間ごとに適用されます．
  - 「(全体時間制御)」のはオブジェクト全体の時間で適用されます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/対数補間)

### 逆数補間 / 逆数補間(全体時間制御)

数値を線形補間 (直線移動) で変化させるのではなく，逆数を線形補間するように変化させます．拡大率に適用した場合，奥行き方向に等速移動したときの大きさの変化と等価になります．

- 変化前と変化後の数値が 0 でない，同符号の数値である必要があります．そうでない場合は線形補間します．
- 時間制御のグラフの抑揚を適用できます．
  - 無印のは中間点区間ごとに適用されます．
  - 「(全体時間制御)」のはオブジェクト全体の時間で適用されます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/逆数補間)

### バウンス / バウンス(全体時間制御)

弾性のあるボールが地面を跳ねるような変化をします．指定回数バウンドして止まるような動きをします．

- 「設定」で反発係数と跳ねる回数を指定します．
- 「加速」「減速」の設定で “ease-in” / “ease-out” / “ease-in/out” / “ease-out/in” の種類を切り替えられます．
- 時間制御のグラフの抑揚を適用できます．
  - 無印のは中間点区間ごとに適用されます．
  - 「(全体時間制御)」のはオブジェクト全体の時間で適用されます．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/バウンス)

### バック / バック(全体時間制御)

開始値から勢い余って目的値を一度通り越し，目的値に戻るような動きをします．

- 「設定」で通り越す量を調整できます．
- 「加速」「減速」の設定で “ease-in” / “ease-out” / “ease-in/out” / “ease-out/in” の種類を切り替えられます．
- 時間制御のグラフの抑揚を適用できます．
  - 無印のは中間点区間ごとに適用されます．
  - 「(全体時間制御)」のはオブジェクト全体の時間で適用されます．
- 区間の左右の数値範囲を超えて変化するため，フィルタ効果などによっては数値が規定の範囲外になり，正しく表現されない可能性があるので注意．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/バック)

### バネ振動 / バネ振動(全体時間制御)

バネのように振動するような動きをします．

- 「設定」で，バネの振動回数や減衰率を指定できます．
- 「加速」「減速」の設定で “ease-in” / “ease-out” / “ease-in/out” / “ease-out/in” の種類を切り替えられます．
- 時間制御のグラフの抑揚を適用できます．
  - 無印のは中間点区間ごとに適用されます．
  - 「(全体時間制御)」のはオブジェクト全体の時間で適用されます．
- 区間の左右の数値範囲を超えて変化するため，フィルタ効果などによっては数値が規定の範囲外になり，正しく表現されない可能性があるので注意．

:arrow_right: [\[詳細\]](https://github.com/sigma-axis/aviutl2_script_Basic_S/wiki/バネ振動)

##  謝辞

- ことぶき 様

  [時間制御繰り返し](#時間制御繰り返し秒--時間制御繰り返しフレーム--時間制御繰り返しhz--時間制御繰り返しbpm)は，[「リズミカルイージング」](https://www.nicovideo.jp/watch/sm44336458)から着想を得ています．

  これの時間制御のグラフを利用した AviUtl2 版を移植したいという発想は以前からあったのですが，スクリプトの機能が足りずに長らく実装できませんでした．beta22 が出たことでスクリプト機能が追加され晴れて実装できるようになりました．

  リズミカルイージングがなければこのスクリプトの発想もなかったかもしれませんし，スクリプト機能の要望も AviUtl2 の制作者であるＫＥＮくん様に届かなかったかもしれません．このような場で恐縮ですが，ことぶき様には感謝申し上げます．

##  改版履歴

- **v1.80 (for beta29)** (2026-01-25)

  - 「画像ファイル合成」「動画ファイル合成」のパラメタ「モード」に「前方から合成(クリッピング)」「後方から合成(クリッピング)」を追加．
    - 背景となる画像のアルファ値でマスクして合成します．元画像の透明度を保ったままグランジ素材を合成するなどの使い方ができます．

  - フィルタ効果「色チャンネル入れ替え」を追加．
  - 他言語への翻訳ファイルを含まないようにした．No longer contains language translation files.
    - Basic_S 以外のスクリプトも含めて，翻訳ファイルは別リポジトリに配置・管理・更新する方針に変更．I created a new repository where language translation files are placed, managed and updated, for scripts including Basic_S and ones that I have written:

      https://github.com/sigma-axis/aviutl2_translations_sigma-axis

  - `beta29` での動作確認．

- **v1.76 (for beta28a)** (2026-01-16)

  - 簡体字中国語翻訳ファイルの更新．Updated the Simplified Chinese translation file. Thanks to @nsYW. (#3)

- **v1.75 (for beta28a)** (2026-01-15)

  - 英語翻訳ファイルの翻訳漏れを修正．Fixed missing translations in the English translation file. (#2)
    - 簡体字中国語でも同じ個所に未翻訳のものがありますが，それは未対処．The Simplified Chinese file has the same missing translations, which is not addressed yet.

- **v1.74 (for beta28a)** (2026-01-14)

  - 簡体字中国語翻訳ファイルの追加．Added translation file for Simplified Chinese. Thanks to @nsYW. (#1)

- **v1.73 (for beta28a)** (2026-01-13)

  - AviUtl2 の機能更新に合わせて，一部の処理を簡略化．
  - 英語翻訳ファイルの追加．Added translation file for English.

- **v1.72 (for beta26)** (2025-12-29)

  - トラックバー移動スクリプト「バウンス」にバウンド回数を指定する設定パラメタを追加．
  - 時間制御のあるトラックバー移動スクリプトで，オブジェクト開始終了点での計算手順を修正．

- **v1.71 (for beta26)** (2025-12-27)

  - トラックバー移動スクリプト「バネ振動」で，「減衰率」が 1 以上のとき正しく動かなかったのを修正．

- **v1.70 (for beta26)** (2025-12-27)

  - トラックバー移動スクリプト「バネ振動」を追加．
  - トラックバー移動スクリプトのパラメタに名前を設定．
  - フィルタ効果「小数ぼかし」をフィルタオブジェクトとして使えるように設定．
  - `beta26` での動作確認．

- **v1.60 (for beta25)** (2025-12-23)

  - 「内側シャドウ」の「X」「Y」のパラメタが整数単位でしか影響していなかったのを修正．
  - 一部フィルタ効果をフィルタオブジェクトとして使えるように設定．
  - トラックバー移動スクリプトに「基本緩急」のスクリプトを 7 個追加．
  - `beta25` での動作確認．

- **v1.51 (for beta22)** (2025-12-01)

  - トラックバー移動スクリプト「時間制御繰り返し」が正しく動作しなかったのを修正．

- **v1.50 (for beta22)** (2025-12-01)

  - トラックバー移動スクリプトを 14 個追加．

  - 各種オブジェクト，フィルタ効果のパラメタ設定項目を並び替え/グループ化して整理．

  - `beta22` での動作確認．

- **v1.40 (for beta21)** (2025-11-28)

  - 「別レイヤー同期」フィルタを追加．

  - 「別レイヤー」オブジェクトで回転角度や回転中心の計算手順を変更．
    - 参照元レイヤーの回転角度や拡大率などで拡縮回転した後，自身の「標準描画」等の回転角度や回転中心移動を合成するように．以前は単純な加算計算だった．
    - 破壊的変更になります．「回転拡大の復元」が ON でかつ，参照元と参照先の両方の「標準描画」に軸の異なる回転を適用していたり，参照元に回転角度や拡大率がある状態で参照先の回転中心を変更していた場合に影響があります．

- **v1.30 (for beta21)** (2025-11-23)

  - 「色調補正」フィルタに色空間 `OKLCH` を追加．

  - 「色調補正」フィルタで色空間「HSL(双円錐)」を選んでも「HSL(円柱)」として処理されていたのを修正．

  - `beta21` での動作確認．

- **v1.20 (for beta20)** (2025-11-22)

  - トラックバー移動スクリプト 10 個を追加．
  - 「別レイヤー」オブジェクトを追加．

- **v1.11 (for beta20)** (2025-11-16)

  - `beta20` での仕様変更に合わせて修正．

  - 「任意軸追加回転」で X, Y, Z 個別の拡大率を，回転軸の計算に含めていなかったのを修正．

- **v1.10 (for beta19a)** (2025-11-14)

  - 「画像ファイル合成」と「動画ファイル合成」を追加．

  - `beta19a` での動作確認．

- **v1.00 (for beta15)** (2025-10-16)

  - 初版．


##  ライセンス

このプログラムの利用・改変・再頒布等に関しては MIT ライセンスに従うものとします．

---

The MIT License (MIT)

Copyright (C) 2025-2026 sigma-axis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://mit-license.org/


# 連絡・バグ報告

- GitHub: https://github.com/sigma-axis
- Twitter: https://x.com/sigma_axis
- nicovideo: https://www.nicovideo.jp/user/51492481
- Misskey.io: https://misskey.io/@sigma_axis
- Bluesky: https://bsky.app/profile/sigma-axis.bsky.social
