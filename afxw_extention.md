# あふｗ拡張用のメモ
研究室では，ほぼファイルをコピーするだけです．  
以下では，この環境を構築した時のメモ書きを残しています．  
なお，x64のあふは使いたいdllが一部対応できていなかったりするため，x86で設定したほうがいい場合もありますが，ここではx64で環境を設定しています．  

# 表示カラーの変更
まず，あふを起動すると黒いバックに，白い文字等でファイルが表示されています．  
視認性が悪いため，設定で色を付けましょう．  

zでコンフィグ設定を起動して，何も設定せずに決定を押せば，AFXW.DEFファイルができます．  
このファイルは，さまざまな設定を記述できるファイルです．  
ここに下記のカラーの設定を追記します．  
するとエグゼや圧縮ファイルなどの拡張子に色が付きます．  
```
[REG_COL]
COL_00=255
EXT_00=exe bat lnk
COL_01=65535
EXT_01=lzh zip 7z cab rar tgz tar bz2 gz msi
COL_02=16711935
EXT_02=bmp ppm pgm pbm jpg jpeg jpe png gif tif tiff webp jp2 jls ico svg wmf emf eps
COL_03=8388863
EXT_03=ifo mp2 mpa m1a m2p m2a mpg mpeg m1v m2v mp2v mp4 divx mov qt ra rm ram rmvb rpm smi avi wmv asf mkv
COL_04=8454016
EXT_04=mp3 wav aac m3u
COL_05=16749350
EXT_05=doc docx
COL_06=65280
EXT_06=xls xlsx csv
COL_07=33023
EXT_07=ppt pptx csv
COL_08=16711935
EXT_08=c cpp
COL_09=12632256
EXT_09=txt hlp h hpp md tex
COL_10=8421376
EXT_10=pdf xmind
COL_11=16711680
EXT_11=htm html url
COL_12=12615808
EXT_12=ini cfg dat bkp def key
COL_13=8388736
EXT_13=dll sys reg inf spi sph
COL_14=128
EXT_14=bak old tmp
COL_15=8421631
EXT_15=img iso
```

次に，afxw.iniの色の設定関連も以下に変更します．  
[COL]で区切られているセクションを丸っと上書きします．  
するとフォルダが緑で表示されるようになり視認性が上がりました．  
```
[COL]
NORMAL=16777215
SYSFILE=16711935
HIDDEN=16776960
READONLY=255
DIR=65280
SELECT=32768
BAR=16711680
WAKU=16711680
BGFL=0
PT=16777215
BGPT=0
MB=16777215
BGMB=0
VW=16777215
BGVW=0
STS_BAR=0
STS_BAR2=65535
LNVW=65280
TBVW=8421376
CRVW=65535
```

# あふｗの設定
ｚキーを押すと，あふの細かな設定ができます．  
以下に推奨の設定を書いておきます．  

## 各種設定（１）
一部抜粋．何も書いてないのは好きに設定してよい．

* あふｗをESCでも終了する（非推奨．ESC連打すると，あふが終了してしまう）
* 疑似マウス操作モードを有効にする（チェック推奨．マウスでD&Dが簡単になる．）
* メニューは頭文字のキーで即決定する（チェックを強く推奨）
* 前回終了時のフォルダ履歴を保存して引き継ぎつぐにチェック（お好み）
* 前回終了時の変数$0~$9を保存して引き継ぐ→チェック推奨
* ソートの状態を表示する→チェック推奨
* ファイルサイズをKB MB GB TB 表示する（チェック推奨．普段は詳細がいらない）
  * shift+z:ファイルサイズ表示切替→KByte MByteと直接の表示が切り替え可能．
* タイムスタンプの秒表示を省略する→チェック推奨
* 左右逆カーソルで親フォルダに移動する→チェック推奨
* 通常の削除はゴミ箱を利用する→チェック推奨
* 展開はフォルダを作成してその中へ→チェック推奨
* 左右逆カーソルで親フォルダに移動する→チェック推奨
* ルートフォルダからバックスペースでドライブ選択を開く→（チェックしないのを推奨．ボタン連打で失敗しやすい．）
* フォルダ作成後そのフォルダに移動する→チェック外したほうがいい．（ｋでフォルダ作成をフォルダ作成したのちに反対側のまどで移動するにしたほうがいい）



## 各種設定（２）
１．マークなしファイル操作→即操作する【非推奨】を選択．  

チェックしない場合はSpaceキーで選択してからでないとコピーなどができません．  
チェックしてある場合はカーソルのあるファイルを即操作できます．  
非推奨な理由は，間違って操作するのを抑制するためですが，慣れたら即操作のほうが操作が早いです．  

２．CTRL＋左右キーをファイル窓大きさ変更に割り当て．

CTRL＋左右キーがデフォルトではドライブの順次変更だが，ドライブ変更を頻繁に呼び出すことは少ないです．  
しかもLキーでドライブ変更は可能です．  
キー設定がALTの場合と被っていますが，キーバインドの設定で，Altの左右キーをつぶして過去の履歴に戻る・戻るに上書きして割り当てるため（ブライザやエクスプローラーのデフォルトショートカット），問題ありません．

## 各種設定（３）
特になし．

## フォント（４）
文字の大きさが小さい場合やフォントを変えたい場合はここで設定する．  
文字の大きさはショートカットでも可能．ただし，左右の窓それぞれに設定するので注意．  
* insertキーで文字サイズを縮小
* deleteキーで文字サイズを拡大．

## 表示色（５）
表示カラーの変更で既に終わっています．  
さらに変えたい場合はここを編集してください．  

## プログラム（６）
なお，ダウンロードしたファイルは，以下のところの設定で，エディタがsublime_textになっています．  
```
[PROGRAM]
`EDITOR="%afxw%\..\sublimetext\sublime_text.exe"`
```

デフォルトは下記のようにメモ帳が指定されています．  
各個人で好きなものを設定してください．  
GUIから設定したければｚキーを打って，プログラム（６）のタブから変更してください．  

```
[PROGRAM]
EDITOR="notepad.exe"
ED_V="$P\$F"
VIEWER=""
SUSIEPATH="%afxw%\susie"
VARCPATH=""
NXCMD=""
SXCMD=""
```

## 拡張子判別実行（７）
画像の閲覧の設定やキーカスタマイズの設定のところでより詳細に述べます．  

### あふのメニューファイル
あふのメニューファイルであるmnuを登録しておくと，メニューキーの開発時に楽ができる．  

拡張子=mnuを追加し，enter(E)に下記を登録  
```
&MENU "$P\$F"
```
こうすることで作ったmnuファイルをenterでメニューが開きます．  

### DIRの時だけshift+enterが反対の窓を開く
拡張子判別実行（７）タブにおいて，
<DIR>を作ってShift+enterに以下を定義
&EXCD -O"$P\$F\"
これを定義しておくとディレクトリの時だけ反対側の窓で開けるようになります．

## キー定義（８）
ファンクションキーと数字の０～９までをキーカスタマイズするために使います．  
ただし，`afwx.key`で機能が上書きされているので，ここで登録せず，`afwx.key`を直接編集すること．
アルファベットや記号など，より詳細な拡張はキーカスタマイズのセクションで述べます．  

## 各種登録（９）
お気に入りのフォルダや，ファイルマスク，拡張子の色が定義できる．  
ファイルマスクや，拡張子の色はすでに定義済み．  

頭文字にj:, h:, k:, u:などとついているのは，キー連打のツーストロークでディレククトリ移動するため．

# 圧縮ファイルのための拡張
デフォルトでは圧縮ファイルをうまく操作することができません．  
そのため，いくつかの圧縮ファイルのためのdllを使います．  

まず，7z.dllでほぼすべての拡張子に対応可能です．  
まず，7zipの公式からダウンロードしてきて，中にある7z.dllをコピーします．  
なお，コマンドライン用の7za.dllと7zax.dllは違うものなので注意すること．  

また，以下のDLLを使うことで，様々な圧縮形式に対応できます．  
[7-zip dll, tar64.dll](http://ayakawa.o.oo7.jp/soft/ntutil.html#7z)

現在の設定で圧縮・展開可能なのは以下のものです．
* zip（7zipによるDeflate level 1,5,9）
* 7zip（LZMA, PPMd, bz2, deflate）
* tar
* tgz
* bz2（level指定が無効）
* xz（level 1-9）
* lzma（level 1-9，非推奨．xz,lzmaのどちらもXZ Utilsで扱うが，今は基本はxzを使う．アルゴリズムはどちらもLZMA）
* lzh（展開のみ）
* rar（展開のみ）

# 画像表示関連の設定
あふはデフォルトでもいくつかの画像（bmp, jpeg, png, gif, tiff, ico）を閲覧することが可能です（内部的にはGDI＋を使用）．  

以下では拡張することで，より高速に，より多様なファイルを閲覧可能にします．  

**対応画像と使用プラグイン**
* bmp（デフォルト）
* jpeg（ifjpegt.sph）
* png（ifPngTr.sph）
* gif（ifGifTr.sph）
* ppm pgm pbm(ZBYPASSI.SPH+ifpng.spi)
* webp（iftwebp.sph）
* j2k（ifjpeg2k.sph）
* wmf（ZBYPASSI.SPH+ifwmf.spi）
* emf（iftgdip.sph）

## susie Plug-inの設定
ｚキーで設定画面をだして，プログラム（６）のタブで，Susie Plug-inの存在するフォルダに  
%afxw%\susie  
を追記．spiファイルはsusieに入れる．
なお，x６４のsusieプラグインは拡張子がsphとなっている．  

## 各種プラグインの設定
### jpg png gif
まず，主要圧縮フォーマット3つに対応し，より高速化するために，下記のプラグインを導入しました．  
"[ifjpegt.sph](http://toro.d.dooo.jp/slplugin.html)"，"[ifPngTr.sph](http://www.puni.jp/~overthe_stardust/susie_plugins.html)"，"[ifGifTr.sph](http://www.puni.jp/~overthe_stardust/susie_plugins.html)" 

### WIC Susie Plug-in
また，その他もろもろのフォーマットに対応するために[WIC Susie Plug-in](http://toro.d.dooo.jp/slplugin.html)を導入しました．  
デフォルトではBMP,PNG,ICO,JPG(JPEG),GIF,TIFF,HDP(HD Photo) に対応．  
コーデックが追加可能で，Windows 10 ではHEIFも表示可能

### webp hief jp2（新しい圧縮フォーマット）
WebpとHEIFとJPEG2000．あっても使うことはまれだが，一応設定した．
wicでは，Windows 10 では拡張（HEVC, HEIF）をインストールすればHEIF/HEVCも表示可能
[HEIF](https://www.microsoft.com/ja-jp/p/heif-image-extensions/9pmmsr1cgpwg?activetab=pivot:overviewtab)

### gdi+プラグイン
EMF, WMF, GIF,ICO,JPEG,PNG,TIFF,BMPに対応
特にwmfとemfが重要．

対応する拡張子を，拡張子判別実行に追加して，（ここではEMF）下記をenterに追記．
```
&SUSIE iftwic.sph
```
WMFはなぜかレンダリングが汚いため，下記のZBYPASSI.SPHを利用．

### 32bit のspiを無理やり拡張して使う
以下のフォーマットに対応する．
* pxm(ppm/pgm/pbm)（linux系でよく使われる非圧縮フォーマットpxm）
* wmf(レンダリングが汚いのでwmf.spiを使用)（パワポの画像出力形式のwmf emf）
* eps（ただし未設定）（texではもう本当は非推奨なので原則使わないこと）

これは，ZBYPASSI.SPHを経由して32ビット版をSPIをブリッジして使う．
ZBYPASSI.SPH一式（"UNBYPASS.DLL" "UNBYPASS.EXE" "ZBYPASSA.SPH" "ZBYPASSI.SPH"）をsusieディレクトリに入れ，
拡張子判別実行（７）で
`pbm pgm ppm wmf eps`を登録し，ENTER(E)に
```
&SUSIE ZBYPASSI.SPH
```
を追記する．

また，"ifepsgs.spi" "ghostscript.dll" "ifpnm.spi" "ifwmf.spi"もsusieのフォルダに入れる．
すると，拡張子に応じて自動的に32bitのspiが選ばれる．

epsは，ifepsgs.spiがghostscriptが入っていれば動く．
`C:\bin\afxw64\susie\ghostscript.dll`ここにあるものとして，設定されている．

# pdf表示関連の設定

pdfファイルは，[axpdf](http://mimizunoapp2.appspot.com/susie/)を使って，複数のbmpファイルとしてレンダリングして，書庫として展開します．  
pdfファイルが見ずらい場合は下記ショートカットを使うこと．

* homeキーでそのままのサイズで表示
* endキーで画面にフィット
* Aキーでアンチエイリアスをトグル

また，xdoc2txtを使ってpdfファイルやオフィスのファイルをテキストファイルとして展開します．  
書庫として展開をshift+enterに割付，テキストとして表示をenterに割り振っています．

拡張子判別実行（７）で
`pdf`を登録し，ENTER(E) ，SHIFT+ENTER(E) にそれぞれに下記を設定します．
```
$~\afxexec.exe cmd /c $~\pdfhead.bat "$P\$F" 7
&S_ARC ZBYPASSA.SPH
```
上は，あふのメッセージ窓に標準出力を投げるライブラリで，`pdfhead.bat`は，xdoc2txtをラップした自作のbatファイルです．  
デフォルトのメッセージコマンドの大きさに合わせて，最後の引数７で先頭から7行だけ表示するようにしています．  
下は，ZBYPASSA.SPHの書庫版を内部命令&S_ARCで呼び出します．  

xdoc2txtの出力結果のフルサイズのファイルは，”,”キーで参照できます．  
ただし，別pdfファイル（その他officファイル）を見込んだら上書きします．  

### その他pdf展開spi
以下の物もpdfを画像の書庫として展開できるが，挙動が重たかったため使用していない．  
* axwrpdf.spi
* axpdfium.spi

# 動画を書庫として展開する
`axffmpeg.spi`を使って，動画をffmpegにより画像として展開し，一定間隔の画像として書庫として展開します．  
なお，設定として`FFMEPGがC:\bin\ffmpeg\ffmpeg.exe`に存在するものとして設定してあります．  
もし，この設定を変えるには，susieフォルダ内にあるsusie.exeを起動し（起動したかどうかが非常に見づらい），一番下の矢印アイコン（これも当たり判定が厳しい）→ファイル→設定→axffmpeg.spiの設定で絶対パスや，インターバルを定義してください．  

拡張子判別実行（７）で`avi mov wmv mp4 avc 264 hevc 265 flv mpg mpeg m1v m1a mp2 m2p m2a m2v m4a divx mkv webm`を追加．
ENTER(E)に下記を追加
```
&S_ARC ZBYPASSA.SPH
```
pdfによる展開に類似．

# MS office
pdfと同様に，xdoc2txtで先頭7行を表示をEnterに設定，shift+Enterで書庫として開くを設定（officeのファイルはxmlのzipファイルとして作成されているため）．

doc docx xls xlsx ppt pptx
```
$~\afxexec.exe cmd /c $~\pdfhead.bat "$P\$F" 7
&V_ARC
```
# exe
exeファイルも書庫として開けるように設定する．インストーラしか提供されていない場合，レジストリ等を汚さないで設定できる可能性がある．
shift+Enterに
```
&V_ARC
```


# 外部ツールを導入する

## 高速な画像コピー
大きなファイルをコピーするとあふがしばらく固まっていて操作を受け付けない．
その場合は，高速にファイルコピーするソフトを別スレッドで立ち上げると便利．
なお，`alt+z`で固まっていたとしても新規にあふを立ち上げることができるので，覚えておくこと．

## xdoc2txt
バイナリファイルを強制的にテキストに展開して閲覧するツール．
pdfのところでも述べている．

以下をダウンロードして展開orインストール．  
for xdoc2txtは32ビット版を使う．
[xdoc2txt](http://ebstudio.info/home/xdoc2txt.html)
[afx4v](http://yak3.myhome.cx:8080/afxwiki/index.php?%A5%D5%A5%A1%A5%A4%A5%EB%C3%D6%A4%AD%BE%EC)
[Microsoft Visual C++ 2010 再頒布可能パッケージ (x64)](https://www.microsoft.com/ja-jp/download/details.aspx?id=14632)

展開してできた　afx4v.exe を実行すると afx4v.ini ができる
afx4v.ini　　Ctrl + F12 に割り当て


## gnuplot
gnuplotを起動するディレクトリを指定して立ち上げることができると非常に便利．  


## diff(winmerge)

## pdfcrop

## コマンドライン（cmd）

## touch

## Tips

## migemo
日本語ファイルはほとんど使わないけどどうする？

## 環境変数を登録するための処理
L キーによるドライブ選択メニュー表示して，　My Doc.にカーソルを合わせたのちに _ 
キーを押おし，プロパティを選ぶと選択可能な画面がでる．

もしくは，c-InsでPCアイコンのプロパティを出す相当
c-s-/にも割り当ててある．

c-Delはゴミ箱のプロパティ

## mnuファイルの保存形式
SJISで保存すること．デフォルトのUTF-8だと文字化けする．
F11にnkfコマンドを割り当てているので，作ったら押すといい．

## 設定したメニューファイル
afxsetting.mnu
afxtest.mnu
bookmark.mnu
command.mnu
compress.mnu
control.mnu
image_help.mnu
launcher.mnu
opposit_cd.mnu
view_help.mnu

* key_menu/以下のヘルプ一覧

環境変数の取得
サンプル
$V"USERPROFILE"

# その他
コマンド出力をあふ直下のstdout.txt（コマンドだと$~\stdout.txt）に書き込むようにすると，","キーで中身が内部ビューアで閲覧できます．  

# その他拡張情報リンク
[ユーザー用Wiki](http://yak3.myhome.cx:8080/afxwiki/index.php?FrontPage)
[お気に入りのツールを気ままに拡張するブログ](http://yuratomo.seesaa.net/category/10005929-1.html)