/* 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 "AHK�̃_�������΍�"
 mbstring.ahk
   AutoHotkey�ŁA���{��(�}���`�o�C�g������)�̏������s�����߂�
   �����񏈗����C�u�����B
   �ڍׂ́A
   http://www.tierra.ne.jp/~aki/diary/?date=20060111#p01
   ���Q�Ƃ��Ă��������B

   ver0.09.00   06/1/4
   �Ȃ܂�

 �����̃v���O�����͂Ȃ܂��̒��앨�ł����A��������ς͎��R�ɍs���Ă���������
   ���\�ł��B�܂��A�ĔЕz(���O���M)�⏤�Ɨ��p���܂ޏ��n���A�u�Ȃ܂��v�̖��O�ƁA
   URL(http://www.tierra.ne.jp/~aki/diary/)��Y���Ă���������΁A�����R��
   ���Ă��������Č��\�ł��B���ς������̂��ĔЕz(���O���M)����n����ꍇ�́A
   ���ς����|��\�L���Ă��������B
 �����̃v���O�����𗘗p���Đ����������Ȃ鑹�Q�ɑ΂��Ă��A�Ȃ܂��͐ӔC�𕉂���
   ����B�������炸���������������B

 �ύX����

 ver0.09.00   06/1/4
   �ŏ��̃o�[�W����

 �ړ���
   MBS_
   �{�t�@�C���Œ�`���ꂽ�O���[�o����(�֐�)�́A���ׂ�
   "MBS_"�Ƃ����ړ�������B
   
 �O���[�o���ϐ�
   ��؃O���[�o���ϐ��͎g���Ă��Ȃ��B
   
 �}���`�X���b�h�Z�[�t
   �{�֐��͂��ׂă}���`�X���b�h�Z�[�t�ł���B
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/

/*
 ...............................................................

  "InStr"(http://lukewarm.s101.xrea.com/Scripts.htm)�̑���
  
  MBS_InStr(inputVar, searchText[, caseSnstv, startingPos])
    ����:   
      inputVar  :    �������镶����(�I���W�i���Ɠ���)
      searchText :   ����������(�I���W�i���Ɠ���)
      caseSnstv :    true�ŁA�啶���������̋�ʂ�����B�ȗ�����false
                     (�I���W�i���Ɠ���)
      startingPos :  �����J�n�����w��(�I���W�i���Ɠ���)
    �߂�l: 
      searchText��inputVar�̒��ōŏ��ɏo������ʒu��Ԃ��B
      �o�����Ȃ�������0(= false)�B
      (�I���W�i���Ɠ���)
    ����:
      �_��������肪�Ȃ��ȊO�A
      �I���W�i����InStr�Ɠ����B�S�p������1�����Ɛ�����B

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

  "If var is type"(http://lukewarm.s101.xrea.com/commands/IfIs.htm)�̑���
  
  MBS_IfVarIsType(var, type)
    ����:   
      var  :         �������镶����(�I���W�i���Ɠ���)
      type :         ��������^������킷������
                     �I���W�i���Ɠ����^���w��ł��邪�A�ǉ��ňȉ��̌^��
                     �w��ł���B
                       hankaku  : var�����ׂĔ��p��������true
                                  ���p�J�i�����p�Ƃ݂Ȃ��B
                       zenkaku  : var�����ׂđS�p��������true
    �߂�l: 
      var�����ׂ�type�Ŏw�肵���^��������true,�����łȂ����false���Ԃ�
      (�I���W�i���Ɠ���)
    ����:
      type��"integer","float","number","time"�̏ꍇ�Avar�����ׂĔ��p��������A
      �I���W�i����If var is type���R�[������B�S�p��������Afalse��Ԃ��B
      "hankaku","zenkaku","digit","xdigit","alpha","upper","lower","alnum",
      "space"��������A�S�p�A���p���l�������������s���B
      �Ⴆ�΁A"digit"�̏ꍇ�A�S�p�̂P�Q�R�ł��Atrue���Ԃ�B�܂��A"space"������
      �ꍇ�́A�S�p�̋󔒂�true���Ԃ�B
      ����ȊO�́A�I���W�i���Ɠ����B

 ...............................................................
*/  
MBS_IfVarIsType(ByRef var, type)
{
  
  ; WC�ɕϊ�����
  len := MBS_MultiByteToWideChar(wcVar,var)
  
  ; ���������̃��[�v�̏���
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
    
    ; �S�p�����p��
    ;  0x00�`0x7e       ���p�J�i
    if(wchar <= 0x7e || (wchar >= 0xff61 && wchar <= 0xff9f))
    {
      hankaku := true
    }
    else
    {
      zenkaku := true
    }
      
    ; �������p����
    ; ������Ђ炪�Ȃ͉��L�֐��͐����������Ȃ��̂ŁA�p�����݂̂𗬂�
    if((wchar <= 0x7d || (wchar >= 0xff10 && wchar <= 0xff5a) ) 
    && DllCall("IsCharAlphaNumericW","Ushort",wchar))
    {
      ; �p����
      if(DllCall("IsCharAlphaW","Ushort",wchar))
      {
        ; A-F,a-f��(���p�S�p)
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
          
        ; upper��lower��
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
  
  ; ���ׂĔ��p�ŁA�ȉ���type�̏ꍇ�́A�W���̃R�}���h�ɔC����
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

  "Loop,PARSE"(http://lukewarm.s101.xrea.com/commands/LoopParse.htm)�̑���
  
  MBS_ParseBegin(inputVar [, delimiters, omitChars, mark])
    ����:   
      inputVar :     ��������镶���񂪊i�[���ꂽ�ϐ���(�I���W�i���Ɠ���)
      delimiters :   ��؂蕶���Ƃ��Ďg�p�������������
                     �I���W�i���Ɠ����Ӗ������A"CSV"�͎w��ł��Ȃ��B
                     �������A�S�p�������w��ł���B
                     �ȗ����́A1�o�C�g�����������
      omitChars :    �e�t�B�[���h�̐擪�Ɩ��������菜�������������
                     (�I���W�i���Ɠ���)
                     �������A�S�p�������w��ł���B
      mark :         MBS_ParseReturn()�Ŕ�����ہA�����o�����[�v���w�肷��B
                     (��q)

    �߂�l: 
      ��������true,�������擾�Ɏ��s�����ꍇ��false�B
      �������A�����炭�������擾�Ɏ��s�����ꍇ�́AAHK���̂��܂Ƃ��ɓ����Ȃ�
      ���낤����A�`�F�b�N�͂��܂�Ӗ����Ȃ��Ǝv���B

    ����:
      Loop, PARSE�Ɠ��l�ȓ���������邽�߂̊֐��B
      �ȉ��̋L�q�́A�܂����������Ӗ��ƂȂ�B
      
      ; �I���W�i��
      Loop, PARSE, inputVar, `,
      {
        MsgBox, %A_LoopField%
      }
      
      ; �{�֐�(�_�������Ȃ�)
      MBS_ParseBegin(inputVar,",")
      Loop
      {
        if(!MBS_Parse(loopField))
          break
          
        MsgBox, %A_LoopField%
      }
      MBS_ParseEnd()
      
      
      MBS_ParseBegin()�ƁAMBS_ParseEnd()�Ƃ́A�K�����[�v�̊O�ɁA�Z�b�g��
      ���݂��Ȃ���΂Ȃ�Ȃ��B
      ���[�v�̒�����A�����Ȃ�return����悤�ȏꍇ�́AMBS_ParseReturn()��
      �g���A����ɁA�����o�郋�[�v�̐擪��MBS_ParseBegin()�ŁA
      mark��true�ɂ��Ă����Ȃ���΂Ȃ�Ȃ��B
      
      ; �I���W�i��
      Loop, PARSE, inputVar1, `,
      {
        Loop, PARSE, inputVar2, `,
        {
          if(A_LoopField == "end")
            return
        }
      }
      
      ; �{�֐�(�_�������Ȃ�)
      MBS_ParseBegin(inputVar1,",","",true)  ; mark��true��
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
            MBS_Return() ; return�̑O�ɁA���Ȃ炸MBS_Return()���Ă�
                         ; ���̃R�[���ŁA��ԍŋ�mark��true�ɂ������[�v
                         ; (���̏ꍇ��inputVar1�̃��[�v)�܂ł��A���������B
            return
          }
        }
        MBS_ParseEnd()
      }
      MBS_ParseEnd()
      
      
      �I���W�i���Ɠ����悤�ɁAinputVar�̓��e�́A�����Ɏ�荞�܂��̂ŁA
      MBS_ParseBegin()�̌�ŁA���R�ɓ��e��ύX���Ă悢�B
      
      ����������������AMBS_ParseBegin()�Ŏn�܂郋�[�v�́A����ł�����q��
      ���邱�Ƃ��ł���B�������A���[�v�̊O�ɁA�K���Ή�����MBS_ParseEnd()
      ���R�[�����Ȃ���΂Ȃ�Ȃ�(�������Ȃ��ƁA����q�̊O�ɏo�����Ƃ�F��
      �ł��Ȃ�)�BMBS_ParseEnd()���R�[�������ɁA��C�ɓ���q��E�o����ꍇ�́A
      MBS_ParseReturn()���R�[������B����ƁA��ԍŋ߂�mark��true�ɂ���
      MBS_ParseBegin()�̃��[�v�܂ł��A���������B

      �I���W�i���ƈقȂ�Adelimiters��"CSV"���w�肷�邱�Ƃ��ł��Ȃ��B
      (����)"CSV"�ł́A�_��������肪�������Ȃ��̂ŁA
      �I���W�i����Loop,PARSE�̕������g���ɂȂ邱�Ƃ������߂���B

 ...............................................................
*/  
MBS_ParseBegin(ByRef inputStr,searchStr="",omitStr="",mark = false)
{
  return MBS_Parse(dummy,3,inputStr,searchStr,omitStr,mark)
}

/*
 ...............................................................

  "Loop,PARSE"(http://lukewarm.s101.xrea.com/commands/LoopParse.htm)�̑���
  
  MBS_ParseEnd()
    ����:
      �Ȃ�

    �߂�l: 
      �Ȃ�

    ����:
      �Ή�����MBS_ParseBegin()�Ŏn�܂郋�[�v����������B
      �ڍׂ�MBS_ParseBegin()���Q�Ƃ̂��ƁB

 ...............................................................
*/  
MBS_ParseEnd()
{
  MBS_Parse(dummy,4)
}

/*
 ...............................................................

  "Loop,PARSE"(http://lukewarm.s101.xrea.com/commands/LoopParse.htm)�̑���
  
  MBS_ParseReturn()
    ����:
      �Ȃ�

    �߂�l: 
      �Ȃ�

    ����:
      ��ԍŋ߂�mark��true�ɂ���MBS_ParseBegin()�Ŏn�܂郋�[�v�܂ł̓���q��
      ���[�v����������B
      �ڍׂ�MBS_ParseBegin()���Q�Ƃ̂��ƁB

 ...............................................................
*/  
MBS_ParseReturn()
{
  MBS_Parse(dummy,5)
}

/*
 ...............................................................

  "Loop,PARSE"(http://lukewarm.s101.xrea.com/commands/LoopParse.htm)�̑���
  
  index := MBS_Parse(loopField [,method])
    ����:
      loopField : �؂���ꂽ�����񂪊i�[�����B�I���W�i����A_LoopField��
                  �����B
      method    : ���܂��@�\�B
                  1���w�肷��ƁA�E�[�̕������؂���AloopField
                  �Ɋi�[����B
                  2���w�肷��ƁA�؂���ꂽ��̎c��̕����񂷂ׂĂ�loopField
                  �Ɋi�[����B
                  �ȗ����́A�ʏ�ʂ�A���[�̕������؂���AloopField��
                  �i�[����B
                  1�w�莞(�E�[�؂��莞)�́A���[�w�莞�Ɠ����悤�ɁA������
                  �ۑ����Ă��镶����͒Z���Ȃ�B�܂�A1���w�肵��MBS_Parse()��
                  �R�[������΁A�E�[����Aparse���Ă������ƂɂȂ�B
                  2�w�莞(�c�蕶������o����)�́A�؂��蓮��͍s��Ȃ��B
                  �܂�A2���w�肵��MBS_Parse()�����x�Ă�ł��A���̂��т�
                  loopField�͓����l������A�ω����Ȃ��B

    �߂�l: 
      index    :  ���[�v�񐔁B�I���W�i����A_Index�Ɠ����B
                  ���ׂ�Parse���I���ƁA0���Ԃ�B���̏ꍇ�AloopField��NULL��
                  �i�[�����B

    ����:
      ����̏ڍׂ́AMBS_ParseBegin()���Q�Ƃ̂��ƁB
      
      method�̎g�����́A�ȉ����Q�Ƃ̂��ƁB
      
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
  ; ���݂̃��[�v�ŏ������̎����́A���������擾���A���̒��Ɋi�[���Ă���B
  ; �������A��������MBS_Parse()�̂��тɂ��̃���������ǂݏo���A�܂��i�[����
  ; �̂ł͌����������̂ŁA���i��static�ϐ��ŕێ����Ă����A���[�v��
  ; ����q�ɂȂ�(�V����MBS_ParseBegin()���Ă΂��)�Ƃ��A����q����o��
  ; (MBS_ParseEnd()��MBS_ParseReturn()���Ă΂��)�Ȃǂ̏󋵂ɂȂ����Ƃ������A
  ; �������Ɋi�[������A�ǂݏo�����肷��悤�ɂ���B

  ; �}���`�X���b�h�Z�[�t�ȃR�[�h�ɂ��邽�߁Astatic�ϐ��ւ̏����߂���
  ; Critical�ɂ���ăN���e�B�J���Z�N�V�����ɂ��邱�ƂŁA�ی삵�Ă���B

  static stack
  static handlePtr
  static inputPtr,inputLen,inputRemain
  static searchPtr,searchLen
  static omitPtr,omitLen
  static fieldNum

  dlmt := Chr(0x2c) ; ","
  markCode := Chr(0x3a) ; ":"
  absltNoExistCode := Chr(1)

  ; ���[�v�Ώێ��� := 
  ; ���ݏ������|�C���^ ���ݏ����c�蕶���� ����܂Ő؂�o�����t�B�[���h��
  ; ���͕����񕶎��� ���͕����� �T�[�`�����񕶎��� �T�[�`������ 
  ; ���O�����񕶎��� ���O������

  if(!method || method == 1)
  {
    ; ���[�v�̒��B�t�B�[���h�̐؂�o��

    ; ���ׂăp�[�X���Ďc�肪�������false�Ń��^�[��
    if(inputRemain == 0)
    {
      ;Parse_in--
      return false
    }
    
    ; �擪�̃t�B�[���h�̐؂藣��
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
        ; �f���~�^�������ł��Ȃ�������A�c��̕�����͑S���t�B�[���h
        fieldLen := inputRemain
        input_remain := 0
      }
      else
      {
        input_remain := inputRemain - fieldLen - 1  ; -1�̓f���~�^��
        input_ptr := inputPtr + (fieldLen + 1) * 2
      }
    }
    else
    {
      ; ���܂��@�\�B�E����p�[�X����
      if(searchLen)
        fieldLen := MBS_wcStringGetPos_IfCharInStr(fieldPtr,inputRemain
                                                 ,searchPtr,searchLen
                                                 ,"R",1,0)
      else
        fieldLen := 1

      if(fieldLen == -1)
      {
        ; �f���~�^�������ł��Ȃ�������A�c��̕�����͑S���t�B�[���h
        fieldLen := inputRemain
        input_remain := 0
      }
      else
      {
        ; ����fieldLen�́A�E�͂��̃f���~�^���w���Ă���B
        ; ���̈ʒu��fieldPtr��ύX���āA�����fieldLen���C������B
        fieldLen     := inputRemain - fieldLen - 1
        input_remain := inputRemain - fieldLen - 1  ; -1�̓f���~�^��
        fieldPtr     := inputPtr + (input_remain + 1) * 2  ; +1�̓f���~�^��
        ; inputPtr�͓������Ȃ��B���̂܂�
        input_ptr    := inputPtr
      }
    }

    ; fieldPtr����AfieldLen�̒������A�؂�o���t�B�[���h�B���ꂩ��A
    ; ���O������O�ォ��؂藣��
    if(fieldLen && omitLen)
    {
      lPos := MBS_wcStringGetPos_IfCharNotInStr(fieldPtr,fieldLen
                                                ,omitPtr,omitLen
                                                ,"L",1,0)


      if(lPos == -1)
        fieldLen := 0
      else
      {
        ; �擪�͏��O�����B���������O����B
        fieldPtr := fieldPtr + lPos * 2
        fieldLen := fieldLen - lPos
        rPos := MBS_wcStringGetPos_IfCharNotInStr(fieldPtr,fieldLen
                                                  ,omitPtr,omitLen
                                                  ,"R",1,0)
        ; ���O�ȊO�̕����͂��肦�Ȃ�
        fieldLen := rPos + 1
      }
    }
    
    ; fieldPtr����fieldLen�̒������A������o���t�B�[���h
    bufSize := MBS_GetMbsSize(fieldPtr,fieldLen)
    VarSetCapacity(loopField,bufSize + 1) ; +1�̓^�[�~�l�[�^��

    ; �}���`�o�C�g������ɕϊ�
    ; loopField�́A�|�C���^�ł͓n���Ȃ�
    MBS_WideCharToMultiByteStr(loopField,fieldPtr,bufSize)

    ; endcode���ߍ���
    DllCall("RtlFillMemory", "Uint",(&loopField) + bufSize
             ,"Uint",1,"UChar",0)
    
    ; �Ō�Astatic�ϐ��̏��������ƁA���[�v�J�E���^���J�E���g�A�b�v
    ; ���������A�N���e�B�J���Z�N�V�����ɂ���
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
    ; ���܂��@�\
    ; �p�[�X�����c��̕���������o��
  
    ; ���ׂăp�[�X���Ďc�肪�������NULL��Ԃ�
    if(inputRemain == 0)
    {
      loopField := ""
      return
    }
    
    ; inputPtr����inputRemain�����o��
    bufSize := MBS_GetMbsSize(inputPtr,inputRemain)
    VarSetCapacity(loopField,bufSize + 1) ; +1�̓^�[�~�l�[�^��

    ; �}���`�o�C�g������ɕϊ�
    ; loopField�́A�|�C���^�ł͓n���Ȃ�
    MBS_WideCharToMultiByteStr(loopField,inputPtr,inputRemain)

    ; endcode���ߍ���
    DllCall("RtlFillMemory", "Uint",(&loopField) + bufSize
             ,"Uint",1,"UChar",0)
  }
  else
  if(method == 3)
  {
    ; Begin(���[�v�̐擪)
    ; ���͕�������󂯎��AUNICODE�ɓW�J���āA�{�֐����ɕێ�����

    ;
    ; �܂��A���݂̃X�e�[�g(static�ϐ�)���������ɏ����߂�
    if(handlePtr)
    {
      ptr := handlePtr
      MBS_WriteUint(ptr,inputPtr)
      ptr += 4
      MBS_WriteUint(ptr,inputRemain)
      ptr += 4
      MBS_WriteUint(ptr,fieldNum)
    }

    ; �����ɉ����������̎擾
    ; �܂��A�K�v�ȃ������ʂ̌v�Z
    new_inputBsz :=  MBS_GetWcsSize(&inputStr)
    new_searchBsz := MBS_GetWcsSize(&searchStr)
    new_omitBsz :=   MBS_GetWcsSize(&omitStr)
    allSize := new_inputBsz * 2 + new_searchBsz * 2 + new_omitBsz * 2 + 4 * 6
     ; inputPtr + inputRemain + fieldNum + inputLen + searchLen + omitLen = 6

    ; �������̎擾
    ptr := MBS_Alloc(allSize)
    
    if(!ptr)
      return false

    ; �}�[�N���Z�b�g����Ă�����A�}�[�N�L�������߂���
    markFlag := ""
    if(mark)
      markFlag := markCode
      
    ; �����u���b�N�̃|�C���^��stack�ɕۑ�
    new_stack := stack . markFlag . dlmt . ptr
    handle_ptr := ptr
    
    ; �����̕�����̏��������u���b�N�ɋL�^���AUNICODE�ɕϊ�����
    ; ���͕�����̕��������L�^
    input_len := new_inputBsz - 1 ; �^�[�~�l�[�^��
    ptr += 4 * 3  ; inputPtr + inputRemain + fieldNum = 3
    MBS_WriteUint(ptr,input_len)
    ptr += 4
    ; UNICODE�ɕύX
    MBS_MultiByteToWideCharPtr(ptr,&inputStr,new_inputBsz)
    input_ptr := ptr
    ptr := ptr + new_inputBsz * 2

    ; ����������̕��������L�^
    search_len := new_searchBsz - 1 ; �^�[�~�l�[�^��
    MBS_WriteUint(ptr,search_len)
    ptr += 4
    ; UNICODE�ɕύX
    MBS_MultiByteToWideCharPtr(ptr,&searchStr,new_searchBsz)
    search_ptr := ptr
    ptr := ptr + new_searchBsz * 2
    
    ; ���O������̕��������L�^
    omit_len := new_omitBsz - 1 ; �^�[�~�l�[�^��
    MBS_WriteUint(ptr,omit_len)
    ptr += 4
    ; UNICODE�ɕύX
    MBS_MultiByteToWideCharPtr(ptr,&omitStr,new_omitBsz)
    omit_ptr := ptr

    ; �������I������̂ŁAstatic�ϐ��ɏ����߂�
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
    ; End(���[�v�̏I���)
    ; ���[�v�̃X�^�b�N����グ��(������?)

    ; stack�����񂩂�A�E�[�̃|�C���^���폜
    StringGetPos,pos,stack,%dlmt%,R1
    StringLeft,new_stack,stack,%pos%

    ; �����ŁAstatic�ϐ�stack������������B
    Critical
    stack := new_stack
    old_handle_ptr := handlePtr

    if(stack != "")
    {
      StringGetPos,pos,stack,%dlmt%,R1
      pos++
      StringTrimLeft,ptr,stack,%pos%
      ; markCode�̍폜�B����͊֌W�Ȃ�
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

    ; �Ō��handlePtr������������B
    ; �����̔p���̑O�Ƀ|�C���^�����������Ă����͔̂��ɏd�v�B
    ; ���̏��Ԃ��ԈႦ��Ƃ��Ȃ����ȃo�O�𐶂ނ�B
    handlePtr   := handle_ptr
    Critical,Off

    ; �Â�������p������B
    MBS_Free(old_handle_ptr)
  }
  else
  if(method == 5)
  {
    ; Return(���[�v����̒E�o)
    ; ���[�v�̃X�^�b�N���A�}�[�N���ꂽ�Ƃ���ɖ߂��B
    ; �㔼�́AEnd�Ƃ܂����������R�[�h

    ; markCode��T��
    StringGetPos,pos,stack,%markCode%,R1
    if(pos == -1)
    {
      ; markCode������Ȃ�������A�S���̃X�^�b�N���폜����
      new_stack := ""
      old_stack := stack
    }
    else
    {
      StringLeft,new_stack,stack,%pos%
      pos++
      StringTrimLeft,old_stack,stack,%pos%
    }

    ; �����̕���(����ȍ~�AEnd�Ɠ����R�[�h)
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
    
    ; �����̍폜(old_stack)
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

  "StringLower"(http://lukewarm.s101.xrea.com/commands/StringLower.htm)�̑���
  
  MBS_StringLower(outputVar, inputVar [, title])

    ����:
      outputVar : �ϊ���̕�������i�[����ϐ���(�I���W�i���Ɠ���)
      inputVar  : �ϊ����Ƃ̕�����̓������ϐ��̖��O
      title     : "T"(�ق�Ƃ́ANULL�ȊO���w�肷��΂Ȃ�ł�����)��
                  �w�肷��ƁA�P��̐擪�������啶���Ō�͏������̌`����
                  �ϊ������

    �߂�l: 
      �Ȃ�

    ����:
      �p�����������ɂ���B�S�p�̉p�����������ɂȂ�B
      ���́Atitle���w�肵�����ȊO�́A�W����StringLower���Ă�ł���B
      title���w�肵���ꍇ�́A�W���ł̓_��������肪�o��̂ŁA
      ���̊֐��ŏ������Ă���B

 ...............................................................
*/  
MBS_StringLower(ByRef outputVar, ByRef inputVar, title = "")
{
  if(title == "")
  {
    StringLower, outputVar, inputVar
    return
  }
  
  ; "T"�̂��߂̊֐����Ăяo���BUpper�ŌĂԂ̂Ɠ���
  MBS_StrToTitleCase(outputVar, inputVar)
}

/*
 ...............................................................

  "StringUpper"(http://lukewarm.s101.xrea.com/commands/StringLower.htm)�̑���
  
  MBS_StringUpper(outputVar, inputVar [, title])

    ����:
      outputVar : �ϊ���̕�������i�[����ϐ���(�I���W�i���Ɠ���)
      inputVar  : �ϊ����Ƃ̕�����̓������ϐ��̖��O
      title     : "T"(�ق�Ƃ́ANULL�ȊO���w�肷��΂Ȃ�ł�����)��
                  �w�肷��ƁA�P��̐擪�������啶���Ō�͏������̌`����
                  �ϊ������

    �߂�l: 
      �Ȃ�

    ����:
      �p����啶���ɂ���B�S�p�̉p�����啶���ɂȂ�B
      ���́Atitle���w�肵�����ȊO�́A�W����StringUpper���Ă�ł���B
      title���w�肵���ꍇ�́A�W���ł̓_��������肪�o��̂ŁA
      ���̊֐��ŏ������Ă���B

 ...............................................................
*/  
MBS_StringUpper(ByRef outputVar, ByRef inputVar, title = "")
{
  if(title == "")
  {
    StringUpper, outputVar, inputVar
    return
  }
  
  ; "T"�̂��߂̊֐����Ăяo���BLower�ŌĂԂ̂Ɠ���
  MBS_StrToTitleCase(outputVar, inputVar)
}

/*
 ...............................................................

  "StringLeft"(http://lukewarm.s101.xrea.com/commands/StringLeft.htm)�̑���
  
  MBS_StringLeft(outputVar, inputVar , count)

    ����:
      outputVar : �����o������������i�[����ϐ���(�I���W�i���Ɠ���)
      inputVar  : �����o�����̕�����̓������ϐ���(�I���W�i���Ɠ���)
      count     : �����o��������(�I���W�i���Ɠ���)

    �߂�l: 
      �Ȃ�

    ����:
      count�́A�S�p��1�����Ɛ�����B����ȊO�́A�I���W�i���Ɠ���

 ...............................................................
*/  
MBS_StringLeft(ByRef outputVar, ByRef inputVar, count)
{
  ; count��0�ȉ���������ANULL�ɂ��ĕԂ�
  if(count <= 0)
  {
    outputVar := ""
    return
  }

  ; ���͕������WC��
  len := MBS_MultiByteToWideChar(wc_in, inputVar)
  
  ; ���͕�����̒������Acount�̕��������������Ȃ�Aoutput��input�Ɠ���
  if(len <= count)
  {
    outputVar := inputVar
    return
  }
  
  ; outpuVar�̗̈���A���o�����A�m�ۂ��Ă���(+1�̓^�[�~�l�[�^�̕�)
  ptr := &wc_in
  bufSize := MBS_GetMbsSize(ptr,count)
  VarSetCapacity(outputVar,bufSize + 1) ; +1�̓^�[�~�l�[�^��
  
  ; �}���`�o�C�g������ɕϊ�
  ; loopField�́A�|�C���^�ł͓n���Ȃ�
  MBS_WideCharToMultiByteStr(outputVar,ptr,bufSize)

  ; endcode���ߍ���
  DllCall("RtlFillMemory", "Uint",(&outputVar) + bufSize
           ,"Uint",1,"UChar",0)
}

/*
 ...............................................................

  "StringRight"(http://lukewarm.s101.xrea.com/commands/StringLeft.htm)�̑���
  
  MBS_StringRight(outputVar, inputVar , count)

    ����:
      outputVar : �����o������������i�[����ϐ���(�I���W�i���Ɠ���)
      inputVar  : �����o�����̕�����̓������ϐ���(�I���W�i���Ɠ���)
      count     : �����o��������(�I���W�i���Ɠ���)

    �߂�l: 
      �Ȃ�

    ����:
      count�́A�S�p��1�����Ɛ�����B����ȊO�́A�I���W�i���Ɠ���

 ...............................................................
*/  
MBS_StringRight(ByRef outputVar, ByRef inputVar, count)
{
  ; count��0�ȉ���������ANULL�ɂ��ĕԂ�
  if(count <= 0)
  {
    outputVar := ""
    return
  }

  ; ���͕������WC��
  len := MBS_MultiByteToWideChar(wc_in, inputVar)
  
  ; ���͕�����̒������Acount�̕��������������Ȃ�Aoutput��input�Ɠ���
  if(len <= count)
  {
    outputVar := inputVar
    return
  }
  
  ; outpuVar�̗̈���A���o�����A�m�ۂ��Ă���(+1�̓^�[�~�l�[�^�̕�)
  ptr := &wc_in
  ptr := ptr + ((len - count) * 2)
  
  bufSize := MBS_GetMbsSize(ptr,count)
  VarSetCapacity(outputVar,bufSize + 1) ; +1�̓^�[�~�l�[�^��
  
  ; �}���`�o�C�g������ɕϊ�
  ; loopField�́A�|�C���^�ł͓n���Ȃ�
  MBS_WideCharToMultiByteStr(outputVar,ptr,bufSize)

  ; endcode���ߍ���
  DllCall("RtlFillMemory", "Uint",(&outputVar) + bufSize
           ,"Uint",1,"UChar",0)
}

/*
 ...............................................................

  "StringTrimLeft"(http://lukewarm.s101.xrea.com/commands/StringTrimLeft.htm)
  �̑���
  
  MBS_StringTrimLeft(outputVar, inputVar , count)

    ����:
      outputVar : �����o������������i�[����ϐ���(�I���W�i���Ɠ���)
      inputVar  : �����o�����̕�����̓������ϐ���(�I���W�i���Ɠ���)
      count     : �����o��������(�I���W�i���Ɠ���)

    �߂�l: 
      �Ȃ�

    ����:
      count�́A�S�p��1�����Ɛ�����B����ȊO�́A�I���W�i���Ɠ���

 ...............................................................
*/  
MBS_StringTrimLeft(ByRef outputVar, ByRef inputVar, count)
{
  ; count��0�ȉ���������A�R�s�[�������ĕԂ�
  if(count <= 0)
  {
    outputVar := inputVar
    return
  }

  ; ���͕������WC��
  len := MBS_MultiByteToWideChar(wc_in, inputVar)
  
  ; ���͕�����̒������Acount�̕��������������Ȃ�AinputVar��NULL�ŕԂ�
  if(len <= count)
  {
    outputVar := ""
    return
  }
  
  ; count���A�|�C���^�𓮂���
  ptr := &wc_in
  ptr := ptr + (count * 2)
  
  ; outpuVar�̗̈���A���o�����A�m�ۂ��Ă���(+1�̓^�[�~�l�[�^�̕�)
  bufSize := MBS_GetMbsSize(ptr,len - count)
  VarSetCapacity(outputVar,bufSize + 1) ; +1�̓^�[�~�l�[�^��
  
  ; �}���`�o�C�g������ɕϊ�
  ; loopField�́A�|�C���^�ł͓n���Ȃ�
  MBS_WideCharToMultiByteStr(outputVar,ptr,bufSize)

  ; endcode���ߍ���
  DllCall("RtlFillMemory", "Uint",(&outputVar) + bufSize
           ,"Uint",1,"UChar",0)
}

/*
 ...............................................................

  "StringTrimRight"(http://lukewarm.s101.xrea.com/commands/StringTrimLeft.htm)
  �̑���
  
  MBS_StringTrimRight(outputVar, inputVar , count)

    ����:
      outputVar : �����o������������i�[����ϐ���(�I���W�i���Ɠ���)
      inputVar  : �����o�����̕�����̓������ϐ���(�I���W�i���Ɠ���)
      count     : �����o��������(�I���W�i���Ɠ���)

    �߂�l: 
      �Ȃ�

    ����:
      count�́A�S�p��1�����Ɛ�����B����ȊO�́A�I���W�i���Ɠ���

 ...............................................................
*/  
MBS_StringTrimRight(ByRef outputVar, ByRef inputVar, count)
{
  ; count��0�ȉ���������A�R�s�[�������ĕԂ�
  if(count <= 0)
  {
    outputVar := inputVar
    return
  }

  ; ���͕������WC��
  len := MBS_MultiByteToWideChar(wc_in, inputVar)
  
  ; ���͕�����̒������Acount�̕��������������Ȃ�AinputVar��NULL�ŕԂ�
  if(len <= count)
  {
    outputVar := ""
    return
  }
  
  ; outpuVar�̗̈���A���o�����A�m�ۂ��Ă���(+1�̓^�[�~�l�[�^�̕�)
  ptr := &wc_in
  bufSize := MBS_GetMbsSize(ptr,len - count)
  VarSetCapacity(outputVar,bufSize + 1) ; +1�̓^�[�~�l�[�^��
  
  ; �}���`�o�C�g������ɕϊ�
  ; loopField�́A�|�C���^�ł͓n���Ȃ�
  MBS_WideCharToMultiByteStr(outputVar,ptr,bufSize)

  ; endcode���ߍ���
  DllCall("RtlFillMemory", "Uint",(&outputVar) + bufSize
           ,"Uint",1,"UChar",0)
}

/*
 ...............................................................

  "StringMid"(http://lukewarm.s101.xrea.com/commands/StringMid.htm)
  �̑���
  
  MBS_StringMid(outputVar, inputVar , startChar, count[, dir])

    ����:
      outputVar : �����o������������i�[����ϐ���(�I���W�i���Ɠ���)
      inputVar  : �����o�����̕�����̓������ϐ���(�I���W�i���Ɠ���)
      startChar : ���o�������̊J�n�ʒu(�I���W�i���Ɠ���)
      count     : �����o��������(�I���W�i���Ɠ���)
      dir       : "L"(����NULL�łȂ�������Ȃ�ł�����)���w�肷��ƁA
                  StartChar�ȑO(��)�̕�����Count�����������o��
                  (�I���W�i���Ɠ���)

    �߂�l: 
      �Ȃ�

    ����:
      startChar��count�́A�S�p��1�����Ɛ�����B����ȊO�́A�I���W�i���Ɠ���

 ...............................................................
*/  
MBS_StringMid(ByRef outputVar, ByRef inputVar, startChar, count, dir = "")
{
  ; count��0�ȉ���������ANULL�ɂ��ĕԂ�
  if(count <= 0)
  {
    outputVar := ""
    return
  }

  ; ���͕������WC��
  len := MBS_MultiByteToWideChar(wc_in, inputVar)

  ; dir��"L"(���͂Ȃ�ł�����)��������A��������O������
  if(dir != "")
  {
    ; startChar��1��菬����������ANULL�ɂ��ĕԂ�
    if(startChar < 1)
    {
      outputVar := ""
      return
    }

    ; �X�^�[�g�ʒu�̕ύX
    startChar := startChar - count + 1
    
    ; startChar��1��菬����������A���̕��Acount�����炷
    if(startChar < 1)
      count := count - 1 + startChar
  }

  ; startChar��1��菬����������A1�Ƃ݂Ȃ�
  if(startChar < 1)
    startChar := 1
    
  ; ���o���J�n�ʒu���͂ݏo�Ă��܂��悤�Ȃ�A NULL�ŕԂ�
  if(startChar > len)
  {
    outputVar := ""
    return
  }
  
  ; ���o�������񂪂͂ݏo�Ă��܂��悤�Ȃ�A���̕������񂪒Z���Ȃ�
  if(startChar + count - 1 > len)
    count := len - startChar + 1
    
  
  ; outpuVar�̗̈���A���o�����A�m�ۂ��Ă���(+1�̓^�[�~�l�[�^�̕�)
  ptr := &wc_in
  ptr := ptr + ((startChar - 1) * 2)
  bufSize := MBS_GetMbsSize(ptr,count)
  VarSetCapacity(outputVar,bufSize + 1) ; +1�̓^�[�~�l�[�^��
  
  ; �}���`�o�C�g������ɕϊ�
  ; loopField�́A�|�C���^�ł͓n���Ȃ�
  MBS_WideCharToMultiByteStr(outputVar,ptr,bufSize)

  ; endcode���ߍ���
  DllCall("RtlFillMemory", "Uint",(&outputVar) + bufSize
           ,"Uint",1,"UChar",0)
}

/*
 ...............................................................

  "StrLen"(http://lukewarm.s101.xrea.com/Scripts.htm)�̑���
  
  len := MBS_StrLen(var)

    ����:
      var       : �������镶����

    �߂�l: 
      len       : ������̒���

    ����:
      len�́A�S�p��1�����Ɛ�����B����ȊO�́A�I���W�i���Ɠ���

 ...............................................................
*/  
MBS_StrLen(ByRef var)
{
  return MBS_GetWcsSize(&var) - 1
}

/*
 ...............................................................

  "StringGetPos"(http://lukewarm.s101.xrea.com/commands/StringGetPos.htm)
  �̑���
  
  pos := MBS_StringGetPos(inputVar, searchText [, dir , offset, caseSnstv])

    ����:
      inputVar   : �������镶���񂪊i�[���ꂽ�ϐ�(�I���W�i���Ɠ���)
      searchText : �������镶����(�I���W�i���Ɠ���)
      dir        : "1"�Ƃ��A"L2"�Ƃ��A"R3"�Ƃ��w�肷��B�ȗ�����"L1"�Ɠ���
                   (�I���W�i���Ɠ���)
      offset     : �������A�ŏ���Offset�����������������Č������n�߂�B
                   �ȗ�����"0"�Ɠ���(�I���W�i���Ɠ���)
      caseSnstv  : true�̂Ƃ��A�啶������������ʂ���B�ȗ����͋�ʂ��Ȃ��B

    �߂�l: 
      pos        : �������ꂽ�ʒu�B������̍ŏ��́u0�v�Ƃ��Đ�����
                   (�I���W�i����outputVar�Ɠ���)
                   offset���}�C�i�X��������AdirLR�̒l����L��`�ȊO��������A
                   inputVar��searchText��NULL�������ꍇ�́A-2���Ԃ�B

    ����:
      pos�́A�S�p��1�����Ƃ݂Ȃ��B

 ...............................................................
*/  
MBS_StringGetPos(ByRef inputVar, searchText, dir="", offset=0,caseSnstv=false)
{
  ; �G���[�`�F�b�N
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
  
  ; ���͕������WC��
  testlen := MBS_MultiByteToWideChar(wcIn, inputVar)
  
  ; �����������WC��
  searchlen := MBS_MultiByteToWideChar(wcSch, searchText)

  ; ���͕�����̒������Aoffset+searchText�̒����̕��������Ȃ�A
  ; ������Ȃ������ŕԂ�
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
  �̑���
  
  err := MBS_StringReplace(outputVar,inputVar, searchText
                           [,replaceText, replaceAll, caseSnstv])

    ����:
      outputVar  : �u�����ʂ̕�������i�[����ϐ�(�I���W�i���Ɠ���)
      inputVar   : �u���O�̕�������i�[���Ă���ϐ�(�I���W�i���Ɠ���)
      searchText : ����������(�I���W�i���Ɠ���)
      replaceText: SearchText���u�����������̕�����(�I���W�i���Ɠ���)
      replaceAll : �ȗ����邩�A"1"�Ȃ�A�ŏ��̈�񂾂��A�u������B
                   ����ȊO�Ȃ�A���ׂĂ̕������u������B
      caseSnstv  : true�̂Ƃ��A�啶������������ʂ���B�ȗ����͋�ʂ��Ȃ��B

    �߂�l: 
      err        : �u���񐔂�Ԃ��B-1�̂Ƃ��́A���������擾�ł��Ȃ��������Ƃ�
                   �����B

    ����:
      �_��������肪�Ȃ��ȊO�́A�I���W�i���Ɠ���

 ...............................................................
*/  
MBS_StringReplace(ByRef outputVar,ByRef inputVar, searchText
                  ,replaceText = "", replaceAll = "", caseSnstv = false)
{
  ; �b��I�Ɏ擾����o�b�t�@�̑傫�����A�ϊ��̐��Œ�`����B
  ; AHK�W����StringReplace�ł́A20��ŐU�镑�����ς��悤�Ȃ̂ŁA
  ; �����ł���������B
  rplcNumPerIncrsBuf := 20

  ; searchText��NULL�Ȃ�A�P�ɃR�s�[���ċA��
  if(searchText == "")
  {
    outputVar := inputVar
    return 0
  }
    
  ; All���A��񂾂����A�I�v�V�����𒲂ׂ�
  if(replaceAll == "" || replaceAll == "1")
    rplcAllFlg := false
  else
    rplcAllFlg := true

  ; ���͕������WC��
  inputLen := MBS_MultiByteToWideChar(wcIn, inputVar)
  
  ; �����������WC��
  searchLen := MBS_MultiByteToWideChar(wcSch, searchText)
  
  ; �ϊ�����
  rplcNum    := 0                     ; �ϊ���
  bufNum     := 0                     ; �o�b�t�@�̉\�ϊ���(20�̔{��)
  bufSize    := StrLen(inputVar) + 1  ; ���݂̃o�b�t�@�̃T�C�Y(+1�̓^�[�~�l�[�^)
  bufUsage   := 0                     ; �o�b�t�@�g�p��(�ϊ���̃o�C�g������)
  searchSize := StrLen(searchText)    ; ����������o�C�g����
  rplcSize   := StrLen(replaceText)   ; �ϊ�������o�C�g����
  inputPtr   := &wcIn                 ; ���͕�����̌��ݏ������|�C���^
  inputRemain:= inputLen              ; ���͕����񖢕ϊ������񒷂�
  
  ; �ŏ��ɁA�ϊ����ʗp�̃o�b�t�@���AinputVar�����擾����B�ȍ~�A���[�v���ł���
  ; �o�b�t�@��reallocate���Ȃ���ϊ�����B
  bufTop    := MBS_Alloc(bufSize)     ; �ϊ���̕�������ꎞ�ۑ�����o�b�t�@
  if(!bufTop)
    return -1
  bufPtr    := bufTop                ; ��L�o�b�t�@�̌��ݏ������|�C���^
  
  Loop
  {
    ; ������T�[�`
    if(caseSnstv)
      pos := MBS_wcStringGetPos_IfInStrCaseSnstv(inputPtr,inputRemain
                                                 ,&wcSch,searchLen
                                                 ,"L",1,0)
    else
      pos := MBS_wcStringGetPos_IfInStrNoCaseSnstv(inputPtr,inputRemain
                                                   ,&wcSch,searchLen
                                                   ,"L",1,0)
    ; ������𔭌��ł��Ȃ�������A���[�v���甲����
    if(pos == -1)
      break
    
    ; ���ꂩ��ϊ�������̂����A�����o�b�t�@���g���؂��Ă����ꍇ�́A
    ; �����ōL����
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
  
    ; inputPtr����pos�̒�������MB�ŏ����߂��A��������searchLen�̒�������
    ; �X�L�b�v(���̕��AreplaceText���R�s�[)
    
    ; MB�ŏ����߂�
    mbsLen := MBS_GetMbsSize(inputPtr,pos)  ; MB�����߂��T�C�Y�̎擾
    MBS_WideCharToMultiBytePtr(bufPtr,inputPtr,mbsLen)
    bufPtr := bufPtr + mbsLen
    
    ; replaceText���R�s�[
    DllCall("RtlMoveMemory", "Uint",bufPtr, "Str",replaceText,"Uint",rplcSize)
    bufPtr := bufPtr + rplcSize
    
    ; �o�b�t�@�g�p�ʍX�V
    bufUsage := bufUsage + mbsLen + rplcSize

    ; MB�ŏ����߂������ƁAsearchLen�̒��������X�L�b�v
    inputPtr := inputPtr + (pos + searchLen) * 2
    inputRemain := inputRemain - (pos + searchLen)
    
    ; "All"�łȂ�������A�����Ń��[�v���甲����
    if(!rplcAllFlg)
      break
      
  }
  
  ; �Ō�ɁA�ϊ������Ɏc����������MB�ɏ����߂�
  mbsLen := MBS_GetMbsSize(inputPtr,inputRemain)  ; MB�����߂��T�C�Y�̎擾
  MBS_WideCharToMultiBytePtr(bufPtr,inputPtr,mbsLen)
  bufPtr := bufPtr + mbsLen
  bufUsage := bufUsage + mbsLen
  
  ; �ϊ��I��
  ; bufTop�ȉ��Ɋi�[���ꂽ������ɁA�^�[�~�l�[�^������
  DllCall("RtlFillMemory", "Uint",bufPtr
           ,"Uint",1,"UChar",0)
  
  ; outputVar�̗̈���L���āA�����ɁAbufTop����bufUsage���̕�������R�s�[
  VarSetCapacity(outputVar,bufUsage + 1) ; +1�̓^�[�~�l�[�^��
  DllCall("RtlMoveMemory", "Str",outputVar, "Uint",bufTop
          ,"Uint",bufUsage + 1) ; +1�̓^�[�~�l�[�^��
          
  ; �o�b�t�@��p��
  MBS_Free(bufTop)
  
  return rplcNum
}

/*
 ...............................................................

  "StringSplit"(http://lukewarm.s101.xrea.com/commands/StringSplit.htm)
  �̑���A�Ƃ������A��`���B
  
  dlmt := MBS_StringSplit(outputVar,inputVar
                         [, delimiters,omitChars,outputVarDelimiter])

    ����:
      outputVar  : ����(?)���ʂ̕�������i�[����ϐ�
      inputVar   : �����O�̕�������i�[���Ă���ϐ�(�I���W�i���Ɠ���)
      delimiters : ��؂蕶���Ƃ��Ďg�p�������������(�I���W�i���Ɠ���)
      omitChars  : �������ꂽ�e�v�f�̍ŏ��ƍŌォ���菜���������
                   (�I���W�i���Ɠ���)
      outputVarDelimiter : outputVar�Ɋi�[����镶����̋�؂蕶�����w�肷��B
                           �ȗ����ɂ́A��؂蕶���́A0x01�Ƃ����R�[�h���g����B
    �߂�l: 
      dlmt       : outputVar�Ɋi�[����镶����̋�؂蕶�����Ԃ�B
                   outputVarDelimiter���ȗ�������A���0x01�B
                   outputVarDelimiter���w�肵����A��ɁAoutputVarDelimiter��
                   �����l�B

    ����:
      �I���W�i����StringSplit�́A���������e�t�B�[���h���Aarray1,array2��
      �������^���z��ϐ��Ɋi�[����邪�A�֐��ł́A���̂悤�ȓ���͎���
      �ł��Ȃ��B�������A�I���W�i����StringSplit�ł́A�_��������肪��������
      ���܂��B
      �����ŁA�{�֐��ł́A�_��������肪�������Ȃ��`��inputVar�𕪊����A
      �����Shift-JIS�ł�ASCII�ł��g��Ȃ�0x01�Ƃ����R�[�h����؂蕶���Ƃ���
      ��̕�����Ƃ��āAoutputVar�Ɋi�[����B0x01�ŕ������镪�ɂ́A���Ȃ��Ƃ�
      Shift-JIS�Ɋւ��ẮA�_���������͐�΂ɋN����Ȃ��̂ŁA�I���W�i����
      StringSplit���g���΂悢�B
      �ȉ��̃R�[�h�́A�܂����������Ӗ��ƂȂ�B
      
      ; �I���W�i��
      inputVar := "a,b,c"
      StringSplit, array, inputVar, `,
      
      ; �{�֐�
      inputVar := "a,b,c"
      dlmt := MBS_StringSplit(tmp, inputVar, ",")
      StringSplit, array, tmp, %dlmt%
      
      
      ��؂蕶��0x01�́AShift-JIS�ł�ASCII�ł��ʏ�͐�΂Ɏg��Ȃ����������A
      �����AinputVar�̒��ŁA�����Ă��̃R�[�h���g���Ă���ƁA���R�A��������
      �듮�삷��B�����ŁA���̂悤�ȏꍇ�́AoutputVarDelimiter�ŁA�C�ӂ�
      �������w�肷��K�v������B�_�����������N���Ȃ����߂ɂ́A���̎��w�肷��
      �����́A0x3e�ȉ��̒l�ł���K�v������B
      
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
  
  ; �Ō�̃f���~�^���폜
  if(outputVar != "")
    StringTrimRight,outputVar,outputVar,1
    
  return dlmt
}

/*
 ...............................................................

  "SplitPath"(http://lukewarm.s101.xrea.com/commands/SplitPath.htm)
  �̑���
  
  MBS_SplitPath(InputVar 
               , outFileName, outDir, outExtension, outNameNoExt, outDrive)

    ����:
      inputVar     : ��������t�@�C���p�X���i�[�����ϐ�
      outFileName  : �I���W�i���Ɠ����B�������A�ȗ��͕s��
      outDir       : �I���W�i���Ɠ����B�������A�ȗ��͕s��
      outExtension : �I���W�i���Ɠ����B�������A�ȗ��͕s��
      outNameNoExt : �I���W�i���Ɠ����B�������A�ȗ��͕s��
      outDrive     : �I���W�i���Ɠ����B�������A�ȗ��͕s��

    �߂�l: 
      �Ȃ�

    ����:
      �_��������肪�Ȃ��ȊO�́A�I���W�i���Ɠ���
      �������AoutFileName�Ȃǂ́AByRef���g���Ă���̂ŁA�ȗ��ł��Ȃ��̂�
      �c�O�ȂƂ���B

 ...............................................................
*/  
MBS_SplitPath(inputVar
              ,ByRef outFileName, ByRef outDir, ByRef outExtension
              ,ByRef outNameNoExt, ByRef outDrive)
{
  ; �h���C�u���A���邢�̓}�V�����A���邢�̓T�C�g�����Ƃɂ��
  ; �����B
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
  
  ; inputVar�́Apos�ȍ~���A�h���C�u�����������t�@�C���p�X�ƂȂ��Ă���B
  filePos := MBS_InStr(inputVar,dlmt,false,0)
  
  if(filePos)
  {
    if(filePos < pos)
    {
      ; �t�@�C�����Ȃ�
      out_fileName := ""
      out_nameNoExt := ""
      out_ext := ""
      out_dir := inputVar
    }
    else
    {
      ; �t�@�C��������
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
    ; �t�@�C�����̋�؂肪������Ȃ�����(c:xxx.txt�̂悤�ȃ^�C�v)
    ; ���̏ꍇ�Apos�ȍ~���A�t�@�C�����Ƃ���B
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

  ���p�������A�Ή�����S�p�����ɕϊ�����B
  
  MBS_StringZenkaku(outputVar, inputVar
                    [, alpha, num, symbol, space, kana])

    ����:
      outputVar    : �ϊ���̕�������i�[����ϐ�
      inputVar     : �ϊ��O�̕�������i�[����ϐ�
      alpha        : �p����ϊ�����ꍇ��true,���Ȃ��ꍇ��false
                     �ȗ�����true
      num          : ������ϊ�����ꍇ��true,���Ȃ��ꍇ��false
                     �ȗ�����true
      symbol       : �L����ϊ�����ꍇ��true,���Ȃ��ꍇ��false
                     �ȗ�����true
      space        : ���p��(0x20)���A�S�p�󔒂ɕϊ�����Ƃ���true,���Ȃ��ꍇ��
                     flase�B�ȗ�����true
      kana         : ���p�J�i��S�p�J�i�ɕϊ�����Ƃ���true,���Ȃ��ꍇ��false
                     �ȗ�����false �� ���ӁB���������f�t�H���g��false

    �߂�l: 
      �Ȃ�

    ����:
      ������ASCII������(0x20����0x7e)���A�Ή�����S�p�����ɕϊ�����B
      �܂��A���p�J�i���A�Ή�����S�p�J�i�ɕϊ�����B���̏ꍇ�A
      ���p�J�i��"�o"�Ȃǂ́A�n�ƃe���e���̓񕶎��͈�̑S�p�����ɂȂ�̂�
      ���ӁB

 ...............................................................
*/  
MBS_StringZenkaku(ByRef outputVar, ByRef inputVar
          , alpha = true, num = true, symbol = true, space = true, kana = false)
{
  ; �܂��A�R�[�h�ϊ��p�e�[�u�������炤
  MBS_MakeZenHanTable(symblTbl1,symblTbl2,symblTbl3,symblTbl4,kanaTbl)
  
  ; WC�ɕϊ�
  inLen := MBS_MultiByteToWideChar(wcIn, inputVar)
  
  ; ���[�N�p�̈���擾�B�S�p�ɕϊ�����Ƃ��́A�������K���������Ȃ�͂�
  VarSetCapacity(wcOut,(inLen + 1) * 2)
  
  ; �|�C���^�ݒ�
  inPtr := &wcIn
  outPtr := &wcOut
  
  ; ���[�v�J�n
  Loop
  {
    if(inLen == 0)
      break
  
    inChar := MBS_ReadUint16(inPtr)
    inPtr += 2
    inLen--
    
    ; ��{�I�ɁA���̓R�[�h�Ɠ����R�[�h���o�͂���B
    ; �ϊ��ΏۂɂЂ����������ꍇ�ɁA�o�̓R�[�h��ύX����
    outChar := inChar
    
    if(alpha)
    {
      ; �A���t�@�x�b�g�ϊ�
      ; �啶���Ə�����
      if((inChar >= 0x0041 && inChar <= 0x005a)
       ||(inChar >= 0x0061 && inChar <= 0x007a))
        outChar := inChar + 0xFF00 - 0x20
        
    }
    
    if(num)
    {
      ; �����ϊ�
      if(inChar >= 0x0030 && inChar <= 0x0039)
        outChar := inChar + 0xFF00 - 0x20
    }
    
    if(symbol)
    {
      ; �L���ϊ�
      ; �S�p�Ɣ��p�͕��я����Ή����ĂȂ��̂ŁA4�̕������ƂɁA�e�[�u����
      ; �����ĕϊ�����
      
      ;      symbol1
      if(inChar >= 0x0021 && inChar <= 0x002f)
      {
        pos := (inChar - 0x0021) * 6 + 1 ; 0x????�ŁA6����������Bmid��+1������
        StringMid, outChar, symblTbl1, %pos%, 6
      }
      else ; symbol2
      if(inChar >= 0x003a && inChar <= 0x0040)
      {
        pos := (inChar - 0x003a) * 6 + 1 ; 0x????�ŁA6����������Bmid��+1������
        StringMid, outChar, symblTbl2, %pos%, 6
      }
      else ; symbol3
      if(inChar >= 0x005b && inChar <= 0x0060)
      {
        pos := (inChar - 0x005b) * 6 + 1 ; 0x????�ŁA6����������Bmid��+1������
        StringMid, outChar, symblTbl3, %pos%, 6
      }
      else ; symbol4
      if(inChar >= 0x007b && inChar <= 0x007e)
      {
        pos := (inChar - 0x007b) * 6 + 1 ; 0x????�ŁA6����������Bmid��+1������
        StringMid, outChar, symblTbl4, %pos%, 6
      }
        
      outChar := outChar + 0 ; ����Ȃ���������Ȃ����A���l�ł��邱�Ƃ𖾎�
    }
    
    if(space)
    {
      ; ���p�X�y�[�X��S�p�X�y�[�X��
      if(inChar == 0x0020)
        outChar := 0x3000
    }

    if(kana)
    {
      ; ���p�J�i��S�p�ɕϊ�
      ; �J�A�T�A�^�A�n��������A���̃R�[�h���ǂ�ŁA�o��p��������A�����
      ; �������S�p�R�[�h��I�΂Ȃ��Ƃ����Ȃ��B�����A�ʓ|�������B
      
      ; �܂��A���������ϊ��Ώۂ̔��p�J�i�ł��邩�ǂ���
      if(inChar >= 0xff61 && inChar <= 0xff9f)
      {
        ; �Ƃ肠�����A�ϊ��e�[�u���Ō����o���Ă���
        pos := (inChar - 0xff61) * 6 + 1 ; 0x????�ŁA6����������Bmid��+1������
        StringMid, outChar, kanaTbl, %pos%, 6
        outChar := outChar + 0 ; ����Ȃ���������Ȃ����A���l�ł��邱�Ƃ𖾎�
        
        ;      �J���邢�̓T���邢�̓^��
        if(inChar >= 0xff76 && inChar <= 0xff84)
        {
          ; ���̈ꕶ����ǂ�ŁA�K�Ƃ���������A�R�[�h������₷
          nextChar := MBS_ReadUint16(inPtr)
          if(nextChar == 0xff9e)
          {
            outChar := outChar + 1
            inPtr += 2
            inLen--
          }
        }
        else ; �n��
        if(inChar >= 0xff8a && inChar <= 0xff8e)
        {
          ; ���̈ꕶ����ǂ�ŁA�o��p�Ƃ���������A�R�[�h�𑝂₷
          nextChar := MBS_ReadUint16(inPtr)
          if(nextChar == 0xff9e)  ; �o
          {
            outChar := outChar + 1
            inPtr += 2
            inLen--
          }
          else
          if(nextChar == 0xff9f)  ; �p
          {
            outChar := outChar + 2
            inPtr += 2
            inLen--
          }
        }
        else ; �E��
        if(inChar == 0xff73)
        {
          ; ���̈ꕶ����ǂ�ŁA����������A���ʂɃ���p��
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
    
    ; outChar������ꂽ�̂ŁA��������
    MBS_WriteUint16(outPtr,outChar)
    outPtr += 2
  }
  
  ; �ϊ��̈�ɁA�^�[�~�l�[�^�𖄂ߍ���
  MBS_WriteUint16(outPtr,0)
  
  ; MB�ɕϊ�
  MBS_WideCharToMultiByte(outputVar,wcOut)
  
}

/*
 ...............................................................

  �S�p�������A�Ή����锼�p�����ɕϊ�����B
  
  MBS_StringHankaku(outputVar, inputVar
                    [, alpha, num, symbol, space, kana])

    ����:
      outputVar    : �ϊ���̕�������i�[����ϐ�
      inputVar     : �ϊ��O�̕�������i�[����ϐ�
      alpha        : �p����ϊ�����ꍇ��true,���Ȃ��ꍇ��false
                     �ȗ�����true
      num          : ������ϊ�����ꍇ��true,���Ȃ��ꍇ��false
                     �ȗ�����true
      symbol       : �L����ϊ�����ꍇ��true,���Ȃ��ꍇ��false
                     �ȗ�����true
      space        : �S�p�󔒂��A���p�󔒂ɕϊ�����Ƃ���true,���Ȃ��ꍇ��
                     flase�B�ȗ�����true
      kana         : �S�p�J�i�𔼊p�J�i�ɕϊ�����Ƃ���true,���Ȃ��ꍇ��false
                     �ȗ�����false �� ���ӁB���������f�t�H���g��false

    �߂�l: 
      �Ȃ�

    ����:
      �S�p�������A������ASCII������(0x20����0x7e)�ɁA�ϊ�����B
      �܂��A�S�p�J�i���A�Ή����锼�p�J�i�ɕϊ�����B���̏ꍇ�A
      �S�p�J�i��"�o"�Ȃǂ́A��̑S�p�������A�n�ƃe���e����
      ��̔��p�����ɂȂ�̂Œ��ӁB

 ...............................................................
*/  
MBS_StringHankaku(ByRef outputVar, ByRef inputVar
          , alpha = true, num = true, symbol = true, space = true, kana = false)
{
  ; �܂��A�R�[�h�ϊ��p�e�[�u�������炤
  MBS_MakeZenHanTable(symblTbl1,symblTbl2,symblTbl3,symblTbl4,kanaTbl)
  
  ; WC�ɕϊ�
  inLen := MBS_MultiByteToWideChar(wcIn, inputVar)
  
  ; ���[�N�p�̈���擾�B���p�ɕϊ�����Ƃ��́A�ň��A�Q�{�̗̈悪����B
  ; "�o"�Ȃǂ́A�Q�����ɂȂ邩��B
  VarSetCapacity(wcOut,((inLen * 2) + 1) * 2)
  
  ; �|�C���^�ݒ�
  inPtr := &wcIn
  outPtr := &wcOut
  
  ; ���[�v�J�n
  Loop
  {
    if(inLen == 0)
      break
  
    inChar := MBS_ReadUint16(inPtr)
    inPtr += 2
    inLen--
    
    ; ��{�I�ɁA���̓R�[�h�Ɠ����R�[�h���o�͂���B
    ; �ϊ��ΏۂɂЂ����������ꍇ�ɁA�o�̓R�[�h��ύX����
    outChar := inChar
    
    if(alpha)
    {
      ; �A���t�@�x�b�g�ϊ�
      ; �啶���Ə�����
      if((inChar >= 0xff21 && inChar <= 0xff3a)
       ||(inChar >= 0xff41 && inChar <= 0xff5a))
        outChar := inChar - 0xFF00 + 0x20
        
    }
    
    if(num)
    {
      ; �����ϊ�
      if(inChar >= 0xff10 && inChar <= 0xff19)
        outChar := inChar - 0xFF00 + 0x20
    }
    
    if(symbol)
    {
      ; �L���ϊ�
      ; �S�p�Ɣ��p�͕��я����Ή����ĂȂ��̂ŁA4�̕������ƂɁA�e�[�u����
      ; �����ĕϊ�����
      
      ; 16�i���\���ɂ��āA�����񉻂���
      SetFormat, INTEGER, H
      inCharStr := inChar + 0
      inCharStr := inCharStr . "0x"

      ;      symbol1
      if(InStr(symblTbl1,inCharStr))
      {
        outChar := (InStr(symblTbl1,inCharStr) - 1) // 6 + 0x0021
                                           ; 0x????�ŁA6����
      }
      else ; symbol2
      if(InStr(symblTbl2,inCharStr))
      {
        outChar := (InStr(symblTbl2,inCharStr) - 1) // 6 + 0x003a
                                           ; 0x????�ŁA6����
      }
      else ; symbol3
      if(InStr(symblTbl3,inCharStr))
      {
        outChar := (InStr(symblTbl3,inCharStr) - 1) // 6 + 0x005b
                                           ; 0x????�ŁA6����
      }
      else ; symbol4
      if(InStr(symblTbl4,inCharStr))
      {
        outChar := (InStr(symblTbl4,inCharStr) - 1) // 6 + 0x007b
                                           ; 0x????�ŁA6����
      }

      SetFormat, INTEGER, D
    }
    
    if(space)
    {
      ; ���p�X�y�[�X��S�p�X�y�[�X��
      if(inChar == 0x3000)
        outChar := 0x0020
    }

    if(kana)
    {
      ; �S�p�J�i�𔼊p�ɕϊ�
      ; �K�Ȃǂ�������A���p�J�ƃe���e�����o���B
      ; 
      ; (1)�J�i�e�[�u���ɃR�[�h������΁A���̂܂ܕϊ�
      ; (2)�J�i�e�[�u���ɃR�[�h���Ȃ���΁A
      ;    (�J�A�T) (�^) (�n) (��) ����ʈ���
      ; (3)����ȊO�́A���p�ɕϊ��ł��Ȃ��̂ŁA���̂܂�
      
      
      ; 16�i���\���ɂ��āA�����񉻂���
      SetFormat, INTEGER, H
      inCharStr := inChar + 0
      inCharStr := inCharStr . "0x"

      if(InStr(kanaTbl,inCharStr))
      {
        outChar := (InStr(kanaTbl,inCharStr) - 1) // 6 + 0xff61
                                         ; 0x????�ŁA6����
      }
      else
      {
        ; �e�[�u���ɂ͂Ȃ������B
        ; �o��p�Ȃǂ̃e����}���t�����A���p�ɂȂ��J�i��������Ȃ��B
        
        ;       �J���邢�̓T�̍s
        if(inChar >= 0x30ab && inChar <= 0x30be)
        {
          ; �e���e�����B���p�J�i���o���āA���Ƀe���e����p��
          outChar := ((inChar - 0x30ab) // 2) + 0xff76
          MBS_WriteUint16(outPtr,outChar)
          outPtr += 2
          outChar := 0xff9e
        }
        else ; �_�ƃa
        if(inChar == 0x30c0 || inChar == 0x30c2)
        {
          outChar := ((inChar - 0x30c0) // 2) + 0xff80
          MBS_WriteUint16(outPtr,outChar)
          outPtr += 2
          outChar := 0xff9e
        }
        else ; �d�f�h
        if(inChar >= 0x30c5 && inChar <= 0x30c9)
        {
          outChar := ((inChar - 0x30c5) // 2) + 0xff82
          MBS_WriteUint16(outPtr,outChar)
          outPtr += 2
          outChar := 0xff9e
        }
        else ; �n�̍s
        if(inChar >= 0x30cf && inChar <= 0x30dd)
        {
          ; �n�̃R�[�h�������Z���āA3�Ŋ��������܂肪�A1�Ȃ�e���e���A2�Ȃ�}��
          ; 3�Ŋ����������𔼊p�̃n�ɑ����Z����΁A���p�R�[�h�ɂȂ�B
          outChar := ((inChar - 0x30cf) // 3) + 0xff8a
          MBS_WriteUint16(outPtr,outChar)
          outPtr += 2
          
          if(Mod(inChar - 0x30cf, 3) == 1)
            outChar := 0xff9e ; �e���e��
          else
            outChar := 0xff9f ; �}��
        }
        else ; ��
        if(inChar == 0x30f4)
        {
          outChar := 0xff73 ; �E
          MBS_WriteUint16(outPtr,outChar)
          outPtr += 2
          outChar := 0xff9e
        }
      }

      SetFormat, INTEGER, D
    }
    
    ; outChar������ꂽ�̂ŁA��������
    MBS_WriteUint16(outPtr,outChar)
    outPtr += 2
  }
  
  ; �ϊ��̈�ɁA�^�[�~�l�[�^�𖄂ߍ���
  MBS_WriteUint16(outPtr,0)
  
  ; MB�ɕϊ�
  MBS_WideCharToMultiByte(outputVar,wcOut)
}




/* 
 ---------------------------------------------------------------
 �����艺�́A��L�֐����Ăяo���ėp�I�Ȋ֐��ł��B
 ---------------------------------------------------------------
*/

/*
 ...............................................................
 
 �S�p�A���p�ϊ����s�����߂̕����R�[�h�e�[�u���̍쐬
 
 MBS_MakeZenHanTable(symbol1, symbol2, symbol3, symbol4, kana)
  
    ����:
      symbol1      : �L���p�e�[�u�����i�[����ϐ�(1/4)
      symbol2      : �L���p�e�[�u�����i�[����ϐ�(2/4)
      symbol3      : �L���p�e�[�u�����i�[����ϐ�(3/4)
      symbol4      : �L���p�e�[�u�����i�[����ϐ�(4/4)
      kana         : �J�i�p�e�[�u�����i�[����ϐ�

    �߂�l: 
      �Ȃ�

    ����:
      �e�[�u���́A0x�t����16�i��4�P�^���A�r�b�`���ƕ��ׂ��Ă���B
      �Ō�ɂ̓_�~�[��0x�����Ă���̂ŁA"0xabcd0x"�Ƃ����������T���΁A
      �m���ɏ��]�̃R�[�h��T�����Ƃ��ł���B

      ���p�J�i�̕����R�[�h�̕��тɉ����āA�Ή�����S�p�J�i�̕����R�[�h��
      ����ł���Ƃ����X�^�C���B�ڍׂ͈ȉ��̒ʂ�(�E����16�i��4�P�^���e�[�u����
      �Ȃ��Ă���)

            ���p       �S�p
      symbol1
         !  0x0021  �I FF01
         "  0x0022  �� 2033
         #  0x0023  �� FF03
         $  0x0024  �� FF04
         %  0x0025  �� FF05
         &  0x0026  �� FF06
         '  0x0027  �� 2032
         (  0x0028  �i FF08
         )  0x0029  �j FF09
         *  0x002a  �� FF0A
         +  0x002b  �{ FF0B
         ,  0x002c  �C FF0C
         -  0x002d  �| 30FC
         .  0x002e  �D FF0E
         /  0x002f  �^ FF0F
      
         0  0x0030  �O FF10
         9  0x0039  �X FF19
      
      symbol2
         :  0x003a  �F FF1A
         ;  0x003b  �G FF1B
         <  0x003c  �� FF1C
         =  0x003d  �� FF1D
         >  0x003e  �� FF1E
         ?  0x003f  �H FF1F
         @  0x0040  �� FF20
      
         A  0x0041  �` FF21
         Z  0x005a  �y FF3A
      
      symbol3
         [  0x005b  �m FF3B
         \  0x005c  �� FFE5
         ]  0x005d  �n FF3D
         ^  0x005e  �O FF3E
         _  0x005f  �Q FF3F
         `  0x0060  �M FF40
      
         a  0x0061  �� FF41
         z  0x007a  �� FF5a
      
      symbol4
         {  0x007b  �o FF5B
         |  0x007c  �b FF5C
         }  0x007d  �p FF5D
         ~  0x007e  �` 301C
      
      kana
         �B FF61    �B 3002
         �u FF62    �u 300C
         �v FF63    �v 300D
         �A FF64    �A 3001
         �E FF65    �E 30FB
         �� FF66    �� 30F2
         �@ FF67    �@ 30A1
         �B FF68    �B 30A3
         �D FF69    �D 30A5
         �F FF6A    �F 30A7
         �H FF6B    �H 30A9
         �� FF6C    �� 30E3
         �� FF6D    �� 30E5
         �� FF6E    �� 30E7
         �b FF6F    �b 30C3
         �[ FF70    �[ 30FC
      
         �A FF71    �A 30A2
         �C FF72    �C 30A4
         �E FF73    �E 30A6
         �G FF74    �G 30A8
         �I FF75    �I 30AA
      
         �J FF76    �J 30AB  (�K 30AC)
         �L FF77    �L 30AD
         �N FF78    �N 30AF
         �P FF79    �P 30B1
         �R FF7A    �R 30B3
      
         �T FF7B    �T 30B5  (�U 30B6)
         �V FF7C    �V 30B7
         �X FF7D    �X 30B9
         �Z FF7E    �Z 30BB
         �\ FF7F    �\ 30BD
      
         �^ FF80    �^ 30BF  (�_ 30C0)
         �` FF81    �` 30C1  (�a 30C2 �b 30C3)
         �c FF82    �c 30C4  (�d 30C5)
         �e FF83    �e 30C6
         �g FF84    �g 30C8
      
         �i FF85    �i 30CA
         �j FF86    �j 30CB
         �k FF87    �k 30CC
         �l FF88    �l 30CD
         �m FF89    �m 30CE
      
         �n FF8A    �n 30CF  (�o 30D0 �p 30D1)
         �q FF8B    �q 30D2
         �t FF8C    �t 30D5
         �w FF8D    �w 30D8
         �z FF8E    �z 30DB
      
         �} FF8F    �} 30DE
         �~ FF90    �~ 30DF
         �� FF91    �� 30E0
         �� FF92    �� 30E1
         �� FF93    �� 30E2
      
         �� FF94    �� 30E4
         �� FF95    �� 30E6
         �� FF96    �� 30E8
      
         �� FF97    �� 30E9
         �� FF98    �� 30EA
         �� FF99    �� 30EB
         �� FF9A    �� 30EC
         �� FF9B    �� 30ED
      
         �� FF9C    �� 30EF
         �� FF9D    �� 30F3
      
         �J FF9E    �J 309B
         �K FF9F    �K 309C

              (�� 30F4)

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
 
 �p�P��̐擪����������啶���A���Ƃ͏������ɂ���
 �S�p�̉p�����A�����Ƒ啶���������ɂȂ�B
 
 MBS_StrToTitleCase(outputVar, inputVar)
  
    ����:
      outputVar    : �ϊ���̕�������i�[����ϐ�
      inputVar     : �ϊ��O�̕�������i�[����ϐ�

    �߂�l: 
      �Ȃ�

    ����:
      �擪�̉p��������啶���ɂ��āA���̉p���͏������ɂ���B
      �󔒂����ꂽ��A�܂��A���̉p����啶���ɂ���B
      AHK�̃\�[�X�R�[�h�̒ʂ�ɏ���������Ȃ�ł����ǁA�Ԉ���Ă���
      ���߂�Ȃ����B
 ...............................................................
*/
MBS_StrToTitleCase(ByRef outputVar, ByRef inputVar)
{
  ; WC�ɕϊ�����
  len := MBS_MultiByteToWideChar(wcVar,inputVar)
  
  ; ���������̃��[�v
  nextUpFlag := true
  ptr := &wcVar
  Loop,%len%
  {
    wchar := MBS_ReadUint16(ptr)
    
    ; �p����
    if((wchar <= 0x7d || (wchar >= 0xff10 && wchar <= 0xff5a) ) 
    && DllCall("IsCharAlphaW","Ushort",wchar))
    {
      ; �ŏ��̈ꕶ���Ȃ�啶���ɁB�����łȂ���Ώ�������
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
    else ; �󔒂�
    if(wchar == 0x20 || wchar == 0x0d || wchar == 0x0a || wchar == 0x09
    || wchar == 0x3000)
    {
      nextUpFlag := true
    }

    ptr += 2
  }
  
  ; MB�ɕϊ�����
  MBS_WideCharToMultiByte(outputVar, wcVar)
}


/*
 ...............................................................
 
 ������T�[�`�֐��Q
 
 ��̕�����̔�r(�啶���������̋�ʂ���)
 
 MBS_CondIfInStr_CaseSense(testPtr,searchPtr,searchLen)
  
    ����:
      testPtr      : �]�����镶����(UNICODE)�ւ̃|�C���^
      searchPtr    : �T�[�`���镶����(UNICODE)�ւ̃|�C���^
      searchLen    : �T�[�`���镶����̒���

    �߂�l: 
      ��v������0,��v���Ȃ������炻��ȊO

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_CondIfInStr_CaseSense(testPtr,searchPtr,searchLen)
{
  ; �^�[�~�l�[�^��˂����ޕ����̑ޔ�
  tailPtr := testPtr + (searchLen * 2)
  stack1 := *tailPtr
  stack2 := *(tailPtr+1)

  ; �^�[�~�l�[�^��˂�����
  DllCall("RtlFillMemory", "Uint",tailPtr, "Uint",1,"UChar",0)
  DllCall("RtlFillMemory", "Uint",tailPtr+1, "Uint",1,"UChar",0)

  cmpResult := DllCall("lstrcmpW", "Uint",testPtr, "Uint",searchPtr)

  DllCall("RtlFillMemory", "Uint",tailPtr, "Uint",1,"UChar",stack1)
  DllCall("RtlFillMemory", "Uint",tailPtr+1, "Uint",1,"UChar",stack2)
  
  return cmpResult
}

/*
 ...............................................................
 
 ������T�[�`�֐��Q
 
 ��̕�����̔�r(�啶���������̋�ʂȂ�)
 
 MBS_CondIfInStr_NoCaseSense(testPtr,searchPtr,searchLen)
  
    ����:
      testPtr      : �]�����镶����(UNICODE)�ւ̃|�C���^
      searchPtr    : �T�[�`���镶����(UNICODE)�ւ̃|�C���^
      searchLen    : �T�[�`���镶����̒���

    �߂�l: 
      ��v������0,��v���Ȃ������炻��ȊO

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_CondIfInStr_NoCaseSnstv(testPtr,searchPtr,searchLen)
{
  ; �^�[�~�l�[�^��˂����ޕ����̑ޔ�
  tailPtr := testPtr + (searchLen * 2)
  stack1 := *tailPtr
  stack2 := *(tailPtr+1)

  ; �^�[�~�l�[�^��˂�����
  DllCall("RtlFillMemory", "Uint",tailPtr, "Uint",1,"UChar",0)
  DllCall("RtlFillMemory", "Uint",tailPtr+1, "Uint",1,"UChar",0)

  cmpResult := DllCall("lstrcmpiW", "Uint",testPtr, "Uint",searchPtr)

  DllCall("RtlFillMemory", "Uint",tailPtr, "Uint",1,"UChar",stack1)
  DllCall("RtlFillMemory", "Uint",tailPtr+1, "Uint",1,"UChar",stack2)
  
  return cmpResult
}

/*
 ...............................................................
 
 ������T�[�`�֐��Q
 
 �����̕����̂ǂꂩ���A�w�肵�������ł��邩�ǂ���(�啶���������̋�ʂȂ�)
 
 MBS_CondIfCharNotInStr(testPtr,searchPtr,searchLen)
  
    ����:
      testPtr      : �]�����镶��(UNICODE)�ւ̃|�C���^
      searchPtr    : �T�[�`���镶���Q(UNICODE)�ւ̃|�C���^
      searchLen    : �T�[�`���镶���Q�̐�

    �߂�l: 
      ��v���Ȃ�������0,��v�����炻��ȊO

    ����:
      searchPtr�������ł���searchLen��UNICODE�����̂ǂ�����A
      testPtr������UNICODE�ꕶ���ƈ�v���Ȃ�������0���Ԃ�A
      �ǂꂩ��ł���v������Atrue���Ԃ�
 ...............................................................
*/
MBS_CondIfCharNotInStr(testPtr,searchPtr,searchLen)
{

  ; �e�X�g���镶�������o��
  code1 := *testPtr
  code2 := *(testPtr + 1)
  
  found := false

  ; searchLen�̕������AsearchPtr�̕�����Ɣ�r
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
 
 ������T�[�`�֐��Q
 
 �����̕����̂ǂꂩ���A�w�肵�������ł��邩�ǂ���(�啶���������̋�ʂȂ�)
 
 MBS_CondIfCharInStr(testPtr,searchPtr,searchLen)
  
    ����:
      testPtr      : �]�����镶��(UNICODE)�ւ̃|�C���^
      searchPtr    : �T�[�`���镶���Q(UNICODE)�ւ̃|�C���^
      searchLen    : �T�[�`���镶���Q�̐�

    �߂�l: 
      ��v������0,��v���Ȃ������炻��ȊO

    ����:
      searchPtr�������ł���searchLen��UNICODE�����̂ǂ�����A
      testPtr������UNICODE�ꕶ���ƈ�v���Ȃ�������true���Ԃ�A
      �ǂꂩ��ł���v������A0���Ԃ�
 ...............................................................
*/
MBS_CondIfCharInStr(testPtr,searchPtr,searchLen)
{

  ; �e�X�g���镶�������o��
  code1 := *testPtr
  code2 := *(testPtr + 1)
  
  not_found := true

  ; searchLen�̕������AsearchPtr�̕�����Ɣ�r
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
 
 ������T�[�`�֐��Q
 
 �w�肵�������񂪏o������ꏊ(������)��Ԃ�(�啶���������̋�ʂ���)
 
 pos:=MBS_wcStringGetPos_IfInStrCaseSnstv(testPtr,testLen, searchPtr,searchLen
                                           , dirLR,check_num,offset)
    ����:
      testPtr      : �]�����镶����(UNICODE)�ւ̃|�C���^
      testLen      : �]�����镶����(UNICODE)�̒���
      searchPtr    : �T�[�`���镶����(UNICODE)�ւ̃|�C���^
      searchLen    : �T�[�`���镶����(UNICODE)�̒���
      dirLR        : "L"��"R"���w��B�T�[�`�̌���
      check_num    : ����ڂ̏o���̈ʒu��Ԃ����B
      offset       : �����Ŏw�肵�����������΂����ʒu����T�[�`���J�n

    �߂�l: 
      �w�肵�������񂪏o������ꏊ(������)��Ԃ��BdirLR�ɂ�炸�A
      ��ɕ����̐擪����̈ʒu�B�ꕶ���ڂ�0�ƂȂ�B
      �o�����Ȃ�������-1���Ԃ�B

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_wcStringGetPos_IfInStrCaseSnstv(testPtr,testLen, searchPtr,searchLen
                   , dirLR,check_num,offset)
{
  ; �����ɉ����āA�����l��ݒ�(����ȍ~�A�E�����������R�[�h�ɂȂ�)
  ptr := testPtr
  MBS_wcStringGetPos_begin(ptr,delta,testCount
                            ,testPtr,testLen,searchLen,dirLR,offset)
  ; �e�X�g�񐔕��̃��[�v
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
 
 ������T�[�`�֐��Q
 
 �w�肵�������񂪏o������ꏊ(������)��Ԃ�(�啶���������̋�ʂȂ�)
 
 pos:=MBS_wcStringGetPos_IfInStrNoCaseSnstv(testPtr,testLen, searchPtr,searchLen
                                           , dirLR,check_num,offset)
    ����:
      testPtr      : �]�����镶����(UNICODE)�ւ̃|�C���^
      testLen      : �]�����镶����(UNICODE)�̒���
      searchPtr    : �T�[�`���镶����(UNICODE)�ւ̃|�C���^
      searchLen    : �T�[�`���镶����(UNICODE)�̒���
      dirLR        : "L"��"R"���w��B�T�[�`�̌���
      check_num    : ����ڂ̏o���̈ʒu��Ԃ����B
      offset       : �����Ŏw�肵�����������΂����ʒu����T�[�`���J�n

    �߂�l: 
      �w�肵�������񂪏o������ꏊ(������)��Ԃ��BdirLR�ɂ�炸�A
      ��ɕ����̐擪����̈ʒu�B�ꕶ���ڂ�0�ƂȂ�B
      �o�����Ȃ�������-1���Ԃ�B

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_wcStringGetPos_IfInStrNoCaseSnstv(testPtr,testLen, searchPtr,searchLen
                   , dirLR,check_num,offset)
{
  ; �����ɉ����āA�����l��ݒ�(����ȍ~�A�E�����������R�[�h�ɂȂ�)
  ptr := testPtr
  MBS_wcStringGetPos_begin(ptr,delta,testCount
                            ,testPtr,testLen,searchLen,dirLR,offset)
  ; �e�X�g�񐔕��̃��[�v
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
 
 ������T�[�`�֐��Q
 
 �w�肵�������Q�̂����ǂꂩ���o������ꏊ(������)��Ԃ�(�啶���������̋�ʂȂ�)
 
 pos:=MBS_wcStringGetPos_IfCharInStr(testPtr,testLen, searchPtr,searchLen
                                           , dirLR,check_num,offset)
    ����:
      testPtr      : �]�����镶����(UNICODE)�ւ̃|�C���^
      testLen      : �]�����镶����(UNICODE)�̒���
      searchPtr    : �T�[�`���镶���Q(UNICODE)�ւ̃|�C���^
      searchLen    : �T�[�`���镶���Q(UNICODE)�̌�
      dirLR        : "L"��"R"���w��B�T�[�`�̌���
      check_num    : ����ڂ̏o���̈ʒu��Ԃ����B
      offset       : �����Ŏw�肵�����������΂����ʒu����T�[�`���J�n

    �߂�l: 
      �w�肵�������Q�̂����ǂꂩ���o������ꏊ(������)��Ԃ��BdirLR�ɂ�炸�A
      ��ɕ����̐擪����̈ʒu�B�ꕶ���ڂ�0�ƂȂ�B
      �o�����Ȃ�������-1���Ԃ�B

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_wcStringGetPos_IfCharInStr(testPtr,testLen, searchPtr,searchLen
                   , dirLR,check_num,offset)
{
  ; �����ɉ����āA�����l��ݒ�(����ȍ~�A�E�����������R�[�h�ɂȂ�)
  ptr := testPtr
  MBS_wcStringGetPos_begin(ptr,delta,testCount
                            ,testPtr,testLen,1,dirLR,offset)
  ; �e�X�g�񐔕��̃��[�v
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
 
 ������T�[�`�֐��Q
 
 �w�肵�������Q�̂����A�ǂ�Ƃ���v���Ȃ��������o������ꏊ(������)��Ԃ�
 (�啶���������̋�ʂȂ�)
 
 pos:=MBS_wcStringGetPos_IfCharNotInStr(testPtr,testLen, searchPtr,searchLen
                                           , dirLR,check_num,offset)
    ����:
      testPtr      : �]�����镶����(UNICODE)�ւ̃|�C���^
      testLen      : �]�����镶����(UNICODE)�̒���
      searchPtr    : �T�[�`���镶���Q(UNICODE)�ւ̃|�C���^
      searchLen    : �T�[�`���镶���Q(UNICODE)�̌�
      dirLR        : "L"��"R"���w��B�T�[�`�̌���
      check_num    : ����ڂ̏o���̈ʒu��Ԃ����B
      offset       : �����Ŏw�肵�����������΂����ʒu����T�[�`���J�n

    �߂�l: 
      �w�肵�������Q�̂����ǂ�Ƃ���v���Ȃ��������o������ꏊ(������)��Ԃ��B
      dirLR�ɂ�炸�A��ɕ����̐擪����̈ʒu�B�ꕶ���ڂ�0�ƂȂ�B
      �o�����Ȃ�������-1���Ԃ�B

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_wcStringGetPos_IfCharNotInStr(testPtr,testLen, searchPtr,searchLen
                   , dirLR,check_num,offset)
{
  ; �����ɉ����āA�����l��ݒ�(����ȍ~�A�E�����������R�[�h�ɂȂ�)
  ptr := testPtr
  MBS_wcStringGetPos_begin(ptr,delta,testCount
                            ,testPtr,testLen,1,dirLR,offset)
  ; �e�X�g�񐔕��̃��[�v
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
 
 ������T�[�`�֐��Q
 
 ��L�֐��̑O����
 
 MBS_wcStringGetPos_begin(ptr,delta,testCount
                          ,testPtr,testLen,searchLen,dirLR,offset)
    ����:
      ptr          : �T�[�`���J�n����|�C���^���i�[�����
      delta        : �|�C���^�𓮂����傫��(2��-2)���i�[�����
      testCount    : �T�[�`�̉񐔂��i�[�����
      testPtr      : �]�����镶����ւ̃|�C���^
      testLen      : �]�����镶����̒���
      searchLen    : �T�[�`���镶����̒���
      dirLR        : "L"��"R"���w��B�T�[�`�̌���
      offset       : �����Ŏw�肵�����������΂����ʒu����T�[�`���J�n

    �߂�l: 
      �Ȃ�

    ����:
      ��L�̒ʂ�
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

  ; �e�X�g��
  testCount := testLen - offset - searchLen + 1
  
  if(testCount < 0)
    testCount := 0
}

/*
 ...............................................................
 
 ������T�[�`�֐��Q
 
 ��L�֐��̌㏈��
 
 pos := MBS_wcStringGetPos_end(check_num,ptr,testPtr)

    ����:
      check_num    : �ŏI�I�ɏo�������񐔁B���ꂪ0�Ȃ�A�����ʂ��
                     �o�����������Ƃ������ƁB
      ptr          : �ŏI�I�ȏo���ʒu(�|�C���^)
      testPtr      : �]�����镶����̐擪�|�C���^

    �߂�l: 
      pos          : �o���ʒu�B�����ǂ���o�����Ȃ�������A-1

    ����:
      ��L�̒ʂ�
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
 
 �}���`�o�C�g������(Shift-JIS������ASCII�Ȃ�)���A
 ���C�h�L�����N�^������(UNICODE)�ɕϊ�����
 
 len := MBS_MultiByteToWideChar(wcstr, mbstr)

    ����:
      wcstr        : �ϊ���̃��C�h�L�����N�^�����񂪊i�[�����ϐ�
      mbstr        : �}���`�o�C�g�����񂪊i�[���ꂽ�ϐ�

    �߂�l: 
      len          : �������B�S�p�������P�����ƃJ�E���g����B

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_MultiByteToWideChar(ByRef wcstr, ByRef mbstr)
{
  ; �܂��A�K�v�ȃo�b�t�@�T�C�Y�������Ă��炤
  ; CP_ACP��0���������B
  bufSize := DllCall("MultiByteToWideChar", "Uint",0, "Uint",0,"Str",mbstr,"Int",-1,"Uint",0,"Uint",0)
  
  ; ����ł́A������̃o�b�t�@�̍쐬
  ; WideChar��2�o�C�g���Ǝv���Ă邩�灨 * 2
  VarSetCapacity(wcstr,bufSize * 2)
  
  ; �ϊ�
  DllCall("MultiByteToWideChar", "Uint",0, "Uint",0,"Str",mbstr,"Int",-1,"Str",wcstr,"Uint",bufSize)

  return bufSize - 1
}
  
/*
 ...............................................................
 
 ���C�h�L�����N�^������(UNICODE)���A
 �}���`�o�C�g������(Shift-JIS������ASCII�Ȃ�)�ɕϊ�����
 
 len := MBS_WideCharToMultiByte(mbstr, wcstr)

    ����:
      mbstr        : �ϊ���̃}���`�o�C�g�����񂪊i�[�����ϐ�
      wcstr        : ���C�h�L�����N�^�����񂪊i�[���ꂽ�ϐ�

    �߂�l: 
      �Ȃ�

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_WideCharToMultiByte(ByRef mbstr, ByRef wcstr)
{
  ; �܂��A�K�v�ȃo�b�t�@�T�C�Y�������Ă��炤
  ; CP_ACP��0���������B
  bufSize := DllCall("WideCharToMultiByte", "Uint",0, "Uint",0,"Str",wcstr,"Int",-1,"Uint",0, "Uint",0, "Uint",0, "Uint",0)
  
  ; ����ł́A������̃o�b�t�@�̍쐬
  VarSetCapacity(mbstr,bufSize)
  
  ; �ϊ�
  DllCall("WideCharToMultiByte", "Uint",0, "Uint",0,"Str",wcstr,"Int",-1,"Str",mbstr, "Uint",bufSize, "Uint",0, "Uint",0)

  return
}

/*
 ...............................................................
 
 �}���`�o�C�g������(Shift-JIS������ASCII�Ȃ�)���A
 ���C�h�L�����N�^������(UNICODE)�ɕϊ�����
 
 MBS_MultiByteToWideCharPtr(wcPtr,mbPtr, bufSize)

    ����:
      wcPtr        : �ϊ���̃��C�h�L�����N�^�����񂪊i�[�����
                     �o�b�t�@�̐擪�|�C���^
      mbPtr        : �}���`�o�C�g�����񂪊i�[���ꂽ�o�b�t�@�ւ̃|�C���^
      bufSize      : wcPtr�̃o�b�t�@�̑傫��(�o�C�g���ł͂Ȃ��AUNICODE������)

    �߂�l: 
      �Ȃ�

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_MultiByteToWideCharPtr(ptr, strPtr, bufSize)
{
  ; �ϊ�
  DllCall("MultiByteToWideChar", "Uint",0, "Uint",0
          ,"Uint",strPtr,"Int",-1,"Uint",ptr,"Uint",bufSize)
}

/*
 ...............................................................
 
 ���C�h�L�����N�^������(UNICODE)���A
 �}���`�o�C�g������(Shift-JIS������ASCII�Ȃ�)�ɕϊ�����

 
 MBS_WideCharToMultiBytePtr(mbPtr,wcPtr, bufSize)

    ����:
      mbPtr        : �ϊ���̃}���`�o�C�g�����񂪊i�[�����
                     �o�b�t�@�̐擪�|�C���^
      wcPtr        : ���C�h�L���������񂪊i�[���ꂽ�o�b�t�@�ւ̃|�C���^
      bufSize      : mbPtr�̃o�b�t�@�̑傫��(�o�C�g��)

    �߂�l: 
      �Ȃ�

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_WideCharToMultiBytePtr(ptr, strPtr, bufSize)
{
  ; �ϊ�
  DllCall("WideCharToMultiByte", "Uint",0, "Uint",0
          ,"Uint",strPtr,"Int",-1,"Uint",ptr, "Uint",bufSize
          , "Uint",0, "Uint",0)

  return
}

/*
 ...............................................................
 
 ���C�h�L�����N�^������(UNICODE)���A
 �}���`�o�C�g������(Shift-JIS������ASCII�Ȃ�)�ɕϊ�����
 
 MBS_WideCharToMultiByteStr(mbStr,wcPtr, bufSize)

    ����:
      mbStr        : �ϊ���̃}���`�o�C�g�����񂪊i�[�����
                     �ϐ�
      wcPtr        : ���C�h�L���������񂪊i�[���ꂽ�o�b�t�@�ւ̃|�C���^
      bufSize      : mbStr�̃o�b�t�@�̑傫��(�o�C�g��)

    �߂�l: 
      �Ȃ�

    ����:
      �Ȃ��AMBS_WideCharToMultiBytePtr()������̂ɁA
      �{�֐����������(���҂�ByRef���|�C���^���̈Ⴂ�����Ȃ�)
      
      AHK���A�ϐ����A���l�ƔF������̂��A������ƔF������̂��́A
      �󋵂ɂ���ĈقȂ�̂����ADllCall�ŕϐ��̒��ɕ������������
      �悤�ȏꍇ�́A"Str"�ł�����Ŗ��Ȃ��ƁA������ƔF���ł��Ȃ�
      �悤���B
      
      �Ⴆ�΁A�ȉ��̂悤��DllCall���s���Ƃ���B
      
      ; 1
      DllCall("xxxx","Str",str)
      
      ; 2
      DllCall("xxxx","Uint",&str)
      
      "xxxx"�́A�^����ꂽ�|�C���^�ɁA��������i�[����֐����Ǝv���ė~�����B
      "xxxx"�ɂƂ��āA1��2���A�܂����������Ӗ��ł���B���҂Ƃ��A�ϐ�str��
      �̈�ɁA�����񂪊i�[�����B

      �������AAHK�ɂƂ��ẮA2�́A�P��"xxxx"�ɐ��l��n�������ƂɂȂ�A
      str�ɕ����񂪊i�[���ꂽ���Ƃ͔F���ł��Ȃ��B���̏ꍇ�AAHK�́Astr��
      ���l���Ǝv���悤�ɂȂ�A
        str2 := str
      �̂悤�Ȓl�̃R�s�[���s���ƁA"xxxx"���i�[����������̐擪�̐��o�C�g�����A
      str2�ɃR�s�[����Ȃ��Ȃ��Ă��܂��B
      
      ���������āAAHK���Astr�ɁA�m���ɕ����񂪊i�[���ꂽ���Ƃ�F�����邽�߂ɂ́A
      1�̂悤�ɁA"Str"�ŁADllCall�����Ȃ���΂Ȃ�Ȃ��B
      
      ���̂��߂ɁA�{�֐���p�ӂ����B

 ...............................................................
*/
MBS_WideCharToMultiByteStr(ByRef output, strPtr, bufSize)
{
  ; �ϊ�
  DllCall("WideCharToMultiByte", "Uint",0, "Uint",0
          ,"Uint",strPtr,"Int",-1,"Str",output, "Uint",bufSize
          , "Uint",0, "Uint",0)

  return
}

/*
 ...............................................................
 
 �}���`�o�C�g������(Shift-JIS������ASCII�Ȃ�)��
 ���C�h�L�����N�^������(UNICODE)�ɕϊ����鎞�ɕK�v�ȃo�b�t�@�T�C�Y��Ԃ�
 
 size := MBS_GetWcsSize(mbstrPtr,len="")

    ����:
      mbstrPtr     : �}���`�o�C�g�����񂪊i�[���ꂽ�o�b�t�@�ւ̃|�C���^
      len          : �ϊ�����}���`�o�C�g������̒����B�ȗ����́A
                     ���ׂĂ̕�����(mbstrPtr����^�[�~�l�[�^�܂ł̕�����)

    �߂�l: 
      size         : �o�b�t�@�T�C�Y(�o�C�g���ł͂Ȃ��AUNICODE������)
                     len���w�肵���ꍇ�́A�^�[�~�l�[�^���͊܂܂Ȃ����璍��

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_GetWcsSize(mbstrPtr,len="")
{
  ; �܂��A�K�v�ȃo�b�t�@�T�C�Y�������Ă��炤
  ; CP_ACP��0���������B
  if(len=="")
    len := -1

  return DllCall("MultiByteToWideChar", "Uint",0
                 , "Uint",0,"Uint",mbstrPtr,"Int",len,"Uint",0,"Uint",0)
}

/*
 ...............................................................
 
 ���C�h�L�����N�^������(UNICODE)��
 �}���`�o�C�g������(Shift-JIS������ASCII�Ȃ�)�ɕϊ����鎞��
 �K�v�ȃo�b�t�@�T�C�Y��Ԃ�
 
 size := MBS_GetMbsSize(wcstrPtr,len="")

    ����:
      wcstrPtr     : ���C�h�L���������񂪊i�[���ꂽ�o�b�t�@�ւ̃|�C���^
      len          : �ϊ����郏�C�h�L����������̒����B�ȗ����́A
                     ���ׂĂ̕�����(wcstrPtr����^�[�~�l�[�^�܂ł̕�����)

    �߂�l: 
      size         : �o�b�t�@�T�C�Y(�o�C�g��)
                     len���w�肵���ꍇ�́A�^�[�~�l�[�^���͊܂܂Ȃ����璍��

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_GetMbsSize(wcstrPtr,len="")
{
  ; �܂��A�K�v�ȃo�b�t�@�T�C�Y�������Ă��炤
  ; CP_ACP��0���������B
  if(len=="")
    len := -1
    
  return DllCall("WideCharToMultiByte", "Uint",0
                 , "Uint",0,"Uint",wcstrPtr,"Int",len,"Uint",0,"Uint",0
                 , "Uint",0, "Uint",0)
}

/*
 ...............................................................
 
 �������̎擾
 
 ptr := MBS_Alloc(size)

    ����:
      size         : �擾�������������̃o�C�g��

    �߂�l: 
      ptr          : �擾�����������̃|�C���^
                     ���s�����Ƃ��́ANULL���Ԃ�

    ����:
     �����Ŏ擾�����������́A�p���ς񂾂�A�K��MBS_Free()�ŉ�����邱�ƁB
     �����Ȃ��ƁA���������[�N�̌����ƂȂ�B
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
 
 �������̉��
 
 result := MBS_Free(ptr)

    ����:
      ptr          : ����������������̃|�C���^�B�K���AMBS_Alloc()�Ŏ擾����
                     ���̂ł��邱�ƁB

    �߂�l: 
      result       : ����������true,���s������false

    ����:
      ��L�̒ʂ�
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
 
 �������̃T�C�Y�ύX
 
 new_ptr := Reallocate(ptr,size)

    ����:
      ptr          : �T�C�Y�ύX�������������̃|�C���^�B
                     �K���AMBS_Alloc()�Ŏ擾�������̂ł��邱�ƁB
      size         : �V�����T�C�Y

    �߂�l: 
      new_ptr      : �T�C�Y��size�ƂȂ����������̃|�C���^�B
                     ptr�Ɠ������ǂ����͂킩��Ȃ��B
                     ���s�����ꍇ��NULL

    ����:
      ��L�̒ʂ�
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
 
 Unsigned int(32bit)�̓ǂݏo��
 
 val := MBS_ReadUint(ptr)

    ����:
      ptr          : �ǂݏo�������|�C���^

    �߂�l: 
      val          : ptr����͂��܂�4byte(32bit)�̃f�[�^�𕄍��Ȃ�����
                     �ŕ\�������l�B
                     �f�[�^�́A���g���G���f�B�A���Ŋi�[����Ă��邱�ƁB

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_ReadUint(ptr)
{
  val := *ptr | (*(ptr+1) << 8) | (*(ptr+2) << 16) | (*(ptr+3) << 24)
  return val
}

/*
 ...............................................................
 
 Unsigned int(32bit)�̏�������
 
 MBS_ReadUint(ptr,val)

    ����:
      ptr          : �������݂����|�C���^
      val          : �������݂����l(�����Ȃ������l)

    �߂�l: 
      �Ȃ�

    ����:
      ptr����4byte(32bit)�̃f�[�^�Ƃ��āAval�̒l���������ށB
      ���g���G���f�B�A���ŏ������ށB
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
 
 Unsigned int(16bit)�̓ǂݏo��
 
 val := MBS_ReadUint16(ptr)

    ����:
      ptr          : �ǂݏo�������|�C���^

    �߂�l: 
      val          : ptr����͂��܂�2byte(16bit)�̃f�[�^�𕄍��Ȃ�����
                     �ŕ\�������l�B
                     �f�[�^�́A���g���G���f�B�A���Ŋi�[����Ă��邱�ƁB

    ����:
      ��L�̒ʂ�
 ...............................................................
*/
MBS_ReadUint16(ptr)
{
  val := *ptr | (*(ptr+1) << 8)
  return val
}

/*
 ...............................................................
 
 Unsigned int(16bit)�̏�������
 
 MBS_ReadUint16(ptr,val)

    ����:
      ptr          : �������݂����|�C���^
      val          : �������݂����l(�����Ȃ������l)

    �߂�l: 
      �Ȃ�

    ����:
      ptr����2byte(16bit)�̃f�[�^�Ƃ��āAval�̒l���������ށB
      ���g���G���f�B�A���ŏ������ށB
 ...............................................................
*/
MBS_WriteUint16(ptr,val)
{
  byte1 := (val & 0x000000ff)
  byte2 := (val & 0x0000ff00) >> 8

  DllCall("RtlFillMemory", "Uint",ptr,     "Uint",1,"UChar",byte1)
  DllCall("RtlFillMemory", "Uint",ptr + 1, "Uint",1,"UChar",byte2)
}

