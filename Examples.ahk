﻿#Requires AutoHotkey v2.0
#SingleInstance

#include Notify.ahk

;============================================================================================

Notify.Show('The quick brown fox jumps over the lazy dog.')
Notify.Show('Alert!', 'You are being warned.',,,, 'theme=!')
Notify.Show('Error', 'Something has gone wrong!',,,, 'theme=x dur=6 pos=bl')
Notify.Show('Info', 'Some information to show.',, 'soundi',, 'theme=idark style=edge show=slideNorth hide=slideSouth@250')

;============================================================================================
;   5 Ways to Destroy/Dismiss GUI
;============================================================================================

Notify.Show('Destroy the GUI by clicking on it before the set duration ends.', 'Click on GUI',,,, 'theme=matrix style=edge dur=15 pos=bl maxw=325')

mNotifyGUI := Notify.Show('Destroy the GUI using a Handle.', 'Press Ctrl+F1', 'none',,, 'theme=!Dark dur=0 pos=tc mali=center')
^F1::Notify.Destroy(mNotifyGUI['hwnd'])

Notify.Show('Destroy the GUI with the TAG option. This destroys every GUI with the specified tag across all scripts.', 'Press Ctrl+F2',,,, 'theme=synthwave dur=0 pos=ct tag=myTAG style=edge mali=center maxw=375')
^F2::Notify.Destroy('myTAG')

Notify.Show(strTitleDGTAG := 'Destroy the GUI with DG and TAG options. This destroys all GUIs with the tag before creating a new one.', 'Press Ctrl+F3',,,, 'theme=iDark dur=0 mali=center tag=thisTag maxw=325')
^F3::Notify.Show(strTitleDGTAG, 'Press Ctrl+F3',,,, 'theme=iDark mali=center dg=5 tag=thisTag maxw=325')

; Assign a hotkey to destroy GUIs one by one, starting with the oldest.
HotIfWinExist('NotifyGUI_ ahk_class AutoHotkeyGUI')
Hotkey('Esc', (*) => Notify.Destroy())
HotIfWinExist()

;============================================================================================
;   Change the icon and text upon left-clicking the GUI using a callback.
;   Limitation: The GUI doesn’t automatically resize when text is updated.
;============================================================================================

mNotifyGUI_CB := Notify.Show('Title', 'Click to change the icon and text using a callback.', A_WinDir '\system32\imageres.dll|Icon5',, NotifyGUICallback, 'theme=Dracula dur=0 dgc=0 pos=tl')

NotifyGUICallback(*)
{
    mNotifyGUI_CB['pic'].Value := A_WinDir '\system32\user32.dll'
    mNotifyGUI_CB['title'].Value := 'Title changed'
    SetTimer((*) => _UpdateNotifyGUI('msg', 'Message changed'), -2000)
    SetTimer((*) => Notify.Destroy(mNotifyGUI_CB['hwnd']), -4000)
}

; Try, to prevent an error in case the GUI was destroyed.
_UpdateNotifyGUI(ctrlName, value) {
    try mNotifyGUI_CB[ctrlName].Value := value
}

;============================================================================================
;   Progress Bar
;============================================================================================

mNotifyGUI_Prog := Notify.Show('Progress Bar Example', '0%',,,, 'theme=Solarized Dark style=edge dur=0 prog=w325 dgc=0 mali=right')

SetTimer((*) => UpdateNotifyGUI('prog', 50), -2000)
SetTimer((*) => UpdateNotifyGUI('msg', '50%'), -2000)
SetTimer((*) => UpdateNotifyGUI('prog', 100), -4000)
SetTimer((*) => UpdateNotifyGUI('msg', 'Finished!'), -4000)
SetTimer((*) => Notify.Destroy(mNotifyGUI_Prog['hwnd']), -6000)

UpdateNotifyGUI(ctrlName, value) {
    try mNotifyGUI_Prog[ctrlName].Value := value
}

;============================================================================================
;   Set default theme
;============================================================================================

Notify.SetDefaultTheme('Cyberpunk')
Notify.Show('Cyberpunk', 'Cyberpunk is a subgenre of science fiction in a dystopian futuristic setting that tends to focus on a combination of low-life and high tech.',,,, 'pos=ct mali=center tali=center maxw=325')
Notify.Show('Notify Title', 'Notify message with Cyberpunk theme.',,,, 'pos=ct style=edge bdr=default tali=center')

Notify.SetDefaultTheme('Monokai')
Notify.Show('Monokai', 'Monokai is a popular theme for coding environments, featuring a dark background with vibrant, neon colors for enhanced readability.',,,, 'pos=tl maxw=325')
Notify.Show('Notify Title', 'Notify message with Monokai theme.',,,, 'pos=tl style=edge bdr=default')

;============================================================================================
;   Lock keys indicators
;============================================================================================

~*NumLock::
~*ScrollLock::
~*Insert::
{
    Sleep(10)
	thisHotkey := SubStr(A_ThisHotkey, 3)
	Notify.Show(thisHotkey ' ' (GetKeyState(thisHotkey, 'T') ? 'ON' : 'OFF'),,,,, 'theme=synthwave style=edge pos=bl dur=3 ts=35 show=none hide=none dg=5 tag=' thisHotkey)
}

~*CapsLock::
{
	Sleep(10)
	thisHotkey := SubStr(A_ThisHotkey, 3)
	Notify.Destroy(thisHotkey)

	if GetKeyState(thisHotkey, 'T')
		Notify.Show(thisHotkey ' ON',,,,, 'theme=matrix pos=bl dur=0 ts=35 dgc=0 tag=' thisHotkey)
}