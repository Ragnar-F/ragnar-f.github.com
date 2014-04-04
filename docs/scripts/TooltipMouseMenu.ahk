; ToolTip-Mausmen� (ben�tigt XP/2k/NT) -- von Rajat
; http://www.autohotkey.com
; Dieses Script zeigt ein aufklappbares Men� beim kurzen
; Dr�cken der mittleren Maustaste an.  Ein Men�punkt kann mit einem Linksklick ausgew�hlt werden.
; Das Men� wird geschlossen, sobald au�erhalb des Men�s mit der linken Maustaste geklickt wird.  Als aktuelle Verbesserung
; kann der Inhalt des Men�s ge�ndert werden, abh�ngig davon,
; welcher Fenstertyp aktiv ist (Notepad und Word wurden hier als Beispiele verwendet).

; Hier kann ein beliebiger Titel f�r das Men� angegeben werden:
MenuTitle = -=-=-=-=-=-=-=-

; Damit wird die Druckdauer der Maustaste bestimmt, bis das Men� angezeigt wird:
UMDelay = 20

SetFormat, float, 0.0
SetBatchLines, 10ms
SetTitleMatchMode, 2
#SingleInstance


;___________________________________________
;_____Men�-Definitionen_____________________

; Hier k�nnen die Men�punkte erstellt oder bearbeitet werden.
; Es d�rfen keine Leerzeichen im Schl�ssel-/Wert-/Bereichssnamen verwendet werden.

; Mach dir keine Sorgen �ber die Reihenfolge, das Men� wird sortiert.

MenuItems = Editor/Rechner/Bereich 3/Bereich 4/Bereich 5


;___________________________________________
;______Hier dynamische Men�punkte___________

; Syntax:
;     Dyn# = Men�punkt|Fenstertitel

Dyn1 = MS Word|- Microsoft Word
Dyn2 = Editor II|- Editor

;___________________________________________

Exit


;___________________________________________
;_____Men�bereiche__________________________

; Hier k�nnen die Men�bereiche erstellt oder bearbeitet werden.

Editor:
Run, Notepad.exe
Return

Rechner:
Run, Calc
Return

Bereich3:
MsgBox, 3 ausgew�hlt
Return

Bereich4:
MsgBox, 4 ausgew�hlt
Return

Bereich5:
MsgBox, 5 ausgew�hlt
Return

MSWord:
msgbox, Das ist ein dynamischer Eintrag (Word)
Return

EditorII:
msgbox, Das ist ein dynamischer Eintrag (Editor)
Return


;___________________________________________
;_____Hotkey-Bereich________________________

~MButton::
HowLong = 0
Loop
{
    HowLong ++
    Sleep, 10
    GetKeyState, MButton, MButton, P
    IfEqual, MButton, U, Break
}
IfLess, HowLong, %UMDelay%, Return


; Dynamisches Men� vorbereiten
DynMenu =
Loop
{
    IfEqual, Dyn%a_index%,, Break

    StringGetPos, ppos, dyn%a_index%, |
    StringLeft, item, dyn%a_index%, %ppos%
    ppos += 2
    StringMid, win, dyn%a_index%, %ppos%, 1000

    IfWinActive, %win%,
        DynMenu = %DynMenu%/%item%
}


; Sortiertes Hauptmen� mit dynamisches Men� verbinden
Sort, MenuItems, D/
TempMenu = %MenuItems%%DynMenu%


; Fr�here Eintr�ge entfernen
Loop
{
    IfEqual, MenuItem%a_index%,, Break
    MenuItem%a_index% =
}

; Neue Eintr�ge erstellen
Loop, Parse, TempMenu, /
{
    MenuItem%a_index% = %a_loopfield%
}

; Das Men� erstellen
Menu = %MenuTitle%
Loop
{
    IfEqual, MenuItem%a_index%,, Break
    numItems ++
    StringTrimLeft, MenuText, MenuItem%a_index%, 0
    Menu = %Menu%`n%MenuText%
}

MouseGetPos, mX, mY
HotKey, ~LButton, MenuClick
HotKey, ~LButton, On
ToolTip, %Menu%, %mX%, %mY%
WinActivate, %MenuTitle%
Return


MenuClick:
HotKey, ~LButton, Off
IfWinNotActive, %MenuTitle%
{
    ToolTip
    Return
}

MouseGetPos, mX, mY
ToolTip
mY -= 3        ; Platz, bevor die erste Zeile startet
mY /= 13    ; Ben�tigter Platz jeder Zeile
IfLess, mY, 1, Return
IfGreater, mY, %numItems%, Return
StringTrimLeft, TargetSection, MenuItem%mY%, 0
StringReplace, TargetSection, TargetSection, %a_space%,, A
Gosub, %TargetSection%
Return
