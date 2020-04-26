/* 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 "AHKのダメ文字対策"
 mbstring.ahk
   AutoHotkeyで、日本語(マルチバイト文字列)の処理を行うための
   文字列処理ライブラリ。
   詳細は、
   http://www.tierra.ne.jp/~aki/diary/?date=20060111#p01
   を参照してください。

   ver0.09.00   06/1/4
   なまず

 ※このプログラムはなまずの著作物ですが、複製や改変は自由に行っていただいて
   結構です。また、再頒布(公衆送信)や商業利用を含む譲渡も、「なまず」の名前と、
   URL(http://www.tierra.ne.jp/~aki/diary/)を添えていただければ、ご自由に
   していただいて結構です。改変したものを再頒布(公衆送信)や譲渡する場合は、
   改変した旨を表記してください。
 ※このプログラムを利用して生じたいかなる損害に対しても、なまずは責任を負いま
   せん。あしからずご了承ください。

 変更履歴

 ver0.09.00   06/1/4
   最初のバージョン

 接頭語
   MBS_
   本ファイルで定義されたグローバル名(関数)は、すべて
   "MBS_"という接頭語を持つ。
   
 グローバル変数
   一切グローバル変数は使っていない。
   
 マルチスレッドセーフ
   本関数はすべてマルチスレッドセーフである。
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/

/*
 ...............................................................

  "InStr"(http://lukewarm.s101.xrea.com/Scripts.htm)の代わり
  
  MBS_InStr(inputVar, searchText[, caseSnstv, startingPos])
    引数:   
      inputVar  :    検査する文字列(オリジナルと同じ)
      searchText :   検索文字列(オリジナルと同じ)
      caseSnstv :    trueで、大文字小文字の区別をする。省略時はfalse
                     (オリジナルと同じ)
      startingPos :  検査開始文字指定(オリジナルと同じ)
    戻り値: 
      searchTextがinputVarの中で最初に出現する位置を返す。
      出現しなかったら0(= false)。
      (オリジナルと同じ)
    動作:
      ダメ文字問題がない以外、
      オリジナルのInStrと同じ。全角文字も1文字と数える。

 ...............................................................
*/  
MBS_InStr(ByRef inputVar, searchText, caseSnstv = false, startingPos = "")
{
  dirLR := "L"
  offset := 0
  if(startingPos != "")
  {
    offset := startingPos - 1
    if(startingPos == 0)
    {
      dirLR := "R"
      offset := 0
    }
  }

  pos := MBS_StringGetPos(inputVar,searchText,dirLR,offset,caseSnstv) + 1
  
  if(pos == -1)
    pos := 0
    
  return pos
}

/*
 ...............................................................

  "If var is type"(http://lukewarm.s101.xrea.com/commands/IfIs.htm)の代わり
  
  MBS_IfVarIsType(var, type)
    引数:   
      var  :         検査する文字列(オリジナルと同じ)
      type :         検索する型をあらわす文字列
                     オリジナルと同じ型が指定できるが、追加で以下の型も
                     指定できる。
                       hankaku  : varがすべて半角だったらtrue
                                  半角カナも半角とみなす。
                       zenkaku  : varがすべて全角だったらtrue
    戻り値: 
      varがすべてtypeで指定した型だったらtrue,そうでなければfalseが返る
      (オリジナルと同じ)
    動作:
      typeが"integer","float","number","time"の場合、varがすべて半角だったら、
      オリジナルのIf var is typeをコールする。全角だったら、falseを返す。
      "hankaku","zenkaku","digit","xdigit","alpha","upper","lower","alnum",
      "space"だったら、全角、半角を考慮した検査を行う。
      例えば、"digit"の場合、全角の１２３でも、trueが返る。また、"space"だった
      場合は、全角の空白もtrueが返る。
      それ以外は、オリジナルと同じ。

 ...............................................................
*/  
MBS_IfVarIsType(ByRef var, type)
{
  
  ; WCに変換する
  len := MBS_MultiByteToWideChar(wcVar,var)
  
  ; 文字個数分のループの準備
  hankaku := false
  zenkaku := falas
  digit   := false
  xdigit  := false
  alpha   := false
  upper   := false
  lower   := false
  space   := false
  others  := false
  
  ptr := &wcVar
  Loop,%len%
  {
    wchar := MBS_ReadUint16(ptr)
    ptr += 2
    
    ; 全角か半角か
    ;  0x00～0x7e       半角カナ
    if(wchar <= 0x7e || (wchar >= 0xff61 && wchar <= 0xff9f))
    {
      hankaku := true
    }
    else
    {
      zenkaku := true
    }
      
    ; 数字か英字か
    ; 漢字やひらがなは下記関数は正しく動かないので、英数字のみを流す
    if((wchar <= 0x7d || (wchar >= 0xff10 && wchar <= 0xff5a) ) 
    && DllCall("IsCharAlphaNumericW","Ushort",wchar))
    {
      ; 英字か
      if(DllCall("IsCharAlphaW","Ushort",wchar))
      {
        ; A-F,a-fか(半角全角)
        if((wchar <= 0x41 && wchar >= 0x46) 
        || (wchar >= 0x61 && wchar <= 0x66)
        || (wchar >= 0xff21 && wchar <= 0xff26)
        || (wchar >= 0xff41 && wchar <= 0xff46))
        {
          xdigit := true
        }
        else
        {
          alpha  := true
        }
          
        ; upperかlowerか
        if(DllCall("IsCharUpperW","Ushort",wchar))
        {
          upper := true
        }
        else
        {
          lower := true
        }
      }
      else
        digit := true
    }
    else
    if(wchar == 0x20 || wchar == 0x0d || wchar == 0x0a || wchar == 0x09
    || wchar == 0x3000)
    {
      space := true
    }
    else
    {
      others := true
    }
  }
  
  ; すべて半角で、以下のtypeの場合は、標準のコマンドに任せる
  if(!zenkaku
  &&(type == "integer" || type == "float" || type == "number" || type =="time"))
  {
    If var is %type%
      return true
    else
      return false
  }

  if(type == "hankaku" && hankaku && !zenkaku)
    return true

  if(type == "zenkaku" && zenkaku && !hankaku)
    return true

  if(type == "digit" && digit && (!xdigit) && (!alpha) && (!others))
    return true
    
  if(type == "xdigit" && (xdigit || digit) && (!alpha) && (!others))
    return true
    
  if(type == "alpha" && (alpha || xdigit) && (!digit) && (!space) && (!others))
    return true
    
  if(type == "upper" && upper && (!digit) && (!lower) && (!space) && (!others))
    return true
    
  if(type == "lower" && lower && (!digit) && (!upper) && (!space) && (!others))
    return true

  if(type == "alnum" && (alpha || digit || xdigit) && (!space) && (!others))
    return true
    
  if(type == "space" && space && (!alpha) && (!digit) && (!xdigit) && (!others))
    return true

  return false
}

/*
 ...............................................................

  "Loop,PARSE"(http://lukewarm.s101.xrea.com/commands/LoopParse.htm)の代わり
  
  MBS_ParseBegin(inputVar [, delimiters, omitChars, mark])
    引数:   
      inputVar :     分割される文字列が格納された変数名(オリジナルと同じ)
      delimiters :   区切り文字として使用したい文字を列挙
                     オリジナルと同じ意味だが、"CSV"は指定できない。
                     もちろん、全角文字も指定できる。
                     省略時は、1バイトずつ処理される
      omitChars :    各フィールドの先頭と末尾から取り除きたい文字を列挙
                     (オリジナルと同じ)
                     もちろん、全角文字も指定できる。
      mark :         MBS_ParseReturn()で抜ける際、抜け出すループを指定する。
                     (後述)

    戻り値: 
      成功時はtrue,メモリ取得に失敗した場合はfalse。
      しかし、おそらくメモリ取得に失敗した場合は、AHK自体がまともに動かない
      だろうから、チェックはあまり意味がないと思う。

    動作:
      Loop, PARSEと同様な動作をさせるための関数。
      以下の記述は、まったく同じ意味となる。
      
      ; オリジナル
      Loop, PARSE, inputVar, `,
      {
        MsgBox, %A_LoopField%
      }
      
      ; 本関数(ダメ文字なし)
      MBS_ParseBegin(inputVar,",")
      Loop
      {
        if(!MBS_Parse(loopField))
          break
          
        MsgBox, %A_LoopField%
      }
      MBS_ParseEnd()
      
      
      MBS_ParseBegin()と、MBS_ParseEnd()とは、必ずループの外に、セットで
      存在しなければならない。
      ループの中から、いきなりreturnするような場合は、MBS_ParseReturn()を
      使い、さらに、抜け出るループの先頭のMBS_ParseBegin()で、
      markをtrueにしておかなければならない。
      
      ; オリジナル
      Loop, PARSE, inputVar1, `,
      {
        Loop, PARSE, inputVar2, `,
        {
          if(A_LoopField == "end")
            return
        }
      }
      
      ; 本関数(ダメ文字なし)
      MBS_ParseBegin(inputVar1,",","",true)  ; markをtrueに
      Loop
      {
        if(!MBS_Parse(loopField))
          break
        
        MBS_ParseBegin(inputVar2,",")
        Loop
        {
          if(!MBS_Parse(loopField))
            break
          
          if(loopField == "end")
          {
            MBS_Return() ; returnの前に、かならずMBS_Return()を呼ぶ
                         ; このコールで、一番最近markをtrueにしたループ
                         ; (この場合はinputVar1のループ)までが、解消される。
            return
          }
        }
        MBS_ParseEnd()
      }
      MBS_ParseEnd()
      
      
      オリジナルと同じように、inputVarの内容は、内部に取り込まれるので、
      MBS_ParseBegin()の後で、自由に内容を変更してよい。
      
      メモリが許す限り、MBS_ParseBegin()で始まるループは、何回でも入れ子に
      することができる。ただし、ループの外に、必ず対応するMBS_ParseEnd()
      をコールしなければならない(そうしないと、入れ子の外に出たことを認識
      できない)。MBS_ParseEnd()をコールせずに、一気に入れ子を脱出する場合は、
      MBS_ParseReturn()をコールする。すると、一番最近にmarkをtrueにした
      MBS_ParseBegin()のループまでが、解消される。

      オリジナルと異なり、delimitersに"CSV"を指定することができない。
      (多分)"CSV"では、ダメ文字問題が発生しないので、
      オリジナルのLoop,PARSEの方をお使いになることをお勧めする。

 ...............................................................
*/  
MBS_ParseBegin(ByRef inputStr,searchStr="",omitStr="",mark = false)
{
  return MBS_Parse(dummy,3,inputStr,searchStr,omitStr,mark)
}

/*
 ...............................................................

  "Loop,PARSE"(http://lukewarm.s101.xrea.com/commands/LoopParse.htm)の代わり
  
  MBS_ParseEnd()
    引数:
      なし

    戻り値: 
      なし

    動作:
      対応するMBS_ParseBegin()で始まるループを解消する。
      詳細はMBS_ParseBegin()を参照のこと。

 ...............................................................
*/  
MBS_ParseEnd()
{
  MBS_Parse(dummy,4)
}

/*
 ...............................................................

  "Loop,PARSE"(http://lukewarm.s101.xrea.com/commands/LoopParse.htm)の代わり
  
  MBS_ParseReturn()
    引数:
      なし

    戻り値: 
      なし

    動作:
      一番最近にmarkをtrueにしたMBS_ParseBegin()で始まるループまでの入れ子の
      ループを解消する。
      詳細はMBS_ParseBegin()を参照のこと。

 ...............................................................
*/  
MBS_ParseReturn()
{
  MBS_Parse(dummy,5)
}

/*
 ...............................................................

  "Loop,PARSE"(http://lukewarm.s101.xrea.com/commands/LoopParse.htm)の代わり
  
  index := MBS_Parse(loopField [,method])
    引数:
      loopField : 切り取られた文字列が格納される。オリジナルのA_LoopFieldと
                  同じ。
      method    : おまけ機能。
                  1を指定すると、右端の文字列を切り取り、loopField
                  に格納する。
                  2を指定すると、切り取られた後の残りの文字列すべてをloopField
                  に格納する。
                  省略時は、通常通り、左端の文字列を切り取り、loopFieldに
                  格納する。
                  1指定時(右端切り取り時)は、左端指定時と同じように、内部に
                  保存している文字列は短くなる。つまり、1を指定してMBS_Parse()を
                  コールすれば、右端から、parseしていくことになる。
                  2指定時(残り文字列取り出し時)は、切り取り動作は行わない。
                  つまり、2を指定してMBS_Parse()を何度呼んでも、そのたびに
                  loopFieldは同じ値が入り、変化しない。

    戻り値: 
      index    :  ループ回数。オリジナルのA_Indexと同じ。
                  すべてParseし終わると、0が返る。その場合、loopFieldはNULLが
                  格納される。

    動作:
      動作の詳細は、MBS_ParseBegin()を参照のこと。
      
      methodの使い方は、以下を参照のこと。
      
      test := "a,b,c,d"
      
      MBS_ParseBegin(test,",")
      
      index := MBS_Parse(loopField)   ; loopField = "a"    index = 1
      index := MBS_Parse(loopField,1) ; loopField = "d"    index = 2
      index := MBS_Parse(loopField,2) ; loopField = "b,c"  index = ""
      index := MBS_Parse(loopField)   ; loopField = "b"    index = 3
      index := MBS_Parse(loopField)   ; loopField = "c"    index = 4
      index := MBS_Parse(loopField)   ; loopField = ""     index = 0
      
      MBS_ParseEnd()

 ...............................................................
*/  
MBS_Parse(ByRef loopField
          , method = 0, inputStr = "", searchStr = "", omitStr = "",mark=false)
{
  ; 現在のループで処理中の資源は、メモリを取得し、その中に格納している。
  ; しかし、いちいちMBS_Parse()のたびにそのメモリから読み出し、また格納する
  ; のでは効率が悪いので、普段はstatic変数で保持しておき、ループが
  ; 入れ子になる(新たにMBS_ParseBegin()が呼ばれる)とか、入れ子から出る
  ; (MBS_ParseEnd()やMBS_ParseReturn()が呼ばれる)などの状況になったときだけ、
  ; メモリに格納したり、読み出したりするようにする。

  ; マルチスレッドセーフなコードにするため、static変数への書き戻しは
  ; Criticalによってクリティカルセクションにすることで、保護している。

  static stack
  static handlePtr
  static inputPtr,inputLen,inputRemain
  static searchPtr,searchLen
  static omitPtr,omitLen
  static fieldNum

  dlmt := Chr(0x2c) ; ","
  markCode := Chr(0x3a) ; ":"
  absltNoExistCode := Chr(1)

  ; ループ対象資源 := 
  ; 現在処理中ポインタ 現在処理残り文字数 これまで切り出したフィールド数
  ; 入力文字列文字数 入力文字列 サーチ文字列文字数 サーチ文字列 
  ; 除外文字列文字数 除外文字列

  if(!method || method == 1)
  {
    ; ループの中。フィールドの切り出し

    ; すべてパースして残りが無ければfalseでリターン
    if(inputRemain == 0)
    {
      ;Parse_in--
      return false
    }
    
    ; 先頭のフィールドの切り離し
    fieldPtr := inputPtr
    
    if(!method)
    {
      if(searchLen)
        fieldLen := MBS_wcStringGetPos_IfCharInStr(fieldPtr,inputRemain
                                                 ,searchPtr,searchLen
                                                 ,"L",1,0)
      else
        fieldLen := 1

      if(fieldLen == -1)
      {
        ; デリミタが発見できなかったら、残りの文字列は全部フィールド
        fieldLen := inputRemain
        input_remain := 0
      }
      else
      {
        input_remain := inputRemain - fieldLen - 1  ; -1はデリミタ分
        input_ptr := inputPtr + (fieldLen + 1) * 2
      }
    }
    else
    {
      ; おまけ機能。右からパースする
      if(searchLen)
        fieldLen := MBS_wcStringGetPos_IfCharInStr(fieldPtr,inputRemain
                                                 ,searchPtr,searchLen
                                                 ,"R",1,0)
      else
        fieldLen := 1

      if(fieldLen == -1)
      {
        ; デリミタが発見できなかったら、残りの文字列は全部フィールド
        fieldLen := inputRemain
        input_remain := 0
      }
      else
      {
        ; 今のfieldLenは、右はしのデリミタを指している。
        ; この位置にfieldPtrを変更して、さらにfieldLenを修正する。
        fieldLen     := inputRemain - fieldLen - 1
        input_remain := inputRemain - fieldLen - 1  ; -1はデリミタ分
        fieldPtr     := inputPtr + (input_remain + 1) * 2  ; +1はデリミタ分
        ; inputPtrは動かさない。そのまま
        input_ptr    := inputPtr
      }
    }

    ; fieldPtrから、fieldLenの長さが、切り出すフィールド。これから、
    ; 除外文字を前後から切り離す
    if(fieldLen && omitLen)
    {
      lPos := MBS_wcStringGetPos_IfCharNotInStr(fieldPtr,fieldLen
                                                ,omitPtr,omitLen
                                                ,"L",1,0)


      if(lPos == -1)
        fieldLen := 0
      else
      {
        ; 先頭は除外した。おけつも除外する。
        fieldPtr := fieldPtr + lPos * 2
        fieldLen := fieldLen - lPos
        rPos := MBS_wcStringGetPos_IfCharNotInStr(fieldPtr,fieldLen
                                                  ,omitPtr,omitLen
                                                  ,"R",1,0)
        ; 除外以外の文字はありえない
        fieldLen := rPos + 1
      }
    }
    
    ; fieldPtrからfieldLenの長さが、今回取り出すフィールド
    bufSize := MBS_GetMbsSize(fieldPtr,fieldLen)
    VarSetCapacity(loopField,bufSize + 1) ; +1はターミネータ分

    ; マルチバイト文字列に変換
    ; loopFieldは、ポインタでは渡せない
    MBS_WideCharToMultiByteStr(loopField,fieldPtr,bufSize)

    ; endcode埋め込み
    DllCall("RtlFillMemory", "Uint",(&loopField) + bufSize
             ,"Uint",1,"UChar",0)
    
    ; 最後、static変数の書き換えと、ループカウンタをカウントアップ
    ; ここだけ、クリティカルセクションにする
    Critical
    fieldNum++
    inputPtr :=    input_ptr
    inputRemain := input_remain
    Critical,Off
   
    return fieldNum
  }
  else
  if(method == 2)
  {
    ; おまけ機能
    ; パースした残りの文字列を取り出す
  
    ; すべてパースして残りが無ければNULLを返す
    if(inputRemain == 0)
    {
      loopField := ""
      return
    }
    
    ; inputPtrからinputRemain分取り出す
    bufSize := MBS_GetMbsSize(inputPtr,inputRemain)
    VarSetCapacity(loopField,bufSize + 1) ; +1はターミネータ分

    ; マルチバイト文字列に変換
    ; loopFieldは、ポインタでは渡せない
    MBS_WideCharToMultiByteStr(loopField,inputPtr,inputRemain)

    ; endcode埋め込み
    DllCall("RtlFillMemory", "Uint",(&loopField) + bufSize
             ,"Uint",1,"UChar",0)
  }
  else
  if(method == 3)
  {
    ; Begin(ループの先頭)
    ; 入力文字列を受け取り、UNICODEに展開して、本関数内に保持する

    ;
    ; まず、現在のステート(static変数)をメモリに書き戻す
    if(handlePtr)
    {
      ptr := handlePtr
      MBS_WriteUint(ptr,inputPtr)
      ptr += 4
      MBS_WriteUint(ptr,inputRemain)
      ptr += 4
      MBS_WriteUint(ptr,fieldNum)
    }

    ; 引数に応じた資源の取得
    ; まず、必要なメモリ量の計算
    new_inputBsz :=  MBS_GetWcsSize(&inputStr)
    new_searchBsz := MBS_GetWcsSize(&searchStr)
    new_omitBsz :=   MBS_GetWcsSize(&omitStr)
    allSize := new_inputBsz * 2 + new_searchBsz * 2 + new_omitBsz * 2 + 4 * 6
     ; inputPtr + inputRemain + fieldNum + inputLen + searchLen + omitLen = 6

    ; メモリの取得
    ptr := MBS_Alloc(allSize)
    
    if(!ptr)
      return false

    ; マークをセットされていたら、マーク記号をうめこむ
    markFlag := ""
    if(mark)
      markFlag := markCode
      
    ; 資源ブロックのポインタをstackに保存
    new_stack := stack . markFlag . dlmt . ptr
    handle_ptr := ptr
    
    ; 引数の文字列の情報を資源ブロックに記録し、UNICODEに変換する
    ; 入力文字列の文字数を記録
    input_len := new_inputBsz - 1 ; ターミネータ分
    ptr += 4 * 3  ; inputPtr + inputRemain + fieldNum = 3
    MBS_WriteUint(ptr,input_len)
    ptr += 4
    ; UNICODEに変更
    MBS_MultiByteToWideCharPtr(ptr,&inputStr,new_inputBsz)
    input_ptr := ptr
    ptr := ptr + new_inputBsz * 2

    ; 検索文字列の文字数を記録
    search_len := new_searchBsz - 1 ; ターミネータ分
    MBS_WriteUint(ptr,search_len)
    ptr += 4
    ; UNICODEに変更
    MBS_MultiByteToWideCharPtr(ptr,&searchStr,new_searchBsz)
    search_ptr := ptr
    ptr := ptr + new_searchBsz * 2
    
    ; 除外文字列の文字数を記録
    omit_len := new_omitBsz - 1 ; ターミネータ分
    MBS_WriteUint(ptr,omit_len)
    ptr += 4
    ; UNICODEに変更
    MBS_MultiByteToWideCharPtr(ptr,&omitStr,new_omitBsz)
    omit_ptr := ptr

    ; 処理が終わったので、static変数に書き戻す
    Critical
    stack        := new_stack
    handlePtr    := handle_ptr
    inputRemain  := input_len
    inputPtr     := input_ptr
    inputLen     := input_len
    searchPtr    := search_ptr
    searchLen    := search_len
    omitPtr      := omit_ptr
    omitLen      := omit_len
    fieldNum     := 0
    Critical,Off
   
    return true
  }
  else
  if(method == 4)
  {
    ; End(ループの終わり)
    ; ループのスタックを一つ上げる(下げる?)

    ; stack文字列から、右端のポインタを削除
    StringGetPos,pos,stack,%dlmt%,R1
    StringLeft,new_stack,stack,%pos%

    ; ここで、static変数stackを書き換える。
    Critical
    stack := new_stack
    old_handle_ptr := handlePtr

    if(stack != "")
    {
      StringGetPos,pos,stack,%dlmt%,R1
      pos++
      StringTrimLeft,ptr,stack,%pos%
      ; markCodeの削除。今回は関係ない
      StringSplit, tmp, ptr , %absltNoExistCode%, %markCode%
      ptr := tmp1

      ptr += 0
      handle_ptr  := ptr
      inputPtr    := MBS_ReadUint(ptr)
      ptr += 4
      inputRemain := MBS_ReadUint(ptr)
      ptr += 4
      fieldNum    := MBS_ReadUint(ptr)
      ptr += 4
      inputLen    := MBS_ReadUint(ptr)
      ptr += 4
      ptr := ptr + (inputLen + 1) * 2
      searchLen   := MBS_ReadUint(ptr)
      ptr += 4
      searchPtr   := ptr
      ptr := ptr + (searchLen + 1) * 2
      omitLen     := MBS_ReadUint(ptr)
      ptr += 4
      omitPtr     := ptr
    }
    else
      handle_ptr := 0

    ; 最後にhandlePtrを書き換える。
    ; 資源の廃棄の前にポインタを書き換えておくのは非常に重要。
    ; この順番を間違えるとかなり難解なバグを生むよ。
    handlePtr   := handle_ptr
    Critical,Off

    ; 古い資源を廃棄する。
    MBS_Free(old_handle_ptr)
  }
  else
  if(method == 5)
  {
    ; Return(ループからの脱出)
    ; ループのスタックを、マークされたところに戻す。
    ; 後半は、Endとまったく同じコード

    ; markCodeを探す
    StringGetPos,pos,stack,%markCode%,R1
    if(pos == -1)
    {
      ; markCodeが一つもなかったら、全部のスタックを削除する
      new_stack := ""
      old_stack := stack
    }
    else
    {
      StringLeft,new_stack,stack,%pos%
      pos++
      StringTrimLeft,old_stack,stack,%pos%
    }

    ; 資源の復元(これ以降、Endと同じコード)
    Critical
    stack := new_stack

    if(stack != "")
    {
      StringGetPos,pos,stack,%dlmt%,R1
      pos++
      StringTrimLeft,ptr,stack,%pos%

      handle_ptr  := ptr
      inputPtr    := MBS_ReadUint(ptr)
      ptr += 4
      inputRemain := MBS_ReadUint(ptr)
      ptr += 4
      fieldNum    := MBS_ReadUint(ptr)
      ptr += 4
      inputLen    := MBS_ReadUint(ptr)
      ptr += 4
      ptr := ptr + (inputLen + 1) * 2
      searchLen   := MBS_ReadUint(ptr)
      ptr += 4
      searchPtr   := ptr
      ptr := ptr + (searchLen + 1) * 2
      omitLen     := MBS_ReadUint(ptr)
      ptr += 4
      omitPtr     := ptr
    }
    else
      handle_ptr := 0
      
    handlePtr   := handle_ptr
    Critical,Off
    
    ; 資源の削除(old_stack)
    Loop, parse, old_stack, %dlmt%,%absltNoExistCode%
    {
      if(A_LoopField == "")
        continue
        
      MBS_Free(A_LoopField)
    }
  }
}

/*
 ...............................................................

  "StringLower"(http://lukewarm.s101.xrea.com/commands/StringLower.htm)の代わり
  
  MBS_StringLower(outputVar, inputVar [, title])

    引数:
      outputVar : 変換後の文字列を格納する変数名(オリジナルと同じ)
      inputVar  : 変換もとの文字列の入った変数の名前
      title     : "T"(ほんとは、NULL以外を指定すればなんでもいい)を
                  指定すると、単語の先頭だけが大文字で後は小文字の形式に
                  変換される

    戻り値: 
      なし

    動作:
      英字を小文字にする。全角の英字も小文字になる。
      実は、titleを指定した時以外は、標準のStringLowerを呼んでいる。
      titleを指定した場合は、標準ではダメ文字問題が出るので、
      この関数で処理している。

 ...............................................................
*/  
MBS_StringLower(ByRef outputVar, ByRef inputVar, title = "")
{
  if(title == "")
  {
    StringLower, outputVar, inputVar
    return
  }
  
  ; "T"のための関数を呼び出す。Upperで呼ぶのと同じ
  MBS_StrToTitleCase(outputVar, inputVar)
}

/*
 ...............................................................

  "StringUpper"(http://lukewarm.s101.xrea.com/commands/StringLower.htm)の代わり
  
  MBS_StringUpper(outputVar, inputVar [, title])

    引数:
      outputVar : 変換後の文字列を格納する変数名(オリジナルと同じ)
      inputVar  : 変換もとの文字列の入った変数の名前
      title     : "T"(ほんとは、NULL以外を指定すればなんでもいい)を
                  指定すると、単語の先頭だけが大文字で後は小文字の形式に
                  変換される

    戻り値: 
      なし

    動作:
      英字を大文字にする。全角の英字も大文字になる。
      実は、titleを指定した時以外は、標準のStringUpperを呼んでいる。
      titleを指定した場合は、標準ではダメ文字問題が出るので、
      この関数で処理している。

 ...............................................................
*/  
MBS_StringUpper(ByRef outputVar, ByRef inputVar, title = "")
{
  if(title == "")
  {
    StringUpper, outputVar, inputVar
    return
  }
  
  ; "T"のための関数を呼び出す。Lowerで呼ぶのと同じ
  MBS_StrToTitleCase(outputVar, inputVar)
}

/*
 ...............................................................

  "StringLeft"(http://lukewarm.s101.xrea.com/commands/StringLeft.htm)の代わり
  
  MBS_StringLeft(outputVar, inputVar , count)

    引数:
      outputVar : 抜き出した文字列を格納する変数名(オリジナルと同じ)
      inputVar  : 抜き出す元の文字列の入った変数名(オリジナルと同じ)
      count     : 抜き出す文字数(オリジナルと同じ)

    戻り値: 
      なし

    動作:
      countは、全角も1文字と数える。それ以外は、オリジナルと同じ

 ...............................................................
*/  
MBS_StringLeft(ByRef outputVar, ByRef inputVar, count)
{
  ; countが0以下だったら、NULLにして返る
  if(count <= 0)
  {
    outputVar := ""
    return
  }

  ; 入力文字列をWCに
  len := MBS_MultiByteToWideChar(wc_in, inputVar)
  
  ; 入力文字列の長さより、countの方が長いか同じなら、outputはinputと同じ
  if(len <= count)
  {
    outputVar := inputVar
    return
  }
  
  ; outpuVarの領域を、取り出す分、確保しておく(+1はターミネータの分)
  ptr := &wc_in
  bufSize := MBS_GetMbsSize(ptr,count)
  VarSetCapacity(outputVar,bufSize + 1) ; +1はターミネータ分
  
  ; マルチバイト文字列に変換
  ; loopFieldは、ポインタでは渡せない
  MBS_WideCharToMultiByteStr(outputVar,ptr,bufSize)

  ; endcode埋め込み
  DllCall("RtlFillMemory", "Uint",(&outputVar) + bufSize
           ,"Uint",1,"UChar",0)
}

/*
 ...............................................................

  "StringRight"(http://lukewarm.s101.xrea.com/commands/StringLeft.htm)の代わり
  
  MBS_StringRight(outputVar, inputVar , count)

    引数:
      outputVar : 抜き出した文字列を格納する変数名(オリジナルと同じ)
      inputVar  : 抜き出す元の文字列の入った変数名(オリジナルと同じ)
      count     : 抜き出す文字数(オリジナルと同じ)

    戻り値: 
      なし

    動作:
      countは、全角も1文字と数える。それ以外は、オリジナルと同じ

 ...............................................................
*/  
MBS_StringRight(ByRef outputVar, ByRef inputVar, count)
{
  ; countが0以下だったら、NULLにして返る
  if(count <= 0)
  {
    outputVar := ""
    return
  }

  ; 入力文字列をWCに
  len := MBS_MultiByteToWideChar(wc_in, inputVar)
  
  ; 入力文字列の長さより、countの方が長いか同じなら、outputはinputと同じ
  if(len <= count)
  {
    outputVar := inputVar
    return
  }
  
  ; outpuVarの領域を、取り出す分、確保しておく(+1はターミネータの分)
  ptr := &wc_in
  ptr := ptr + ((len - count) * 2)
  
  bufSize := MBS_GetMbsSize(ptr,count)
  VarSetCapacity(outputVar,bufSize + 1) ; +1はターミネータ分
  
  ; マルチバイト文字列に変換
  ; loopFieldは、ポインタでは渡せない
  MBS_WideCharToMultiByteStr(outputVar,ptr,bufSize)

  ; endcode埋め込み
  DllCall("RtlFillMemory", "Uint",(&outputVar) + bufSize
           ,"Uint",1,"UChar",0)
}

/*
 ...............................................................

  "StringTrimLeft"(http://lukewarm.s101.xrea.com/commands/StringTrimLeft.htm)
  の代わり
  
  MBS_StringTrimLeft(outputVar, inputVar , count)

    引数:
      outputVar : 抜き出した文字列を格納する変数名(オリジナルと同じ)
      inputVar  : 抜き出す元の文字列の入った変数名(オリジナルと同じ)
      count     : 抜き出す文字数(オリジナルと同じ)

    戻り値: 
      なし

    動作:
      countは、全角も1文字と数える。それ以外は、オリジナルと同じ

 ...............................................................
*/  
MBS_StringTrimLeft(ByRef outputVar, ByRef inputVar, count)
{
  ; countが0以下だったら、コピーだけして返る
  if(count <= 0)
  {
    outputVar := inputVar
    return
  }

  ; 入力文字列をWCに
  len := MBS_MultiByteToWideChar(wc_in, inputVar)
  
  ; 入力文字列の長さより、countの方が長いか同じなら、inputVarはNULLで返る
  if(len <= count)
  {
    outputVar := ""
    return
  }
  
  ; count分、ポインタを動かす
  ptr := &wc_in
  ptr := ptr + (count * 2)
  
  ; outpuVarの領域を、取り出す分、確保しておく(+1はターミネータの分)
  bufSize := MBS_GetMbsSize(ptr,len - count)
  VarSetCapacity(outputVar,bufSize + 1) ; +1はターミネータ分
  
  ; マルチバイト文字列に変換
  ; loopFieldは、ポインタでは渡せない
  MBS_WideCharToMultiByteStr(outputVar,ptr,bufSize)

  ; endcode埋め込み
  DllCall("RtlFillMemory", "Uint",(&outputVar) + bufSize
           ,"Uint",1,"UChar",0)
}

/*
 ...............................................................

  "StringTrimRight"(http://lukewarm.s101.xrea.com/commands/StringTrimLeft.htm)
  の代わり
  
  MBS_StringTrimRight(outputVar, inputVar , count)

    引数:
      outputVar : 抜き出した文字列を格納する変数名(オリジナルと同じ)
      inputVar  : 抜き出す元の文字列の入った変数名(オリジナルと同じ)
      count     : 抜き出す文字数(オリジナルと同じ)

    戻り値: 
      なし

    動作:
      countは、全角も1文字と数える。それ以外は、オリジナルと同じ

 ...............................................................
*/  
MBS_StringTrimRight(ByRef outputVar, ByRef inputVar, count)
{
  ; countが0以下だったら、コピーだけして返る
  if(count <= 0)
  {
    outputVar := inputVar
    return
  }

  ; 入力文字列をWCに
  len := MBS_MultiByteToWideChar(wc_in, inputVar)
  
  ; 入力文字列の長さより、countの方が長いか同じなら、inputVarはNULLで返る
  if(len <= count)
  {
    outputVar := ""
    return
  }
  
  ; outpuVarの領域を、取り出す分、確保しておく(+1はターミネータの分)
  ptr := &wc_in
  bufSize := MBS_GetMbsSize(ptr,len - count)
  VarSetCapacity(outputVar,bufSize + 1) ; +1はターミネータ分
  
  ; マルチバイト文字列に変換
  ; loopFieldは、ポインタでは渡せない
  MBS_WideCharToMultiByteStr(outputVar,ptr,bufSize)

  ; endcode埋め込み
  DllCall("RtlFillMemory", "Uint",(&outputVar) + bufSize
           ,"Uint",1,"UChar",0)
}

/*
 ...............................................................

  "StringMid"(http://lukewarm.s101.xrea.com/commands/StringMid.htm)
  の代わり
  
  MBS_StringMid(outputVar, inputVar , startChar, count[, dir])

    引数:
      outputVar : 抜き出した文字列を格納する変数名(オリジナルと同じ)
      inputVar  : 抜き出す元の文字列の入った変数名(オリジナルと同じ)
      startChar : 取り出す部分の開始位置(オリジナルと同じ)
      count     : 抜き出す文字数(オリジナルと同じ)
      dir       : "L"(実はNULLでなかったらなんでもいい)を指定すると、
                  StartChar以前(左)の部分をCount文字だけ取り出す
                  (オリジナルと同じ)

    戻り値: 
      なし

    動作:
      startCharやcountは、全角も1文字と数える。それ以外は、オリジナルと同じ

 ...............................................................
*/  
MBS_StringMid(ByRef outputVar, ByRef inputVar, startChar, count, dir = "")
{
  ; countが0以下だったら、NULLにして返る
  if(count <= 0)
  {
    outputVar := ""
    return
  }

  ; 入力文字列をWCに
  len := MBS_MultiByteToWideChar(wc_in, inputVar)

  ; dirが"L"(実はなんでもいい)だったら、いくつか例外がある
  if(dir != "")
  {
    ; startCharが1より小さかったら、NULLにして返る
    if(startChar < 1)
    {
      outputVar := ""
      return
    }

    ; スタート位置の変更
    startChar := startChar - count + 1
    
    ; startCharが1より小さかったら、その分、countを減らす
    if(startChar < 1)
      count := count - 1 + startChar
  }

  ; startCharが1より小さかったら、1とみなす
  if(startChar < 1)
    startChar := 1
    
  ; 取り出し開始位置がはみ出てしまうようなら、 NULLで返る
  if(startChar > len)
  {
    outputVar := ""
    return
  }
  
  ; 取り出し文字列がはみ出てしまうようなら、その分文字列が短くなる
  if(startChar + count - 1 > len)
    count := len - startChar + 1
    
  
  ; outpuVarの領域を、取り出す分、確保しておく(+1はターミネータの分)
  ptr := &wc_in
  ptr := ptr + ((startChar - 1) * 2)
  bufSize := MBS_GetMbsSize(ptr,count)
  VarSetCapacity(outputVar,bufSize + 1) ; +1はターミネータ分
  
  ; マルチバイト文字列に変換
  ; loopFieldは、ポインタでは渡せない
  MBS_WideCharToMultiByteStr(outputVar,ptr,bufSize)

  ; endcode埋め込み
  DllCall("RtlFillMemory", "Uint",(&outputVar) + bufSize
           ,"Uint",1,"UChar",0)
}

/*
 ...............................................................

  "StrLen"(http://lukewarm.s101.xrea.com/Scripts.htm)の代わり
  
  len := MBS_StrLen(var)

    引数:
      var       : 検査する文字列

    戻り値: 
      len       : 文字列の長さ

    動作:
      lenは、全角も1文字と数える。それ以外は、オリジナルと同じ

 ...............................................................
*/  
MBS_StrLen(ByRef var)
{
  return MBS_GetWcsSize(&var) - 1
}

/*
 ...............................................................

  "StringGetPos"(http://lukewarm.s101.xrea.com/commands/StringGetPos.htm)
  の代わり
  
  pos := MBS_StringGetPos(inputVar, searchText [, dir , offset, caseSnstv])

    引数:
      inputVar   : 検査する文字列が格納された変数(オリジナルと同じ)
      searchText : 検索する文字列(オリジナルと同じ)
      dir        : "1"とか、"L2"とか、"R3"とか指定する。省略時は"L1"と同じ
                   (オリジナルと同じ)
      offset     : 検索時、最初のOffset文字分だけ無視して検索を始める。
                   省略時は"0"と同じ(オリジナルと同じ)
      caseSnstv  : trueのとき、大文字小文字を区別する。省略時は区別しない。

    戻り値: 
      pos        : 検索された位置。文字列の最初は「0」として数える
                   (オリジナルのoutputVarと同じ)
                   offsetがマイナスだったり、dirLRの値が上記定義以外だったり、
                   inputVarかsearchTextがNULLだった場合は、-2が返る。

    動作:
      posは、全角も1文字とみなす。

 ...............................................................
*/  
MBS_StringGetPos(ByRef inputVar, searchText, dir="", offset=0,caseSnstv=false)
{
  ; エラーチェック
  if(offset < 0)
    return -2
    
  if(dir != "")
  {
    If dir is integer
    {
      dirLR := "L"
      check_num := dir
    }
    else
    {
      StringLeft,dirLR,dir,1
      StringTrimLeft,check_num,dir,1
      if(dirLR != "L" && dirLR != "R")
        return -2
    }
    
    if(check_num == "")
      check_num := 1
      
    If check_num is not integer
      return -2

    if(check_num <= 0)
      return -2
  }
  else
  {
    dirLR := "L"
    check_num := 1
  }
  
  if(inputVar == "" || searchText == "")
    return -2
  
  ; 入力文字列をWCに
  testlen := MBS_MultiByteToWideChar(wcIn, inputVar)
  
  ; 検索文字列をWCに
  searchlen := MBS_MultiByteToWideChar(wcSch, searchText)

  ; 入力文字列の長さより、offset+searchTextの長さの方が長いなら、
  ; 見つからなかったで返る
  if(testlen < offset+searchlen)
    return -1

  if(caseSnstv)
    return MBS_wcStringGetPos_IfInStrCaseSnstv(&wcIn,testlen,&wcSch,searchlen
                              ,dirLR,check_num,offset)
  else
    return MBS_wcStringGetPos_IfInStrNoCaseSnstv(&wcIn,testlen,&wcSch,searchlen
                              ,dirLR,check_num,offset)
}

/*
 ...............................................................

  "StringReplace"(http://lukewarm.s101.xrea.com/commands/StringReplace.htm)
  の代わり
  
  err := MBS_StringReplace(outputVar,inputVar, searchText
                           [,replaceText, replaceAll, caseSnstv])

    引数:
      outputVar  : 置換結果の文字列を格納する変数(オリジナルと同じ)
      inputVar   : 置換前の文字列を格納している変数(オリジナルと同じ)
      searchText : 検索文字列(オリジナルと同じ)
      replaceText: SearchTextが置き換えられる先の文字列(オリジナルと同じ)
      replaceAll : 省略するか、"1"なら、最初の一回だけ、置換する。
                   それ以外なら、すべての文字列を置換する。
      caseSnstv  : trueのとき、大文字小文字を区別する。省略時は区別しない。

    戻り値: 
      err        : 置換回数を返す。-1のときは、メモリが取得できなかったことを
                   示す。

    動作:
      ダメ文字問題がない以外は、オリジナルと同じ

 ...............................................................
*/  
MBS_StringReplace(ByRef outputVar,ByRef inputVar, searchText
                  ,replaceText = "", replaceAll = "", caseSnstv = false)
{
  ; 暫定的に取得するバッファの大きさを、変換の数で定義する。
  ; AHK標準のStringReplaceでは、20回で振る舞いが変わるようなので、
  ; ここでもそうする。
  rplcNumPerIncrsBuf := 20

  ; searchTextがNULLなら、単にコピーして帰る
  if(searchText == "")
  {
    outputVar := inputVar
    return 0
  }
    
  ; Allか、一回だけか、オプションを調べる
  if(replaceAll == "" || replaceAll == "1")
    rplcAllFlg := false
  else
    rplcAllFlg := true

  ; 入力文字列をWCに
  inputLen := MBS_MultiByteToWideChar(wcIn, inputVar)
  
  ; 検索文字列をWCに
  searchLen := MBS_MultiByteToWideChar(wcSch, searchText)
  
  ; 変換準備
  rplcNum    := 0                     ; 変換回数
  bufNum     := 0                     ; バッファの可能変換回数(20の倍数)
  bufSize    := StrLen(inputVar) + 1  ; 現在のバッファのサイズ(+1はターミネータ)
  bufUsage   := 0                     ; バッファ使用量(変換後のバイト文字列長)
  searchSize := StrLen(searchText)    ; 検索文字列バイト長さ
  rplcSize   := StrLen(replaceText)   ; 変換文字列バイト長さ
  inputPtr   := &wcIn                 ; 入力文字列の現在処理中ポインタ
  inputRemain:= inputLen              ; 入力文字列未変換文字列長さ
  
  ; 最初に、変換結果用のバッファを、inputVarだけ取得する。以降、ループ内でこの
  ; バッファをreallocateしながら変換する。
  bufTop    := MBS_Alloc(bufSize)     ; 変換後の文字列を一時保存するバッファ
  if(!bufTop)
    return -1
  bufPtr    := bufTop                ; 上記バッファの現在処理中ポインタ
  
  Loop
  {
    ; 文字列サーチ
    if(caseSnstv)
      pos := MBS_wcStringGetPos_IfInStrCaseSnstv(inputPtr,inputRemain
                                                 ,&wcSch,searchLen
                                                 ,"L",1,0)
    else
      pos := MBS_wcStringGetPos_IfInStrNoCaseSnstv(inputPtr,inputRemain
                                                   ,&wcSch,searchLen
                                                   ,"L",1,0)
    ; 文字列を発見できなかったら、ループから抜ける
    if(pos == -1)
      break
    
    ; これから変換をするのだが、もうバッファを使い切っていた場合は、
    ; ここで広げる
    rplcNum++
    if(rplcNum > bufNum)
    {
      bufSize := bufSize + rplcSize * rplcNumPerIncrsBuf
      bufNum  := bufNum + rplcNumPerIncrsBuf
      new_bufTop := MBS_Reallocate(bufTop,bufSize)
      if(!new_bufTop)
      {
        MBS_Free(bufTop)
        return -1
      }
      
      bufTop := new_bufTop
      bufPtr := bufTop + bufUsage
    }
  
    ; inputPtrからposの長さだけMBで書き戻し、そこからsearchLenの長さだけ
    ; スキップ(その分、replaceTextをコピー)
    
    ; MBで書き戻し
    mbsLen := MBS_GetMbsSize(inputPtr,pos)  ; MB書き戻しサイズの取得
    MBS_WideCharToMultiBytePtr(bufPtr,inputPtr,mbsLen)
    bufPtr := bufPtr + mbsLen
    
    ; replaceTextをコピー
    DllCall("RtlMoveMemory", "Uint",bufPtr, "Str",replaceText,"Uint",rplcSize)
    bufPtr := bufPtr + rplcSize
    
    ; バッファ使用量更新
    bufUsage := bufUsage + mbsLen + rplcSize

    ; MBで書き戻した分と、searchLenの長さだけスキップ
    inputPtr := inputPtr + (pos + searchLen) * 2
    inputRemain := inputRemain - (pos + searchLen)
    
    ; "All"でなかったら、ここでループから抜ける
    if(!rplcAllFlg)
      break
      
  }
  
  ; 最後に、変換せずに残った部分をMBに書き戻す
  mbsLen := MBS_GetMbsSize(inputPtr,inputRemain)  ; MB書き戻しサイズの取得
  MBS_WideCharToMultiBytePtr(bufPtr,inputPtr,mbsLen)
  bufPtr := bufPtr + mbsLen
  bufUsage := bufUsage + mbsLen
  
  ; 変換終了
  ; bufTop以下に格納された文字列に、ターミネータをつける
  DllCall("RtlFillMemory", "Uint",bufPtr
           ,"Uint",1,"UChar",0)
  
  ; outputVarの領域を広げて、そこに、bufTopからbufUsage分の文字列をコピー
  VarSetCapacity(outputVar,bufUsage + 1) ; +1はターミネータ分
  DllCall("RtlMoveMemory", "Str",outputVar, "Uint",bufTop
          ,"Uint",bufUsage + 1) ; +1はターミネータ分
          
  ; バッファを廃棄
  MBS_Free(bufTop)
  
  return rplcNum
}

/*
 ...............................................................

  "StringSplit"(http://lukewarm.s101.xrea.com/commands/StringSplit.htm)
  の代わり、というか、手伝い。
  
  dlmt := MBS_StringSplit(outputVar,inputVar
                         [, delimiters,omitChars,outputVarDelimiter])

    引数:
      outputVar  : 分割(?)結果の文字列を格納する変数
      inputVar   : 分割前の文字列を格納している変数(オリジナルと同じ)
      delimiters : 区切り文字として使用したい文字を列挙(オリジナルと同じ)
      omitChars  : 分割された各要素の最初と最後から取り除く文字を列挙
                   (オリジナルと同じ)
      outputVarDelimiter : outputVarに格納される文字列の区切り文字を指定する。
                           省略時には、区切り文字は、0x01というコードが使われる。
    戻り値: 
      dlmt       : outputVarに格納される文字列の区切り文字が返る。
                   outputVarDelimiterを省略したら、常に0x01。
                   outputVarDelimiterを指定したら、常に、outputVarDelimiterと
                   同じ値。

    動作:
      オリジナルのStringSplitは、分割した各フィールドが、array1,array2と
      いった疑似配列変数に格納されるが、関数では、そのような動作は実現
      できない。しかし、オリジナルのStringSplitでは、ダメ文字問題が発生して
      しまう。
      そこで、本関数では、ダメ文字問題が発生しない形でinputVarを分割し、
      それをShift-JISでもASCIIでも使わない0x01というコードを区切り文字とする
      一つの文字列として、outputVarに格納する。0x01で分割する分には、少なくとも
      Shift-JISに関しては、ダメ文字問題は絶対に起こらないので、オリジナルの
      StringSplitを使えばよい。
      以下のコードは、まったく同じ意味となる。
      
      ; オリジナル
      inputVar := "a,b,c"
      StringSplit, array, inputVar, `,
      
      ; 本関数
      inputVar := "a,b,c"
      dlmt := MBS_StringSplit(tmp, inputVar, ",")
      StringSplit, array, tmp, %dlmt%
      
      
      区切り文字0x01は、Shift-JISでもASCIIでも通常は絶対に使わない文字だが、
      もし、inputVarの中で、あえてこのコードを使っていると、当然、分割時に
      誤動作する。そこで、そのような場合は、outputVarDelimiterで、任意の
      文字を指定する必要がある。ダメ文字問題を起さないためには、その時指定する
      文字は、0x3e以下の値である必要がある。
      
 ...............................................................
*/  
MBS_StringSplit(ByRef outputVar,ByRef inputVar, delimiters="",omitChars=""
                ,outputVarDelimiter="")
{
  if(outputVarDelimiter != "")
    dlmt := outputVarDelimiter
  else
    dlmt := Chr(1)
    
  outputVar := ""
  MBS_ParseBegin(inputVar, delimiters,omitChars)
  Loop
  {
    if(!MBS_Parse(field))
      break

    outputVar := outputVar . field . dlmt
  }
  MBS_ParseEnd()
  
  ; 最後のデリミタを削除
  if(outputVar != "")
    StringTrimRight,outputVar,outputVar,1
    
  return dlmt
}

/*
 ...............................................................

  "SplitPath"(http://lukewarm.s101.xrea.com/commands/SplitPath.htm)
  の代わり
  
  MBS_SplitPath(InputVar 
               , outFileName, outDir, outExtension, outNameNoExt, outDrive)

    引数:
      inputVar     : 分解するファイルパスを格納した変数
      outFileName  : オリジナルと同じ。ただし、省略は不可
      outDir       : オリジナルと同じ。ただし、省略は不可
      outExtension : オリジナルと同じ。ただし、省略は不可
      outNameNoExt : オリジナルと同じ。ただし、省略は不可
      outDrive     : オリジナルと同じ。ただし、省略は不可

    戻り値: 
      なし

    動作:
      ダメ文字問題がない以外は、オリジナルと同じ
      ただし、outFileNameなどは、ByRefを使っているので、省略できないのが
      残念なところ。

 ...............................................................
*/  
MBS_SplitPath(inputVar
              ,ByRef outFileName, ByRef outDir, ByRef outExtension
              ,ByRef outNameNoExt, ByRef outDrive)
{
  ; ドライブ名、あるいはマシン名、あるいはサイト名ごとによる
  ; 分割。
  ; c:\xxxx\aaaa.txt
  ; \\xxxx\aaaa.txt
  ; http://xxxxx/xxxx.txt
  
  col := Chr(0x3a) ; ":"
  sla := Chr(0x2f) ; "/"
  bsl := Chr(0x5c) ; "\"
  prd := Chr(0x2e) ; "."

  drvPos := MBS_InStr(inputVar,col)
  netPos := MBS_InStr(inputVar,bsl . bsl)
  urlPos := MBS_InStr(inputVar,"http" . col . sla . sla)
  if(drvPos == 2)
  {
    MBS_StringLeft(out_drive,inputVar,drvPos)
    pos := drvPos + 1
    dlmt := bsl
  }
  else
  if(netPos == 1)
  {
    pos := MBS_InStr(inputVar,bsl,false,3)
    if(pos)
    {
      MBS_StringLeft(out_drive,inputVar,pos - 1)
    }
    else
    {
      out_drive := inputVar
      pos := MBS_StrLen(inputVar) + 1
    }
    dlmt := bsl
  }
  else
  if(urlPos == 1)
  {
    pos := MBS_InStr(inputVar,sla,false,8)
    if(pos)
    {
      MBS_StringLeft(out_drive,inputVar,pos - 1)
    }
    else
    {
      out_drive := inputVar
      pos := MBS_StrLen(inputVar) + 1
    }
    dlmt := sla
  }
  else
  {
    pos := 1
    dlmt := bsl
  }
  
  ; inputVarの、pos以降が、ドライブ名を除いたファイルパスとなっている。
  filePos := MBS_InStr(inputVar,dlmt,false,0)
  
  if(filePos)
  {
    if(filePos < pos)
    {
      ; ファイル名なし
      out_fileName := ""
      out_nameNoExt := ""
      out_ext := ""
      out_dir := inputVar
    }
    else
    {
      ; ファイル名あり
      MBS_StringTrimLeft(out_fileName,inputVar,filePos)
      MBS_StringLeft(out_dir,inputVar,filePos - 1)
      pos := MBS_InStr(out_fileName,prd,false,0)
      if(pos)
      {
        MBS_StringTrimLeft(out_ext,out_fileName,pos)
        MBS_StringLeft(out_nameNoExt,out_fileName,pos-1)
      }
      else
      {
        out_ext := ""
        out_nameNoExt := out_fileName
      }
    }
  }
  else
  {
    ; ファイル名の区切りが見つからなかった(c:xxx.txtのようなタイプ)
    ; この場合、pos以降を、ファイル名とする。
    MBS_StringTrimLeft(out_fileName,inputVar,pos - 1)
    MBS_StringLeft(out_dir,inputVar,pos - 1)

    pos := MBS_InStr(out_fileName,prd,false,0)
    if(pos)
    {
      MBS_StringTrimLeft(out_ext,out_fileName,pos)
      MBS_StringLeft(out_nameNoExt,out_fileName,pos-1)
    }
    else
    {
      out_ext := ""
      out_nameNoExt := out_fileName
    }
  }
  
  outFileName := out_fileName
  outDir      := out_dir
  outExtension:= out_ext
  outNameNoExt:= out_nameNoExt
  outDrive    := out_drive
}

/*
 ...............................................................

  半角文字を、対応する全角文字に変換する。
  
  MBS_StringZenkaku(outputVar, inputVar
                    [, alpha, num, symbol, space, kana])

    引数:
      outputVar    : 変換後の文字列を格納する変数
      inputVar     : 変換前の文字列を格納する変数
      alpha        : 英字を変換する場合はtrue,しない場合はfalse
                     省略時はtrue
      num          : 数字を変換する場合はtrue,しない場合はfalse
                     省略時はtrue
      symbol       : 記号を変換する場合はtrue,しない場合はfalse
                     省略時はtrue
      space        : 半角空白(0x20)を、全角空白に変換するときはtrue,しない場合は
                     flase。省略時はtrue
      kana         : 半角カナを全角カナに変換するときはtrue,しない場合はfalse
                     省略時はfalse ← 注意。ここだけデフォルトはfalse

    戻り値: 
      なし

    動作:
      いわゆるASCII文字列(0x20から0x7e)を、対応する全角文字に変換する。
      また、半角カナも、対応する全角カナに変換する。その場合、
      半角カナの"バ"などは、ハとテンテンの二文字は一つの全角文字になるので
      注意。

 ...............................................................
*/  
MBS_StringZenkaku(ByRef outputVar, ByRef inputVar
          , alpha = true, num = true, symbol = true, space = true, kana = false)
{
  ; まず、コード変換用テーブルをもらう
  MBS_MakeZenHanTable(symblTbl1,symblTbl2,symblTbl3,symblTbl4,kanaTbl)
  
  ; WCに変換
  inLen := MBS_MultiByteToWideChar(wcIn, inputVar)
  
  ; ワーク用領域を取得。全角に変換するときは、同じか必ず小さくなるはず
  VarSetCapacity(wcOut,(inLen + 1) * 2)
  
  ; ポインタ設定
  inPtr := &wcIn
  outPtr := &wcOut
  
  ; ループ開始
  Loop
  {
    if(inLen == 0)
      break
  
    inChar := MBS_ReadUint16(inPtr)
    inPtr += 2
    inLen--
    
    ; 基本的に、入力コードと同じコードを出力する。
    ; 変換対象にひっかかった場合に、出力コードを変更する
    outChar := inChar
    
    if(alpha)
    {
      ; アルファベット変換
      ; 大文字と小文字
      if((inChar >= 0x0041 && inChar <= 0x005a)
       ||(inChar >= 0x0061 && inChar <= 0x007a))
        outChar := inChar + 0xFF00 - 0x20
        
    }
    
    if(num)
    {
      ; 数字変換
      if(inChar >= 0x0030 && inChar <= 0x0039)
        outChar := inChar + 0xFF00 - 0x20
    }
    
    if(symbol)
    {
      ; 記号変換
      ; 全角と半角は並び順が対応してないので、4つの部分ごとに、テーブルを
      ; 引いて変換する
      
      ;      symbol1
      if(inChar >= 0x0021 && inChar <= 0x002f)
      {
        pos := (inChar - 0x0021) * 6 + 1 ; 0x????で、6文字だから。midは+1がいる
        StringMid, outChar, symblTbl1, %pos%, 6
      }
      else ; symbol2
      if(inChar >= 0x003a && inChar <= 0x0040)
      {
        pos := (inChar - 0x003a) * 6 + 1 ; 0x????で、6文字だから。midは+1がいる
        StringMid, outChar, symblTbl2, %pos%, 6
      }
      else ; symbol3
      if(inChar >= 0x005b && inChar <= 0x0060)
      {
        pos := (inChar - 0x005b) * 6 + 1 ; 0x????で、6文字だから。midは+1がいる
        StringMid, outChar, symblTbl3, %pos%, 6
      }
      else ; symbol4
      if(inChar >= 0x007b && inChar <= 0x007e)
      {
        pos := (inChar - 0x007b) * 6 + 1 ; 0x????で、6文字だから。midは+1がいる
        StringMid, outChar, symblTbl4, %pos%, 6
      }
        
      outChar := outChar + 0 ; いらないかもしれないが、数値であることを明示
    }
    
    if(space)
    {
      ; 半角スペースを全角スペースに
      if(inChar == 0x0020)
        outChar := 0x3000
    }

    if(kana)
    {
      ; 半角カナを全角に変換
      ; カ、サ、タ、ハだったら、次のコードも読んで、バやパだったら、それに
      ; 応じた全角コードを選ばないといけない。ああ、面倒くさい。
      
      ; まず、そもそも変換対象の半角カナであるかどうか
      if(inChar >= 0xff61 && inChar <= 0xff9f)
      {
        ; とりあえず、変換テーブルで候補を出しておく
        pos := (inChar - 0xff61) * 6 + 1 ; 0x????で、6文字だから。midは+1がいる
        StringMid, outChar, kanaTbl, %pos%, 6
        outChar := outChar + 0 ; いらないかもしれないが、数値であることを明示
        
        ;      カあるいはサあるいはタか
        if(inChar >= 0xff76 && inChar <= 0xff84)
        {
          ; 次の一文字を読んで、ガとかだったら、コードを一つ増やす
          nextChar := MBS_ReadUint16(inPtr)
          if(nextChar == 0xff9e)
          {
            outChar := outChar + 1
            inPtr += 2
            inLen--
          }
        }
        else ; ハか
        if(inChar >= 0xff8a && inChar <= 0xff8e)
        {
          ; 次の一文字を読んで、バやパとかだったら、コードを増やす
          nextChar := MBS_ReadUint16(inPtr)
          if(nextChar == 0xff9e)  ; バ
          {
            outChar := outChar + 1
            inPtr += 2
            inLen--
          }
          else
          if(nextChar == 0xff9f)  ; パ
          {
            outChar := outChar + 2
            inPtr += 2
            inLen--
          }
        }
        else ; ウか
        if(inChar == 0xff73)
        {
          ; 次の一文字を読んで、ヴだったら、特別にヴを用意
          nextChar := MBS_ReadUint16(inPtr)
          if(nextChar == 0xff9e)
          {
            outChar := 0x30f4
            inPtr += 2
            inLen--
          }
        }
      }
    }
    
    ; outCharが得られたので、書き込む
    MBS_WriteUint16(outPtr,outChar)
    outPtr += 2
  }
  
  ; 変換領域に、ターミネータを埋め込む
  MBS_WriteUint16(outPtr,0)
  
  ; MBに変換
  MBS_WideCharToMultiByte(outputVar,wcOut)
  
}

/*
 ...............................................................

  全角文字を、対応する半角文字に変換する。
  
  MBS_StringHankaku(outputVar, inputVar
                    [, alpha, num, symbol, space, kana])

    引数:
      outputVar    : 変換後の文字列を格納する変数
      inputVar     : 変換前の文字列を格納する変数
      alpha        : 英字を変換する場合はtrue,しない場合はfalse
                     省略時はtrue
      num          : 数字を変換する場合はtrue,しない場合はfalse
                     省略時はtrue
      symbol       : 記号を変換する場合はtrue,しない場合はfalse
                     省略時はtrue
      space        : 全角空白を、半角空白に変換するときはtrue,しない場合は
                     flase。省略時はtrue
      kana         : 全角カナを半角カナに変換するときはtrue,しない場合はfalse
                     省略時はfalse ← 注意。ここだけデフォルトはfalse

    戻り値: 
      なし

    動作:
      全角文字を、いわゆるASCII文字列(0x20から0x7e)に、変換する。
      また、全角カナも、対応する半角カナに変換する。その場合、
      全角カナの"バ"などは、一つの全角文字が、ハとテンテンの
      二つの半角文字になるので注意。

 ...............................................................
*/  
MBS_StringHankaku(ByRef outputVar, ByRef inputVar
          , alpha = true, num = true, symbol = true, space = true, kana = false)
{
  ; まず、コード変換用テーブルをもらう
  MBS_MakeZenHanTable(symblTbl1,symblTbl2,symblTbl3,symblTbl4,kanaTbl)
  
  ; WCに変換
  inLen := MBS_MultiByteToWideChar(wcIn, inputVar)
  
  ; ワーク用領域を取得。半角に変換するときは、最悪、２倍の領域がいる。
  ; "バ"などは、２文字になるから。
  VarSetCapacity(wcOut,((inLen * 2) + 1) * 2)
  
  ; ポインタ設定
  inPtr := &wcIn
  outPtr := &wcOut
  
  ; ループ開始
  Loop
  {
    if(inLen == 0)
      break
  
    inChar := MBS_ReadUint16(inPtr)
    inPtr += 2
    inLen--
    
    ; 基本的に、入力コードと同じコードを出力する。
    ; 変換対象にひっかかった場合に、出力コードを変更する
    outChar := inChar
    
    if(alpha)
    {
      ; アルファベット変換
      ; 大文字と小文字
      if((inChar >= 0xff21 && inChar <= 0xff3a)
       ||(inChar >= 0xff41 && inChar <= 0xff5a))
        outChar := inChar - 0xFF00 + 0x20
        
    }
    
    if(num)
    {
      ; 数字変換
      if(inChar >= 0xff10 && inChar <= 0xff19)
        outChar := inChar - 0xFF00 + 0x20
    }
    
    if(symbol)
    {
      ; 記号変換
      ; 全角と半角は並び順が対応してないので、4つの部分ごとに、テーブルを
      ; 引いて変換する
      
      ; 16進数表現にして、文字列化する
      SetFormat, INTEGER, H
      inCharStr := inChar + 0
      inCharStr := inCharStr . "0x"

      ;      symbol1
      if(InStr(symblTbl1,inCharStr))
      {
        outChar := (InStr(symblTbl1,inCharStr) - 1) // 6 + 0x0021
                                           ; 0x????で、6文字
      }
      else ; symbol2
      if(InStr(symblTbl2,inCharStr))
      {
        outChar := (InStr(symblTbl2,inCharStr) - 1) // 6 + 0x003a
                                           ; 0x????で、6文字
      }
      else ; symbol3
      if(InStr(symblTbl3,inCharStr))
      {
        outChar := (InStr(symblTbl3,inCharStr) - 1) // 6 + 0x005b
                                           ; 0x????で、6文字
      }
      else ; symbol4
      if(InStr(symblTbl4,inCharStr))
      {
        outChar := (InStr(symblTbl4,inCharStr) - 1) // 6 + 0x007b
                                           ; 0x????で、6文字
      }

      SetFormat, INTEGER, D
    }
    
    if(space)
    {
      ; 半角スペースを全角スペースに
      if(inChar == 0x3000)
        outChar := 0x0020
    }

    if(kana)
    {
      ; 全角カナを半角に変換
      ; ガなどだったら、半角カとテンテンを出す。
      ; 
      ; (1)カナテーブルにコードがあれば、そのまま変換
      ; (2)カナテーブルにコードがなければ、
      ;    (カ、サ) (タ) (ハ) (ヴ) を特別扱い
      ; (3)それ以外は、半角に変換できないので、そのまま
      
      
      ; 16進数表現にして、文字列化する
      SetFormat, INTEGER, H
      inCharStr := inChar + 0
      inCharStr := inCharStr . "0x"

      if(InStr(kanaTbl,inCharStr))
      {
        outChar := (InStr(kanaTbl,inCharStr) - 1) // 6 + 0xff61
                                         ; 0x????で、6文字
      }
      else
      {
        ; テーブルにはない文字。
        ; バやパなどのテンやマル付きか、半角にないカナかもしれない。
        
        ;       カあるいはサの行
        if(inChar >= 0x30ab && inChar <= 0x30be)
        {
          ; テンテンつき。半角カナを出して、次にテンテンを用意
          outChar := ((inChar - 0x30ab) // 2) + 0xff76
          MBS_WriteUint16(outPtr,outChar)
          outPtr += 2
          outChar := 0xff9e
        }
        else ; ダとヂ
        if(inChar == 0x30c0 || inChar == 0x30c2)
        {
          outChar := ((inChar - 0x30c0) // 2) + 0xff80
          MBS_WriteUint16(outPtr,outChar)
          outPtr += 2
          outChar := 0xff9e
        }
        else ; ヅデド
        if(inChar >= 0x30c5 && inChar <= 0x30c9)
        {
          outChar := ((inChar - 0x30c5) // 2) + 0xff82
          MBS_WriteUint16(outPtr,outChar)
          outPtr += 2
          outChar := 0xff9e
        }
        else ; ハの行
        if(inChar >= 0x30cf && inChar <= 0x30dd)
        {
          ; ハのコードを引き算して、3で割ったあまりが、1ならテンテン、2ならマル
          ; 3で割った答えを半角のハに足し算すれば、半角コードになる。
          outChar := ((inChar - 0x30cf) // 3) + 0xff8a
          MBS_WriteUint16(outPtr,outChar)
          outPtr += 2
          
          if(Mod(inChar - 0x30cf, 3) == 1)
            outChar := 0xff9e ; テンテン
          else
            outChar := 0xff9f ; マル
        }
        else ; ヴ
        if(inChar == 0x30f4)
        {
          outChar := 0xff73 ; ウ
          MBS_WriteUint16(outPtr,outChar)
          outPtr += 2
          outChar := 0xff9e
        }
      }

      SetFormat, INTEGER, D
    }
    
    ; outCharが得られたので、書き込む
    MBS_WriteUint16(outPtr,outChar)
    outPtr += 2
  }
  
  ; 変換領域に、ターミネータを埋め込む
  MBS_WriteUint16(outPtr,0)
  
  ; MBに変換
  MBS_WideCharToMultiByte(outputVar,wcOut)
}




/* 
 ---------------------------------------------------------------
 これより下は、上記関数が呼び出す汎用的な関数です。
 ---------------------------------------------------------------
*/

/*
 ...............................................................
 
 全角、半角変換を行うための文字コードテーブルの作成
 
 MBS_MakeZenHanTable(symbol1, symbol2, symbol3, symbol4, kana)
  
    引数:
      symbol1      : 記号用テーブルを格納する変数(1/4)
      symbol2      : 記号用テーブルを格納する変数(2/4)
      symbol3      : 記号用テーブルを格納する変数(3/4)
      symbol4      : 記号用テーブルを格納する変数(4/4)
      kana         : カナ用テーブルを格納する変数

    戻り値: 
      なし

    動作:
      テーブルは、0x付きの16進数4ケタが、ビッチリと並べられている。
      最後にはダミーの0xがついているので、"0xabcd0x"という文字列を探せば、
      確実に所望のコードを探すことができる。

      半角カナの文字コードの並びに応じて、対応する全角カナの文字コードが
      並んでいるというスタイル。詳細は以下の通り(右側の16進数4ケタがテーブルに
      なっている)

            半角       全角
      symbol1
         !  0x0021  ！ FF01
         "  0x0022  ″ 2033
         #  0x0023  ＃ FF03
         $  0x0024  ＄ FF04
         %  0x0025  ％ FF05
         &  0x0026  ＆ FF06
         '  0x0027  ′ 2032
         (  0x0028  （ FF08
         )  0x0029  ） FF09
         *  0x002a  ＊ FF0A
         +  0x002b  ＋ FF0B
         ,  0x002c  ， FF0C
         -  0x002d  － 30FC
         .  0x002e  ． FF0E
         /  0x002f  ／ FF0F
      
         0  0x0030  ０ FF10
         9  0x0039  ９ FF19
      
      symbol2
         :  0x003a  ： FF1A
         ;  0x003b  ； FF1B
         <  0x003c  ＜ FF1C
         =  0x003d  ＝ FF1D
         >  0x003e  ＞ FF1E
         ?  0x003f  ？ FF1F
         @  0x0040  ＠ FF20
      
         A  0x0041  Ａ FF21
         Z  0x005a  Ｚ FF3A
      
      symbol3
         [  0x005b  ［ FF3B
         \  0x005c  ￥ FFE5
         ]  0x005d  ］ FF3D
         ^  0x005e  ＾ FF3E
         _  0x005f  ＿ FF3F
         `  0x0060  ｀ FF40
      
         a  0x0061  ａ FF41
         z  0x007a  ｚ FF5a
      
      symbol4
         {  0x007b  ｛ FF5B
         |  0x007c  ｜ FF5C
         }  0x007d  ｝ FF5D
         ~  0x007e  ～ 301C
      
      kana
         。 FF61    。 3002
         「 FF62    「 300C
         」 FF63    」 300D
         、 FF64    、 3001
         ・ FF65    ・ 30FB
         ヲ FF66    ヲ 30F2
         ァ FF67    ァ 30A1
         ィ FF68    ィ 30A3
         ゥ FF69    ゥ 30A5
         ェ FF6A    ェ 30A7
         ォ FF6B    ォ 30A9
         ャ FF6C    ャ 30E3
         ュ FF6D    ュ 30E5
         ョ FF6E    ョ 30E7
         ッ FF6F    ッ 30C3
         ー FF70    ー 30FC
      
         ア FF71    ア 30A2
         イ FF72    イ 30A4
         ウ FF73    ウ 30A6
         エ FF74    エ 30A8
         オ FF75    オ 30AA
      
         カ FF76    カ 30AB  (ガ 30AC)
         キ FF77    キ 30AD
         ク FF78    ク 30AF
         ケ FF79    ケ 30B1
         コ FF7A    コ 30B3
      
         サ FF7B    サ 30B5  (ザ 30B6)
         シ FF7C    シ 30B7
         ス FF7D    ス 30B9
         セ FF7E    セ 30BB
         ソ FF7F    ソ 30BD
      
         タ FF80    タ 30BF  (ダ 30C0)
         チ FF81    チ 30C1  (ヂ 30C2 ッ 30C3)
         ツ FF82    ツ 30C4  (ヅ 30C5)
         テ FF83    テ 30C6
         ト FF84    ト 30C8
      
         ナ FF85    ナ 30CA
         ニ FF86    ニ 30CB
         ヌ FF87    ヌ 30CC
         ネ FF88    ネ 30CD
         ノ FF89    ノ 30CE
      
         ハ FF8A    ハ 30CF  (バ 30D0 パ 30D1)
         ヒ FF8B    ヒ 30D2
         フ FF8C    フ 30D5
         ヘ FF8D    ヘ 30D8
         ホ FF8E    ホ 30DB
      
         マ FF8F    マ 30DE
         ミ FF90    ミ 30DF
         ム FF91    ム 30E0
         メ FF92    メ 30E1
         モ FF93    モ 30E2
      
         ヤ FF94    ヤ 30E4
         ユ FF95    ユ 30E6
         ヨ FF96    ヨ 30E8
      
         ラ FF97    ラ 30E9
         リ FF98    リ 30EA
         ル FF99    ル 30EB
         レ FF9A    レ 30EC
         ロ FF9B    ロ 30ED
      
         ワ FF9C    ワ 30EF
         ン FF9D    ン 30F3
      
         ゛ FF9E    ゛ 309B
         ゜ FF9F    ゜ 309C

              (ヴ 30F4)

 ...............................................................
*/  
MBS_MakeZenHanTable(ByRef symbol1, ByRef symbol2, ByRef symbol3, ByRef symbol4
                    , ByRef kana)
{
   symbol1 :=
     (LTrim Join
      "
      0xFF01
      0x2033
      0xFF03
      0xFF04
      0xFF05
      0xFF06
      0x2032
      0xFF08
      0xFF09
      0xFF0A
      0xFF0B
      0xFF0C
      0x2015
      0xFF0E
      0xFF0F0x
      "
    )

  symbol2 :=
    (LTrim Join
    "
     0xFF1A
     0xFF1B
     0xFF1C
     0xFF1D
     0xFF1E
     0xFF1F
     0xFF200x
   "
   )
   
  symbol3 :=
   (LTrim Join
   "
    0xFF3B
    0xFFE5
    0xFF3D
    0xFF3E
    0xFF3F
    0xFF400x
   "
   )

  symbol4 :=
    (LTrim Join
    "
     0xFF5B
     0xFF5C
     0xFF5D
     0xFF5E0x
    "
    )
    
  kana :=
    (LTrim Join
    "
     0x3002
     0x300C
     0x300D
     0x3001
     0x30FB
     0x30F2
     0x30A1
     0x30A3
     0x30A5
     0x30A7
     0x30A9
     0x30E3
     0x30E5
     0x30E7
     0x30C3
     0x30FC
     0x30A2
     0x30A4
     0x30A6
     0x30A8
     0x30AA
     0x30AB
     0x30AD
     0x30AF
     0x30B1
     0x30B3
     0x30B5
     0x30B7
     0x30B9
     0x30BB
     0x30BD
     0x30BF
     0x30C1
     0x30C4
     0x30C6
     0x30C8
     0x30CA
     0x30CB
     0x30CC
     0x30CD
     0x30CE
     0x30CF
     0x30D2
     0x30D5
     0x30D8
     0x30DB
     0x30DE
     0x30DF
     0x30E0
     0x30E1
     0x30E2
     0x30E4
     0x30E6
     0x30E8
     0x30E9
     0x30EA
     0x30EB
     0x30EC
     0x30ED
     0x30EF
     0x30F3
     0x309B
     0x309C0x
    "
    )
}

/*
 ...............................................................
 
 英単語の先頭文字だけを大文字、あとは小文字にする
 全角の英字も、ちゃんと大文字小文字になる。
 
 MBS_StrToTitleCase(outputVar, inputVar)
  
    引数:
      outputVar    : 変換後の文字列を格納する変数
      inputVar     : 変換前の文字列を格納する変数

    戻り値: 
      なし

    動作:
      先頭の英字だけを大文字にして、他の英字は小文字にする。
      空白が現れたら、また、次の英字を大文字にする。
      AHKのソースコードの通りに書いたつもりなんですけど、間違ってたら
      ごめんなさい。
 ...............................................................
*/
MBS_StrToTitleCase(ByRef outputVar, ByRef inputVar)
{
  ; WCに変換する
  len := MBS_MultiByteToWideChar(wcVar,inputVar)
  
  ; 文字数分のループ
  nextUpFlag := true
  ptr := &wcVar
  Loop,%len%
  {
    wchar := MBS_ReadUint16(ptr)
    
    ; 英字か
    if((wchar <= 0x7d || (wchar >= 0xff10 && wchar <= 0xff5a) ) 
    && DllCall("IsCharAlphaW","Ushort",wchar))
    {
      ; 最初の一文字なら大文字に。そうでなければ小文字に
      if(nextUpFlag)
      {
        newWchar := DllCall("CharUpperW","Uint",wchar)
        MBS_WriteUint16(ptr,newWchar)
        nextUpFlag := false
      }
      else
      {
        newWchar := DllCall("CharLowerW","Uint",wchar)
        MBS_WriteUint16(ptr,newWchar)
      }
    }
    else ; 空白か
    if(wchar == 0x20 || wchar == 0x0d || wchar == 0x0a || wchar == 0x09
    || wchar == 0x3000)
    {
      nextUpFlag := true
    }

    ptr += 2
  }
  
  ; MBに変換する
  MBS_WideCharToMultiByte(outputVar, wcVar)
}


/*
 ...............................................................
 
 文字列サーチ関数群
 
 二つの文字列の比較(大文字小文字の区別あり)
 
 MBS_CondIfInStr_CaseSense(testPtr,searchPtr,searchLen)
  
    引数:
      testPtr      : 評価する文字列(UNICODE)へのポインタ
      searchPtr    : サーチする文字列(UNICODE)へのポインタ
      searchLen    : サーチする文字列の長さ

    戻り値: 
      一致したら0,一致しなかったらそれ以外

    動作:
      上記の通り
 ...............................................................
*/
MBS_CondIfInStr_CaseSense(testPtr,searchPtr,searchLen)
{
  ; ターミネータを突っ込む部分の退避
  tailPtr := testPtr + (searchLen * 2)
  stack1 := *tailPtr
  stack2 := *(tailPtr+1)

  ; ターミネータを突っ込む
  DllCall("RtlFillMemory", "Uint",tailPtr, "Uint",1,"UChar",0)
  DllCall("RtlFillMemory", "Uint",tailPtr+1, "Uint",1,"UChar",0)

  cmpResult := DllCall("lstrcmpW", "Uint",testPtr, "Uint",searchPtr)

  DllCall("RtlFillMemory", "Uint",tailPtr, "Uint",1,"UChar",stack1)
  DllCall("RtlFillMemory", "Uint",tailPtr+1, "Uint",1,"UChar",stack2)
  
  return cmpResult
}

/*
 ...............................................................
 
 文字列サーチ関数群
 
 二つの文字列の比較(大文字小文字の区別なし)
 
 MBS_CondIfInStr_NoCaseSense(testPtr,searchPtr,searchLen)
  
    引数:
      testPtr      : 評価する文字列(UNICODE)へのポインタ
      searchPtr    : サーチする文字列(UNICODE)へのポインタ
      searchLen    : サーチする文字列の長さ

    戻り値: 
      一致したら0,一致しなかったらそれ以外

    動作:
      上記の通り
 ...............................................................
*/
MBS_CondIfInStr_NoCaseSnstv(testPtr,searchPtr,searchLen)
{
  ; ターミネータを突っ込む部分の退避
  tailPtr := testPtr + (searchLen * 2)
  stack1 := *tailPtr
  stack2 := *(tailPtr+1)

  ; ターミネータを突っ込む
  DllCall("RtlFillMemory", "Uint",tailPtr, "Uint",1,"UChar",0)
  DllCall("RtlFillMemory", "Uint",tailPtr+1, "Uint",1,"UChar",0)

  cmpResult := DllCall("lstrcmpiW", "Uint",testPtr, "Uint",searchPtr)

  DllCall("RtlFillMemory", "Uint",tailPtr, "Uint",1,"UChar",stack1)
  DllCall("RtlFillMemory", "Uint",tailPtr+1, "Uint",1,"UChar",stack2)
  
  return cmpResult
}

/*
 ...............................................................
 
 文字列サーチ関数群
 
 複数の文字のどれかが、指定した文字であるかどうか(大文字小文字の区別なし)
 
 MBS_CondIfCharNotInStr(testPtr,searchPtr,searchLen)
  
    引数:
      testPtr      : 評価する文字(UNICODE)へのポインタ
      searchPtr    : サーチする文字群(UNICODE)へのポインタ
      searchLen    : サーチする文字群の数

    戻り値: 
      一致しなかったら0,一致したらそれ以外

    動作:
      searchPtrから並んでいるsearchLen個のUNICODE文字のどれもが、
      testPtrがさすUNICODE一文字と一致しなかったら0が返り、
      どれか一個でも一致したら、trueが返る
 ...............................................................
*/
MBS_CondIfCharNotInStr(testPtr,searchPtr,searchLen)
{

  ; テストする文字を取り出す
  code1 := *testPtr
  code2 := *(testPtr + 1)
  
  found := false

  ; searchLenの分だけ、searchPtrの文字列と比較
  Loop, %searchLen%
  {
    if(code1 == *searchPtr && code2 == *(searchPtr + 1))
    {
      found := true
      break
    }
    
    searchPtr += 2
  }

  return found
}

/*
 ...............................................................
 
 文字列サーチ関数群
 
 複数の文字のどれかが、指定した文字であるかどうか(大文字小文字の区別なし)
 
 MBS_CondIfCharInStr(testPtr,searchPtr,searchLen)
  
    引数:
      testPtr      : 評価する文字(UNICODE)へのポインタ
      searchPtr    : サーチする文字群(UNICODE)へのポインタ
      searchLen    : サーチする文字群の数

    戻り値: 
      一致したら0,一致しなかったらそれ以外

    動作:
      searchPtrから並んでいるsearchLen個のUNICODE文字のどれもが、
      testPtrがさすUNICODE一文字と一致しなかったらtrueが返り、
      どれか一個でも一致したら、0が返る
 ...............................................................
*/
MBS_CondIfCharInStr(testPtr,searchPtr,searchLen)
{

  ; テストする文字を取り出す
  code1 := *testPtr
  code2 := *(testPtr + 1)
  
  not_found := true

  ; searchLenの分だけ、searchPtrの文字列と比較
  Loop, %searchLen%
  {
    if(code1 == *searchPtr && code2 == *(searchPtr + 1))
    {
      not_found := false
      break
    }
    
    searchPtr += 2
  }

  return not_found
}

/*
 ...............................................................
 
 文字列サーチ関数群
 
 指定した文字列が出現する場所(文字数)を返す(大文字小文字の区別あり)
 
 pos:=MBS_wcStringGetPos_IfInStrCaseSnstv(testPtr,testLen, searchPtr,searchLen
                                           , dirLR,check_num,offset)
    引数:
      testPtr      : 評価する文字列(UNICODE)へのポインタ
      testLen      : 評価する文字列(UNICODE)の長さ
      searchPtr    : サーチする文字列(UNICODE)へのポインタ
      searchLen    : サーチする文字列(UNICODE)の長さ
      dirLR        : "L"か"R"を指定。サーチの向き
      check_num    : 何回目の出現の位置を返すか。
      offset       : ここで指定した文字数を飛ばした位置からサーチを開始

    戻り値: 
      指定した文字列が出現する場所(文字数)を返す。dirLRによらず、
      常に文字の先頭からの位置。一文字目は0となる。
      出現しなかったら-1が返る。

    動作:
      上記の通り
 ...............................................................
*/
MBS_wcStringGetPos_IfInStrCaseSnstv(testPtr,testLen, searchPtr,searchLen
                   , dirLR,check_num,offset)
{
  ; 方向に応じて、初期値を設定(これ以降、右も左も同じコードになる)
  ptr := testPtr
  MBS_wcStringGetPos_begin(ptr,delta,testCount
                            ,testPtr,testLen,searchLen,dirLR,offset)
  ; テスト回数分のループ
  Loop, %testCount%
  {
    if(MBS_CondIfInStr_CaseSense(ptr,searchPtr,searchLen) == 0)
    {
      check_num--
      if(check_num == 0)
       break
    }

    ptr := ptr + delta
  }

  return MBS_wcStringGetPos_end(check_num,ptr,testPtr)
}

/*
 ...............................................................
 
 文字列サーチ関数群
 
 指定した文字列が出現する場所(文字数)を返す(大文字小文字の区別なし)
 
 pos:=MBS_wcStringGetPos_IfInStrNoCaseSnstv(testPtr,testLen, searchPtr,searchLen
                                           , dirLR,check_num,offset)
    引数:
      testPtr      : 評価する文字列(UNICODE)へのポインタ
      testLen      : 評価する文字列(UNICODE)の長さ
      searchPtr    : サーチする文字列(UNICODE)へのポインタ
      searchLen    : サーチする文字列(UNICODE)の長さ
      dirLR        : "L"か"R"を指定。サーチの向き
      check_num    : 何回目の出現の位置を返すか。
      offset       : ここで指定した文字数を飛ばした位置からサーチを開始

    戻り値: 
      指定した文字列が出現する場所(文字数)を返す。dirLRによらず、
      常に文字の先頭からの位置。一文字目は0となる。
      出現しなかったら-1が返る。

    動作:
      上記の通り
 ...............................................................
*/
MBS_wcStringGetPos_IfInStrNoCaseSnstv(testPtr,testLen, searchPtr,searchLen
                   , dirLR,check_num,offset)
{
  ; 方向に応じて、初期値を設定(これ以降、右も左も同じコードになる)
  ptr := testPtr
  MBS_wcStringGetPos_begin(ptr,delta,testCount
                            ,testPtr,testLen,searchLen,dirLR,offset)
  ; テスト回数分のループ
  Loop, %testCount%
  {
    if(MBS_CondIfInStr_NoCaseSnstv(ptr,searchPtr,searchLen) == 0)
    {
      check_num--
      if(check_num == 0)
       break
    }

    ptr := ptr + delta
  }

  return MBS_wcStringGetPos_end(check_num,ptr,testPtr)
}

/*
 ...............................................................
 
 文字列サーチ関数群
 
 指定した文字群のうちどれかが出現する場所(文字数)を返す(大文字小文字の区別なし)
 
 pos:=MBS_wcStringGetPos_IfCharInStr(testPtr,testLen, searchPtr,searchLen
                                           , dirLR,check_num,offset)
    引数:
      testPtr      : 評価する文字列(UNICODE)へのポインタ
      testLen      : 評価する文字列(UNICODE)の長さ
      searchPtr    : サーチする文字群(UNICODE)へのポインタ
      searchLen    : サーチする文字群(UNICODE)の個数
      dirLR        : "L"か"R"を指定。サーチの向き
      check_num    : 何回目の出現の位置を返すか。
      offset       : ここで指定した文字数を飛ばした位置からサーチを開始

    戻り値: 
      指定した文字群のうちどれかが出現する場所(文字数)を返す。dirLRによらず、
      常に文字の先頭からの位置。一文字目は0となる。
      出現しなかったら-1が返る。

    動作:
      上記の通り
 ...............................................................
*/
MBS_wcStringGetPos_IfCharInStr(testPtr,testLen, searchPtr,searchLen
                   , dirLR,check_num,offset)
{
  ; 方向に応じて、初期値を設定(これ以降、右も左も同じコードになる)
  ptr := testPtr
  MBS_wcStringGetPos_begin(ptr,delta,testCount
                            ,testPtr,testLen,1,dirLR,offset)
  ; テスト回数分のループ
  Loop, %testCount%
  {
    if(MBS_CondIfCharInStr(ptr,searchPtr,searchLen) == 0)
    {
      check_num--
      if(check_num == 0)
       break
    }

    ptr := ptr + delta
  }

  return MBS_wcStringGetPos_end(check_num,ptr,testPtr)
}

/*
 ...............................................................
 
 文字列サーチ関数群
 
 指定した文字群のうち、どれとも一致しない文字が出現する場所(文字数)を返す
 (大文字小文字の区別なし)
 
 pos:=MBS_wcStringGetPos_IfCharNotInStr(testPtr,testLen, searchPtr,searchLen
                                           , dirLR,check_num,offset)
    引数:
      testPtr      : 評価する文字列(UNICODE)へのポインタ
      testLen      : 評価する文字列(UNICODE)の長さ
      searchPtr    : サーチする文字群(UNICODE)へのポインタ
      searchLen    : サーチする文字群(UNICODE)の個数
      dirLR        : "L"か"R"を指定。サーチの向き
      check_num    : 何回目の出現の位置を返すか。
      offset       : ここで指定した文字数を飛ばした位置からサーチを開始

    戻り値: 
      指定した文字群のうちどれとも一致しない文字が出現する場所(文字数)を返す。
      dirLRによらず、常に文字の先頭からの位置。一文字目は0となる。
      出現しなかったら-1が返る。

    動作:
      上記の通り
 ...............................................................
*/
MBS_wcStringGetPos_IfCharNotInStr(testPtr,testLen, searchPtr,searchLen
                   , dirLR,check_num,offset)
{
  ; 方向に応じて、初期値を設定(これ以降、右も左も同じコードになる)
  ptr := testPtr
  MBS_wcStringGetPos_begin(ptr,delta,testCount
                            ,testPtr,testLen,1,dirLR,offset)
  ; テスト回数分のループ
  Loop, %testCount%
  {
    if(MBS_CondIfCharNotInStr(ptr,searchPtr,searchLen) == 0)
    {
      check_num--
      if(check_num == 0)
       break
    }

    ptr := ptr + delta
  }

  return MBS_wcStringGetPos_end(check_num,ptr,testPtr)
}

/*
 ...............................................................
 
 文字列サーチ関数群
 
 上記関数の前処理
 
 MBS_wcStringGetPos_begin(ptr,delta,testCount
                          ,testPtr,testLen,searchLen,dirLR,offset)
    引数:
      ptr          : サーチを開始するポインタが格納される
      delta        : ポインタを動かす大きさ(2か-2)が格納される
      testCount    : サーチの回数が格納される
      testPtr      : 評価する文字列へのポインタ
      testLen      : 評価する文字列の長さ
      searchLen    : サーチする文字列の長さ
      dirLR        : "L"か"R"を指定。サーチの向き
      offset       : ここで指定した文字数を飛ばした位置からサーチを開始

    戻り値: 
      なし

    動作:
      上記の通り
 ...............................................................
*/
MBS_wcStringGetPos_begin(ByRef ptr,ByRef delta,ByRef testCount
                          ,testPtr,testLen,searchLen,dirLR,offset)
{
  if(dirLR == "L")
  {
    delta := 2
    ptr := testPtr + offset * 2
  }
  else
  {
    delta := -2
    ptr := testPtr + testLen * 2 - offset * 2 - searchLen * 2
  }

  ; テスト回数
  testCount := testLen - offset - searchLen + 1
  
  if(testCount < 0)
    testCount := 0
}

/*
 ...............................................................
 
 文字列サーチ関数群
 
 上記関数の後処理
 
 pos := MBS_wcStringGetPos_end(check_num,ptr,testPtr)

    引数:
      check_num    : 最終的に出現した回数。これが0なら、条件通りの
                     出現があったということ。
      ptr          : 最終的な出現位置(ポインタ)
      testPtr      : 評価する文字列の先頭ポインタ

    戻り値: 
      pos          : 出現位置。条件どおり出現しなかったら、-1

    動作:
      上記の通り
 ...............................................................
*/
MBS_wcStringGetPos_end(check_num,ptr,testPtr)
{
  if(check_num == 0)
    pos := (ptr - testPtr) >> 1
  else
    pos := -1
    
  return pos
}


/*
 ...............................................................
 
 マルチバイト文字列(Shift-JIS交じりASCIIなど)を、
 ワイドキャラクタ文字列(UNICODE)に変換する
 
 len := MBS_MultiByteToWideChar(wcstr, mbstr)

    引数:
      wcstr        : 変換後のワイドキャラクタ文字列が格納される変数
      mbstr        : マルチバイト文字列が格納された変数

    戻り値: 
      len          : 文字数。全角文字も１文字とカウントする。

    動作:
      上記の通り
 ...............................................................
*/
MBS_MultiByteToWideChar(ByRef wcstr, ByRef mbstr)
{
  ; まず、必要なバッファサイズを教えてもらう
  ; CP_ACPは0だそうだ。
  bufSize := DllCall("MultiByteToWideChar", "Uint",0, "Uint",0,"Str",mbstr,"Int",-1,"Uint",0,"Uint",0)
  
  ; それでは、文字列のバッファの作成
  ; WideCharは2バイトだと思ってるから→ * 2
  VarSetCapacity(wcstr,bufSize * 2)
  
  ; 変換
  DllCall("MultiByteToWideChar", "Uint",0, "Uint",0,"Str",mbstr,"Int",-1,"Str",wcstr,"Uint",bufSize)

  return bufSize - 1
}
  
/*
 ...............................................................
 
 ワイドキャラクタ文字列(UNICODE)を、
 マルチバイト文字列(Shift-JIS交じりASCIIなど)に変換する
 
 len := MBS_WideCharToMultiByte(mbstr, wcstr)

    引数:
      mbstr        : 変換後のマルチバイト文字列が格納される変数
      wcstr        : ワイドキャラクタ文字列が格納された変数

    戻り値: 
      なし

    動作:
      上記の通り
 ...............................................................
*/
MBS_WideCharToMultiByte(ByRef mbstr, ByRef wcstr)
{
  ; まず、必要なバッファサイズを教えてもらう
  ; CP_ACPは0だそうだ。
  bufSize := DllCall("WideCharToMultiByte", "Uint",0, "Uint",0,"Str",wcstr,"Int",-1,"Uint",0, "Uint",0, "Uint",0, "Uint",0)
  
  ; それでは、文字列のバッファの作成
  VarSetCapacity(mbstr,bufSize)
  
  ; 変換
  DllCall("WideCharToMultiByte", "Uint",0, "Uint",0,"Str",wcstr,"Int",-1,"Str",mbstr, "Uint",bufSize, "Uint",0, "Uint",0)

  return
}

/*
 ...............................................................
 
 マルチバイト文字列(Shift-JIS交じりASCIIなど)を、
 ワイドキャラクタ文字列(UNICODE)に変換する
 
 MBS_MultiByteToWideCharPtr(wcPtr,mbPtr, bufSize)

    引数:
      wcPtr        : 変換後のワイドキャラクタ文字列が格納される
                     バッファの先頭ポインタ
      mbPtr        : マルチバイト文字列が格納されたバッファへのポインタ
      bufSize      : wcPtrのバッファの大きさ(バイト数ではなく、UNICODE文字数)

    戻り値: 
      なし

    動作:
      上記の通り
 ...............................................................
*/
MBS_MultiByteToWideCharPtr(ptr, strPtr, bufSize)
{
  ; 変換
  DllCall("MultiByteToWideChar", "Uint",0, "Uint",0
          ,"Uint",strPtr,"Int",-1,"Uint",ptr,"Uint",bufSize)
}

/*
 ...............................................................
 
 ワイドキャラクタ文字列(UNICODE)を、
 マルチバイト文字列(Shift-JIS交じりASCIIなど)に変換する

 
 MBS_WideCharToMultiBytePtr(mbPtr,wcPtr, bufSize)

    引数:
      mbPtr        : 変換後のマルチバイト文字列が格納される
                     バッファの先頭ポインタ
      wcPtr        : ワイドキャラ文字列が格納されたバッファへのポインタ
      bufSize      : mbPtrのバッファの大きさ(バイト数)

    戻り値: 
      なし

    動作:
      上記の通り
 ...............................................................
*/
MBS_WideCharToMultiBytePtr(ptr, strPtr, bufSize)
{
  ; 変換
  DllCall("WideCharToMultiByte", "Uint",0, "Uint",0
          ,"Uint",strPtr,"Int",-1,"Uint",ptr, "Uint",bufSize
          , "Uint",0, "Uint",0)

  return
}

/*
 ...............................................................
 
 ワイドキャラクタ文字列(UNICODE)を、
 マルチバイト文字列(Shift-JIS交じりASCIIなど)に変換する
 
 MBS_WideCharToMultiByteStr(mbStr,wcPtr, bufSize)

    引数:
      mbStr        : 変換後のマルチバイト文字列が格納される
                     変数
      wcPtr        : ワイドキャラ文字列が格納されたバッファへのポインタ
      bufSize      : mbStrのバッファの大きさ(バイト数)

    戻り値: 
      なし

    動作:
      なぜ、MBS_WideCharToMultiBytePtr()があるのに、
      本関数を作ったか(両者はByRefかポインタかの違いしかない)
      
      AHKが、変数を、数値と認識するのか、文字列と認識するのかは、
      状況によって異なるのだが、DllCallで変数の中に文字列をつっこむ
      ような場合は、"Str"でつっこんで貰わないと、文字列と認識できない
      ようだ。
      
      例えば、以下のようなDllCallを行うとする。
      
      ; 1
      DllCall("xxxx","Str",str)
      
      ; 2
      DllCall("xxxx","Uint",&str)
      
      "xxxx"は、与えられたポインタに、文字列を格納する関数だと思って欲しい。
      "xxxx"にとって、1も2も、まったく同じ意味である。両者とも、変数strの
      領域に、文字列が格納される。

      しかし、AHKにとっては、2は、単に"xxxx"に数値を渡したことになり、
      strに文字列が格納されたことは認識できない。この場合、AHKは、strを
      数値だと思うようになり、
        str2 := str
      のような値のコピーを行うと、"xxxx"が格納した文字列の先頭の数バイトしか、
      str2にコピーされなくなってしまう。
      
      したがって、AHKが、strに、確かに文字列が格納されたことを認識するためには、
      1のように、"Str"で、DllCallをしなければならない。
      
      そのために、本関数を用意した。

 ...............................................................
*/
MBS_WideCharToMultiByteStr(ByRef output, strPtr, bufSize)
{
  ; 変換
  DllCall("WideCharToMultiByte", "Uint",0, "Uint",0
          ,"Uint",strPtr,"Int",-1,"Str",output, "Uint",bufSize
          , "Uint",0, "Uint",0)

  return
}

/*
 ...............................................................
 
 マルチバイト文字列(Shift-JIS交じりASCIIなど)を
 ワイドキャラクタ文字列(UNICODE)に変換する時に必要なバッファサイズを返す
 
 size := MBS_GetWcsSize(mbstrPtr,len="")

    引数:
      mbstrPtr     : マルチバイト文字列が格納されたバッファへのポインタ
      len          : 変換するマルチバイト文字列の長さ。省略時は、
                     すべての文字列(mbstrPtrからターミネータまでの文字列)

    戻り値: 
      size         : バッファサイズ(バイト数ではなく、UNICODE文字数)
                     lenを指定した場合は、ターミネータ分は含まないから注意

    動作:
      上記の通り
 ...............................................................
*/
MBS_GetWcsSize(mbstrPtr,len="")
{
  ; まず、必要なバッファサイズを教えてもらう
  ; CP_ACPは0だそうだ。
  if(len=="")
    len := -1

  return DllCall("MultiByteToWideChar", "Uint",0
                 , "Uint",0,"Uint",mbstrPtr,"Int",len,"Uint",0,"Uint",0)
}

/*
 ...............................................................
 
 ワイドキャラクタ文字列(UNICODE)を
 マルチバイト文字列(Shift-JIS交じりASCIIなど)に変換する時に
 必要なバッファサイズを返す
 
 size := MBS_GetMbsSize(wcstrPtr,len="")

    引数:
      wcstrPtr     : ワイドキャラ文字列が格納されたバッファへのポインタ
      len          : 変換するワイドキャラ文字列の長さ。省略時は、
                     すべての文字列(wcstrPtrからターミネータまでの文字列)

    戻り値: 
      size         : バッファサイズ(バイト数)
                     lenを指定した場合は、ターミネータ分は含まないから注意

    動作:
      上記の通り
 ...............................................................
*/
MBS_GetMbsSize(wcstrPtr,len="")
{
  ; まず、必要なバッファサイズを教えてもらう
  ; CP_ACPは0だそうだ。
  if(len=="")
    len := -1
    
  return DllCall("WideCharToMultiByte", "Uint",0
                 , "Uint",0,"Uint",wcstrPtr,"Int",len,"Uint",0,"Uint",0
                 , "Uint",0, "Uint",0)
}

/*
 ...............................................................
 
 メモリの取得
 
 ptr := MBS_Alloc(size)

    引数:
      size         : 取得したいメモリのバイト数

    戻り値: 
      ptr          : 取得したメモリのポインタ
                     失敗したときは、NULLが返る

    動作:
     ここで取得したメモリは、用が済んだら、必ずMBS_Free()で解放すること。
     さもないと、メモリリークの原因となる。
 ...............................................................
*/
MBS_Alloc(size)
{
  static heapHandle
  
  if(!heapHandle)
    heapHandle := DllCall("GetProcessHeap")

  return DllCall("HeapAlloc","Uint",heapHandle,"Uint",0,"Uint",size)
}
  
/*
 ...............................................................
 
 メモリの解放
 
 result := MBS_Free(ptr)

    引数:
      ptr          : 解放したいメモリのポインタ。必ず、MBS_Alloc()で取得した
                     ものであること。

    戻り値: 
      result       : 成功したらtrue,失敗したらfalse

    動作:
      上記の通り
 ...............................................................
*/
MBS_Free(ptr)
{
  static heapHandle
  
  if(!heapHandle)
    heapHandle := DllCall("GetProcessHeap")

  return DllCall("HeapFree","Uint",heapHandle,"Uint",0,"Uint",ptr)
}

/*
 ...............................................................
 
 メモリのサイズ変更
 
 new_ptr := Reallocate(ptr,size)

    引数:
      ptr          : サイズ変更したいメモリのポインタ。
                     必ず、MBS_Alloc()で取得したものであること。
      size         : 新しいサイズ

    戻り値: 
      new_ptr      : サイズがsizeとなったメモリのポインタ。
                     ptrと同じかどうかはわからない。
                     失敗した場合はNULL

    動作:
      上記の通り
 ...............................................................
*/
MBS_Reallocate(ptr,size)
{
  static heapHandle
  
  if(!heapHandle)
    heapHandle := DllCall("GetProcessHeap")

  return DllCall("HeapReAlloc","Uint",heapHandle,"Uint",0
                                                  ,"Uint",ptr,"Uint",size)
}

/*
 ...............................................................
 
 Unsigned int(32bit)の読み出し
 
 val := MBS_ReadUint(ptr)

    引数:
      ptr          : 読み出したいポインタ

    戻り値: 
      val          : ptrからはじまる4byte(32bit)のデータを符号なし整数
                     で表現した値。
                     データは、リトルエンディアンで格納されていること。

    動作:
      上記の通り
 ...............................................................
*/
MBS_ReadUint(ptr)
{
  val := *ptr | (*(ptr+1) << 8) | (*(ptr+2) << 16) | (*(ptr+3) << 24)
  return val
}

/*
 ...............................................................
 
 Unsigned int(32bit)の書き込み
 
 MBS_ReadUint(ptr,val)

    引数:
      ptr          : 書き込みたいポインタ
      val          : 書き込みたい値(符号なし整数値)

    戻り値: 
      なし

    動作:
      ptrから4byte(32bit)のデータとして、valの値を書き込む。
      リトルエンディアンで書き込む。
 ...............................................................
*/
MBS_WriteUint(ptr,val)
{
  byte1 := (val & 0x000000ff)
  byte2 := (val & 0x0000ff00) >> 8
  byte3 := (val & 0x00ff0000) >> 16
  byte4 := (val & 0xff000000) >> 24

  DllCall("RtlFillMemory", "Uint",ptr,     "Uint",1,"UChar",byte1)
  DllCall("RtlFillMemory", "Uint",ptr + 1, "Uint",1,"UChar",byte2)
  DllCall("RtlFillMemory", "Uint",ptr + 2, "Uint",1,"UChar",byte3)
  DllCall("RtlFillMemory", "Uint",ptr + 3, "Uint",1,"UChar",byte4)
}

/*
 ...............................................................
 
 Unsigned int(16bit)の読み出し
 
 val := MBS_ReadUint16(ptr)

    引数:
      ptr          : 読み出したいポインタ

    戻り値: 
      val          : ptrからはじまる2byte(16bit)のデータを符号なし整数
                     で表現した値。
                     データは、リトルエンディアンで格納されていること。

    動作:
      上記の通り
 ...............................................................
*/
MBS_ReadUint16(ptr)
{
  val := *ptr | (*(ptr+1) << 8)
  return val
}

/*
 ...............................................................
 
 Unsigned int(16bit)の書き込み
 
 MBS_ReadUint16(ptr,val)

    引数:
      ptr          : 書き込みたいポインタ
      val          : 書き込みたい値(符号なし整数値)

    戻り値: 
      なし

    動作:
      ptrから2byte(16bit)のデータとして、valの値を書き込む。
      リトルエンディアンで書き込む。
 ...............................................................
*/
MBS_WriteUint16(ptr,val)
{
  byte1 := (val & 0x000000ff)
  byte2 := (val & 0x0000ff00) >> 8

  DllCall("RtlFillMemory", "Uint",ptr,     "Uint",1,"UChar",byte1)
  DllCall("RtlFillMemory", "Uint",ptr + 1, "Uint",1,"UChar",byte2)
}

