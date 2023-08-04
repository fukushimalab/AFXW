======================================================================
                     FastCopy  ver4.1.5                2022/04/26
                                            H.Shirouzu（白水啓章）
                                            FastCopy Lab, LLC.
======================================================================

特徴：
	Windows系最速のファイルコピー＆削除ツールです。

	NT系OS の場合、UNICODE でしか表現できないファイル名や MAX_PATH
	(260文字) を越えた位置のファイルもコピー（＆削除）できます。

	自動的に、コピー元とコピー先が、同一の物理HDD or 別HDD かを判定
	した後、以下の動作を行います。

		別HDD 間：
			マルチスレッドで、読み込みと書き込みを並列に行う

		同一HDD 間：
			コピー元から（バッファが一杯になるまで）連続読み込み後、
			コピー先に連続して書き込む

	Read/Write も、OS のキャッシュを全く使わないため、他のプロセス
	（アプリケーション）が重くなりにくくなっています。

	可能な限り大きな単位で Read/Write するため、デバイスの限界に
	近いパフォーマンスが出ます。

	Include/Exclude フィルタ（UNIXワイルドカード形式）が指定可能です。

	MFC 等のフレームワークを使わず、Win32API だけで作っていますので、
	軽量＆コンパクト＆軽快に動作します。

ライセンス：
	FastCopy ver4.x
	 Copyright(C) 2004-2022 SHIROUZU Hiroaki All rights reserved.
	 Copyright(C) 2018-2022 FastCopy Lab, LLC. All rights reserved.

	  現在、一時的にソースコード公開を中止ています。
	  無保証のフリーウェアとしてお使いください。

	xxHash library
	  Copyright (C) 2012-2021 Mr.Yann Collet, All rights reserved.
	  more details: doc/xxhash-LICENSE.txt

	OpenSSL library Copyright (C) 1998-2021 The OpenSSL Project,
	  All rights reserved. more details: doc/apache-license-2.0.txt

使用法等：
	ヘルプ(fastcopy.htm) を参照してください。

ソース・ビルドについて：
	VS2022 以降でビルドできます。

