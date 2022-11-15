ToggleTotalCMD() {
    DetectHiddenWindows, on
    IfWinNotExist ahk_class TTOTAL_CMD
        Run, C:\Users\hongy\AppData\Local\TotalCMD64
    Else
        IfWinNotActive ahk_class TTOTAL_CMD
            WinActivate
    Return
}
