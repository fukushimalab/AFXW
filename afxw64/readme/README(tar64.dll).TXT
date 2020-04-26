tar32.dll/tar64.dll ver 2.42.00.06 - 私家版 -

rev. 2.42.00.06
auth 市丸 剛
date 2019/12/19

０．はじめに

　本DLLはtar32.dll ver 2.42.00.01を64bit向けに微修正して、VS Community 2019
　ver 16.4.1にて再コンパイルしたものです。

　使用したライブラリは
　　bzip2-1.0.8
　　xz utils 5.2.4
　　zlib 1.2.11
　となります。

１．ファイルについて

　配布ファイルを展開すると以下のファイルが得られます。

　　README.TXT
　　x86\tar32.dll
　　    tar32.lib
　　    tar32.exp
　　x64\tar64.dll
　　    tar64.lib
　　    tar64.exp
　　src242_0_6.zip
　　作成手順.TXT

２．使い方

　Windows 10 ver 1909にて動作確認を行っています。

　基本的に本家tar32.dllと同じです。

　なお、本DLLはVisual Studio Community 2019 ver 16.4.1でコンパイルしています。

　zlib 1.2.9以降、gzip headerのOS Flagが0x0Bから0x0Aに変更されています。
　tgzファイルの先頭9バイト目の値が変わりますので注意してください。

３．ビルド

　別テキストの作成手順.txtを参照してください。

４．著作権及び転載について

　基本的にoriginalのtar32.dllと同等とします。

５．サポート

　本DLLに関する質問等は、64bit版作者である私の方にお願いいたします。

　http://ayakawa.o.oo7.jp
　ayakawa.m@gmail.com

６．履歴

ver 2.42.00.06     date 2019/12/19
　◎コンパイラをVS Community 2019 ver16.4.1に変更
　◎ディレクトリの格納時にエラーが発生するミスを修正
　◎tar64.dllでsusie APIを無効化
　◎CTarArcFile_GZip::read/ CTarArcFile_GZip::write関数で
　　INT_MAXを越える読み書き時にエラーを返すように変更
　◎64bit/32bitでコンパイル時にwarningが出ないようにソースを修正
　◎簡易テスト用ツールtinycmp追加
　◎簡易テスト追加(src\testフォルダ)
　◎tar32.dllも追加
　×2GB超のtgzファイルの読み込みに失敗するミスを修正
　　これを修正するためにzlibの作成時にzconf.hの先頭で
　　　#define Z_LARGE64
　　を定義してからbuildしています。
　△DLL作成手順.TXTを改訂

ver 2.42.00.05     date 2019/12/01
　◎使用しているbzip2とxzをver up
　◎コンパイラをVS Community 2019に変更
　◎ディレクトリの格納時にエラーが発生するミスを修正
　△TAR64_DLL作成手順.TXTを改訂

ver 2.42.00.04     date 2018/03/23
　◎TAR作成時にクラッシュするケースがあったミスを修正(from 掲示板)

ver 2.42.00.03     date 2017/04/15
　◎一部環境で動かないことがあったことの修正(from 掲示板)
　◎コンパイラをVS Community 2015 update 3に変更

ver 2.42.00.02     date 2017/02/09
　◎使用しているzlibとxzをver up

ver 2.42.00.01     date 2012/09/30
　◎ver 2.42.00.01をbaseにre-compile

ver 2.41.00.01     date 2012/07/09
　◎ver 2.41.00.01をbaseにre-compile
　△本ドキュメントを改訂
　△TAR64_DLL作成手順.TXTを改訂

ver 2.40.00.01     date 2011/12/18
　◎ver 2.40.00.01をbaseにre-compile

ver 2.39.00.01     date 2011/10/31
　◎ver 2.39.00.01をbaseにre-compile

ver 2.38.00.01     date 2011/09/19
　◎私家版として再リリース

ver 2.38.00.01     date 2011/09/11
　◎初公開
