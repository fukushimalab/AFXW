@echo off
REM afxmake.exe�̃t���p�X�ݒ�
SET AFXMAKE=%~d0%~p0afxmake.exe

REM Visual Studio 2005 vcproje�p�ݒ�
IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio 8.0\VC\bin\vcvars32.bat" (SET VC8VAR=C:\Program Files (x86)\Microsoft Visual Studio 8.0\VC\bin\vcvars32.bat) ELSE (SET VC8VAR=C:\Program Files\Microsoft Visual Studio 8.0\VC\bin\vcvars32.bat)

REM Visual Studio 2008 vcproje�p�ݒ�
IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat" (SET VC9VAR=C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat) ELSE (SET VC9VAR=C:\Program Files\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat)

REM apache ant�̃p�X�w�� (�ʏ�̊J�����Ȃ�p�X���ʂ��Ă���)
SET ANT=ant

REM java�R���p�C���̃p�X�w�� (�ʏ�̊J�����Ȃ�p�X���ʂ��Ă���)
SET JAVAC=javac

REM WDK(Windows Driver Kit)�̃C���X�g�[���f�B���N�g���ݒ�
SET WDK7DIR=C:\WinDDK\7600.16385.1

