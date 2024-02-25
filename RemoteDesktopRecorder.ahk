#WinActivateForce
#SingleInstance,Force
#Persistent
SetTitleMatchMode 2
StringReplace, endrecord, record, }, %A_Space%Down}
StringLen, length, endrecord
Menu, Tray, Icon, record.ico



typeOfExecution = %1%
typeOfExecutionOriginal = %1%
Title :=
finalEXEPath :=
isDifferentEXE := 1
startButton :=0
sentWindowError = 0
scriptName = %2%
scriptNameOriginal = %2%
readyToRecord = 0
recording   = 0
playback   = 0
is_paused   = 0
xpos_old  = 0
ypos_old  = 0
lButt_old = 0
mButt_old = 0
rButt_old = 0
xpos  = 1
ypos  = 1
lButt = 1
mButt = 1
rButt = 1
matchTitle = 1
opts = %3%
SetTitleMatchMode, Fast
SetBatchLines, -1
PID := DllCall("GetCurrentProcessId")
AutoTrim, Off
CoordMode, Mouse, Relative
modifiers =LCTRL,RCTRL,LALT,RALT,LSHIFT,RSHIFT,LWIN,RWIN,LButton,RButton,MButton,XButton1,XButton2
recording = 0
playing = 0
isRePlaying = 0
SendFlag = 0		;Flag for keyboard-recording
ControlSendFlag = 0	;Flag for special record-mode
Stop := ""
SelectedExe := ""
ExeHold := ""
IsTyping = 0
File := A_Temp . "\TempPlay.ahk"  
ScriptHold := ""
VersionMark := ASWv02



if (opts <> "") 
{
	StringSplit, options, opts,-
	matchTitle = %options1%
}

if (scriptName == "") 
{
	scriptName = Script %A_MM%-%A_DD%-%A_YYYY% %A_Hour% %A_Min% %A_Sec%
}

;;;SETUP MENU TRAYS;;;

Menu, Tray, NoDefault
Menu, Tray, NoStandard
Menu, Tray, Add, &Record, Start
Menu, Tray, Add, &Stop, Stop
Menu, Tray, Add, Play&back, ReplayProd
Menu, Tray, Add, E&xit, ButtonExit



Transform, CtrlA, Chr, 1
Transform, CtrlB, Chr, 2
Transform, CtrlC, Chr, 3
Transform, CtrlD, Chr, 4
Transform, CtrlE, Chr, 5
Transform, CtrlF, Chr, 6
Transform, CtrlG, Chr, 7
Transform, CtrlH, Chr, 8
Transform, CtrlI, Chr, 9
Transform, CtrlJ, Chr, 10
Transform, CtrlK, Chr, 11
Transform, CtrlL, Chr, 12
Transform, CtrlM, Chr, 13
Transform, CtrlN, Chr, 14
Transform, CtrlO, Chr, 15
Transform, CtrlP, Chr, 16
Transform, CtrlQ, Chr, 17
Transform, CtrlR, Chr, 18
Transform, CtrlS, Chr, 19
Transform, CtrlT, Chr, 20
Transform, CtrlU, Chr, 21
Transform, CtrlV, Chr, 22
Transform, CtrlW, Chr, 23
Transform, CtrlX, Chr, 24
Transform, CtrlY, Chr, 25
Transform, CtrlZ, Chr, 26

StringReplace, scriptName, scriptName, `(, , All

if (typeOfExecution != "") 
{
	scriptName = %typeOfExecution%
	If (Not InStr(scriptName,"\")) 
	{
		ExecutingFromHotKey = 1
		StringReplace, scriptName, scriptName, .rdr, , All
	}
	Gosub, ReplayProd
}

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
CoordMode, Mouse, Screen
SetBatchLines, -1

if (debug = 1) 
{
	Gosub, ReplayProd
} 
else 
{
	GoSub, Start
}


GoSub, InitStyle

~WheelDown::Wheel_down += A_EventInfo
~Wheelup::Wheel_up += A_EventInfo

^+p::
  Gosub, ReplayProd
Return


^+r::
  GoSub, Start
Return

F8::
  GoSub, ButtonClickToStopOrPress(F8)
return


^+s::
  GoSub, Stop
return



WatchKeyboard:
	Time_Index := A_TickCount - Time_old
	Input, OutputVar,L1 M B V, {BackSpace}{Space}{WheelDown}{WheelUp}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}{ENTER}{ESCAPE}{TAB}{DELETE}{INSERT}{UP}{DOWN}{LEFT}{RIGHT}{HOME}{END}{PGUP}{PGDN}{CapsLock}{ScrollLock}{NumLock}{APPSKEY}{SLEEP}{Numpad0}{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{NumpadDot}{NumpadEnter}{NumpadMult}{NumpadDiv}{NumpadAdd}{NumpadSub}{NumpadDel}{NumpadIns}{NumpadClear}{NumpadUp}{NumpadDown}{NumpadLeft}{NumpadRight}{NumpadHome}{NumpadEnd}{NumpadPgUp}{NumpadPgDn}{BROWSER_BACK}{BROWSER_FORWARD}{BROWSER_REFRESH}{BROWSER_STOP}{BROWSER_SEARCH}{BROWSER_FAVORITES}{BROWSER_HOME}{VOLUME_MUTE}{VOLUME_DOWN}{VOLUME_UP}{MEDIA_NEXT}{MEDIA_PREV}{MEDIA_STOP}{MEDIA_PLAY_PAUSE}{LAUNCH_MAIL}{LAUNCH_MEDIA}{LAUNCH_APP1}{LAUNCH_APP2}{PRINTSCREEN}{CTRLBREAK}{PAUSE}


	If (Errorlevel = "Timeout") 
	{
			
	} 
	else if (Errorlevel <> "Timeout" && Not InStr(Errorlevel,"EndKey")) 
	{
		If (OutputVar<> "")
		{
			keyPress = ""
			if OutputVar = Tab
				keyPress = {Tab}
			if OutputVar = Enter
				keyPress = {ENTER}
			if OutputVar = Space
				keyPress = {SPACE}
			if OutputVar = %keyESC%
				keyPress = {ESC}
			if OutputVar = %CtrlA%
				keyPress = {CtrlDown}a{CtrlUp}
			if OutputVar = %CtrlB%
				keyPress = {CtrlDown}b{CtrlUp} 
			if OutputVar = %CtrlC%
				keyPress = {CtrlDown}c{CtrlUp} 
			if OutputVar = %CtrlD%
				keyPress = {CtrlDown}d{CtrlUp} 
			if OutputVar = %CtrlE%
				keyPress = {CtrlDown}e{CtrlUp} 
			if OutputVar = %CtrlF%
				keyPress = {CtrlDown}f{CtrlUp} 
			if OutputVar = %CtrlG%
				keyPress = {CtrlDown}g{CtrlUp} 
			if OutputVar = %CtrlH%
				keyPress = {CtrlDown}h{CtrlUp} 
			if OutputVar = %CtrlI%
				keyPress = {CtrlDown}i{CtrlUp} 
			if OutputVar = %CtrlJ%
				keyPress = {CtrlDown}j{CtrlUp} 
			if OutputVar = %CtrlL%
				keyPress = {CtrlDown}l{CtrlUp} 
			if OutputVar = %CtrlM%
				keyPress = {CtrlDown}m{CtrlUp} 
			if OutputVar = %CtrlN%
				keyPress = {CtrlDown}n{CtrlUp} 
			if OutputVar = %CtrlO%
				keyPress = {CtrlDown}o{CtrlUp}
			if OutputVar = %CtrlP%
				keyPress = {CtrlDown}p{CtrlUp} 
			if OutputVar = %CtrlQ%
				keyPress = {CtrlDown}q{CtrlUp} 
			if OutputVar = %CtrlR%
				keyPress = {CtrlDown}r{CtrlUp} 
			if OutputVar = %CtrlS%
				keyPress = {CtrlDown}s{CtrlUp}  
			if OutputVar = %CtrlT%
				keyPress = {CtrlDown}t{CtrlUp}  
			if OutputVar = %CtrlU%
				keyPress = {CtrlDown}u{CtrlUp} 
			if OutputVar = %CtrlV%
				keyPress = {CtrlDown}v{CtrlUp} 
			if OutputVar = %CtrlW%
				keyPress = {CtrlDown}w{CtrlUp} 
			if OutputVar = %CtrlX%
				keyPress = {CtrlDown}x{CtrlUp} 
			if OutputVar = %CtrlY%
				keyPress = {CtrlDown}y{CtrlUp} 
			if OutputVar = %CtrlZ%
				keyPress = {CtrlDown}z{CtrlUp}
				
			GetKeyState, state, LWin
			if state = D
				isWinKeyDown = 1
			else
				isWinKeyDown = 0
			GetKeyState, state, LAlt
			if state = D
				isAltKeyDown = 1
			else
				isAltKeyDown = 0
				
			GetKeyState, state, LShift
			if state = D
				isShiftKeyDown = 1
			else
				isShiftKeyDown = 0
				
			if keypress = ""
				keyPress = %OutputVar%
				
			
			if (isAltKeyDown=1)
			{
				keyPress = {AltDown}%keyPress%{AltUp}
			}
		
			if (isWinKeyDown=1)
			{
				keyPress = {LWinDown}%keyPress%{LWinUp}
			}
		
			if (isShiftKeyDown=1)
			{
				keyPress = {ShiftDown}%keyPress%{ShiftUp}
			}
			isWinKeyDown = 0
			isAltKeyDown = 0
			isShiftKeyDown = 0
			IsTyping = 1
		}	
	} 
	Else 
	{
		keyPress = ""
		StringReplace newString,Errorlevel,EndKey:,,1
		keyPress = {%newString%}
		GetKeyState, state, LWin
		if state = D
			isWinKeyDown = 1
		else
			isWinKeyDown = 0
			
		GetKeyState, state, LAlt
		if state = D
			isAltKeyDown = 1
		else
			isAltKeyDown = 0
			
		GetKeyState, state, LShift
		if state = D
			isShiftKeyDown = 1
		else
			isShiftKeyDown = 0	
			
		GetKeyState, state, LCtrl
		if state = D
			isControlKeyDown = 1
		else
			isControlKeyDown = 0	
			
		
		if (isAltKeyDown=1)
		{
			keyPress = {AltDown}%keyPress%{AltUp}
		}
	
		if (isWinKeyDown=1)
		{
			keyPress = {LWinDown}%keyPress%{LWinUp}
		}
	
		if (isShiftKeyDown=1)
		{
			keyPress = {ShiftDown}%keyPress%{ShiftUp}
		}
	
		if (isControlKeyDown=1)
		{
			keyPress = {CtrlDown}%keyPress%{CtrlUp}
		}
	
		isWinKeyDown = 0
		isAltKeyDown = 0
		isShiftKeyDown = 0
		isControlKeyDown = 0
		IsTyping = 1
	}
  
  
  
	If(IsTyping = 1)
	{
		;translate special keys
		if (keyPress == "|" || keyPress == "{ShiftDown}|{ShiftUp}") 
		{
			keyPress = {ShiftDown}\{ShiftUp}
		}

		if (keyPress == "^" || keyPress == "{ShiftDown}^{ShiftUp}") 
		{
			keyPress = {ShiftDown}6{ShiftUp}
		}
	
		if (keyPress == "{" || keyPress == "{ShiftDown}{{ShiftUp}") 
		{
			keyPress = {ShiftDown}[{ShiftUp}
		}
	
		if (keyPress == "}" || keyPress == "{ShiftDown}}{ShiftUp}") 
		{
			keyPress = {ShiftDown}]{ShiftUp}
		}
	
		if (keyPress == "`!" || keyPress == "{ShiftDown}`!{ShiftUp}") 
		{
			keyPress = {ShiftDown}1{ShiftUp}
		}
	
		if (keyPress == "`@" || keyPress == "{ShiftDown}`@{ShiftUp}") 
		{
			keyPress = {ShiftDown}2{ShiftUp}
		}
	
		if (keyPress == "`#" || keyPress == "{ShiftDown}`#{ShiftUp}") 
		{
			keyPress = {ShiftDown}3{ShiftUp}
		}
	
		if (keyPress == "=" || keyPress == "{ShiftDown}={ShiftUp}") 
		{
			keyPress = `=
		}
	
		if (keyPress == "-" || keyPress == "{ShiftDown}-{ShiftUp}") 
		{
			keyPress = `-
		}
	
		if (keyPress == "`+" || keyPress == "{ShiftDown}+{ShiftUp}") 
		{
			keyPress = {ShiftDown}`={ShiftUp}
		}
		localfinalEXEPath := finalEXEPath
		WinGetTitle, tit, A
		Mouse_Data = KEY|KEY|%keyPress%|KEY|KEY|KEY|KEY|KEY|%Time_Index%|%tit%|%localfinalEXEPath%`n
		GoSub, AppendMouseToTemp
	}
	Gosub, DebugMouse
Return


MaximizeWindows:
	WinGet, style, Style, ahk_id %ID%
	If (style & 0x40000)
	{
		WinMaximize, ahk_id %ID%
	}
Return



DebugMouse:
	;ToolTip, %Mouse_Data% 
Return



WatchMouse:
	Time_Index := A_TickCount - Time_old
	MouseGetPos, xpos, ypos, id, Control
	GetKeyState, lButt, LButton
	GetKeyState, mButt, MButton
	GetKeyState, rButt, RButton
	WinGetTitle, active_title, A
	If ( (rButt = "D" Or mButt = "D" Or lButt = "D") OR (xpos<>xpos_old OR ypos<>ypos_old OR Wheel_up OR Wheel_down OR lButt<>Lbutt_old OR mButt<>mButt_old OR rButt<>rButt_old) And ((xpos<>1 AND ypos<>1 AND lButt<>1 AND mButt<>1 AND rButt<>1)) )
	{
		IsTyping = 0
		if (Time_Index <> 0 ) 
		{
			
			WinGetTitle, this_title, ahk_id %ID%
			if (this_title == active_title) 
			{
				windowID = %ID%
			} 
			else 
			{
				windowID = SAME
			}
			
			localfinalEXEPath := finalEXEPath
			Mouse_Data = %xpos%|%ypos%|%lButt%|%mButt%|%rButt%|%Wheel_up%|%Wheel_down%|%windowID%|%Time_Index%|%active_title%|%localfinalEXEPath%`n

			if (active_title = "Start Menu" And startButton = 0) 
			{
				startButton = 1
				keyPress = {LWin}
				Mouse_Data = %Mouse_Data%KEY|KEY|%keyPress%|KEY|KEY|KEY|KEY|KEY|%Time_Index%|%tit%|%localfinalEXEPath%`n
			}
		}
		GoSub, AppendMouseToTemp
		xpos_old  := xpos
		ypos_old  := ypos
		lButt_old := lButt
		mButt_old := mButt
		rButt_old := rButt
		Wheel_up =
		Wheel_down =
	} 
	else 
	{
		if (active_title = "Start Menu" And startButton = 0) 
		{
			startButton = 1
			keyPress = {LWin}
			Mouse_Data = KEY|KEY|%keyPress%|KEY|KEY|KEY|KEY|KEY|%Time_Index%|%tit%|%localfinalEXEPath%`n
			GoSub, AppendMouseToTemp
		}
	}
	Gosub, DebugMouse
Return



AppendMouseToTemp:
	FileAppend, %Mouse_data%, RecordedScripts\Temp\%scriptName%.rdr
Return



Stop:
	if (recording == 1)
	{
		recording = 0
		Gui, Destroy
		SetTimer, WatchMouse, Off
		SetTimer, WatchKeyboard, Off
		SetTimer, GetCurrentlyInFocusExe, Off
		SetTimer, MaximizeWindows, Off
		Mouse_Data = END|END|END|END|END|END|END|END|END`n
		GoSub, AppendMouseToTemp
		TrayTip, RemoteDesktop, Remote Desktop Recorder is done recording
		Gosub, DoneRecording
	} 
	else 
	{
		if (is_paused = 0) 
		{
			SetTimer, ReplayScript, Off
			SetTimer, ReplayScript, 0
			Menu, Tray, Standard
			TrayTip, RemoteDesktop, Script Paused.  Please resume by going to system tray or exit if you are finished.
;~ 			;*Msgbox Script Paused.  Please resume by going to system tray or exit if you are finished.
			Pause
		}
	}
Return




Start:
	if (recording == 0 && playback == 0) 
	{
		readyToRecord = 0
		recording = 1
		GoSub, EnsureDirectoriesExist
		FileDelete, RecordedScripts\Temp\%scriptName%.rdr
		IniRead, OutputVar,  Recorder.ini, configuration, show_exe_popup
		
		if (scriptNameOriginal <> "")
		{
			ButtonSelected:=CMsgbox("Minimize Desktop?","Minimize Desktop?  Or Begin recording on current window?","Stay On Window|Minimize To Desktop", 350, 100)
			if (ButtonSelected == "Minimize Desktop") 
			{
				Mouse_data :=
				Mouse_Data = MIN|MIN|MIN|MIN|MIN|MIN|MIN|MIN|EXE`n
				GoSub, AppendMouseToTemp
				WinMinimizeAll
			}
		}
		Gosub, Record
	}
Return



Record:
	Gui, Destroy
	Gosub, ShowGUI2
	WinActivate , %Title%
	Mouse_data :=
	if (SelectedExe <> "") 
	{
		Mouse_Data = EXE|EXE|%SelectedExe%|EXE|EXE|EXE|EXE|EXE|EXE`n
		GoSub, AppendMouseToTemp
	}

	TrayTip, RemoteDesktop, Remote Desktop Recorder is recording your mouse and keyboard (F8 to stop recording)
	Mouse_moves = 
	Wheel_up =
	Wheel_down =
	Time_old := A_TickCount
	Process, Priority, %PID%, High	  ;Sets Priority to high, but may cause trouble on older and slower computers
	
	;poll every 10 seconds for EXE of current window
	SetTimer, GetCurrentlyInFocusExe, Off
	SetTimer, GetCurrentlyInFocusExe, 20
	SetTimer, GetCurrentlyInFocusExe, on
	SetTimer, MaximizeWindows, Off
	SetTimer, MaximizeWindows, 1000
	SetTimer, MaximizeWindows, on
	SetTimer, WatchMouse, Off
	SetTimer, WatchMouse, 20
	SetTimer, WatchMouse, on
	SetTimer, WatchKeyboard, Off
	SetTimer, WatchKeyboard, 0
	SetTimer, WatchKeyboard, on
Return




ShowGUI2: ; Creates little STOP button in upper left hand corner
	Gui, font, s10 w700, Arial
	Gui, Add, Button, w80 h60, &Click To Stop Or Press (F8)
	Gui, +AlwaysOnTop -SysMenu +Owner -Border
	;Gui, Color, EEAA99
	WinSet, TransColor, EEAA99
	Gui, Show, x400 y0 NoActivate NA, ASWv02
	if (Title <> "") 
	{
		WinActivate , %Title%
	}
Return



ButtonPLEASEOPENUPYOURPROGRAMSTOTHEIRINITIALSTATETHENPRESSTHE"F5"OR"S"KEYTOSTARTRECORDING:
	msgbox, Please Press the "s" key or "f5" to start recording
Return

ShowGUI3: ; Creates little STOP button in upper left hand corner
	Gui, font, s10 w700, Arial
	Gui, Add, Button, w900 h20, PLEASE OPEN UP YOUR PROGRAMS TO THEIR INITIAL STATE THEN PRESS THE "F5" OR "S" KEY TO START RECORDING
	Gui, +AlwaysOnTop -SysMenu +Owner -Border
	Gui, Color, EEAA99
	Gui, +Lastfound ; Make the GUI window the last found window. 
	WinSet, TransColor, EEAA99 
	Gui, Show, x300 y0, ASWv02 
Return



ShowGUI1: ; GUI that is launched from Traymenu 
	Gui, font, s9
	Gui, Add, Text, x96 y7 w420 h50 , Initiate the following 'Run' line upon Record
	Gui, Add, Edit, x106 y27 w340 h20 , 
	Gui, Add, Button, x6 y149 w80 h39 , &Save
	Gui, Add, Button, x7 y208 w79 h40 , E&xit
	Gui, Add, Button, x456 y27 w50 h20 , &Browse
	Gui, Add, GroupBox, x96 y7 w420 h50 , Initiate the following 'Run' line upon Record
	Gui, Add, Edit, x96 y57 w420 h250 vScriptEdit, 
	Gui, Add, ComboBox, x-25 y-81 w41 h89 +Menu, ComboBox
	Gui, font, s12
	Gui, Add, Button, x6 y87 w80 h40 , &Play
	Gui, font, s12, MS sans serif
	Gui, Add, Button, x6 y8 w80 h59 , &Record
	Gui, font, s10 w700, Arial
	;Gui, Add, Checkbox, x96 y316 w100 h20 vToolTipOption gToolTipShow, ToolTip
	Gui, Show, x230 y182 h360 w528, Remote Desktop Recorder
Return



EnsureDirectoriesExist:
	FileCreateDir, %A_ScriptDir%\RecordedScripts\Temp
Return



DoneRecording:
	Text="Script Recording Complete, Please either Discard the script or Replay/Test."
	If (isRePlaying == 1) 
	{
		;Replay Again
		Buttons:="*Just Save It|Discard Recording"
	} 
	else 
	{
		Buttons:="*Just Save It|Replay|Discard Recording"
	}
	ButtonSelected:=CMsgbox("Recording Complete!",Text,Buttons, 350, 100)
	if (ButtonSelected == "Replay" Or ButtonSelected == "Replay Again") 
	{
		isRePlaying = 1
		recording = 0
		playback = 0
		Mouse_Data :=
		GoSub, ReadTempScript
		Gosub, Replay
	}

	if (ButtonSelected == "Just Save It") 
	{
		GoSub, EnsureDirectoriesExist
		InputBox, UserInput, Rename Script, Rename your script if you want..., , , , , , , ,%scriptName%
		if (ErrorLevel)
		{
			UserInput = scriptName
		}
		FileMove, RecordedScripts\Temp\%scriptName%.rdr, RecordedScripts\%UserInput%.rdr
		Mouse_Data :=
		Gosub, whatsNext
	}

	if (ButtonSelected == "Discard Recording") 
	{
		FileDelete, RecordedScripts\Temp\%scriptName%.rdr
		Mouse_Data :=
		Gosub, whatsNext
	}

Return

whatsNext:
	Run, StartRecording.exe
	ExitApp
Return

;******************************************

ReadTempScript:
	FileRead, Mouse_moves, RecordedScripts\Temp\%scriptName%.rdr
Return

ReadScript:
	FileRead, Mouse_moves, RecordedScripts\%scriptName%.rdr
	if (ErrorLevel)
	{
		MsgBox An Error Occured, this script will not be executed
		Run, StartRecording.exe
		ExitApp
	}
Return

ReadScriptOther:
	FileRead, Mouse_moves, %scriptName%
	if (ErrorLevel)
	{
		MsgBox An Error Occured, this script will not be executed
		Run, StartRecording.exe
		ExitApp
	}
Return


ReplayProd:
	If (InStr(scriptName,"\")) 
	{
		Gosub, ReadScriptOther
	} 
	else 
	{
		Gosub, ReadScript	
	}
	Gosub, Replay
Return

;******************************************

Replay:
	if (recording == 0 && playback == 0) 
	{
		playback = 1
		TrayTip, RemoteDesktop, Remote Desktop Recorder is playing back script %scriptName% press F8 to stop
		StringReplace, Mouse_data_Tmp, Mouse_moves, `n, @, All
		StringSplit, Mouse_data_, Mouse_data_Tmp , @
		Loop, %Mouse_data_0%
		  StringSplit, Mouse_data_%A_Index%_, Mouse_data_%A_Index% ,|
		Data_Index = 1
		Data_Index_old := 1
		id := Mouse_data_1_8
		WinActivate, ahk_id %id%
		Time_old := A_TickCount
		Process, Priority, %PID%, High	  ;Sets Priority to high, but may cause trouble on older and slower computers
		SetTimer, ReplayScript, Off
		SetTimer, ReplayScript, 0
		SetTimer, ReplayScript, on
		SetTimer, MaximizeWindows, Off
		SetTimer, MaximizeWindows, 5000
		SetTimer, MaximizeWindows, on
		SetTimer, ReplayWindowFocus, Off
		SetTimer, ReplayWindowFocus, 1000
		SetTimer, ReplayWindowFocus, on
	}
Return

ReplayWindowFocus:
	WinActivate , %titleTmp%
	WinActivate, ahk_id %id%
Return

;***********************************

ReplayScript:

    ; Check if F8 is pressed to stop the script
    if GetKeyState("F8", "P")
    {
        SetTimer ReplayScript, Off
        SetTimer MaximizeWindows, Off
        SetTimer ReplayWindowFocus, Off
        If (isRePlaying == 1) 
        {
            Gosub, DoneRecording
        }
        playback = 0
        TrayTip, RemoteDesktop, Stopped playback via F8 keypress
        Return
    }
	Time_Index := A_TickCount - Time_old
	Mouse_data_%Data_Index%_9 += 0

	If (Time_Index > Mouse_data_%Data_Index%_9)
	{
		lButt := Mouse_data_%Data_Index%_3
		mButt := Mouse_data_%Data_Index%_4
		rButt := Mouse_data_%Data_Index%_5
		wheel_up := Mouse_data_%Data_Index%_6
		wheel_down := Mouse_data_%Data_Index%_7
		
		titleTmp := Mouse_data_%Data_Index%_10
		If (rButt == "KEY") 
		{
			Send, %lButt%
		} 
		else if (rButt == "EXE") 
		{
			StringLower, out, lButt
			If (InStr(out,".exe")) 
			{
				SplitPath, lButt, name
				Process, Exist, %name%
				If (ErrorLevel = 0)
				{
				    Run, %lButt%
				}
			} 
			else 
			{
				Run,  %lButt%
			}
		}  
		else if (rButt == "MIN") 
		{
			WinMinimizeAll
		} 
		else if (rButt == "END") 
		{
			SetTimer ReplayScript, Off
			SetTimer MaximizeWindows, Off
			SetTimer ReplayWindowFocus, Off
			If (isRePlaying == 1) 
			{
				Gosub, DoneRecording
			}
			playback = 0
			TrayTip, RemoteDesktop, Remote Desktop is done playing back %scriptName%
			if (typeOfExecution != "") 
			{
				if (ExecutingFromHotKey = 0) 
				{
					Run, StartRecording.exe
				}
				ExitApp
			}
		} 
		else 
		{	
			MouseMove, Mouse_data_%Data_Index%_1, Mouse_data_%Data_Index%_2
			If (Mouse_data_%Data_Index_old%_3 <> Mouse_data_%Data_Index%_3)
			  MouseClick , Left ,,,,, %lButt%
			If (Mouse_data_%Data_Index_old%_4 <> Mouse_data_%Data_Index%_4)
			  MouseClick , middle ,,,,, %mButt% 
			If (Mouse_data_%Data_Index_old%_5 <> Mouse_data_%Data_Index%_5 And Mouse_data_%Data_Index_old%_5 <> "EXE" And Mouse_data_%Data_Index_old%_5 <> "KEY" And Mouse_data_%Data_Index_old%_5 <> "WIN")
			{
			  ;msgbox  Mouse_data_%Data_Index%_5
			  MouseClick , Right ,,,,, %rButt%
			}
			If (Mouse_data_%Data_Index%_6)
			  MouseClick, WheelUp, , , %wheel_up%       
			If (Mouse_data_%Data_Index%_7)
			  MouseClick, Wheeldown, , , %wheel_down% 
			
			id := Mouse_data_%Data_Index%_8
			if (id <> "SAME") 
			{
				doesWinExist = 1
				IfWinNotExist, %titleTmp%
					doesWinExist = 0
			}
		}
	  
		Data_Index_old := Data_Index
		Data_Index += 1
		If (Data_Index = Mouse_data_0)
		{
		  SetTimer ReplayScript, Off
		  SetTimer MaximizeWindows, Off
		  SetTimer ReplayWindowFocus, Off
		  Data_Index = 0
		}
	}

Return

ButtonBrowse:
	FileSelectFile, SelectedExe, 3,, Select a program or file to run when this script replays
Gosub ExeShowBrowseEdit1

ExeShowBrowseEdit1:
    IfExist, %SelectedExe%
    	GuiControl,,Edit1,%SelectedExe%
ExeHold = %SelectedExe%  
return

ExeRunBrowseEdit1:

	IfEqual, ExeHold,
	{ 
		return
	} 

	IfNotEqual, ExeHold,
	{
		Run, %ExeHold%
		Sleep, 1000
		GuiControl,,Edit1,
	}   	
return


ButtonClickToStopOrPress(F8): ; Stops the recording
	
	if (recording == 1)
	{
		Gosub Stop
	}
Return 

ToolTipShow:
	Gui, Submit, NoHide
	TrayTip, RemoteDesktop, Remote Desktop Recorder is recording your mouse and keyboard (CTRL+SHIFT+ALT+S to stop recording)
Return


MouseClick:
	LButtonDownTime = %A_TickCount%
	MouseGetPos, XPos, YPos
	keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, `, `, %state%`n
return

;Set constants
InitStyle:
	;Borderstyles
	BS_PUSHBUTTON = 0x0
	BS_DEFPUSHBUTTON = 0x1
	BS_CHECKBOX = 0x2
	BS_AUTOCHECKBOX = 0x3
	BS_RADIOBUTTON = 0x4 
	BS_3STATE = 0x5
	BS_AUTO3STATE = 0x6
	BS_GROUPBOX = 0x7
	BS_AUTORADIOBUTTON = 0x9
	;BS_PUSHLIKE = 0x1000

	;Constants for retreive/set 3rd state of a checkbox
	BM_GETSTATE = 0xF2
	BST_UNCHECKED = 0x0
	BST_CHECKED = 0x1
	BST_INDETERMINATE = 0x2
	BM_SETCHECK = 0xF1
return

ExitRecorder:
	if (recording == 1) {
		;todo handle issues when they dont save their scripts
	} else {
		ExitApp
	}
Return

ButtonExit:
	GoSub, ExitRecorder
Return

GuiClose:
	GoSub, ExitRecorder
Return


GetCurrentlyInFocusExe:
   WinGet, ProcessID, PID, A
   success := DllCall( "advapi32.dll\LookupPrivilegeValueA"
                     , "uint", 0
                     , "str", "SeDebugPrivilege"
                     , "int64*", luid_SeDebugPrivilege )
   if ( ReportError( ErrorLevel or !success
               , "LookupPrivilegeValue: SeDebugPrivilege"
               , "success = " success ) )
      errorEXE = 1

   pid_this := ProcessID

   hp_this := DllCall( "OpenProcess"
                     , "uint", 0x400                                 ; PROCESS_QUERY_INFORMATION
                     , "int", false
                     , "uint", pid_this )
   if ( ReportError( ErrorLevel or hp_this = 0
               , "OpenProcess: pid_this"
               , "hp_this = " hp_this ) )
      errorEXE = 1

   success := DllCall( "advapi32.dll\OpenProcessToken"
                     , "uint", hp_this
                     , "uint", 0x20                                 ; TOKEN_ADJUST_PRIVILEGES
                     , "uint*", ht_this )
   if ( ReportError( ErrorLevel or !success
               , "OpenProcessToken: hp_this"
               , "success = " success ) )
      errorEXE = 1

   VarSetCapacity( token_info, 4+( 8+4 ), 0 )
      EncodeInteger( 1, 4, &token_info, 0 )
      EncodeInteger( luid_SeDebugPrivilege, 8, &token_info, 4 )
         EncodeInteger( 2, 4, &token_info, 12 )                           ; SE_PRIVILEGE_ENABLED

   success := DllCall( "advapi32.dll\AdjustTokenPrivileges"
                     , "uint", ht_this
                     , "int", false
                     , "uint", &token_info
                     , "uint", 0
                     , "uint", 0
                     , "uint", 0 )

   if ( ReportError( ErrorLevel or !success
               , "AdjustTokenPrivileges: ht_this; SeDebugPrivilege ~ SE_PRIVILEGE_ENABLED"
               , "success = " success ) )
      errorEXE = 1
      
   finalEXEPathTmp := GetModuleFileNameEx( pid_this )

   if (finalEXEPathTmp = finalEXEPath) 
   {
       isDifferentEXE = 0
   }
   Else
   {
	   isDifferentEXE = 1
   }
   
   finalEXEPath := finalEXEPathTmp
   
   If (InStr(finalEXEPath,"AutoHot")) {
	  isDifferentEXE := 1
	  finalEXEPath := SAME
   }
;~    if (finalEXEPath <> "") {
;~       return %finalEXEPath%
;~    } else {
;~       return 1
;~    }
Return


HandleExit:
   DllCall( "CloseHandle", "uint", ht_this )
   DllCall( "CloseHandle", "uint", hp_this )
ExitApp

EncodeInteger( p_value, p_size, p_address, p_offset )
{
   loop, %p_size%
      DllCall( "RtlFillMemory", "uint", p_address+p_offset+A_Index-1, "uint", 1, "uchar", p_value >> ( 8*( A_Index-1 ) ) )
}

ReportError( p_condition, p_title, p_extra )
{
   
   return, p_condition
}

EnumProcesses( byref r_pid_list )
{
   
   pid_list_size := 4*1000
   VarSetCapacity( pid_list, pid_list_size )
   
   status := DllCall( "psapi.dll\EnumProcesses", "uint", &pid_list, "uint", pid_list_size, "uint*", pid_list_actual )
   if ( ErrorLevel or !status )
      return, false
      
   total := pid_list_actual//4

   r_pid_list=
   address := &pid_list
   loop, %total%
   {
      r_pid_list := r_pid_list "|" ( *( address )+( *( address+1 ) << 8 )+( *( address+2 ) << 16 )+( *( address+3 ) << 24 ) )
      address += 4
   }
   
   StringTrimLeft, r_pid_list, r_pid_list, 1
   
   return, total
}

GetModuleFileNameEx( p_pid )
{

   h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )
   if ( ErrorLevel or h_process = 0 )
      return
   
   name_size = 255
   VarSetCapacity( name, name_size )
   
   result := DllCall( "psapi.dll\GetModuleFileNameExA", "uint", h_process, "uint", 0, "str", name, "uint", name_size )
   
   DllCall( "CloseHandle", "uint", h_process ) ; Corrected by Moderator! 2010-03-16
   
   return, name
}

GetRemoteCommandLine( p_pid_target )
{
   hp_target := DllCall( "OpenProcess"
                     , "uint", 0x10                              ; PROCESS_VM_READ
                     , "int", false
                     , "uint", p_pid_target )
   if ( ErrorLevel or hp_target = 0 )
   {
      result = < error: OpenProcess > EL = %ErrorLevel%, LE = %A_LastError%, hp_target = %hp_target%
      Gosub, returnProcess
   }

   hm_kernel32 := DllCall( "GetModuleHandle", "str", "kernel32.dll" )

   pGetCommandLineA := DllCall( "GetProcAddress", "uint", hm_kernel32, "str", "GetCommandLineA" )

   buffer_size = 6
   VarSetCapacity( buffer, buffer_size )

   success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pGetCommandLineA, "uint", &buffer, "uint", buffer_size, "uint", 0 )
   if ( ErrorLevel or !success )
   {
      result = < error: ReadProcessMemory 1 > EL = %ErrorLevel%, LE = %A_LastError%, success = %success%
      Gosub, returnProcess
   }

   loop, 4
      ppCommandLine += ( ( *( &buffer+A_Index ) ) << ( 8*( A_Index-1 ) ) )
   
   buffer_size = 4
   VarSetCapacity( buffer, buffer_size, 0 )

   success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", ppCommandLine, "uint", &buffer, "uint", buffer_size, "uint", 0 )
   if ( ErrorLevel or !success )
   {
      result = < error: ReadProcessMemory 2 > EL = %ErrorLevel%, LE = %A_LastError%, success = %success%
      Gosub, returnProcess
   }

   loop, 4
      pCommandLine += ( ( *( &buffer+A_Index-1 ) ) << ( 8*( A_Index-1 ) ) )

   buffer_size = 32768
   VarSetCapacity( result, buffer_size, 1 )
   
   success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pCommandLine, "uint", &result, "uint", buffer_size, "uint", 0 )
   if ( !success )
   {
      loop, %buffer_size%
      {
         success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pCommandLine+A_Index-1, "uint", &result, "uint", 1, "uint", 0 )
         
         if ( !success or Asc( result ) = 0 )
         {
            buffer_size := A_Index
            break
         }
      }
      success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pCommandLine, "uint", &result, "uint", buffer_size, "uint", 0 )
      if ( ErrorLevel or !success )
      {
         result = < error: ReadProcessMemory 3 > EL = %ErrorLevel%, LE = %A_LastError%, success = %success%
         Gosub, returnProcess
      }
   }

returnProcess:
   DllCall( "CloseHandle", "uint", hp_target )
   return, result
}

#include CMsgBox.ahk