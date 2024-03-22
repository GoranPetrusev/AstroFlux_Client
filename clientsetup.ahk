#SingleInstance Force
steamPath := "C:\Program Files (x86)\Steam\steamapps\common\Astroflux"
itchPath := "C:\Program Files (x86)\Astroflux"
steamSWF := "C:\Users\%A_UserName%\Downloads\Astroflux.swf"
itchSWF := "C:\Users\%A_UserName%\Downloads\AstrofluxDesktop.swf"
client := "C:\Users\%A_UserName%\Downloads\client.swf"
FileGetAttrib, steamAFexists, %steamPath%
FileGetAttrib, itchAFexists, %itchPath%
FileGetAttrib, AFswfExists, C:\Users\%A_UserName%\Downloads\Astroflux.swf
FileGetAttrib, AFDswfExists, C:\Users\%A_UserName%\Downloads\AstrofluxDesktop.swf
FileGetAttrib, clientExists, C:\Users\%A_UserName%\Downloads\client.swf
steamAFexists := Exists(steamAFexists)
itchAFexists := Exists(itchAFexists)
AFswfExists := Exists(AFswfExists)
AFDswfExists := Exists(AFDswfExists)
clientExists := Exists(clientExists)

if (!clientExists) {
MsgBox, 0x30, Client Setup, The main client file is not detected. Please ensure that it is downloaded and the file is in your Downloads folder.
ExitApp
}

if (steamAFexists && !itchAFexists) {
if (AFswfExists) {
ModifySteam()
} else {
MsgBox, 0x30, Client Setup, The Astroflux.swf file is not detected. Please ensure that it is downloaded and the file is in your Downloads folder.
ExitApp
}
} else if (itchAFexists && !steamAFexists) {
if (AFDswfExists) {
ModifyItch()
} else {
MsgBox, 0x30, Client Setup, The AstrofluxDesktop.swf file is not detected. Please ensure that it is downloaded and the file is in your Downloads folder.
ExitApp
}
} else if (itchAFexists && steamAFexists) {
if (AFswfExists && !AFDswfExists) {
ModifySteam()
} else if (AFDswfExists && !AFswfExists) {
ModifyItch()
} else if (AFDswfExists && AFswfExists) {
ModifySteam(True)
ModifyItch(True)
} else {
MsgBox, 0x30, Client Setup, The Astroflux(Desktop).swf file is not detected. Please ensure that it is downloaded and the file is in your Downloads folder.
}
} else {
MsgBox, 0x30, Client Setup, You do not have the game installed. Please install the game and try again.
ExitApp
}


ModifySteam(param1:=False) {
MsgBox, 0x24, Client Setup, The necessary files were found for the steam version to be modified. Continue?
IfMsgBox, Yes 
{
FileMove, C:\Users\%A_UserName%\Downloads\Astroflux.swf, C:\Program Files (x86)\Steam\steamapps\common\Astroflux, 1
FileMove, C:\Users\%A_UserName%\Downloads\client.swf, C:\Program Files (x86)\Steam\steamapps\common\Astroflux, 1
MsgBox, 0x40, Client Setup, Attempted to move the files. Open the game normally to see if it worked.
}
if (param1) {
return
}
ExitApp
}

ModifyItch(param1:=False) {
MsgBox, 0x24, Client Setup, The necessary files were found for the itch.io version to be modified. Continue?
IfMsgBox, Yes
{
if (param1) {
FileCopy, C:\Program Files (x86)\Steam\steamapps\common\Astroflux\client.swf, C:\Users\%A_UserName%\Downloads
}
FileMove, C:\Users\%A_UserName%\Downloads\AstrofluxDesktop.swf, C:\Program Files (x86)\Astroflux, 1
FileMove, C:\Users\%A_UserName%\Downloads\client.swf, C:\Program Files (x86)\Astroflux, 1
MsgBox, 0x40, Client Setup, Attempted to move the files. Open the game normally to see if it worked.
}
ExitApp
}

Exists(param1) {
if (param1 == "") {
return False
} else {
return True
}
}
