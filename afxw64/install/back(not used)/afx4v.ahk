; afx4v 09/05/31 ���E���


; ** ���ݒ� *************************
  #NoTrayIcon                   ; �g���C�A�C�R����\��
  #SingleInstance ignore        ; ���d�N���֎~
  #NoEnv                        ; �\�����ʊ��ϐ���ǂ܂Ȃ��B
  #EscapeChar '                 ; �G�X�P�[�v������ύX (�ʖڕ����΍�)
;  SetWorkingDir, %A_ScriptDir%  ; ���΃p�X�Ή�
  SetTitleMatchMode, 2          ; �^�C�g���̌����𒆊Ԉ�v�ɂ���B
  DetectHiddenWindows, on       ; ��\���̃E�B���h�E����������B


; ** INI �t�@�C���̗L�����`�F�b�N *****
  MBS_SplitPath(A_ScriptName, dummy, dummy, dummy, inifile, dummy)
  inifile = %A_ScriptDir%\%inifile%.ini
  IfNotExist, %inifile%  ; INI �t�@�C�����Ȃ��ꍇ�͍쐬���ďI������B
  {
    IniWrite, %A_Space%, %inifile%, AFX, R.File
    IniWrite, %A_Space%, %inifile%, AFX, V.Key
    IniWrite, 0,         %inifile%, AFX, AFXW
    IniWrite, AFX.INI,   %inifile%, AFX, AFX.P
    IniWrite, AFXW.INI,  %inifile%, AFX, AFXW.P
    IniWrite, %A_Space%, %inifile%, AFX, Title
    IniWrite, %A_Space%, %inifile%, AFX, S.Key
    IniWrite, %A_Space%, %inifile%, AFX, S.Title
    IfExist, %inifile%   ; INI �t�@�C�����쐬���ꂽ���m�F
      MsgBox, INI �t�@�C�����쐬���܂����B'n'n%inifile%
    Else
      MsgBox, INI �t�@�C���̍쐬�Ɏ��s���܂����B'n'n%inifile%
    ExitApp
  }


; ** �����̃`�F�b�N *******************
  if 0 = 0
  {
    MsgBox, �������L��܂���B
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
            MsgBox, /t �� /n �͓����w��o���܂���B
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
          rsize = %1%                       ; RegExMatch �� Target �� 1 �͎g���Ȃ��B
          RegExMatch(rsize, "-.+-", rsize)  ; "-" �ň͂܂ꂽ�������ǂށB
          if rsize != 
          {
            StringTrimLeft, rsize, rsize, 1
            StringTrimRight, rsize, rsize, 1
          }
          else                              ; �����񂪖��������ꍇ�A0 ���i�[����B
            rsize = 0
          if rsize is not digit             ; 0 - 9 �݂̂̃f�[�^�ȊO�� 0 �Ƃ���B
            rsize = 0
        }
      }
    }
  }


; ** INI �t�@�C���̓ǂݍ��� ***********
  if view != 0                                ; /v �w�莞 INI �t�@�C���𖳎�����B
  {
    if pipe != 1                              ; /p �w�莞 R.File �̐ݒ�𖳎�����B
    {
      IniRead, rfile, %inifile%, AFX, R.File  ; ���_�C���N�g�t�@�C����
      if rfile = ERROR                        ; �L�[��������Ȃ��ꍇ�A���������B
      {
        IniWrite, %A_Space%, %inifile%, AFX, R.File
        rfile =                               ; �L�[�����������ꍇ�A�󈵂��ɂ���B
      }
      if (rfile = "" and ini != 1)            ; �󊎂� /i �s�w�莞�A�x������B
      {
        MsgBox, %inifile% �t�@�C����'nR.File �ɓK���ȃt�@�C�������L�q���ĉ������B
        ExitApp
      }
      if ini = 1                              ; /i �w�莞�A�L�[�����������B
        RWIni(inifile, "AFX", "R.File", rfile)
    }
    if (spare != 1 or ini = 1)                ; /s �s�w�薔�� /i �w�莞�AV.Key ��ǂށB
    {
      IniRead, vkey,  %inifile%, AFX, V.Key   ; R.File �{���p�L�[���r���A��G�f�B�^
      if vkey = ERROR
      {
        IniWrite, %A_Space%, %inifile%, AFX, V.Key
        vkey = 
      }
      if ini = 1
        RWIni(inifile, "AFX", "V.Key", vkey)
    }
    IniRead, afxw, %inifile%, AFX, AFXW       ; 0 �Ȃ� ���ӁA1 �Ȃ� ���ӂ� �ƌ��Ȃ��B
    if afxw = ERROR
    {
      IniWrite, 0, %inifile%, AFX, AFXW
      afxw = 0
    }
    if ini = 1
      RWIni(inifile, "AFX", "AFXW", afxw)
    IfInString, 1, /w                         ; /w �w�莞�AAFXW �̒l���t�]���Ĉ����B
    {
      if afxw = 0
        afxw = 1
      else
        afxw = 0
    }
    if (afxw = 0 or ini = 1)                  ; AFXW = 0 ���� /i �w�莞�AAFX.P ��ǂށB
    {
      IniRead, afxp,  %inifile%, AFX, AFX.P   ; ���ӂ� INI �t�@�C���̏ꏊ
      if afxp = ERROR
      {
        IniWrite, AFX.INI, %inifile%, AFX, AFX.P
        afxp = AFX.INI
      }
      if ini = 1
        RWIni(inifile, "AFX", "AFX.P", afxp)
    }
    if (afxw = 1 or ini = 1)                  ; AFXW = 1 ���� /i �w�莞�AAFXW.P ��ǂށB
    {
      IniRead, afxp, %inifile%, AFX, AFXW.P   ; ���ӂ��� INI �t�@�C���̏ꏊ
      if afxp = ERROR
      {
        IniWrite, AFXW.INI, %inifile%, AFX, AFXW.P
        afxp = AFXW.INI
      }
      if ini = 1
        RWIni(inifile, "AFX", "AFXW.P", afxp)
    }
    if (spare != 1 or ini = 1)                ; /s �s�w�薔�� /i �w�莞�ATitle ��ǂށB
    {
      IniRead, title, %inifile%, AFX, Title   ; �O���v���O�����̃^�C�g���o�[�̕���
      if title = ERROR
      {
        IniWrite, %A_Space%, %inifile%, AFX, Title
        title = 
      }
      if ini = 1
        RWIni(inifile, "AFX", "Title", title)
    }
    if (spare = 1 or ini = 1)                 ; /s ���� /i �w�莞�AS.Key, S.Title ��ǂށB
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
    if (delete != 0 or ini = 1)               ; /d �s�w�薔�� /i �w�莞�ATime ��ǂށB
    {
      IniRead, atime, %inifile%, AFX, A.Time
      if (atime != "ERROR" and ini = 1)       ; �L�[���������ꍇ�A���������̑ΏۂɁB
        RWIni(inifile, "AFX", "A.Time", atime)
      if atime = 
        atime = 300                           ; A.Time �̏����l
      else if atime is not digit
        atime = 300
      else if atime <= 300                    ; �����l�ȉ��ɂ͐ݒ肳���Ȃ��B
        atime = 300
      IniRead, vtime, %inifile%, AFX, V.Time
      if (vtime != "ERROR" and ini = 1)
        RWIni(inifile, "AFX", "V.Time", vtime)
      if vtime = 
        vtime = 3                             ; V.Time �̏����l
      else if vtime is not digit
        vtime = 3
      else if vtime <= 3
        vtime = 3
    }
    if ini = 1                                ; /i �w�莞�A�I��
    {
      MsgBox, INI �t�@�C���̍��ڂ𐮗����܂����B'n'n%inifile%
      ExitApp
    }
  }


; ** �p�X�̕ϊ����� *******************
  if view != 0
  {
    GetEnv(vkey)                              ; V.Key �̊��ϐ�������
    MBS_SplitPath(vkey, dummy, dummy, ext, searchv, dummy)
    if ext = exe                              ; V.Key �����s�t�@�C�����ǂ����A�g���q�Ŕ��f
    {
      Rel2Abs(vkey)                           ; V.Key ���΃p�X��
      IfNotExist, %vkey%
      {
        MsgBox, V.Key ( /s �w�莞�AS.Key ) ��'n���������s�t�@�C�������L�q���ĉ������B'n'n%vkey%
        ExitApp
      }
    }
    else                                      ; V.Key �� exe �łȂ��Ȃ�AAFX.P ( AFXW.P ) ��ǂށB
    {
      GetEnv(afxp)
      Rel2Abs(afxp)
      IfNotExist, %afxp%
      {
        MsgBox, AFX.P ( AFXW = 1 �Ȃ� AFXW.P ) ��'n������ AFX ( W ) .INI �̏ꏊ���L�q���ĉ������B'n'n%afxp%
        ExitApp
      }
                                              ; %afx% �����߉\�ɂ���B
      MBS_SplitPath(afxp, dummy, afxid, dummy, dummy, dummy)
      IniRead, afxp, %afxp%, PROGRAM, VIEWER  ; ���ӂ̊O���r���A�̐ݒ��ǂށB
      if afxp !=                              ; �����ݒ肳��Ă����ꍇ�A�����p����B
      {
        StringReplace, vkey, afxp, ", , All   ; " ��S�ĉ����Č�ǖh�~
        GetEnv(vkey)
        StringReplace, vkey, vkey, '%afx'%, %afxid%, All
        Rel2Abs(vkey)
        IfNotExist, %vkey%
          vkey = 0
        Else
          MBS_SplitPath(vkey, dummy, dummy, ext, searchv, dummy)
        if (vkey = 0 or ext != "exe")         ; V.Key �����݂��Ȃ��A���͊g���q�� exe �łȂ��Ȃ�G���[
        {
          MsgBox, ���� ( AFXW = 1 �Ȃ� ���ӂ� ) �ݒ��'n�u�v���O�����v���u�O���e�L�X�g�r���A�v����'n���������s�t�@�C�������L�q���ĉ������B'n'n%vkey%
          ExitApp
        }
      }
      else                                    ; ���ӓ����r���A��p����Ȃ�AV.Key �̕����񒷂��m���߂�B
      {
        if pipe = 1
        {
          MsgBox, /p �w�莞�͂��ӓ����r���A�͎g���܂���B
          ExitApp
        }
        if vkey =                             ; ����L�[����Ȃ�G���[
          MsgBox, %inifile% �t�@�C����'nV.Key ( /s �w�莞�AS.Key ) ��'n�{���p�L�[���r���A��G�f�B�^���L�q���ĉ������B
                                              ; �P��ŏ����ꂽ�C���L�[�����O
        count := RegExReplace(vkey,  "iU)\{(L|R|)(shift|control|ctrl|alt|win)(|down| down|up| up)\}")
                                              ; �G�X�P�[�v���ꂽ�C���L�[�p�L���� 1 ������
        count := RegExReplace(count, "\{[\+\^!#]\}", "b")
                                              ; �L���ŏ����ꂽ�C���L�[�����O
        count := RegExReplace(count, "[\+\^!#]")
                                              ; ����L�[�� 1 ������
        count := RegExReplace(count, "U)\{.+\}", "b")
        if (StrLen(count) > 1)                ; �������ꂽ�L�[�́A�������`�F�b�N�B
        {
          MsgBox, �����L�[�͈�����ł��B'n'n%vkey%
          ExitApp
        }
      }
    }
    if pipe != 1                              ; /p �s�w�莞�AR.File ���g���B
    {
      GetEnv(rfile)
      Rel2Abs(rfile)
      MBS_SplitPath(rfile, dummy, dummy, dummy, searchr, dummy)
      AddDqs(rfile)                           ; R.File ���󔒂��܂ނȂ�Acmd �p�� " �ň͂ށB
      if title != 
        searchr = %title%
    }
  }


; ** ���� �������A������ΏI������ ****
  if view != 0
    if ext != exe  ; ���ӓ����r���A��p���Ȃ��Ȃ猟�����Ȃ��B
    {
      if afxw = 1  ; AFXW = 1 �Ȃ炠�ӂ�������
        afxid := WinExist("ahk_class TAfxWForm")
      else
        afxid := WinExist("ahk_class TAfxForm")
      if afxid = 0
      {
        MsgBox, ���� ( AFXW = 1 �Ȃ� ���ӂ� ) ���N�����Ă��܂���B
        ExitApp
      }
    }


; ** AddDqs ���� 1-n ��Z�߂� *********
  Loop, %0%             ; �����̐��������[�v��������B
  {
    param := %A_Index%  ; ���[�v�̉񐔔ԍ����o���A���̔ԍ��̈������i�[�����B
    AddDqs(param)
    cmd = %cmd% %param%
  }
  if cmdline = 1        ; �{�X�N���v�g�p���������O����B
    StringReplace, cmd, cmd, %1%


; ** �O���R�}���h�̎��s ***************
  if view = 0                           ; /v �w�莞�A�R�}���h�����s���ďI������B
  {
    cmd = %ComSpec% /k %cmd% | more
    Run, %cmd%
    ExitApp
  }
  cmd = %ComSpec% /c %cmd%              ; OS �ɂ�� command.com /c ���� cmd.exe /c
  if stderr = 1                         ; /e �w�莞�A�G���[�o�͂�W���o�͂Ɋ܂߂�B
    param = 2>&1
  else
    param = 
  if pipe = 1                           ; /p �w�莞�A�R�}���h�����s���ďI������B
  {
    cmd = %cmd% %param%| %vkey%
    Run, %cmd%, , Hide
    ExitApp
  }
  IfNotInString, cmd, %rfile%           ; ������ %rfile% ���܂܂Ȃ��ꍇ�A���_�C���N�g����B
  {
    if redirect != 0                    ; /n �w�莞�A���_�C���N�g���Ȃ��B
      cmd = %cmd% > %rfile% %param%
  }
  Else                                  ; ������ %rfile% ���܂ޏꍇ�A���_�C���N�g���Ȃ��B
    if redirect = 1                     ; /t �w�莞�A���_�C���N�g����B
      cmd = %cmd% > %rfile% %param%
  ErrorLevel = 0                        ; ErrorLevel ��Ԃ��Ȃ��R�}���h�p�� 0 ���Z�b�g
  RunWait, %cmd%, , Hide/UseErrorLevel  ; �R�}���h�����s���āA�R�}���h�̏I����҂B
;  if ErrorLevel <> 0                    ; ErrorLevel �� 0 �ȊO�̏ꍇ�A���f����B
  if ErrorLevel < 0                     ; ErrorLevel �����̏ꍇ�A���f����B
  {
    MsgBox, �R�}���h�̎��s�Ɏ��s���܂����B'n'n%cmd%'nHide/UseErrorLevel'n'nErrorLevel ( %ErrorLevel% )
    ExitApp
  }


; ** ���� �ɃL�[�𑗂� ****************
  StringReplace, rfile, rfile, ", ,All       ; R.File �� AutoHotKey �œǂ߂�悤�� " �������B
  IfExist, %rfile%                           ; R.File �̑��݂��m�F����B
  {
    if bottom = 0                            ; /b �w�莞�A�w��T�C�Y�ȉ��� R.File �𖳎�����B
    {
      FileGetSize, count, %rfile%
      if count <= %rsize%
      {
        if delete != 0                       ; /d �s�w�莞�AR.File ���폜
          FileDelete, %rfile%
        ExitApp
      }
    }
    if ext != exe
      ControlSend, , %vkey%, ahk_id %afxid%  ; ���ӂɉ{���p�L�[�𑗂�B
    else
      Run, %vkey% %rfile%                    ; �O���v���O������ R.File ���J���B
    if delete != 0                           ; /d �s�w�莞�AR.File ���폜���邽�߂̑ҋ@���[�`��
    {
      if ext != exe
        Sleep, %atime%                       ; ���ӓ����r���A�p�̃^�C�~���O�␳ ( A.Time )
      else
      {
        WinWaitActive, %searchr%, , %vtime%  ; �O���v���O�����̋N���� V.Time �b�܂ő҂B
        IfWinNotActive, %searchr%            ; �^�C�g���o�[����( R.File ���� Title )
          IfWinNotActive, %searchv%          ; ( �O���v���O�����̃t�@�C���� )
          {
            MsgBox, 4116, , �O���v���O�����̎��s���͌����Ɏ��s���܂����B'n'n%rfile%'n���폜���܂����B
            IfMsgBox, No
              ExitApp
          }
      }
      FileDelete, %rfile%                    ; R.File �̍폜
    }
    ExitApp                                  ; �{�X�N���v�g�̏I��
  }
  Else                                       ; R.File �̍쐬�Ɏ��s�����ꍇ
  {
    MsgBox, ���_�C���N�g�t�@�C���̍쐬�Ɏ��s���܂����B'n'n%rfile%
    ExitApp
  }


; ** �T�u���[�`�� *********************
/*
  ������
    �G�X�P�[�v�������܂܂�Ă��܂��B
    �{�\�[�X�̊��ݒ藓�� #EscapeChar �����邩���m�F�������B
    �ύX����ꍇ�A�S�u���Ŗ�肠��܂���B
*/


/*
  �֐�: RWIni(File, Section, Key, Value)
  INI �t�@�C���̃L�[��n���ꂽ�l�ŏ��������B
*/
RWIni(param, foobar, count, pro)
{
  IniDelete, %param%, %foobar%, %count%
  IniWrite, %pro%, %param%, %foobar%, %count%
}


/*
  �Q�ƌ^�֐�: GetEnv(pro)
  �n���ꂽ�ϐ����� %~% ����������ϐ��Ƃ��Ēu������B
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
  �Q�ƌ^�֐�: Rel2Abs(pro)
  �n���ꂽ�ϐ������΃p�X�Ȃ� A_ScriptDir ����Ƃ�����΃p�X�ɕϊ�����B
*/
Rel2Abs(ByRef pro)
{
  SplitPath, pro, , , , , foobar
  if foobar = 
    pro = %A_ScriptDir%\%pro%
}


/*
  �Q�ƌ^�֐�: AddDqs(pro)
  �n���ꂽ�ϐ������p��S�p�󔒂��܂ނȂ� " �Ŋ���B
*/
AddDqs(ByRef pro)
{
  RegExReplace(pro, "[ �@]", $, count)
  if count > 0
    pro = "%pro%"
}


; ** �C���N���[�h *********************
  #Include %A_ScriptDir%\mbstring.ahk  ; mbstring ���g�p����B(�ʖڕ����΍�)

