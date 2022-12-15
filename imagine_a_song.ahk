#SingleInstance force

SetWorkingDir A_ScriptDir

;todo kill globals
imagineLines := []
offset := 1

^+f1::processFile
^+f2::imagineNext

; todo: support multiple files
; getFileNames() {
;     fileNames := []
;     Loop Files, A_WorkingDir "./in\*.txt"
;     {
;         fileNames.Push(A_LoopFileName)
;     }
;     return fileNames
; }

processFile() {
    ;outPath := Format("./out/{}", fileName)
    if (FileExist("out.txt")) {
        FileDelete("out.txt")
    }
    if (!FileExist("in.txt")) {
        MsgBox("no input file found")
    }
    
    global offset := 1
    global imagineLines := []
    Loop read, "in.txt"
    {
        imagineLines.Push(A_LoopReadLine)

        ; will be used later to re-populate imagineLines after restart
        line := Format("/imagine {}`n", A_LoopReadLine)
        FileAppend(line, "out.txt")
    }
}

imagineNext() {
    global imagineLines
    if (imagineLines.Length < 1){
        MsgBox("No song loaded")
        return
    }

    global offset
    if (offset > imagineLines.Length) {
        offset := 1
    }

    next := imagineLines[offset]
    discordCommandPaste(next)
    offset := offset + 1
}

discordCommandPaste(content) {
    if (WinExist("Discord")) {
        WinActivate
        Sleep(25)
    } else {
        MsgBox("Discord not found")
        return
    }

    SendInput("/imagine")
    Sleep(5)

    A_Clipboard := content
    SendInput("{Space}^v")
}