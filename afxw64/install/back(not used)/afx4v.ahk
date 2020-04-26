; afx4v 09/05/31 第壱拾弐版


; ** 環境設定 *************************
  #NoTrayIcon                   ; トレイアイコン非表示
  #SingleInstance ignore        ; 多重起動禁止
  #NoEnv                        ; 予期せぬ環境変数を読まない。
  #EscapeChar '                 ; エスケープ文字を変更 (駄目文字対策)
;  SetWorkingDir, %A_ScriptDir%  ; 相対パス対応
  SetTitleMatchMode, 2          ; タイトルの検索を中間一致にする。
  DetectHiddenWindows, on       ; 非表示のウィンドウも検索する。


; ** INI ファイルの有無をチェック *****
  MBS_SplitPath(A_ScriptName, dummy, dummy, dummy, inifile, dummy)
  inifile = %A_ScriptDir%\%inifile%.ini
  IfNotExist, %inifile%  ; INI ファイルがない場合は作成して終了する。
  {
    IniWrite, %A_Space%, %inifile%, AFX, R.File
    IniWrite, %A_Space%, %inifile%, AFX, V.Key
    IniWrite, 0,         %inifile%, AFX, AFXW
    IniWrite, AFX.INI,   %inifile%, AFX, AFX.P
    IniWrite, AFXW.INI,  %inifile%, AFX, AFXW.P
    IniWrite, %A_Space%, %inifile%, AFX, Title
    IniWrite, %A_Space%, %inifile%, AFX, S.Key
    IniWrite, %A_Space%, %inifile%, AFX, S.Title
    IfExist, %inifile%   ; INI ファイルが作成されたか確認
      MsgBox, INI ファイルを作成しました。'n'n%inifile%
    Else
      MsgBox, INI ファイルの作成に失敗しました。'n'n%inifile%
    ExitApp
  }


; ** 引数のチェック *******************
  if 0 = 0
  {
    MsgBox, 引数が有りません。
    ExitApp
  }
                                            ; Bottom Delete Error Ini Noredirect Pipe Spare redirecT View afxW
  else if 1 contains /b,/d,/e,/i,/n,/p,/s,/t,/v,/w
  {
    cmdline = 1
    IfInString, 1, /i
      ini = 1
    Else IfInString, 1, /v
      view = 0
    Else
    {
      IfInString, 1, /e
        stderr = 1
      IfInString, 1, /s
        spare = 1
      IfInString, 1, /p
        pipe = 1
      Else
      {
        IfInString, 1, /t
        {
          IfInString, 1, /n
          {
            MsgBox, /t と /n は同時指定出来ません。
            ExitApp
          }
          redirect = 1
        }
        IfInString, 1, /n
          redirect = 0
        IfInString, 1, /d
          delete = 0
        IfInString, 1, /b
        {
          bottom = 0
          rsize = %1%                       ; RegExMatch の Target に 1 は使えない。
          RegExMatch(rsize, "-.+-", rsize)  ; "-" で囲まれた文字列を読む。
          if rsize != 
          {
            StringTrimLeft, rsize, rsize, 1
            StringTrimRight, rsize, rsize, 1
          }
          else                              ; 文字列が無かった場合、0 を格納する。
            rsize = 0
          if rsize is not digit             ; 0 - 9 のみのデータ以外は 0 とする。
            rsize = 0
        }
      }
    }
  }


; ** INI ファイルの読み込み ***********
  if view != 0                                ; /v 指定時 INI ファイルを無視する。
  {
    if pipe != 1                              ; /p 指定時 R.File の設定を無視する。
    {
      IniRead, rfile, %inifile%, AFX, R.File  ; リダイレクトファイル名
      if rfile = ERROR                        ; キーが見つからない場合、書き足す。
      {
        IniWrite, %A_Space%, %inifile%, AFX, R.File
        rfile =                               ; キーが無かった場合、空扱いにする。
      }
      if (rfile = "" and ini != 1)            ; 空且つ /i 不指定時、警告する。
      {
        MsgBox, %inifile% ファイルの'nR.File に適当なファイル名を記述して下さい。
        ExitApp
      }
      if ini = 1                              ; /i 指定時、キーを書き直す。
        RWIni(inifile, "AFX", "R.File", rfile)
    }
    if (spare != 1 or ini = 1)                ; /s 不指定又は /i 指定時、V.Key を読む。
    {
      IniRead, vkey,  %inifile%, AFX, V.Key   ; R.File 閲覧用キーかビュアやエディタ
      if vkey = ERROR
      {
        IniWrite, %A_Space%, %inifile%, AFX, V.Key
        vkey = 
      }
      if ini = 1
        RWIni(inifile, "AFX", "V.Key", vkey)
    }
    IniRead, afxw, %inifile%, AFX, AFXW       ; 0 なら あふ、1 なら あふｗ と見なす。
    if afxw = ERROR
    {
      IniWrite, 0, %inifile%, AFX, AFXW
      afxw = 0
    }
    if ini = 1
      RWIni(inifile, "AFX", "AFXW", afxw)
    IfInString, 1, /w                         ; /w 指定時、AFXW の値を逆転して扱う。
    {
      if afxw = 0
        afxw = 1
      else
        afxw = 0
    }
    if (afxw = 0 or ini = 1)                  ; AFXW = 0 又は /i 指定時、AFX.P を読む。
    {
      IniRead, afxp,  %inifile%, AFX, AFX.P   ; あふの INI ファイルの場所
      if afxp = ERROR
      {
        IniWrite, AFX.INI, %inifile%, AFX, AFX.P
        afxp = AFX.INI
      }
      if ini = 1
        RWIni(inifile, "AFX", "AFX.P", afxp)
    }
    if (afxw = 1 or ini = 1)                  ; AFXW = 1 又は /i 指定時、AFXW.P を読む。
    {
      IniRead, afxp, %inifile%, AFX, AFXW.P   ; あふｗの INI ファイルの場所
      if afxp = ERROR
      {
        IniWrite, AFXW.INI, %inifile%, AFX, AFXW.P
        afxp = AFXW.INI
      }
      if ini = 1
        RWIni(inifile, "AFX", "AFXW.P", afxp)
    }
    if (spare != 1 or ini = 1)                ; /s 不指定又は /i 指定時、Title を読む。
    {
      IniRead, title, %inifile%, AFX, Title   ; 外部プログラムのタイトルバーの文字
      if title = ERROR
      {
        IniWrite, %A_Space%, %inifile%, AFX, Title
        title = 
      }
      if ini = 1
        RWIni(inifile, "AFX", "Title", title)
    }
    if (spare = 1 or ini = 1)                 ; /s 又は /i 指定時、S.Key, S.Title を読む。
    {
      IniRead, vkey,  %inifile%, AFX, S.Key
      if vkey = ERROR
      {
        IniWrite, %A_Space%, %inifile%, AFX, S.Key
        vkey = 
      }
      if ini = 1
        RWIni(inifile, "AFX", "S.Key", vkey)
      IniRead, title, %inifile%, AFX, S.Title
      if title = ERROR
      {
        IniWrite, %A_Space%, %inifile%, AFX, S.Title
        title = 
      }
      if ini = 1
        RWIni(inifile, "AFX", "S.Title", title)
    }
    if (delete != 0 or ini = 1)               ; /d 不指定又は /i 指定時、Time を読む。
    {
      IniRead, atime, %inifile%, AFX, A.Time
      if (atime != "ERROR" and ini = 1)       ; キーがあった場合、書き直しの対象に。
        RWIni(inifile, "AFX", "A.Time", atime)
      if atime = 
        atime = 300                           ; A.Time の初期値
      else if atime is not digit
        atime = 300
      else if atime <= 300                    ; 初期値以下には設定させない。
        atime = 300
      IniRead, vtime, %inifile%, AFX, V.Time
      if (vtime != "ERROR" and ini = 1)
        RWIni(inifile, "AFX", "V.Time", vtime)
      if vtime = 
        vtime = 3                             ; V.Time の初期値
      else if vtime is not digit
        vtime = 3
      else if vtime <= 3
        vtime = 3
    }
    if ini = 1                                ; /i 指定時、終了
    {
      MsgBox, INI ファイルの項目を整理しました。'n'n%inifile%
      ExitApp
    }
  }


; ** パスの変換処理 *******************
  if view != 0
  {
    GetEnv(vkey)                              ; V.Key の環境変数を処理
    MBS_SplitPath(vkey, dummy, dummy, ext, searchv, dummy)
    if ext = exe                              ; V.Key が実行ファイルかどうか、拡張子で判断
    {
      Rel2Abs(vkey)                           ; V.Key を絶対パス化
      IfNotExist, %vkey%
      {
        MsgBox, V.Key ( /s 指定時、S.Key ) に'n正しい実行ファイル名を記述して下さい。'n'n%vkey%
        ExitApp
      }
    }
    else                                      ; V.Key が exe でないなら、AFX.P ( AFXW.P ) を読む。
    {
      GetEnv(afxp)
      Rel2Abs(afxp)
      IfNotExist, %afxp%
      {
        MsgBox, AFX.P ( AFXW = 1 なら AFXW.P ) に'n正しい AFX ( W ) .INI の場所を記述して下さい。'n'n%afxp%
        ExitApp
      }
                                              ; %afx% を解釈可能にする。
      MBS_SplitPath(afxp, dummy, afxid, dummy, dummy, dummy)
      IniRead, afxp, %afxp%, PROGRAM, VIEWER  ; あふの外部ビュアの設定を読む。
      if afxp !=                              ; ↑が設定されていた場合、それを用いる。
      {
        StringReplace, vkey, afxp, ", , All   ; " を全て解いて誤読防止
        GetEnv(vkey)
        StringReplace, vkey, vkey, '%afx'%, %afxid%, All
        Rel2Abs(vkey)
        IfNotExist, %vkey%
          vkey = 0
        Else
          MBS_SplitPath(vkey, dummy, dummy, ext, searchv, dummy)
        if (vkey = 0 or ext != "exe")         ; V.Key が存在しない、又は拡張子が exe でないならエラー
        {
          MsgBox, あふ ( AFXW = 1 なら あふｗ ) 設定の'n「プログラム」→「外部テキストビュア」部に'n正しい実行ファイル名を記述して下さい。'n'n%vkey%
          ExitApp
        }
      }
      else                                    ; あふ内蔵ビュアを用いるなら、V.Key の文字列長を確かめる。
      {
        if pipe = 1
        {
          MsgBox, /p 指定時はあふ内蔵ビュアは使えません。
          ExitApp
        }
        if vkey =                             ; 送るキーが空ならエラー
          MsgBox, %inifile% ファイルの'nV.Key ( /s 指定時、S.Key ) に'n閲覧用キーかビュアやエディタを記述して下さい。
                                              ; 単語で書かれた修飾キーを除外
        count := RegExReplace(vkey,  "iU)\{(L|R|)(shift|control|ctrl|alt|win)(|down| down|up| up)\}")
                                              ; エスケープされた修飾キー用記号を 1 文字化
        count := RegExReplace(count, "\{[\+\^!#]\}", "b")
                                              ; 記号で書かれた修飾キーを除外
        count := RegExReplace(count, "[\+\^!#]")
                                              ; 特殊キーを 1 文字化
        count := RegExReplace(count, "U)\{.+\}", "b")
        if (StrLen(count) > 1)                ; 処理されたキーの、長さをチェック。
        {
          MsgBox, 送れるキーは一つだけです。'n'n%vkey%
          ExitApp
        }
      }
    }
    if pipe != 1                              ; /p 不指定時、R.File を使う。
    {
      GetEnv(rfile)
      Rel2Abs(rfile)
      MBS_SplitPath(rfile, dummy, dummy, dummy, searchr, dummy)
      AddDqs(rfile)                           ; R.File が空白を含むなら、cmd 用に " で囲む。
      if title != 
        searchr = %title%
    }
  }


; ** あふ を検索、無ければ終了する ****
  if view != 0
    if ext != exe  ; あふ内蔵ビュアを用いないなら検索しない。
    {
      if afxw = 1  ; AFXW = 1 ならあふｗを検索
        afxid := WinExist("ahk_class TAfxWForm")
      else
        afxid := WinExist("ahk_class TAfxForm")
      if afxid = 0
      {
        MsgBox, あふ ( AFXW = 1 なら あふｗ ) が起動していません。
        ExitApp
      }
    }


; ** AddDqs 引数 1-n を纏める *********
  Loop, %0%             ; 引数の数だけループ処理する。
  {
    param := %A_Index%  ; ループの回数番号を出し、その番号の引数が格納される。
    AddDqs(param)
    cmd = %cmd% %param%
  }
  if cmdline = 1        ; 本スクリプト用引数を除外する。
    StringReplace, cmd, cmd, %1%


; ** 外部コマンドの実行 ***************
  if view = 0                           ; /v 指定時、コマンドを実行して終了する。
  {
    cmd = %ComSpec% /k %cmd% | more
    Run, %cmd%
    ExitApp
  }
  cmd = %ComSpec% /c %cmd%              ; OS により command.com /c 又は cmd.exe /c
  if stderr = 1                         ; /e 指定時、エラー出力を標準出力に含める。
    param = 2>&1
  else
    param = 
  if pipe = 1                           ; /p 指定時、コマンドを実行して終了する。
  {
    cmd = %cmd% %param%| %vkey%
    Run, %cmd%, , Hide
    ExitApp
  }
  IfNotInString, cmd, %rfile%           ; 引数が %rfile% を含まない場合、リダイレクトする。
  {
    if redirect != 0                    ; /n 指定時、リダイレクトしない。
      cmd = %cmd% > %rfile% %param%
  }
  Else                                  ; 引数が %rfile% を含む場合、リダイレクトしない。
    if redirect = 1                     ; /t 指定時、リダイレクトする。
      cmd = %cmd% > %rfile% %param%
  ErrorLevel = 0                        ; ErrorLevel を返さないコマンド用に 0 をセット
  RunWait, %cmd%, , Hide/UseErrorLevel  ; コマンドを実行して、コマンドの終了を待つ。
;  if ErrorLevel <> 0                    ; ErrorLevel が 0 以外の場合、中断する。
  if ErrorLevel < 0                     ; ErrorLevel が負の場合、中断する。
  {
    MsgBox, コマンドの実行に失敗しました。'n'n%cmd%'nHide/UseErrorLevel'n'nErrorLevel ( %ErrorLevel% )
    ExitApp
  }


; ** あふ にキーを送る ****************
  StringReplace, rfile, rfile, ", ,All       ; R.File を AutoHotKey で読めるように " を除く。
  IfExist, %rfile%                           ; R.File の存在を確認する。
  {
    if bottom = 0                            ; /b 指定時、指定サイズ以下の R.File を無視する。
    {
      FileGetSize, count, %rfile%
      if count <= %rsize%
      {
        if delete != 0                       ; /d 不指定時、R.File を削除
          FileDelete, %rfile%
        ExitApp
      }
    }
    if ext != exe
      ControlSend, , %vkey%, ahk_id %afxid%  ; あふに閲覧用キーを送る。
    else
      Run, %vkey% %rfile%                    ; 外部プログラムで R.File を開く。
    if delete != 0                           ; /d 不指定時、R.File を削除するための待機ルーチン
    {
      if ext != exe
        Sleep, %atime%                       ; あふ内蔵ビュア用のタイミング補正 ( A.Time )
      else
      {
        WinWaitActive, %searchr%, , %vtime%  ; 外部プログラムの起動を V.Time 秒まで待つ。
        IfWinNotActive, %searchr%            ; タイトルバー検索( R.File 又は Title )
          IfWinNotActive, %searchv%          ; ( 外部プログラムのファイル名 )
          {
            MsgBox, 4116, , 外部プログラムの実行又は検索に失敗しました。'n'n%rfile%'nを削除しますか。
            IfMsgBox, No
              ExitApp
          }
      }
      FileDelete, %rfile%                    ; R.File の削除
    }
    ExitApp                                  ; 本スクリプトの終了
  }
  Else                                       ; R.File の作成に失敗した場合
  {
    MsgBox, リダイレクトファイルの作成に失敗しました。'n'n%rfile%
    ExitApp
  }


; ** サブルーチン *********************
/*
  ※注意
    エスケープ文字が含まれています。
    本ソースの環境設定欄に #EscapeChar があるかご確認下さい。
    変更する場合、全置換で問題ありません。
*/


/*
  関数: RWIni(File, Section, Key, Value)
  INI ファイルのキーを渡された値で書き直す。
*/
RWIni(param, foobar, count, pro)
{
  IniDelete, %param%, %foobar%, %count%
  IniWrite, %pro%, %param%, %foobar%, %count%
}


/*
  参照型関数: GetEnv(pro)
  渡された変数内の %~% 文字列を環境変数として置換する。
*/
GetEnv(ByRef pro)
{
  RegExReplace(pro, "%.+%", $, count)
  if count > 0
  {
    StringReplace, pro, pro, '%, '%, UseErrorLevel
    count := ErrorLevel -= 1
    Loop, %count%
    {
      if A_Index > 1
      {
        RegExReplace(pro, "%.+%", $, count)
        if count = 0
          Break
        StringReplace, pro, pro, '%, '%, UseErrorLevel
        count := ErrorLevel -= 1
      }
      foobar := RegExMatch(pro, "%%.+%")
      if foobar > 0
      {
        param := RegExMatch(pro, "%.+%")
        if foobar = %param%
          -- count
      }
      Loop, %count%
      {
        RegExMatch(pro, "%.+%", param)
        if param = 
          Break
        StringTrimLeft, param, param, 1
        StringTrimRight, param, param, 1
        EnvGet, foobar, %param%
        if foobar = 
        {
          foobar = %param%
          if count = %A_Index%
            foobar = >//>%foobar%'%
          else
            foobar = '%%foobar%<//<
        }
        else
        {
          StringReplace, foobar, foobar, ", , All
          StringReplace, foobar, foobar, '%, >//<, All
        }
        StringReplace, pro, pro, '%%param%'%, %foobar%
      }
      StringReplace, pro, pro, <//<, '%, All
    }
    StringReplace, pro, pro, >//>, '%, All
    StringReplace, pro, pro, >//<, '%, All
  }
}


/*
  参照型関数: Rel2Abs(pro)
  渡された変数が相対パスなら A_ScriptDir を基準とした絶対パスに変換する。
*/
Rel2Abs(ByRef pro)
{
  SplitPath, pro, , , , , foobar
  if foobar = 
    pro = %A_ScriptDir%\%pro%
}


/*
  参照型関数: AddDqs(pro)
  渡された変数が半角･全角空白を含むなら " で括る。
*/
AddDqs(ByRef pro)
{
  RegExReplace(pro, "[ 　]", $, count)
  if count > 0
    pro = "%pro%"
}


; ** インクルード *********************
  #Include %A_ScriptDir%\mbstring.ahk  ; mbstring を使用する。(駄目文字対策)

