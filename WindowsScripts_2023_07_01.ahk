#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
global flag_titlecase := 0
global flag_uppercase := 0
global flag_lowercase := 0

!^r::
    MsgBox, 0, Information, Script Reloading, 0.5
    Reload
Return

; Suspend command suspends the script, while still permitting Suspend toggle so it can be turned on again
; A_IsSuspended is a built in variable in AutoHotKey. Refer Documentation for more.
^!s::
    {
        Suspend, Permit
        Suspend, Toggle
        if A_IsSuspended=1
        {
            MsgBox, 0, Information, Script Suspended, 1.5
        }
        if A_IsSuspended=0
        {
            MsgBox, 0, Warning, Script Active, 1.5
        }
        keysUp()
        return
    }

;^ is used to represent <Ctrl>
#IfWinActive, ahk_exe Code.exe,
    {
        ^r::
            MsgBox, 0, Information, Script Reloading, 0.5
            Reload
            Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
        return
    }
#IfWinActive

^+u::
    {
        toggleUpperCase()
        SetTimer, resetFlags, -2000
        return
    }

^+l::
    {
        toggleLowerCase()
        SetTimer, resetFlags, -2000
        return
    }

#IfWinActive, ahk_exe Notion.exe,
    {
        F1::
            {
                Gui, Add, Text, , Hotkey: Functionality
                Gui, Add, Text, , Alt + 4: Rupee Symbol
                Gui, Add, Text, , F1: Show Mappings
                Gui, Add, Text, , Ctrl + Enter: Insert into line above
                Gui, Add, Text, , Ctrl + Shift + Enter: Insert into line below
                Gui, Add, Text, , Windows + c: Add code block
                Gui, Add, Text, , MButton: Select text continuously
                Gui, Add, Text, , # + `: Format name of pdf
                Gui, Add, Text, , # + 1: Format name of pdf
                Gui, Add, Text, , Alt + Shift + 2: Remove whitespace characters
                Gui, Add, Text, , Alt + 2: Create link for selection
                Gui, Add, Text, , Ctrl + Shift + 1: Turn to h1
                Gui, Add, Text, , Ctrl + Shift + 2: Turn to h2
                Gui, Add, Text, , Ctrl + Shift + 3: Turn to h3
                Gui, Add, Text, , Alt + Left: Go back
                Gui, Add, Text, , Alt + Right: Go forward
                Gui, Add, Text, , Ctrl + F1: Turn to h3
                Gui, Add, Text, , F2: Move selected block up
                Gui, Add, Text, , F3: Turn to callout
                Gui, Add, Text, , F4: Manipulate text
                Gui, Add, Text, , F5: Move to sub point
                Gui, Add, Text, , F6: Highlight and italisize
                Gui, Add, Text, , F7: Delete block
                Gui, Add, Text, , F8: Enter then delete
                Gui, Add, Text, , Alt + F: Replace whitespace characters with simple space
                Gui, Add, Text, , F12: Reformat block
                Gui, Add, Text, , Ctrl + Shift + ]: Make bullets in properties
                Gui, Add, Button, , OK
                Gui, Show
                return
            }
        ^e::
            {
                temp :=ClipboardAll
                Clipboard:=""
                SendInput, ^c
                ClipWait, 1
                escapeSpaceAtEndOfSelection()
                SendInput, ^e
                keysUp()
                Clipboard:=temp
                return
            }
        ^+h::
            {
                temp :=ClipboardAll
                Clipboard:=""
                SendInput, ^c
                ClipWait, 1
                escapeSpaceAtEndOfSelection()
                SendInput, ^+h
                keysUp()
                Clipboard:=temp
                return
            }
        ^i::
            {
                temp :=ClipboardAll
                Clipboard:=""
                SendInput, ^c
                ClipWait, 1
                escapeSpaceAtEndOfSelection()
                SendInput, ^i
                keysUp()
                Clipboard:=temp
                return
            }
        ;! is used to represent <Alt>
        !4::
            {
                SendInput, {U+20B9}
                keysUp()
                return
            }
        MButton::
            {
                SendInput, +{LButton}
                keysUp()
                return
            }

        #`::
            {
                temp :=ClipboardAll
                Clipboard:=""
                SendInput, ^c
                ClipWait, 1
                if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.’]$")){
                    Clipboard:=""
                    SendInput,+{Left}
                    Sleep, 100
                    SendInput ^c
                    ClipWait, 1
                }
                Clipboard:=RegExReplace(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\r]+", " ")
                if(RegExMatch(Clipboard, "(^\d{1,2})?(th|rd|st)?\s?([a-zA-Z]+)([,]?)\s?(\d{4})")){
                    Clipboard := RegExReplace(Clipboard, "(^\d{1,2})?(th|rd|st)?\s?([a-zA-Z]+)([,]?)\s?(\d{4})", "$5_$3_$1")
                    Clipboard := RegExReplace(Clipboard, "January", "01")
                    Clipboard := RegExReplace(Clipboard, "February", "02")
                    Clipboard := RegExReplace(Clipboard, "March", "03")
                    Clipboard := RegExReplace(Clipboard, "April", "04")
                    Clipboard := RegExReplace(Clipboard, "May", "05")
                    Clipboard := RegExReplace(Clipboard, "June", "06")
                    Clipboard := RegExReplace(Clipboard, "July", "07")
                    Clipboard := RegExReplace(Clipboard, "August", "08")
                    Clipboard := RegExReplace(Clipboard, "September", "09")
                    Clipboard := RegExReplace(Clipboard, "October", "10")
                    Clipboard := RegExReplace(Clipboard, "November", "11")
                    Clipboard := RegExReplace(Clipboard, "December", "12")
                    Clipboard := RegExReplace(Clipboard, "Jan", "01")
                    Clipboard := RegExReplace(Clipboard, "Feb", "02")
                    Clipboard := RegExReplace(Clipboard, "Mar", "03")
                    Clipboard := RegExReplace(Clipboard, "Apr", "04")
                    Clipboard := RegExReplace(Clipboard, "May", "05")
                    Clipboard := RegExReplace(Clipboard, "Jun", "06")
                    Clipboard := RegExReplace(Clipboard, "Jul", "07")
                    Clipboard := RegExReplace(Clipboard, "Aug", "08")
                    Clipboard := RegExReplace(Clipboard, "Sept", "09")
                    Clipboard := RegExReplace(Clipboard, "Oct", "10")
                    Clipboard := RegExReplace(Clipboard, "Nov", "11")
                    Clipboard := RegExReplace(Clipboard, "Dec", "12")
                    Clipboard := RegExReplace(Clipboard, "_1$", "_01_")
                    Clipboard := RegExReplace(Clipboard, "_2$", "_02_")
                    Clipboard := RegExReplace(Clipboard, "_3$", "_03_")
                    Clipboard := RegExReplace(Clipboard, "_4$", "_04_")
                    Clipboard := RegExReplace(Clipboard, "_5$", "_05_")
                    Clipboard := RegExReplace(Clipboard, "_6$", "_06_")
                    Clipboard := RegExReplace(Clipboard, "_7$", "_07_")
                    Clipboard := RegExReplace(Clipboard, "_8$", "_08_")
                    Clipboard := RegExReplace(Clipboard, "_9$", "_09_")
                    Sleep, 50
                    Clipboard := RegExReplace(Clipboard, "(.+)(_$)", "$1")

                }else if(RegExMatch(Clipboard, "(.*)\s[(](\d*)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.*)\s[(](\d*)[)]", "$1, $2")
                }else if(RegExMatch(Clipboard, "(^.{5,})\s[(](\d{1,2}\.?\d{0,2}%?\-\d{1,2}\.?\d{0,2}%?)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{5,})\s[(](\d{1,2}\.?\d{0,2}%?\-\d{1,2}\.?\d{0,2}%?)[)]", "$2: $1")
                }else if(RegExMatch(Clipboard, "(^.{5,})\s[(](\d{1,2}\.?\d{0,2}%?)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{5,})\s[(](\d{1,2}\.?\d{0,2}%?)[)]", "$2: $1")
                }else if(RegExMatch(Clipboard, "(^.{1,10})\s[(](.{5,})[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{1,5})\s[(](.{5,})[)]", "$1: $2")
                }else{
                    Clipboard := RegExReplace(Clipboard, "(.*)\s[(](.*)[)]", "$2: $1")
                }
                Sleep, 100
                SendInput, ^i^+h
                KeyWait, LWin
                SendInput, %Clipboard%
                keysUp()
                Sleep, 500
                Clipboard:=temp
                Sleep, 100
                temp:=""
                return
            }
        ^+Enter::
            {
                keysUp()
                SendInput, {End}{Enter}
                ; SendInput, {Enter}
                Sleep, 100
                SendInput, {Left}{Right}
                keysUp()
                return
            }
        ^Enter::
            {
                keysUp()
                SendInput, {Home}
                SendInput, {Enter}
                SendEvent, {Up}
                return
            }
        #c::
            {
                SendInput, /turncode
                ; Sleep, 100
                SendInput, {Enter}
                keysUp()
                return
            }
        #1::
            {
                temp :=ClipboardAll
                Clipboard:=""
                SendInput, ^c
                ClipWait, 1
                if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.]$")){
                    Clipboard:=""
                    SendInput,+{Left}
                    Sleep, 100
                    SendInput ^c
                    ClipWait, 1
                }
                Clipboard:=RegExReplace(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\r]+", " ")
                if(RegExMatch(Clipboard, "(^\d{1,2})?(th|rd|st)?\s?([a-zA-Z]+)([,]?)\s?(\d{4})")){
                    Clipboard := RegExReplace(Clipboard, "(^\d{1,2})?(th|rd|st)?\s?([a-zA-Z]+)([,]?)\s?(\d{4})", "$5_$3_$1")
                    Clipboard := RegExReplace(Clipboard, "January", "01")
                    Clipboard := RegExReplace(Clipboard, "February", "02")
                    Clipboard := RegExReplace(Clipboard, "March", "03")
                    Clipboard := RegExReplace(Clipboard, "April", "04")
                    Clipboard := RegExReplace(Clipboard, "May", "05")
                    Clipboard := RegExReplace(Clipboard, "June", "06")
                    Clipboard := RegExReplace(Clipboard, "July", "07")
                    Clipboard := RegExReplace(Clipboard, "August", "08")
                    Clipboard := RegExReplace(Clipboard, "September", "09")
                    Clipboard := RegExReplace(Clipboard, "October", "10")
                    Clipboard := RegExReplace(Clipboard, "November", "11")
                    Clipboard := RegExReplace(Clipboard, "December", "12")
                    Clipboard := RegExReplace(Clipboard, "Jan", "01")
                    Clipboard := RegExReplace(Clipboard, "Feb", "02")
                    Clipboard := RegExReplace(Clipboard, "Mar", "03")
                    Clipboard := RegExReplace(Clipboard, "Apr", "04")
                    Clipboard := RegExReplace(Clipboard, "May", "05")
                    Clipboard := RegExReplace(Clipboard, "Jun", "06")
                    Clipboard := RegExReplace(Clipboard, "Jul", "07")
                    Clipboard := RegExReplace(Clipboard, "Aug", "08")
                    Clipboard := RegExReplace(Clipboard, "Sept", "09")
                    Clipboard := RegExReplace(Clipboard, "Sep", "09")
                    Clipboard := RegExReplace(Clipboard, "Oct", "10")
                    Clipboard := RegExReplace(Clipboard, "Nov", "11")
                    Clipboard := RegExReplace(Clipboard, "Dec", "12")
                    Clipboard := RegExReplace(Clipboard, "_1$", "_01_")
                    Clipboard := RegExReplace(Clipboard, "_2$", "_02_")
                    Clipboard := RegExReplace(Clipboard, "_3$", "_03_")
                    Clipboard := RegExReplace(Clipboard, "_4$", "_04_")
                    Clipboard := RegExReplace(Clipboard, "_5$", "_05_")
                    Clipboard := RegExReplace(Clipboard, "_6$", "_06_")
                    Clipboard := RegExReplace(Clipboard, "_7$", "_07_")
                    Clipboard := RegExReplace(Clipboard, "_8$", "_08_")
                    Clipboard := RegExReplace(Clipboard, "_9$", "_09_")
                    Sleep, 50
                    Clipboard := RegExReplace(Clipboard, "(.+)(_$)", "$1")

                }
                Sleep, 100
                ; SendInput, ^i^u
                KeyWait, LWin
                SendInput, %Clipboard%
                keysUp()
                Sleep, 500
                Clipboard:=temp
                Sleep, 100
                temp:=""
                return
            }

        `::
            {
                temp :=ClipboardAll
                Clipboard:=""
                SendInput, ^c
                ClipWait, 1
                if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.:;’'""]$")){
                    Clipboard:=""
                    SendInput,+{Left}
                    Sleep, 100
                    SendInput ^c
                    ClipWait, 1
                }
                Clipboard:=RegExReplace(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\r]+", " ")
                if(RegExMatch(Clipboard, "(.*)\s[(](\d*)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.*)\s[(](\d*)[)]", "$1, $2")
                }else if(RegExMatch(Clipboard, "(^.{5,})\s[(](\d{1,2}\.?\d{0,2}%?\-\d{1,2}\.?\d{0,2}%?)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{5,})\s[(](\d{1,2}\.?\d{0,2}%?\-\d{1,2}\.?\d{0,2}%?)[)]", "$2: $1")
                }else if(RegExMatch(Clipboard, "(^.{5,})\s[(](\d{1,2}\.?\d{0,2}%?)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{5,})\s[(](\d{1,2}\.?\d{0,2}%?)[)]", "$2: $1")
                }else if(RegExMatch(Clipboard, "(^.{1,10})\s[(](.{5,})[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{1,5})\s[(](.{5,})[)]", "$1: $2")
                }else{
                    Clipboard := RegExReplace(Clipboard, "(.*)\s[(](.*)[)]", "$2: $1")
                }
                Sleep, 100
                SendInput, ^i^+h
                SendInput, %Clipboard%
                Sleep, 50
                SendInput, ^i^+h
                keysUp()
                Sleep, 500
                Clipboard:=temp
                Sleep, 100
                temp:=""
                return
            }
        !`::
            {
                temp :=ClipboardAll
                Clipboard:=""
                SendInput, ^c
                ClipWait, 1
                if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.]$")){
                    Clipboard:=""
                    SendInput,+{Left}
                    Sleep, 100
                    SendInput ^c
                    ClipWait, 1
                }
                Clipboard:=RegExReplace(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\r]+", " ")
                if(RegExMatch(Clipboard, "(.*)\s[(](\d*)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.*)\s[(](\d*)[)]", "$1, $2")
                }else if(RegExMatch(Clipboard, "(^.{5,})\s[(](\d{1,2}\.?\d{0,2}%?\-\d{1,2}\.?\d{0,2}%?)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{5,})\s[(](\d{1,2}\.?\d{0,2}%?\-\d{1,2}\.?\d{0,2}%?)[)]", "$2: $1")
                }else if(RegExMatch(Clipboard, "(^.{5,})\s[(](\d{1,2}\.?\d{0,2}%?)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{5,})\s[(](\d{1,2}\.?\d{0,2}%?)[)]", "$2: $1")
                }else if(RegExMatch(Clipboard, "(^.{1,10})\s[(](.{5,})[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{1,5})\s[(](.{5,})[)]", "$1: $2")
                }else{
                    Clipboard := RegExReplace(Clipboard, "(.*)\s[(](.*)[)]", "$2: $1")
                }
                SendInput, ^+m
                Sleep, 900
                SendInput, @%Clipboard%
                keysUp()
                Sleep, 500
                Clipboard:=temp
                Sleep, 100
                temp:=""
                return
            }

        !+2::
            {
                temp := ClipboardAll
                while (Clipboard!="")
                {
                    Clipboard:=""
                    Sleep, 20
                }
                Send, ^c
                ClipWait
                if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.]$")){
                    Clipboard:=""
                    SendInput,+{Left}
                    Sleep, 100
                    SendInput ^c
                    ClipWait, 1
                }
                Clipboard:=RegExReplace(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\r]+", " ")
                SendInput, {Raw}+
                Sleep, 100
                SendInput, ^v
                keysUp()
                Sleep, 400
                Clipboard := temp
                Sleep, 100
                temp:=""
                return
            }

        !2::
            {
                temp := ClipboardAll
                while (Clipboard!="")
                {
                    Clipboard:=""
                    Sleep, 50
                }

                SendInput, ^c
                ClipWait
                if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.:;(]$")){
                    Clipboard:=""
                    SendInput,+{Left}
                    Sleep, 100
                    SendInput ^c
                    ClipWait, 1
                }
                Clipboard:=RegExReplace(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\r]+", " ")
                SendInput, @
                SendInput, ^v
                keysUp()
                Sleep, 200
                Clipboard := temp
                temp:=""
                return
            }

        ^+1::
            {
                SendInput, /turnintoh1
                SendInput, {Enter}
                return
            }
        ^+2::
            {
                SendInput, /turnintoh2
                SendInput, {Enter}
                return
            }
        ^+3::
            {
                SendInput, /turnintoh3
                SendInput, {Enter}
                return
            }

        !^Left::
            {
                SendInput, ^[
                keysUp()
                return
            }

        !^Right::
            {
                SendInput, ^]
                keysUp()
                return
            }
        ^F1::
            {
                temp:=Clipboard
                Sleep, 50
                Clipboard:="turntoggleh1"
                SendInput, /
                Sleep, 50
                SendInput, ^v
                Sleep, 50
                SendInput, {Enter}
                Sleep, 300
                Clipboard:=temp
                temp:=""
                return
            }
        F2::
            {
                SendInput, ^+{Up}
                Sleep, 50
                return
            }
        F3::
            {
                temp := ClipboardAll
                Clipboard:=""
                Sleep, 150
                Clipboard:="turncallout"
                ClipWait
                SendInput, /
                SendInput, ^v
                ; Sleep, 150
                SendInput, {Enter}
                Sleep, 600
                Clipboard:=temp
                keysUp()
                return
            }

        F4::
            {
                temp :=ClipboardAll
                Clipboard:=""
                SendInput, ^c
                ClipWait, 1
                if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.:;’""']$")){
                    Clipboard:=""
                    SendInput,+{Left}
                    SendInput ^c
                    ClipWait, 1
                }
                Clipboard:=RegExReplace(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\r]+", " ")
                ; Case: Event (2022) -> Event, 2022
                if(RegExMatch(Clipboard, "(.*)\s[(](\d*)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.*)\s[(](\d*)[)]", "$1, $2")
                    ; Case:
                }else if(RegExMatch(Clipboard, "(^.{5,})\s[(](\d{1,2}\.?\d{0,2}%?\-\d{1,2}\.?\d{0,2}%?)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{5,})\s[(](\d{1,2}\.?\d{0,2}%?\-\d{1,2}\.?\d{0,2}%?)[)]", "$2: $1")
                }else if(RegExMatch(Clipboard, "(^.{5,})\s[(](\d{1,2}\.?\d{0,2}%?)[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{5,})\s[(](\d{1,2}\.?\d{0,2}%?)[)]", "$2: $1")
                }else if(RegExMatch(Clipboard, "(^.{1,10})\s[(](.{5,})[)]")){
                    Clipboard := RegExReplace(Clipboard, "(.{1,5})\s[(](.{5,})[)]", "$1: $2")
                }else{
                    Clipboard := RegExReplace(Clipboard, "(.*)\s[(](.*)[)]", "$2: $1")
                }
                Clipboard:= RegExReplace(Clipboard, "\s?Rs\.?\s?", "{U+20B9} ")
                SendInput, {BackSpace}
                SendInput, ^u^i
                ; Sleep, 100
                SendInput, ^v
                Sleep, 50
                SendInput, ^u^i
                keysUp()
                Sleep, 500
                Clipboard:=temp
                temp:=""
                return
            }
        F5::
            {
                temp := ClipboardAll
                Clipboard := ""
                pos = 0
                pos:=checkIfEndSpecialCharacter()
                if(pos!=0){
                    SendInput,+{Left}
                }
                SendInput,^+h^i
                Clipboard := temp
                return
            }
        F6::
            {
                SendInput, {Enter}
                Sleep, 50
                SendInput, {Tab}
                return
            }

        F7::
            {
                keysUp()
                SendInput, {Escape}
                Sleep, 50
                SendInput, {Delete}
                return
            }
        F8::
            {
                ; MsgBox, 1, Title, "F8 Pressed", 5
                keysUp()
                SendInput, {Enter}
                Sleep, 50
                SendInput, {Delete}
                keysUp()
                return
            }

        !f::
            {
                Clipboard:=RegExReplace(Clipboard, "[\r]+", " ")
                Clipboard:=RegExReplace(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}]+", " ")
                KeyWait, LWin
                SendInput, ^v
                Sleep, 600
                keysUp()
                return
            }
        F12::
            {
                temp := ClipboardAll
                Clipboard:=""
                SendInput, {Esc}
                Sleep, 60
                SendInput, {Enter}
                Sleep, 60
                SendInput, ^a
                SendInput, ^c
                ClipWait
                Clipboard:=RegExReplace(Clipboard, "[\r\n\b]+", " ")
                Clipboard:=RegExReplace(Clipboard, "[\x{00A7}]+", "`n`n +") ;\x{25CB}
                Clipboard:=RegExReplace(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}]+", " ")
                Clipboard:=RegExReplace(Clipboard, "[\x{F0FA}\x{2022}\x{25AA}]+", "`n`n")
                KeyWait, LWin
                SendInput, ^v
                Sleep, 300
                Clipboard:=temp
                keysUp()
                return
            }
        ^+]::
            {
                temp := ClipboardAll
                Clipboard:=""
                SendInput, ^a
                SendInput, ^c
                ClipWait
                Clipboard:=RegExReplace(Clipboard, "([\x{2029}\x{000A}\x{000D}]+)", "$1"Chr(8226)" ")
                KeyWait, LWin
                SendInput, {U+2022}{Space}
                SendInput, ^v
                Sleep, 600
                Clipboard:=temp
                keysUp()
                return
            }
        #f::
            {
                temp := ClipboardAll
                Clipboard:=""
                SendInput, ^c
                ClipWait
                Clipboard:=RegExReplace(Clipboard, "[\r]+", " ")
                Clipboard:=RegExReplace(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}]+", " ")
                KeyWait, LWin
                SendInput, ^v
                Sleep, 600
                Clipboard:=temp
                keysUp()
                return
            }
        }
#IfWinActive

#IfWinActive, ahk_exe OneNote.exe,
    {
        MButton::
            {
                SendInput, +{LButton}
                keysUp()
                return
            }
        F1::
            {
                makeSubPageInOneNote()
                return
            }
        F2::
            {
                altCtrl3()
                ; ctrlOne()
                return
            }
        F3::
            {
                ctrlTwo()
                return
            }
        F4::
            {
                SendInput, {Ctrl Down}u{Ctrl Up}
                KeyWait, Ctrl, T0.1
                return
            }
        F5::
            {
                altCtrlH()
                return
            }
        F6::
            {
                ctrlThree()
                return
            }
        F7::
            {
                ctrlEight()
                return
            }
        F8::
            {
                ctrlFour()
                return
            }
        F9::
            {
                preFormatPasted()
                fontChange()
                return
            }
        ^+::
            {
                pasteDate()
                return
            }
        }
#IfWinActive

#IfWinActive, ahk_exe Code.exe,
    {
        ; MButton::
        ;     {
        ;         SendInput, +{LButton}
        ;         keysUp()
        ;         return
        ;     }
        F1::
            {
                encloseInQuotes()
                return
            }
        ^+d::
            {
                pasteDate()
                return
            }
        }
#IfWinActive

#IfWinActive, ahk_exe msedge.exe,
    {
        F1::
            {
                date := getDateYYYY_MM_DD()
                KeyWait,F1,D
                SendInput,_%date%
                return
            }
        F2::
            {
                savePdf()
                Sleep, 700
                test := Clipboard
                test := RegExReplace(test, "[^0-9a-zA-Z]", "_")
                test := RegExReplace(test, "[_ ]*(pdf)", "")
                test := RegExReplace(test, "[_ ]+", "_")
                test := RegExReplace(test, "^(Indian_)", "")
                test := RegExReplace(test, "^(Module_)", "")
                test := RegExReplace(test, "(_Module_)", "_")
                test := RegExReplace(test, "(^_)", "")
                test := RegExReplace(test, "(_I_)", "_01_")
                test := RegExReplace(test, "(_II_)", "_02_")
                test := RegExReplace(test, "(_III_)", "_03_")
                test := RegExReplace(test, "(_IV_)", "_04_")
                test := RegExReplace(test, "(_V_)", "_05_")
                test := RegExReplace(test, "(_VI_)", "_06_")
                test := RegExReplace(test, "(_VII_)", "_07_")
                test := RegExReplace(test, "(_VIII_)", "_08_")
                test := RegExReplace(test, "(_IX_)", "_09_")
                test := RegExReplace(test, "(_X_)", "_10_")
                test := RegExReplace(test, "(_XI_)", "_11_")
                test := RegExReplace(test, "(_XII_)", "_12_")
                test := RegExReplace(test, "(_XIII_)", "_13_")
                test := RegExReplace(test, "(_XIV_)", "_14_")
                test := RegExReplace(test, "(_XV_)", "_15_")
                test := RegExReplace(test, "(_XVI_)", "_16_")
                test := RegExReplace(test, "(_XVII_)", "_17_")
                test := RegExReplace(test, "(_XVIII_)", "_18_")
                test := RegExReplace(test, "(_XIX_)", "_19_")
                test := RegExReplace(test, "(_XX_)", "_20_")
                test := RegExReplace(test, "(_XXI_)", "_21_")
                test := RegExReplace(test, "(_XXII_)", "_22_")
                test := RegExReplace(test, "(_XXIII_)", "_23_")
                test := RegExReplace(test, "(_XXIV_)", "_24_")
                test := RegExReplace(test, "(_XXV_)", "_25_")
                test := RegExReplace(test, "(Ethics_Integrity_Aptitude_)+(.*)", "EIA_$2")
                test := RegExReplace(test, "(.*)_$", "$1")
                KeyWait, F2
                SendInput, %test%
                keysUp()
                return
            }

        }
        ; Win + Q converts text to capitalized
        #q::
            {
                test := Clipboard
                test := RegExReplace(test, "[^0-9a-zA-Z]", "_")
                test := RegExReplace(test, "[_ ]*(pdf)", "")
                test := RegExReplace(test, "[_ ]+", "_")
                test := RegExReplace(test, "^(Indian_)", "")
                test := RegExReplace(test, "^(Module_)", "")
                test := RegExReplace(test, "(_Module_)", "_")
                test := RegExReplace(test, "(^_)", "")
                test := RegExReplace(test, "(_I_)", "_01_")
                test := RegExReplace(test, "(_II_)", "_02_")
                test := RegExReplace(test, "(_III_)", "_03_")
                test := RegExReplace(test, "(_IV_)", "_04_")
                test := RegExReplace(test, "(_V_)", "_05_")
                test := RegExReplace(test, "(_VI_)", "_06_")
                test := RegExReplace(test, "(_VII_)", "_07_")
                test := RegExReplace(test, "(_VIII_)", "_08_")
                test := RegExReplace(test, "(_IX_)", "_09_")
                test := RegExReplace(test, "(_X_)", "_10_")
                test := RegExReplace(test, "(_XI_)", "_11_")
                test := RegExReplace(test, "(_XII_)", "_12_")
                test := RegExReplace(test, "(_XIII_)", "_13_")
                test := RegExReplace(test, "(_XIV_)", "_14_")
                test := RegExReplace(test, "(_XV_)", "_15_")
                test := RegExReplace(test, "(_XVI_)", "_16_")
                test := RegExReplace(test, "(_XVII_)", "_17_")
                test := RegExReplace(test, "(_XVIII_)", "_18_")
                test := RegExReplace(test, "(_XIX_)", "_19_")
                test := RegExReplace(test, "(_XX_)", "_20_")
                test := RegExReplace(test, "(_XXI_)", "_21_")
                test := RegExReplace(test, "(_XXII_)", "_22_")
                test := RegExReplace(test, "(_XXIII_)", "_23_")
                test := RegExReplace(test, "(_XXIV_)", "_24_")
                test := RegExReplace(test, "(_XXV_)", "_25_")
                test := RegExReplace(test, "(Ethics_Integrity_Aptitude_)+(.*)", "EIA_$2")
                test := RegExReplace(test, "(.*)_$", "$1")
                KeyWait, LWin
                KeyWait, q
                KeyWait, LCtrl
                SendInput, %test%
                keysUp()
                return
            }
        ^q::
            {
                SendInput, {CtrlDown}n{CtrlUp}
                Sleep 50
                SendInput, Module_
                keysUp()
                return
            }
#IfWinActive

#IfWinActive, ahk_exe explorer.exe,
    {
        F1::
            {
                date := getDateYYYY_MM_DD()
                KeyWait,F1,D
                SendInput,%date%_
                return
            }
        F2::
            {
                renameFileDir()
                return
            }
        ^+::
            {
                pasteDate()
                return
            }
        ^F1::
            {
                Gui, Add, Text, , Hotkey: Functionality
                Gui, Add, Text, , Ctrl + F1: Show Mappings
                Gui, Add, Text, , Alt + F1: Show Pressed keys
                Gui, Add, Text, , Alt + F2: Release all pressed keys
                Gui, Add, Text, , Ctrl + Esc: Exit Script
                Gui, Add, Button, , OK
                Gui, Show
                return

                ButtonOK:
                    Gui, Submit, Destroy
                return

                ; ^Esc::
                ; GuiClose:
                ; ExitApp
            }
            CoordMode, ToolTip, Window
            !F1::
                {
                    SetTimer, *F1 Up, % (F1:=!F1)?100:"Off"
                    return
                }
            *F1 Up::
                {
                    ToolTip, % KeyCombination(), 1000, 15
                    return
                }
            }
#IfWinActive

; Functions
ctrlOne()
{
    SendInput, ^1
    return
}
altCtrl3()
{
    SendInput, {Home}
    SendInput, {Enter}
    SendInput, ^!3
    return
}
ctrlTwo()
{
    SendInput,^2
    return
}
ctrlThree()
{
    SendInput, ^3
    return
}
altCtrlH()
{
    SendInput, ^!h
    KeyWait, h, 0.5
    return
}

ctrlEight()
{
    SendInput, ^8
    return
}
ctrlFour()
{
    SendInput, ^4
    return
}
preFormatPasted()
{
    SendInput, ^+r
    SendInput, ^a
    SendInput, ^a
    SendInput, ^u
    SendInput, ^u
    SendInput, ^b
    SendInput, ^b
    SendInput, ^b
    SendInput,!8
    Sleep, 1300
    return
}
fontChange()
{
    SendInput,^{Home}
    Sleep, 50
    SendInput, {LAlt Down}{LAlt Up}
    SendInput, ^a
    SendInput, ^a
    Sleep, 800
    SendInput,!9
    Sleep, 600
    SendInput,Corbel Light
    Sleep, 60
    SendInput,{Enter}
    SendInput,{Esc}^{Home}
    return
}

encloseInQuotes()
{
    temp := ClipboardAll
    Clipboard := ""
    SendInput, ^c ;copies selected text
    ClipWait,0.1
    Send, "
    Send, ^v
    Send, "
    SendInput, {Delete}
    Sleep 50
    Clipboard := temp
    return
}
;Edge save the open pdf in the default directory
savePdf()
{
    KeyWait, F2,
    ; KeyWait, #,
    SendInput, ^s
    KeyWait, s, T0.2
    KeyWait, LCtrl, T0.2
    return
}
;Windows Explorer Rename select File/ Directory
renameFileDir()
{
    SendInput, {F2}
    Keywait,F2,D
    return
}

^+d::
    {
        pasteTimeStamp()
        keysUp()
        return
    }
!+d::
    {
        pasteDate()
        keysUp()
        return
    }

    getCurrentDate()
    {
        date:=""
        FormatTime, date,, yyyy_MM_dd
        KeyWait, ^
        return date
    }
    getCurrentTimeStamp()
    {
        date:=""
        FormatTime, date,, yyyy_MM_dd : HH_mm_ss
        ; KeyWait, ^
        return date
    }
    getDateYYYY_MM_DD()
    {
        date:=""
        FormatTime, date,, yyyy_MM_dd
        KeyWait, ^
        return date
    }
    keysUp()
    {
        Loop, 0xFF
            IF GetKeyState(Key:=Format("VK{:X}",A_Index))
                SendInput, {%Key% up}
        return
    }

    pasteDate()
    {
        temp :=ClipboardAll
        Sleep, 100
        Clipboard := getCurrentDate()
        ClipWait, 1
        SendInput, ^v
        Sleep, 500
        Clipboard:=temp
        return
    }

    pasteTimeStamp()
    {
        temp :=ClipboardAll
        Sleep, 100
        Clipboard := getCurrentTimeStamp()
        ClipWait, 1
        SendInput, ^v
        Sleep, 500
        Clipboard:=temp
        return
    }

    paste()
    {
        temp := Clipboard
        StringSplit, wordList, temp, %A_Space%
        Loop, %wordList0%
        {
            this_word := wordList%A_Index%
            SendInput,%this_word%
            Sleep, 50
            SendInput, %A_Space%
            Sleep, 30
        }
    }
^8::
    {
        SendInput, {U+00B0}
        return
    }

#x::
    {
        SendInput, {Delete}{Enter}
        return
    }

    makeSubPageInOneNote()
    {
        temp := ClipboardAll
        Clipboard := ""
        SendInput, ^c ;copies selected text
        ClipWait, 0.5
        if(Clipboard = ""){
            InputBox, vPicked, Enter the page name, , 389, 375, , , , , , Cancel
            Gui, Show
            Gui, Submit
            if(vPicked != "Cancel")
            {
                SendInput, [[%vPicked%]]
                KeyWait, ]
            }
            Gui, Destroy
            return
        }
        Send, [[
        Send, ^v
        Send, ]]
        Sleep 50
        Clipboard := temp
        return
    }

    ;f2 Make a Infographics toggle, Expand it, and enter into it - Undo redo at same spot has a known bug
    makeInfographicsToggleInNotion()
    {
        SendInput, Infographics
        SendInput, ^+7
        SendInput, {Enter}
        KeyWait, Enter,
        SendInput, {CtrlUp}
        return
    }

;Activates Aeon Timeline window if opened in the background
#t::
    {
        SetTitleMatchMode, 2
        IfWinExist,Aeon Timeline
        {
            ifWinActive
            {
                WinActivatebottom,Aeon Timeline
            }
            else
            {
                WinActivate
            }
        }
        else
        {
            Run "C:\Program Files (x86)\Aeon Timeline 2\AeonTimeline2.exe"
        }
        keysUp()
        return
    }
;Activates folder if opened in the background
#b::
    {
        SetTitleMatchMode, 2
        IfWinExist,Webinar Handouts
        {
            ifWinActive
            {
                WinActivatebottom,Webinar Handouts
            }
            else
            {
                WinActivate
            }
        }
        else
        {
            Run "G:\My Drive\Byjus\Webinar Handouts"
        }
        keysUp()
        return
    }
;Activates OneNote window if open in the background
#o::
    {
        SetTitleMatchMode, 2
        IfWinExist,OneNote
        {
            ifWinActive
            {
                WinActivatebottom,OneNote
            }
            else
            {
                WinActivate
            }
        }
        else
        {
            Run "C:\Program Files\Microsoft Office\root\Office16\ONENOTE.EXE"
        }
        keysUp()
        return
    }

;Activates VSCode window if open in the background
!#c::
    {
        SetTitleMatchMode, 2
        IfWinExist,Visual Studio Code
        {
            ifWinActive
            {
                WinActivatebottom,Visual Studio Code
            }
            else
            {
                WinActivate
            }
        }
        else
        {
            ; MsgBox, 1, Title, "No Visual Studio Code Window exists", 1
            Run "C:\Users\Mithun\AppData\Local\Programs\Microsoft VS Code\Code.exe"
        }
        keysUp()
        return
    }

;Activates Edge window if open in the background
!#e::
    {
        SetTitleMatchMode, 2
        IfWinExist,Edge
        {
            ifWinActive
            {
                WinActivatebottom,Edge
            }
            else
            {
                WinActivate
            }
        }
        else
        {
            Run, "https://mail.google.com/mail/u/1/#label/01.+Byjus`%2F01_Online+Classroom" --new-window
        }
        keysUp()
        return
    }

;Activates Notion window if open in the background
!#n::
    {
        SetTitleMatchMode, 2
        IfWinExist,ahk_exe Notion.exe,
        {
            ifWinActive
            {
                WinActivatebottom,ahk_exe Notion.exe
            }
            else
            {
                WinActivate
            }
        }
        else
        {
            Run "C:\Users\Mithun\AppData\Local\Programs\Notion\Notion.exe"
        }
        keysUp()
        return
    }

;Activates Notion window if open in the background
!#i::
    {
        SetTitleMatchMode, 2
        IfWinExist,ahk_exe idea64.exe,
        {
            ifWinActive
            {
                WinActivatebottom,ahk_exe idea64.exe
            }
            else
            {
                WinActivate
            }
        }
        else
        {
            Run, "C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2022.2.1\bin\idea64.exe"
        }
        keysUp()
        return
    }

;Activates VLC player window if open in the background
!#v::
    {
        SetTitleMatchMode, 2
        IfWinExist,ahk_exe vlc.exe,
        {
            ifWinActive
            {
                WinActivatebottom,ahk_exe vlc.exe
            }
            else
            {
                WinActivate
            }
        }
        else
        {
            Run, "C:\Program Files\VideoLAN\VLC\vlc.exe"
        }
        keysUp()
        return
    }

    toUpperCaseText(){
        temp := ClipboardAll
        Clipboard :=""
        SendInput, ^c ;copies selected text
        ClipWait
        StringUpper, str, Clipboard ; Title mode conversion
        pos := RegExMatch(Clipboard, "(.*\s$)")
        ; MsgBox, 1, Title, Pos :%pos%---Str :%str%---Clip: %Clipboard%, 50
        Clipboard := str
        If (pos==0)
        {
            SendInput,^v
        }
        Else
        {
            SendInput,^v
            SendInput, {Space}
        }
        KeyWait, Ctrl,
        keysUp()
        Sleep, 400
        Clipboard := temp
        temp:=""
        return
    }

    toggleTitleCase(){
        temp :=ClipboardAll
        Clipboard:=""
        SendInput, ^c
        ClipWait, 1
        if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.:;]$")){
            Clipboard:=""
            SendInput,+{Left}
            SendInput ^c
            ClipWait, 1
        }
        If (flag_titlecase < 2){
            flag_titlecase := flag_titlecase + 1
        }Else{
            flag_titlecase = 1
        }
        switch flag_titlecase
        {
        case 1: StringUpper, Clipboard, Clipboard, T
        case 2: StringLower, Clipboard, Clipboard,
        default: MsgBox, 1, "Value of flag_titlecase", %flag_titlecase%,
        }
        SendInput, ^v
        keysUp()
        Sleep, 500
        Clipboard:=temp
        temp:=""
        return
    }

    toggleUpperCase(){
        temp :=ClipboardAll
        Clipboard:=""
        SendInput, ^c
        ClipWait, 1
        if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.:;]$")){
            Clipboard:=""
            SendInput,+{Left}
            SendInput ^c
            ClipWait, 1
        }
        If (flag_uppercase < 2){
            flag_uppercase := flag_uppercase + 1
        }Else{
            flag_uppercase = 1
        }
        switch flag_uppercase
        {
        case 1: StringUpper, Clipboard, Clipboard,
        case 2: StringLower, Clipboard, Clipboard,
        default: MsgBox, 1, "Value of flag_uppercase", %flag_uppercase%,
        }
        SendInput, ^v
        keysUp()
        Sleep, 200
        Clipboard:=temp
        temp:=""
        return
    }

    toggleLowerCase(){
        temp :=ClipboardAll
        Clipboard:=""
        SendInput, ^c
        ClipWait, 1
        if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.:;]$")){
            Clipboard:=""
            SendInput,+{Left}
            SendInput ^c
            ClipWait, 1
        }
        If (flag_lowercase < 2){
            flag_lowercase := flag_lowercase + 1
        }Else{
            flag_lowercase = 1
        }
        switch flag_lowercase
        {
        case 1: StringLower, Clipboard, Clipboard,
        case 2: StringUpper, Clipboard, Clipboard,
        default: MsgBox, 1, "Value of flag_lowercase", %flag_lowercase%,
        }
        SendInput, ^v
        keysUp()
        Sleep, 200
        Clipboard:=temp
        temp:=""
        return
    }

    checkIfEndSpecialCharacter()
    {
        SendInput, ^c
        ClipWait, 1
        pos := RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.]$")
        return pos
    }

    capitalizeText(){
        temp := ClipboardAll
        Clipboard :=""
        SendInput, ^c ;copies selected text
        ClipWait
        StringUpper, str, Clipboard, T ; Title mode conversion
        Clipboard := str
        SendInput,^v
        KeyWait, Ctrl,
        keysUp()
        Clipboard := temp
        return
    }

^+v::
    {
        toggleTitleCase()
        SetTimer, resetFlags, -2000
        return
    }

    PasteThis(text) ; use Ctrl+v instead of Send in order to avoid triggering auto-completion in certain environments
    {
        Static tmp_clip, tmp_clip2
        While, tmp_clip <> tmp_clip2
            Sleep, 10 ;restoration not yet finished
        tmp_clip := ClipboardAll ; preserve Clipboard
        ClipBoard := text
        While, tmp_clip2 <> text
            tmp_clip2 := ClipBoard ;validate clipboard
        Send, ^v
        SetTimer, restoration, -500
        return ;don't waste time waiting for restoration
        restoration:
            ClipBoard := tmp_clip ; restore the clipboard
            While, tmp_clip <> tmp_clip2
                tmp_clip2 := ClipBoardAll ;validate clipboard
            tmp_clip:="", tmp_clip2:=""
        return
    }

    CoordMode, ToolTip, Window
    ; !F2::
    ;     {
    ;         Loop, 0xFF
    ;             IF GetKeyState(Key:=Format("VK{:X}",A_Index))
    ;                 SendInput, {%Key% up}
    ;         return
    ;     }
    KeyCombination(ExcludeKeys:="")
    { ;All pressed keys and buttons will be listed
        ExcludeKeys .= "{Shift}{Control}{Alt}{WheelUp}{WheelDown}"
        Loop, 0xFF
        {
            IF !GetKeyState(Key:=Format("VK{:02X}",0x100-A_Index))
                Continue
            If !InStr(ExcludeKeys, Key:="{" GetKeyName(Key) "}")
                KeyCombination .= RegexReplace(Key,"Numpad(\D+)","$1")
        }
        return, KeyCombination
    }

    browser := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    ^g::
        {
            BlockInput, on
            prevClipboard := ClipboardAll
            clipboard := ""
            Send, ^c
            BlockInput, off
            ClipWait, 2
            if ErrorLevel = 0
            {
                searchQuery:=clipboard
                GoSub, GoogleSearch
            }
            clipboard := prevClipboard
            VarSetCapacity(prevClipboard, 0)
            keysUp()
            return
        }
    GoogleSearch:
        StringReplace, searchQuery, searchQuery, `r`n, %A_Space%, All
        Loop
        {
            noExtraSpaces:=1
            StringLeft, leftMost, searchQuery, 1
            IfInString, leftMost, %A_Space%
            {
                StringTrimLeft, searchQuery, searchQuery, 1
                noExtraSpaces:=0
            }
            StringRight, rightMost, searchQuery, 1
            IfInString, rightMost, %A_Space%
            {
                StringTrimRight, searchQuery, searchQuery, 1
                noExtraSpaces:=0
            }
            If (noExtraSpaces==1)
                break
        }
        StringReplace, searchQuery, searchQuery, \, `%5C, All
        StringReplace, searchQuery, searchQuery, %A_Space%, +, All
        StringReplace, searchQuery, searchQuery, `%, `%25, All
        IfInString, searchQuery, .
        {
            IfInString, searchQuery, +
                Run, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" http://www.google.com/search?hl=en&q=%searchQuery%
else
    Run, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" %searchQuery%
        }
        else
            Run, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" http://www.google.com/search?hl=en&q=%searchQuery%
    return

    ^+g::
        {
            BlockInput, on
            prevClipboard = %ClipboardAll%
            clipboard =
            Send, ^c
            BlockInput, off
            ClipWait, 2
            if ErrorLevel = 0
            {
                searchQuery=%clipboard%
                GoSub, GoogleImageSearch
            }
            clipboard = %prevClipboard%
            VarSetCapacity(prevClipboard, 0)
            keysUp()
            return
        }
    GoogleImageSearch:
        StringReplace, searchQuery, searchQuery, `r`n, %A_Space%, All
        searchQuery := %searchQuery% + " map"
        Loop
        {
            noExtraSpaces:=1
            StringLeft, leftMost, searchQuery, 1
            IfInString, leftMost, %A_Space%
            {
                StringTrimLeft, searchQuery, searchQuery, 1
                noExtraSpaces:=0
            }
            StringRight, rightMost, searchQuery, 1
            IfInString, rightMost, %A_Space%
            {
                StringTrimRight, searchQuery, searchQuery, 1
                noExtraSpaces:=0
            }
            If (noExtraSpaces==1)
                break
        }
        StringReplace, searchQuery, searchQuery, \, `%5C, All
        StringReplace, searchQuery, searchQuery, %A_Space%, +, All
        StringReplace, searchQuery, searchQuery, `%, `%25, All
        IfInString, searchQuery, .
        {
            IfInString, searchQuery, +
                Run, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" http://www.google.com/search?hl=en&q=%searchQuery%&tbm=isch
else
    Run, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" %searchQuery%
        }
        else
            Run, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" http://www.google.com/search?hl=en&q=%searchQuery%&tbm=isch
    return

    resetFlags()
    {
        flag_titlecase := 0
        flag_uppercase := 0
        flag_lowercase := 0
        Return
    }
    escapeSpaceAtEndOfSelection(){

        if(RegExMatch(Clipboard, "[\x{0020}\x{00A0}\x{1680}\x{180E}\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{202F}\x{205F}\x{3000}\x{FEFF}\s,.:;’""']$"))
        {
            SendInput, +{Left}
        }
    }