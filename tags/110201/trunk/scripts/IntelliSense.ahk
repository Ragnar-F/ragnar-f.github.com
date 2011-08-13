; IntelliSense -- von Rajat (ben�tigt XP/2k/NT)
; http://www.autohotkey.com
; Dieses Script �berwacht die Benutzereingaben beim Bearbeiten eines AutoHotkey-Scripts.  Sobald ein Befehl
; gefolgt von einem Komma oder eines Leerzeichens eingegeben wird,
; dann wird als Hilfe die Parameterliste des Befehls angezeigt.  Dar�ber hinaus kann Strg+F1 (oder
; ein anderer Hotkey) gedr�ckt werden, um die Befehlsseite in der Hilfe-Datei anzuzeigen.
; Um die Parameterliste zu schlie�en, dr�ckt Escape oder Enter.

; Ben�tigt v1.0.41+

; KONFIGURATIONSBEREICH: Passt das Script mit den folgenden Variablen an.

; Der unten genannte Hotkey wird gedr�ckt, um die aktuelle Befehlsseite in der
; Hilfedatei anzuzeigen:
I_HelpHotkey = ^F1

; Der nachfolgende String muss irgendwo im Titel des aktiven Fensters vorkommen,
; damit IntelliSense bei der Benutzereingabe wirksam wird.  Macht sie leer,
; damit IntelliSense alle Fenster bearbeitet.  Wenn sie Pad enth�lt,
; dann werden Editoren wie Metapad, Notepad und Textpad bearbeitet.  Falls .ahk vorhanden ist,
; dann ist IntelliSense nur wirksam, wenn eine .ahk-Datei im Editor offen ist.
I_Editor = pad

; Wenn der Wunsch besteht, ein anderes Icon f�r dieses Script zu verwenden,
; damit es sich von anderen Scripts unterscheidet, gebt unten den Dateinamen an
; (leer lassen f�r kein Icon). Zum Beispiel: E:\stuff\Pics\icons\GeoIcons\Information.ico
I_Icon = 

; ENDE DES KONFIGURATIONSBEREICHS (Hier danach keine �nderungen durchf�hren,
; es sei denn, die allgemeine Funktionalit�t des Scripts soll ge�ndert werden).

SetKeyDelay, 0
#SingleInstance

if I_HelpHotkey <>
	Hotkey, %I_HelpHotkey%, I_HelpHotkey

; Tray-Icon �ndern (falls ein Icon im Konfigurationsbereich angegeben wurde):
if I_Icon <>
	IfExist, %I_Icon%
		Menu, Tray, Icon, %I_Icon%

; Standort von AutoHotkey ermitteln:
RegRead, ahk_dir, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir
if ErrorLevel  ; Nichts gefunden, so in anderen h�ufigen Standorten nachschauen.
{
	if A_AhkPath
		SplitPath, A_AhkPath,, ahk_dir
	else IfExist ..\..\AutoHotkey.chm
		ahk_dir = ..\..
	else IfExist %A_ProgramFiles%\AutoHotkey\AutoHotkey.chm
		ahk_dir = %A_ProgramFiles%\AutoHotkey
	Else
	{
		MsgBox AutoHotkey-Ordner konnte nicht gefunden werden.
		ExitApp
	}
}

ahk_help_file = %ahk_dir%\AutoHotkey.chm

; Befehlssyntax lesen:
Loop, Read, %ahk_dir%\Extras\Editors\Syntax\Commands.txt
{
	I_FullCmd = %A_LoopReadLine%

	; Anweisungen haben ein erstes Leerzeichen anstelle eines ersten Kommas.
	; So wird je nach dem verwendet, was zuerst als Endzeichen im Befehlsnamen vorkommt:
	StringGetPos, I_cPos, I_FullCmd, `,
	StringGetPos, I_sPos, I_FullCmd, %A_Space%
	if (I_cPos = -1 or (I_cPos > I_sPos and I_sPos <> -1))
		I_EndPos := I_sPos
	Else
		I_EndPos := I_cPos

	if I_EndPos <> -1
		StringLeft, I_CurrCmd, I_FullCmd, %I_EndPos%
	else  ; Eine Anweisung/ein Befehl ohne Parameter.
		I_CurrCmd = %A_LoopReadLine%
	
	StringReplace, I_CurrCmd, I_CurrCmd, [,, All
	StringReplace, I_CurrCmd, I_CurrCmd, %A_Space%,, All
	StringReplace, I_FullCmd, I_FullCmd, ``n, `n, All
	StringReplace, I_FullCmd, I_FullCmd, ``t, `t, All
	
	; Arrays mit Befehlsnamen und vollst�ndige Befehlssyntax erstellen:
	I_Cmd%A_Index% = %I_CurrCmd%
	I_FullCmd%A_Index% = %I_FullCmd%
}

; Input-Befehl verwenden, um die eingegebenen Befehle des Benutzers zu �berwachen:
Loop
{
	; Editor-Fenster �berpr�fen:
	WinGetTitle, ActiveTitle, A
	IfNotInString, ActiveTitle, %I_Editor%
	{
		ToolTip
		Sleep, 500
		Continue
	}
	
	; Alle Tasten bis zur Endtaste abrufen:
	Input, I_Word, V, {enter}{escape}{space}`,
	I_EndKey = %ErrorLevel%
	
	; ToolTip wird in folgenden F�llen versteckt:
	if I_EndKey in EndKey:Enter,EndKey:Escape
	{
		ToolTip
		Continue
	}

	; Nochmals Editor-Fenster �berpr�fen!
	WinGetActiveTitle, ActiveTitle
	IfNotInString, ActiveTitle, %I_Editor%
	{
		ToolTip
		Continue
	}

	; Jede vorhandene Einr�ckung ersetzen:
	StringReplace, I_Word, I_Word, %A_Space%,, All
	StringReplace, I_Word, I_Word, %A_Tab%,, All
	if I_Word =
		Continue
	
	; Kommentierte Zeile untersuchen:
	StringLeft, I_Check, I_Word, 1
	if (I_Check = ";" or I_Word = "If")  ; "If" ist scheinbar ein wenig st�rend, um daf�r den ToolTip anzuzeigen.
		Continue

	; Wort stimmt mit Befehl �berein:
	I_Index =
	Loop
	{
		; Es hilft der Performance, wenn dynamische Variablen nur einmal aufgel�st werden.
		; Dar�ber hinaus wird der eingef�gte Wert in I_ThisCmd auch von der
		; I_HelpHotkey-Subroutine verwendet:
		I_ThisCmd := I_Cmd%A_Index%
		if I_ThisCmd =
			break
		if (I_Word = I_ThisCmd)
		{
			I_Index := A_Index
			I_HelpOn = %I_ThisCmd%
			break
		}
	}
	
	; Falls keine �bereinstimmung erfolgt, dann Benutzereingabe weiter �berwachen:
	if I_Index =
		Continue
	
	; �bereinstimmende Befehle anzeigen, um den Benutzer zu f�hren:
	I_ThisFullCmd := I_FullCmd%I_Index%
	ToolTip, %I_ThisFullCmd%, A_CaretX, A_CaretY + 20
}



I_HelpHotkey:
WinGetTitle, ActiveTitle, A
IfNotInString, ActiveTitle, %I_Editor%, Return

ToolTip  ; Syntaxhelfer deaktivieren, da er zurzeit nicht ben�tigt wird.

SetTitleMatchMode, 1  ; Falls es 3 ist. Diese Einstellung gilt nur f�r diesen Thread.
IfWinNotExist, AutoHotkey Help
{
	IfNotExist, %ahk_help_file%
	{
		MsgBox, Hilfe-Datei konnte nicht gefunden werden: %ahk_help_file%.
		Return
	}
	Run, %ahk_help_file%
	WinWait, AutoHotkey Help
}

if I_ThisCmd =  ; Stattdessen wird die aktuellste Benutzereingabe verwendet.
	I_ThisCmd := I_Word

; Der obere Befehl bestimmt das "zuletzt gefundene" Fenster, das unten verwendet wird:
WinActivate
WinWaitActive
StringReplace, I_ThisCmd, I_ThisCmd, #, {#}  ; F�hrende # ersetzen, falls vorhanden.
Send, !n{home}+{end}%I_HelpOn%{enter}
Return
