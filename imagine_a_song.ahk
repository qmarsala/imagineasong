#SingleInstance force

SetWorkingDir A_ScriptDir
^+f1::imagineASong(true)
^+f2::imagineASong(false)

imagineASong(resetOffset) {
    static offset := readOffset()
    static imagineLines := []
    if (imagineLines.Length < 1) {
        imagineLines := processFile()
    }
    if (resetOffset) {
        offset := 1
    }

    offset := imagineNext(imagineLines, offset)
    storeOffset(offset)
    if (offset = 1) {
        imagineLines := []
    }
}

processFile() {
    if (!FileExist("in.txt")) {
        MsgBox("no input file found")
        return
    }

    imagineLines := []
    Loop read, "in.txt"
    {
        imagineLines.Push(A_LoopReadLine)
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
    sendDiscordCommand(next)
    return offset + 1
}

sendDiscordCommand(content) {
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

storeOffset(offset) {
    offsetStorePath := "offset.txt"
    if (FileExist(offsetStorePath)) {
        FileDelete(offsetStorePath)
    }
    FileAppend(offset, offsetStorePath)
}

readOffset() {
    offsetStorePath := "offset.txt"
    offset := FileExist(offsetStorePath)
        ? FileRead(offsetStorePath)
        : 1
    return offset
}