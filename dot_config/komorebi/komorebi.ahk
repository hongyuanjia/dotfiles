#SingleInstance Force

; Enable hot reloading of changes to this file
Run, komorebic.exe watch-configuration enable, , Hide

; Configure the invisible border dimensions
Run, komorebic.exe invisible-borders 0 0 0 0, , Hide

; Enable focus follows mouse
Run, komorebic.exe focus-follows-mouse disable, , Hide

; Ensure there are 5 workspaces created on monitor 0
Run, komorebic.exe ensure-workspaces 0 5, , Hide

; Give the workspaces some optional names
Run, komorebic.exe workspace-name 0 0 wide, , Hide
Run, komorebic.exe workspace-name 0 1 chats, , Hide
Run, komorebic.exe workspace-name 0 2 mail, , Hide
Run, komorebic.exe workspace-name 0 3 file, , Hide
Run, komorebic.exe workspace-name 0 4 floaty, , Hide

; Set the padding of the different workspaces
Run, komorebic.exe workspace-padding 0 0 0, , Hide
Run, komorebic.exe container-padding 0 0 0, , Hide
Run, komorebic.exe workspace-padding 0 1 0, , Hide
Run, komorebic.exe container-padding 0 1 0, , Hide
Run, komorebic.exe workspace-padding 0 2 0, , Hide
Run, komorebic.exe container-padding 0 2 0, , Hide
Run, komorebic.exe workspace-padding 0 3 0, , Hide
Run, komorebic.exe container-padding 0 3 0, , Hide

Run, komorebic.exe workspace-layout 0 0 ultrawide-vertical-stack, , Hide
Run, komorebic.exe workspace-layout 0 1 columns, , Hide
Run, komorebic.exe workspace-layout 0 2 vertical-stack, , Hide
; Set the floaty layout to not tile any windows
Run, komorebic.exe workspace-tiling 0 4 disable, , Hide

; Set the resize delta
Run, komorebic.exe resize-delta 20, , Hide

; Always show chat apps on the second workspace
; 1. Slack
Run, komorebic.exe float-rule exe "slack.exe", , Hide
Run, komorebic.exe workspace-rule exe "slack.exe" 0 1, , Hide
; Below did not work
; Run, komorebic.exe manage-rule exe "slack.exe", , Hide
; Run, komorebic.exe identify-tray-application exe "slack.exe", , Hide
; Run, komorebic.exe identify-border-overflow-application exe "slack.exe", , Hide
; 2. WeChat
Run, komorebic.exe manage-rule exe "WeChat.exe", , Hide
Run, komorebic.exe identify-tray-application exe "WeChat.exe", , Hide
Run, komorebic.exe float-rule class "SettingWnd", , Hide
Run, komorebic.exe workspace-rule exe "WeChat.exe" 0 1, , Hide
; 3. Tim
Run, komorebic.exe manage-rule exe "TIM.exe", , Hide
Run, komorebic.exe workspace-rule exe "TIM.exe" 0 1, , Hide
Run, komorebic.exe identify-tray-application exe "TIM.exe", , Hide
; 4. WeCom
Run, komorebic.exe manage-rule exe "WXWork.exe", , Hide
Run, komorebic.exe workspace-rule exe "WXWork.exe" 0 1, , Hide
Run, komorebic.exe identify-tray-application exe "WXWork.exe", , Hide

; Specific settings for applications
; Windows Explorer
Run, komorebic.exe float-rule class "OperationStatusWindow", , Hide
; Window Spy
Run, komorebic.exe identify-tray-application exe "AutoHotkeyU64.exe", , Hide
Run, komorebic.exe float-rule title "Window Spy", , Hide
; IntelliJ: Always float IntelliJ popups
Run, komorebic.exe float-rule class SunAwtDialog, , Hide
; Control Panel: Always float
Run, komorebic.exe float-rule title "Control Panel", , Hide
; Task Manager: Always float
Run, komorebic.exe float-rule class TaskManagerWindow, , Hide
; Microsoft Office
Run, komorebic.exe float-rule class "_WwB", , Hide
Run, komorebic.exe identify-border-overflow-application exe "WINWORD.EXE", , Hide
Run, komorebic.exe identify-layered-application exe "WINWORD.EXE", , Hide
Run, komorebic.exe identify-border-overflow-application exe "EXCEL.EXE", , Hide
Run, komorebic.exe identify-layered-application exe "EXCEL.EXE", , Hide
Run, komorebic.exe identify-border-overflow-application exe "OUTLOOK.EXE", , Hide
Run, komorebic.exe identify-layered-application exe "OUTLOOK.EXE", , Hide
Run, komorebic.exe identify-tray-application exe "WeChat.exe", , Hide
Run, komorebic.exe workspace-rule exe "OUTLOOK.EXE" 0 2, , Hide
Run, komorebic.exe float-rule exe OfficeClickToRun.exe, , Hide
; Obsidian
Run, komorebic.exe manage-rule exe "Obsidian.exe", , Hide
Run, komorebic.exe identify-border-overflow-application exe "Obsidian.exe", , Hide
; PyCharm
Run, komorebic.exe identify-object-name-change-application exe "pycharm64.exe", , Hide
Run, komorebic.exe identify-tray-application exe "pycharm64.exe", , Hide
; Clion
Run, komorebic.exe identify-object-name-change-application exe "clion64.exe", , Hide
Run, komorebic.exe identify-tray-application exe "clion64.exe", , Hide
; Zoom
Run, komorebic.exe float-rule exe "Zoom.exe", , Hide
; GitKraken
Run, komorebic.exe manage-rule exe "gitkraken.exe", , Hide
; Clash for Windows
Run, komorebic.exe float-rule exe "Clash for Windows.exe", , Hide
; Total Commander
Run, komorebic.exe workspace-rule exe "TOTALCMD64.EXE" 0 3, , Hide
Run, komorebic.exe float-rule AHK_CLASS TOverWriteForm, , Hide
; VSCode
Run, komorebic.exe manage-rule exe "Code.exe", , Hide

; Change the focused window, Alt + Vim direction keys
!h::
Run, komorebic.exe focus left, , Hide
return

!j::
Run, komorebic.exe focus down, , Hide
return

!k::
Run, komorebic.exe focus up, , Hide
return

!l::
Run, komorebic.exe focus right, , Hide
return

; Move the focused window in a given direction, Alt + Shift + Vim direction keys
!+h::
Run, komorebic.exe move left, , Hide
return

!+j::
Run, komorebic.exe move down, , Hide
return

!+k::
Run, komorebic.exe move up, , Hide
return

!+l::
Run, komorebic.exe move right, , Hide
return

; Stack the focused window in a given direction, Alt + Shift + direction keys
!+Left::
Run, komorebic.exe stack left, , Hide
return

!+Down::
Run, komorebic.exe stack down, , Hide
return

!+Up::
Run, komorebic.exe stack up, , Hide
return

!+Right::
Run, komorebic.exe stack right, , Hide
return

!]::
Run, komorebic.exe cycle-stack next, , Hide
return

![::
Run, komorebic.exe cycle-stack previous, , Hide
return

; Unstack the focused window, Alt + Shift + D
!+d::
Run, komorebic.exe unstack, , Hide
return

; Promote the focused window to the top of the tree, Alt + Shift + Enter
!+Enter::
Run, komorebic.exe promote, , Hide
return

; Switch to ultrawide-vertical-stack layout on the main workspace, Alt + Shift + W
!+w::
Run, komorebic.exe workspace-layout 0 0 ultrawide-vertical-stack, , Hide
return

; Switch to an equal-width, max-height column layout on the main workspace, Alt + Shift + C
!+c::
Run, komorebic.exe workspace-layout 0 0 columns, , Hide
return

; Switch to the default bsp tiling layout on the main workspace, Alt + Shift + T
!+t::
Run, komorebic.exe workspace-layout 0 0 bsp, , Hide
return

; Toggle the Monocle layout for the focused window, Alt + Shift + F
!+f::
Run, komorebic.exe toggle-monocle, , Hide
return

; Toggle native maximize for the focused window, Alt + Shift + =
!+=::
Run, komorebic.exe toggle-maximize, , Hide
return

; Flip horizontally, Alt + X
!x::
Run, komorebic.exe flip-layout horizontal, , Hide
return

; Flip vertically, Alt + Y
!y::
Run, komorebic.exe flip-layout vertical, , Hide
return

; Force a retile if things get janky, Alt + Shift + R
!+r::
Run, komorebic.exe retile, , Hide
return

; Float the focused window, Alt + T
!t::
Run, komorebic.exe toggle-float, , Hide
return

; Reload ~/komorebi.ahk, Alt + O
!o::
Run, komorebic.exe reload-configuration, , Hide
return

; Pause responding to any window events or komorebic commands, Alt + P
!p::
Run, komorebic.exe toggle-pause, , Hide
return

; Switch to workspace
!1::
Send !
Run, komorebic.exe focus-workspace 0, , Hide
return

!2::
Send !
Run, komorebic.exe focus-workspace 1, , Hide
return

!3::
Send !
Run, komorebic.exe focus-workspace 2, , Hide
return

!4::
Send !
Run, komorebic.exe focus-workspace 3, , Hide
return

!5::
Send !
Run, komorebic.exe focus-workspace 4, , Hide
return

; Move window to workspace
!+1::
Run, komorebic.exe move-to-workspace 0, , Hide
return

!+2::
Run, komorebic.exe move-to-workspace 1, , Hide
return

!+3::
Run, komorebic.exe move-to-workspace 2, , Hide
return

!+4::
Run, komorebic.exe move-to-workspace 3, , Hide
return

!+5::
Run, komorebic.exe move-to-workspace 4, , Hide
return

; Resize the focused window, Win + Ctrl + Vim direction keys
#^h::
Run, komorebic.exe resize right decrease, , Hide
return

#^j::
Run, komorebic.exe resize down increase, , Hide
return

#^k::
Run, komorebic.exe resize down decrease, , Hide
return

#^l::
Run, komorebic.exe resize right increase, , Hide
return
