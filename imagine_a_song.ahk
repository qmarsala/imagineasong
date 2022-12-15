#SingleInstance force

SetWorkingDir A_ScriptDir
^+f1::imagineASong(true)
^+f2::imagineASong(false)

imagineASong(reloadSong) {
    static offset := 1
    static imagineLines := []
    if (imagineLines.Length < 1 || reloadSong) {
        imagineLines := processFile()
        offset := 1
    }

    offset := imagineNext(imagineLines, offset)
    if (offset = 1) {
        imagineLines := []
    }
}

processFile() {
    ;outPath := Format("./out/{}", fileName)
    if (FileExist("out.txt")) {
        FileDelete("out.txt")
    }
    if (!FileExist("in.txt")) {
        MsgBox("no input file found")
        return
    }

    imagineLines := []
    Loop read, "in.txt"
    {
        imagineLines.Push(A_LoopReadLine)

        ; will be used later to re-populate imagineLines after restart
        line := Format("/imagine {}`n", A_LoopReadLine)
        FileAppend(line, "out.txt")
    }

    return imagineLines
}

imagineNext(imagineLines, offset) {
    if (imagineLines.Length < 1){
        MsgBox("No song loaded")
        return 1
    }
    if (offset > imagineLines.Length) {
        MsgBox("Song has ended")
        return 1
    }

    next := imagineLines[offset]
    discordCommandPaste(next)
    return offset + 1
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

; todo: support multiple files
; getFileNames() {
;     fileNames := []
;     Loop Files, A_WorkingDir "./in\*.txt"
;     {
;         fileNames.Push(A_LoopFileName)
;     }
;     return fileNames
; }