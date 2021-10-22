file = E:\pfp22.png
Gui, New
Gui, Add, Picture,, %file%
Gui, Color, %color%
Gui, +LastFound -Caption +AlwaysOnTop +ToolWindow -Border
Gui, Show, x0 y0


f4::exitapp
