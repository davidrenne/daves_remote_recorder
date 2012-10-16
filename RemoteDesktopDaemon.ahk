#SingleInstance,Force
#Persistent
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
Menu, Tray, NoDefault
Menu, Tray, NoStandard
Menu, Tray, Add, S&tart Recording, StartRecordingLabel
Menu, Tray, Add, E&xit, GuiClose
Loop, %A_ScriptDir%\RecordedScripts\*rdr
{
	theFile = %A_LoopFileFullPath%
	StringReplace, theFile, theFile, %A_ScriptDir%\RecordedScripts\, , All
	IniRead, hotKeyMapping,  Recorder.ini, hot_keys, %theFile%
	if (hotKeyMapping <> "ERROR") {
		Hotkey, %hotKeyMapping%, RunHotKey
	}
}

Loop, %A_ScriptDir%\RecordedScripts\*exe, , 1  ; Recurse into subfolders.
{
	theFile = %A_LoopFileFullPath%
	StringReplace, theFile, theFile, %A_ScriptDir%\RecordedScripts\, , All
	IniRead, hotKeyMapping,  Recorder.ini, hot_keys, %theFile%
	if (hotKeyMapping <> "ERROR") {
		Hotkey, %hotKeyMapping%, RunHotKey
	}
}

RunHotKey:
	theKeyKeyPressed = %A_ThisHotkey%
	if (theKeyKeyPressed <> "") {
		IniRead, ScriptSelection, Recorder.ini, script_name_by_hotkey, %A_ThisHotkey%
		if (ScriptSelection <> "ERROR" And ScriptSelection <> "Unassigned") {
					
			MsgBox, 1, , Now Executing "%ScriptSelection%"...Press OK To Continue
			IfMsgBox No
				return
				
			if InStr(ScriptSelection, "exe") {
				Run, %A_ScriptDir%\RecordedScripts\%ScriptSelection%
			}

			if InStr(ScriptSelection, "rdr") {
				Run, %A_ScriptDir%\RemoteDesktopRecorder.exe "%ScriptSelection%" "RUNFROMHOTKEY"
			}
		}
	}
Return

!r::
  Run, %A_ScriptDir%\RemoteDesktopRecorder.exe
Return


StartRecordingLabel:
	Run, StartRecording.exe
Return


GuiClose:
	MsgBox, 4, , Do you want to continue exiting?  All hot key mappings will be unavailable...
	IfMsgBox No
		return

	ExitApp
Return

