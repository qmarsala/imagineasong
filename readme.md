### dependencies
[AutoHotKey v2](https://www.autohotkey.com/download/ahk-v2.exe)

## Getting Started
Paste song text into the `in.txt` file.  

If the song includes banned words for MidJourney, add remaps to `remap.txt`.    
The remap format is `oldvalue=newvalue`, ex:    
`in.txt`
```txt
how are you? this all needs to change!
```
`remap.txt`
```txt
this all needs to change!=I'm fine
```
will produce: `/imagine how are you? I'm fine`    

An `offset.txt` file will be created to bookmark the last line processed.    
You can change the value in this file to jump around the song. But the only content of the file should be the offset number.

### hotkeys
`ctrl+shift+f1` - force reset offset, read file, and generate first command    
`ctrl+shift+f2` - generate next command, resetting the offset and reading the input file if needed
