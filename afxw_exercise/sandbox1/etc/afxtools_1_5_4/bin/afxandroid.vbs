'[Android target ids]
' android-3                                            (Android 1.5)
' Google Inc.:Google APIs:3
' android-4                                            (Android 1.6)
' Google Inc.:Google APIs:4
' android-7                                            (Android 2.1)
' Google Inc.:Google APIs:7
' android-8
' Google Inc.:Google APIs:8                            (Android 2.2)
' KYOCERA Corporation:DTS Add-On:8
' LGE:Real3D Add-On:8
' Samsung Electronics Co., Ltd.:GALAXY Tab Addon:8
' Samsung Electronics Co., Ltd.:GALAXY Tab Addon:8
' android-9                                            (Android 2.3.1)
' Google Inc.:Google APIs:9
' Sony Ericsson Mobile Communications AB:EDK:9
' android-10                                           (Android 2.3.3)
' Google Inc.:Google APIs:10
' android-11                                           (Android 3.0)
' Google Inc.:Google APIs:11
' android-12                                           (Android 3.1)
' Google Inc.:Google APIs:12

Dim ao
Set ao = Createobject("afxw.obj")
ao.Exec "&SET 0 android-8"
ao.Exec "&SET 1 HelloProject"
ao.Exec "&SET 2 HelloWorld"
ao.Exec "&SET 3 jp.co.seesaa.yuratomo"
ao.Exec "&SET 4 test_vm"
call ao.MesPrint("ANDROID�p ����w�����ϐ���ݒ肵�܂����B")
call ao.MesPrint("  �^�[�Q�b�gID:"   + ao.Extract("$0"))  ' �v���W�F�N�g�쐬���A���z�}�V���쐬���Ɏg�p
call ao.MesPrint("  �v���W�F�N�g��:" + ao.Extract("$1"))  ' �v���W�F�N�g�쐬���Ɏg�p
call ao.MesPrint("  �N���X��:"       + ao.Extract("$2"))  ' �v���W�F�N�g�쐬���Ɏg�p
call ao.MesPrint("  �p�b�P�[�W��:"   + ao.Extract("$3"))  ' �v���W�F�N�g�쐬���Ɏg�p
call ao.MesPrint("  ���z�}�V����:"   + ao.Extract("$4"))  ' ���z�}�V���쐬���A���z�}�V�����s���Ɏg�p
Set ao = Nothing
