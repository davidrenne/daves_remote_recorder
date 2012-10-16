#SingleInstance,Force
#Persistent
isEditingHotKey = 0
Menu, Tray, NoDefault
Menu, Tray, NoStandard
Menu, Tray, Add, E&xit, GuiClose
Goto, ShowForm


ShowForm:
	RegRead, InstallLocation, HKEY_CURRENT_USER, SOFTWARE\RemoteDesktopRecorder,
	isEditingHotKey = 0
	Filenames :=
	Gui, Add, GroupBox, x16 y104 w420 h110 , Select the type of Script To Record
	Gui, Add, GroupBox, x226 y124 w-40 h-40 , Editor options
	Gui, Add, Button, x306 y154 w120 h40 , Begin Recording
	IfExist, %InstallLocation%\RemoteDesktopRecorderLogo.gif
		Gui, Add, Picture, x16 y4 w420 h90 , %InstallLocation%\RemoteDesktopRecorderLogo.gif
	Gui, Add, Text, x26 y124 w80 h20 , Name of Script
	Gui, Add, Text, x26 y234 w80 h20 , Name of Script
	Gui, Add, Edit, x106 y124 w320 h20 vNameScript, Script %A_MM%-%A_DD%-%A_YYYY% %A_Hour%-%A_Min%
	Gui, Add, Button, x306 y264 w120 h40 , Assign Local Hotkey
	Gui, Add, Button, x106 y264 w140 h40 , Playback Script
	Gui, Add, GroupBox, x16 y214 w420 h100 , Or Playback/Assign Hotkey For Script
	Loop, %A_ScriptDir%\RecordedScripts\*rdr
	{
		theFile = %A_LoopFileFullPath%
		StringReplace, theFile, theFile, %A_ScriptDir%\RecordedScripts\, , All
		IniRead, hotKeyMapping,  Recorder.ini, hot_keys, %theFile%
		if (hotKeyMapping <> "ERROR") {
			Gosub, TranslateHotKey
			theFile = %theFile% (%hotKeyMapping%)
		}
		Filenames = %Filenames%%theFile%|
	}
	Loop, %A_ScriptDir%\RecordedScripts\*exe, , 1  ; Recurse into subfolders.
	{
		theFile = %A_LoopFileFullPath%
		StringReplace, theFile, theFile, %A_ScriptDir%\RecordedScripts\, , All
		IniRead, hotKeyMapping,  Recorder.ini, hot_keys, %theFile%
		if (hotKeyMapping <> "ERROR") {
			Gosub, TranslateHotKey
			theFile = %theFile% (%hotKeyMapping%)
		}
		Filenames = %Filenames%%theFile%|
	}
	Gui, Add, ComboBox, x106 y234 w320 h10 r100000 vScriptSelection, %Filenames%
	Gui, Show,  x503 y246 h343 w453, Remote Desktop Recording Start
Return

TranslateHotKey:
	StringReplace, hotKeyMapping, hotKeyMapping, `+, `Shift`+ , , All
	StringReplace, hotKeyMapping, hotKeyMapping, `^, `Ctrl`+ , , All
	StringReplace, hotKeyMapping, hotKeyMapping, `!, `Alt`+ , , All
Return

ButtonPlaybackScript:
	Gui, Submit, Hide
	Gui, Destroy
	if (ScriptSelection == "") {
		MsgBox  Please select a script to run
		Goto, ShowForm
		Return
	}
	GoSub, StripHotKeyParenths
	if InStr(ScriptSelection, "exe") {
		Run, %A_ScriptDir%\RecordedScripts\%ScriptSelection%
		ExitApp
	}
	if InStr(ScriptSelection, "rdr") {
		Run, %A_ScriptDir%\RemoteDesktopRecorder.exe "%ScriptSelection%"
		ExitApp
	}
Return

ButtonAssignLocalHotkey:
	isEditingHotKey = 1
	Gui, Submit, Hide
	Gui, Destroy
	if (ScriptSelection == "") {
		MsgBox  Please select a script to edit hot key for
		Goto, ShowForm
		Return
	}
	GoSub, StripHotKeyParenths
	
	IniRead, hotKeyMapping,  Recorder.ini, hot_keys, %ScriptSelection%
	if (hotKeyMapping <> "ERROR") {
		hot = %hotKeyMapping%
		isEditing=1
		originalHotKey = %hotKeyMapping%
	} else {
		isEditing=0
		hot :=
	}
	;Gui, Add, Hotkey, vgui_start xp+40 yp-2 Limit1 gHotkey, %gui_start%	
	Gui, Add, Hotkey, vthe_key x76 y54 w130 h20 , %hot%
	Gui, Add, Text, x6 y54 w70 h20 , Hey Key:
	Gui, Add, Text, x6 y14 w70 h20 , Script:
	Gui, Add, Button, x76 y84 w100 h30 , Assign
	Gui, Add, Text, x76 y14 w140 h20 , %ScriptSelection%
	; Generated using SmartGUI Creator 4.0
	Gui, Show, x551 y391 h128 w282, Assign A Hot Key
Return

StripHotKeyParenths:
	if (InStr(ScriptSelection,"(" ) ) {
		StringGetPos, pos, ScriptSelection, `(
		ScriptSelection := SubStr(ScriptSelection,1,pos)
	}
Return

ButtonAssign:
	Gui, Submit
	IniWrite, %the_key%, Recorder.ini, hot_keys, %ScriptSelection%
	IniWrite, %ScriptSelection%, Recorder.ini, script_name_by_hotkey, %the_key%
	if (isEditing = 1) {
		IniWrite, Unassigned, Recorder.ini, script_name_by_hotkey, %originalHotKey%
	}
	Gui, Destroy
	Run, RemoteDesktopDaemon.exe
	Goto, ShowForm
Return

GuiClose:
	if (isEditingHotKey = 1) {
		isEditingHotKey = 0
		Gui, Submit, Hide
		Gui, Destroy
		Goto, ShowForm
		Return
	} else {
		ExitApp
	}
Return

ButtonBeginRecording:   ; RECORD
	Gui, Submit, Hide
	Gui, Destroy
	if (NameScript == "") {
		MsgBox  Please enter a script name
		Goto, ShowForm
		Return
	}

	StringReplace, NameScript, NameScript, `(, , All
	options = %TitleMatch%-
	Run, %A_ScriptDir%\RemoteDesktopRecorder.exe "" "%NameScript%" "%options%"
	ExitApp

Return