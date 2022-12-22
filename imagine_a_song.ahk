#SingleInstance force

SetWorkingDir A_ScriptDir
^+f1::imagineASong(true)
^+f2::imagineASong(false)

imagineASong(resetOffset) {
    static offset := readOffset()
    static imagineLines := []
    if (resetOffset) {
        offset := 1
        imagineLines := []
    }
    if (imagineLines.Length < 1) {
        imagineLines := processFile()
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
    remaps := readRemaps()
    imagineLines := []
    Loop read, "in.txt"
    {
        currentLine := remaps.Length > 0 
            ? applyRemaps(A_LoopReadLine, remaps) 
            : A_LoopReadLine
        imagineLines.Push(currentLine)
    }

    return imagineLines
}

readRemaps() {
    remaps := []
    if (!FileExist("remap.txt")) {
        return remaps
    }
    Loop read, "remap.txt"
    {
        currentLineParts := StrSplit(A_LoopReadLine, "=")
        remap := { find: currentLineParts[1], replace: currentLineParts[2]}
        remaps.Push(remap)
    }
    return remaps
}

applyRemaps(line, remaps) {
    newLine := line
    for k,v in remaps
    {
        newLine := StrReplace(newLine, v.find, v.replace)
    }
    return newLine
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