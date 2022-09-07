#SingleInstance Force
#NoEnv

; Set the script process priority to high
Process, Priority, , High

; Switch to the SendInput for Send
SendMode Input

; Load the AHK helper libaray
#Include %A_ScriptDir%\komorebic.lib.ahk

; Enable hot reloading of changes to this file
WatchConfiguration("enable")

; Add active window border
ActiveWindowBorderColour(89, 87, 82, "single")
ActiveWindowBorder("enable")

; Configure the invisible border dimensions
InvisibleBorders(6, 0, 14, 7)

; Disable focus follows mouse
ToggleFocusFollowsMouse("disable")

; Hide windows when switching workspaces
WindowHidingBehaviour("hide")

; Set the resize delta
ResizeDelta(100)

; Ensure there are 10 workspaces created on monitor 0
EnsureWorkspaces(0, 10)

; Give the workspaces some optional names
WorkspaceName(0, 0, "Work")
WorkspaceName(0, 1, "Chats")
WorkspaceName(0, 2, "Mail")
WorkspaceName(0, 3, "File")
WorkspaceName(0, 4, "Office")
WorkspaceName(0, 5, "Misc")
WorkspaceName(0, 6, "Misc")
WorkspaceName(0, 7, "Misc")
WorkspaceName(0, 8, "Misc")
WorkspaceName(0, 9, "Floaty")

; Disable window tiling
WorkspaceTiling(0, 9, "disable")

; Workspace rules
; IMs
WorkspaceRule("exe", "TIM.exe",        0, 1)
WorkspaceRule("exe", "WXWork.exe",     0, 1)
WorkspaceRule("exe", "WeChat.exe",     0, 1)
WorkspaceRule("exe", "DingTalk.exe",   0, 1)
; Mails
WorkspaceRule("exe", "OUTLOOK.EXE",    0, 2)
; File manager
WorkspaceRule("exe", "TotalCMD64.exe", 0, 3)

; Specific settings for applications
; -- Slack --
FloatRule("exe", "slack.exe")
; Below did not work
; ManageRule("exe", "slack.exe")
; IdentifyTrayApplication("exe", "slack.exe")
; IdentifyBorderOverflowApplication("exe", "slack.exe")

; -- WeChat --
ManageRule("exe", "WeChat.exe")
IdentifyTrayApplication("exe", "WeChat.exe")
IdentifyBorderOverflowApplication("exe", "WeChat.exe")
FloatRule("exe", "WeChatAppEx.exe")
FloatRule("title", "TXMenuWindow")
FloatRule("class", "SettingWnd")
FloatRule("class", "TrayNotifyWnd")
FloatRule("class", "UpdateWnd")
FloatRule("class", "WhatsNewWnd")
FloatRule("class", "EmotionWnd")
FloatRule("class", "ChatContactMenu")
FloatRule("class", "ImagePreviewLayerWnd")
FloatRule("class", "ImagePreviewWnd")
FloatRule("class", "MsgFileWnd")

; -- Tim --
ManageRule("exe", "TIM.exe")
IdentifyTrayApplication("exe", "TIM.exe")
; IdentifyBorderOverflowApplication("exe", "TIM.exe")

; -- DingTalk
ManageRule("exe", "DingTalk.exe")
; IdentifyTrayApplication("exe", "DingTalk.exe")
IdentifyBorderOverflowApplication("exe", "DingTalk.exe")

; -- WeCom --
ManageRule("exe", "WXWork.exe")
IdentifyTrayApplication("exe", "WXWork.exe")
IdentifyBorderOverflowApplication("exe", "WXWork.exe")

; -- Microsoft Office --
FloatRule("class", "_WwB")
; --- Word ---
IdentifyBorderOverflowApplication("exe", "WINWORD.EXE")
IdentifyLayeredApplication("exe", "WINWORD.EXE")
; --- Excel ---
IdentifyBorderOverflowApplication("exe", "EXCEL.EXE")
IdentifyLayeredApplication("exe", "EXCEL.EXE")
; --- PowerPoint ---
IdentifyBorderOverflowApplication("exe", "POWERPNT.EXE")
IdentifyLayeredApplication("exe", "POWERPNT.EXE")
; --- Outlook ---
IdentifyBorderOverflowApplication("exe", "OUTLOOK.EXE")
IdentifyLayeredApplication("exe", "OUTLOOK.EXE")
IdentifyTrayApplication("exe", "OUTLOOK.EXE")
; --- Office 365 ---
FloatRule("exe", "OfficeClickToRun.exe")

; -- IntelliJ IDEs --
FloatRule("class", "SunAwtDialog")
; --- WebStorm ---
IdentifyObjectNameChangeApplication("exe", "webstorm64.exe")
IdentifyTrayApplication("exe", "webstorm64.exe")
; --- PyCharm ---
IdentifyObjectNameChangeApplication("exe", "pycharm64.exe")
IdentifyTrayApplication("exe", "pycharm64.exe")
; --- Clion ---
IdentifyObjectNameChangeApplication("exe", "clion64.exe")
IdentifyTrayApplication("exe", "clion64.exe")

; -- Total Commander --
FloatRule("AHK_CLASS", "TOverWriteForm")
FloatRule("AHK_CLASS", "TFsPluginConfigForm")
FloatRule("AHK_CLASS", "TDlgCustomColors")
FloatRule("AHK_CLASS", "TExtMsgForm")
FloatRule("AHK_CLASS", "TDLG2FILEACTIONMIN")
FloatRule("AHK_CLASS", "TFindFile")
FloatRule("AHK_CLASS", "TDriveSelBox")

; -- Mozilla Firefox
IdentifyObjectNameChangeApplication("exe", "firefox.exe")
IdentifyTrayApplication("exe", "firefox.exe")
; Targets invisible windows spawned by Firefox to show tab previews in the taskbar
FloatRule("class", "MozillaTaskbarPreviewClass")

; -- Visual Studio Code --
IdentifyBorderOverflowApplication("exe", "Code.exe")

; -- Inno Setup --
; Target hidden window spawned by Inno Setup applications
FloatRule("class", "TApplication")
; Target Inno Setup installers
FloatRule("class", "TWizardForm")

; -- Flow Launcher --
IdentifyBorderOverflowApplication("exe", "Flow.Launcher.exe")

; -- Windows Explorer --
FloatRule("class", "OperationStatusWindow")

; -- Windows Installer --
FloatRule("class", "MsiDialogCloseClass")

; -- Windows Console (conhost.exe) --
ManageRule("class", "ConsoleWindowClass")

; -- Window Spy --
IdentifyTrayApplication("exe", "AutoHotkeyU64.exe")
FloatRule("title", "Window Spy")

; -- Control Panel --
FloatRule("title", "Control Panel")

; -- Task Manager --
FloatRule("class", "TaskManagerWindow")

; -- Obsidian --
ManageRule("exe", "Obsidian.exe")
IdentifyBorderOverflowApplication("exe", "Obsidian.exe")

; -- Zoom --
FloatRule("exe", "Zoom.exe")

; -- GitKraken --
FloatRule("exe", "gitkraken.exe")

; -- WinSpy --
FloatRule("exe", "WinSpy64.exe")

; -- Dropbox --
FloatRule("exe", "Dropbox.exe")

; -- RTerm.exe --
FloatRule("exe", "Rterm.exe")

; -- Setup --
FloatRule("exe", "msiexec.exe")

; Allow komorebi to start managing windows
CompleteConfiguration()

; ! -> Alt
; + -> Shift
; ^ -> Ctrl
; # -> Win

; Start komorebi, Alt + Shift + Ctrl + S
!^+s::
Start()
return

; Stop komorebi, Alt + Shift + Ctrl + Q
!^+q::
Stop()
return

; Cycyle workspace, Alt + Shift + []
!+[::
CycleWorkspace("previous")
return
!+]::
CycleWorkspace("next")
return

; Change the focused window, Alt + Vim direction keys
!h::
Focus("left")
return

!j::
Focus("down")
return

!k::
Focus("up")
return

!l::
Focus("right")
return

; Move the focused window in a given direction, Alt + Shift + Vim direction keys
!+h::
Move("left")
return

!+j::
Move("down")
return

!+k::
Move("up")
Run, komorebic.exe move up, , Hide
return

!+l::
Move("right")
return

; Stack the focused window in a given direction, Ctrl + Shift + direction keys
^+Left::
Stack("left")
return

^+Right::
Stack("right")
return

^+Up::
Stack("up")
Run, komorebic.exe stack up, , Hide
return

^+Down::
Stack("down")
return

; Cycle through stacked windows, Alt + []
!]::
CycleStack("next")
return
![::
CycleStack("previous")
return

; Unstack the focused window, Alt + Shift + D
!+d::
Unstack()
return

; Promote the focused window to the top of the tree, Alt + Shift + Enter
!+Enter::
Promote()
return

; Switch to ultrawide-vertical-stack layout on the main workspace, Alt + Shift + W
!+w::
ChangeLayout("ultrawide-vertical-stack")
return

; Switch to an equal-width, max-height column layout on the main workspace, Alt + Shift + C
!+c::
ChangeLayout("columns")
return

; Switch to the default bsp tiling layout on the main workspace, Alt + Shift + B
!+b::
ChangeLayout("bsp")
return

; Switch to the horizontal stack layout on the main workspace, Alt + Shift + S
!+s::
ChangeLayout("horizontal-stack")
return

; Switch to the vertical stack layout on the main workspace, Alt + Shift + V
!+v::
ChangeLayout("vertical-stack")
return

; Toggle the Monocle layout for the focused window, Alt + Shift + F
!+f::
ToggleMonocle()
return

; Toggle native maximize for the focused window, Alt + Shift + =
!+=::
ToggleMaximize()
return

; Flip horizontally, Alt + X
!x::
FlipLayout("horizontal")
return

; Flip vertically, Alt + Y
!y::
FlipLayout("vertical")
return

; Force a retile if things get janky, Alt + Shift + R
!+r::
Retile()
return

; Float the focused window, Alt + F
!f::
ToggleFloat()
return

; Toggle window tiling, Alt + T
!t::
ToggleTiling()
return

; Reload ~/komorebi.ahk, Alt + O
!o::
ReloadConfiguration()
return

; Pause responding to any window events or komorebic commands, Alt + P
!p::
TogglePause()
return

; Switch to workspace, Alt + NUM
!1::
Send !
FocusWorkspace(0)
return
!2::
Send !
FocusWorkspace(1)
return

!3::
Send !
FocusWorkspace(2)
return
!4::
Send !
FocusWorkspace(3)
return
!5::
Send !
FocusWorkspace(4)
return
!6::
Send !
FocusWorkspace(5)
return
!7::
Send !
FocusWorkspace(6)
return
!8::
Send !
FocusWorkspace(7)
Run, komorebic.exe focus-workspace 7, , Hide
return
!9::
Send !
FocusWorkspace(8)
return
!0::
Send !
FocusWorkspace(9)
return

; Move window to workspace, Alt + Shift + NUM
!+1::
MoveToWorkspace(0)
return
!+2::
MoveToWorkspace(1)
return
!+3::
MoveToWorkspace(2)
return
!+4::
MoveToWorkspace(3)
return
!+5::
MoveToWorkspace(4)
return
!+6::
MoveToWorkspace(5)
return
!+7::
MoveToWorkspace(6)
return
!+8::
MoveToWorkspace(7)
return
!+9::
MoveToWorkspace(8)
return
!+0::
MoveToWorkspace(9)
return

; Cycle next focus, Alt + Shift + N
!+n::
CycleFocus("next")
return

; Cycle previous focus, Alt + Shift + P
!+p::
CycleFocus("previous")
return

; Increase the edge of the focused window, Alt + Ctrl + Arrow keys
!^Left::
Resize("left", "increase")
return
!^Right::
Resize("right", "increase")
return
!^Up::
Resize("up", "increase")
return
!^Down::
Resize("down", "increase")
return

; Increase the column of the focused window, Shift + Alt + Ctrl + Arrow keys
!+^Left::
ResizeAxis("left", "decrease")
return
!+^Right::
ResizeAxis("right", "decrease")
return
!+^Up::
ResizeAxis("up", "decrease")
return
!+^Down::
ResizeAxis("down", "decrease")
return

; Force to manage the focused window
^!=::
Manage()
return

; Unmanage a window that was forcibly managed
^!-::
Unmanage()
return

; Close windows using Alt + Q
!q::Send, !{f4}

; horizontal scrolling
!WheelDown::WheelRight
!WheelUp::WheelLeft

; Remap CpasLock to ESC
CapsLock::Send, {ESC}
