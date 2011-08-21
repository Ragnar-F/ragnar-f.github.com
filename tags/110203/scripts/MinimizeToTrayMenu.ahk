; Fenster in das Tray-Men� minimieren
; http://www.autohotkey.com
; Dieses Script erm�glicht einem beliebigen Hotkey, ein beliebiges Fenster zu verstecken,
; damit es als Men�punkt am Ende des Tray-Men�s angezeigt wird.  Versteckte
; Fenster k�nnen dann wieder einzeln oder alle auf einmal sichtbar gemacht werden,
; indem der entsprechende Men�punkt ausgew�hlt wird.  Falls das Script aus irgendeinem Grund beendet wird,
; werden alle versteckten Fenster wieder automatisch sichtbar gemacht.

; �NDERUNGEN:
; 22. Juli 2005 (bereitgestellte �nderungen von egilmour):
; - Neuer Hotkey hinzugef�gt, um das zuletzt versteckte Fenster wieder sichtbar zu machen (Win+U)
;
; 3. November 2004 (bereitgestellte �nderungen von trogdor):
; - Programm-Manager kann nicht mehr versteckt werden.
; - Falls kein aktives Fenster vorhanden ist, dann ist der In-Tray-minimieren-Hotkey nicht aktiv,
;   anstatt unendlich lang zu warten.
;
; 23. Oktober 2004:
; - Tastleiste kann nicht mehr versteckt werden.
; - M�gliche Probleme mit langen Fenstertiteln wurden behoben.
; - Fenster ohne Titel k�nnen ohne Probleme versteckt werden.
; - Wenn das Script unter AHK v1.0.22 oder h�her ausgef�hrt wird,
;   dann wird die maximale L�nge jeden Men�punkts von 100 auf 260 erh�ht.

; KONFIGURATIONSBEREICH: �ndert die unteren Werte je nach Bedarf.

; Die maximale Anzahl der Fenster, die versteckt werden k�nnen (hilft
; der Performance):
mwt_MaxWindows = 50

; Der Hotkey, um das aktive Fenster zu verstecken:
mwt_Hotkey = #h  ; Win+H

; Der Hotkey, um das zuletzt versteckte Fenster wieder sichtbar zu machen:
mwt_UnHotkey = #u  ; Win+U

; Falls der Wunsch besteht, keine vorgegebenen Men�punkte
; wie Help und Pause anzuzeigen, verwendet N.  Ansonsten Y:
mwt_StandardMenu = N

; Die n�chsten Performance-Einstellungen helfen dabei, die Aktion innerhalb
; der #HotkeyModifierTimeout-Periode durchzuf�hren, daher m�ssen die Modifikatoren
; des Hotkeys nicht erst gedr�ckt und wieder losgelassen werden,
; wenn mehr als ein Fenster gleichzeitig versteckt werden soll.  Diese Einstellungen verhindern, dass der Tastatur-Hook mithilfe von
; #InstallKeybdHook oder �hnliches manuell gesetzt werden muss:
#HotkeyModifierTimeout 100
SetWinDelay 10
SetKeyDelay 0

#SingleInstance  ; Dadurch kann nur eine Instanz des Scripts ausgef�hrt werden.

; ENDE DES KONFIGURATIONSBEREICHS (Hier danach keine �nderungen durchf�hren,
; es sei denn, die allgemeine Funktionalit�t des Scripts soll ge�ndert werden).

Hotkey, %mwt_Hotkey%, mwt_Minimize
Hotkey, %mwt_UnHotkey%, mwt_UnMinimize

; Wenn der Benutzer das Script irgendwie beendet, dann zuerst
; alle Fenster wieder sichtbar machen:
OnExit, mwt_RestoreAllThenExit

if mwt_StandardMenu = Y
	Menu, Tray, Add
Else
{
	Menu, Tray, NoStandard
	Menu, Tray, Add, &Beenden und Fenster sichtbar machen, mwt_RestoreAllThenExit
}
Menu, Tray, Add, &Alle versteckten Fenster sichtbar machen, mwt_RestoreAll
Menu, Tray, Add  ; Eine weitere Trennlinie, um die obigen Men�punkte abzugrenzen.

if a_AhkVersion =   ; Falls leer, dann ist die Version �lter als 1.0.22.
	mwt_MaxLength = 100
Else
	mwt_MaxLength = 260  ; Verringern, um die Breite des Men�s zu begrenzen.

Return ; Ende des automatischen Ausf�hrungsbereichs.


mwt_Minimize:
if mwt_WindowCount >= %mwt_MaxWindows%
{
	MsgBox Es k�nnen nicht mehr als %mwt_MaxWindows% gleichzeitig versteckt werden.
	Return
}

; Bestimmt das zuletzt gefundene Fenster f�r die einfache Verwendung und Performance.
; Es kann vorkommen, dass kein aktives Fenster vorhanden ist,
; daher wurde eine Zeit�berschreitung hinzugef�gt:
WinWait, A,, 2
if ErrorLevel <> 0  ; Zeit �berschritten, daher nichts tun.
	Return

; Ansonsten wurde das "zuletzt gefundene Fenster" gesetzt und kann nun verwendet werden:
WinGet, mwt_ActiveID, ID
WinGetTitle, mwt_ActiveTitle
WinGetClass, mwt_ActiveClass
if mwt_ActiveClass in Shell_TrayWnd,Progman
{
	MsgBox Der Desktop und die Taskleiste k�nnen nicht versteckt werden.
	Return
}
; Da das Fenster beim Verstecken nicht deaktiviert wird, wird das Fenster
; darunter aktiviert (falls vorhanden). Ich habe andere Wege ausprobiert, was aber dazu f�hrte,
; dass die Taskleiste aktiviert wurde.  Mit diesem Weg wird das aktive Fenster (welches
; versteckt werden soll) ans Ende des Stapels verschoben, dass scheinbar am besten ist:
Send, !{esc}
; Nun das Fenster verstecken, das mit WinGetTitle/WinGetClass verwendet wurde (da
; standardm��ig solche Befehle keine versteckten Fenster erkennen k�nnen):
WinHide

; Wenn der Titel leer ist, dann wird die Klasse stattdessen verwendet.  Dies dient zwei Aufgaben:
; 1) Ein aussagekr�ftiger Name wird als Men�name verwendet.
; 2) Damit kann der Men�punkt erstellt werden (ansonsten w�rden leere Men�punkte
;    nicht korrekt von den unteren Routinen behandelt).
if mwt_ActiveTitle =
	mwt_ActiveTitle = ahk_class %mwt_ActiveClass%
; Stellt sicher, dass der Titel kurz genug ist, damit er passt. mwt_ActiveTitle dient auch dazu,
; diesen bestimmten Men�punkt eindeutig zu identifizieren.
StringLeft, mwt_ActiveTitle, mwt_ActiveTitle, %mwt_MaxLength%

; Neben dem Tray-Men�, dessen Men�punktnamen eindeutig sein m�ssen,
; muss das Tray-Men� selbst auch eindeutig sein, sodass im Array nachgeschaut werden kann,
; wenn das Fenster sp�ter wieder sichtbar gemacht wird.  Daher macht das Men� eindeutig,
; wenn noch nicht getan:
Loop, %mwt_MaxWindows%
{
	if mwt_WindowTitle%a_index% = %mwt_ActiveTitle%
	{
		; �bereinstimmung gefunden, also nicht eindeutig.
		; Zuerst wird das 0x von der Hexadezimalen Zahl entfernt, um Platz im Men� zu sparen:
		StringTrimLeft, mwt_ActiveIDShort, mwt_ActiveID, 2
		StringLen, mwt_ActiveIDShortLength, mwt_ActiveIDShort
		StringLen, mwt_ActiveTitleLength, mwt_ActiveTitle
		mwt_ActiveTitleLength += %mwt_ActiveIDShortLength%
		mwt_ActiveTitleLength += 1 ; +1 ist das Leerzeichen zwischen Titel & ID.
		if mwt_ActiveTitleLength > %mwt_MaxLength%
		{
			; Da die L�nge der Men�punktnamen limitiert ist,
			; wird der Titel am Ende gek�rzt, damit genug Platz
			; f�r die kurze ID des Fensters vorhanden ist:
			TrimCount = %mwt_ActiveTitleLength%
			TrimCount -= %mwt_MaxLength%
			StringTrimRight, mwt_ActiveTitle, mwt_ActiveTitle, %TrimCount%
		}
		; Eindeutigen Titel konstruieren:
		mwt_ActiveTitle = %mwt_ActiveTitle% %mwt_ActiveIDShort%
		break
	}
}

; Zuerst sicherstellen, dass die ID noch nicht in der Liste vorhanden ist, dass
; passieren kann, wenn ein bestimmtes Fenster extern sichtbar gemacht wurde
; und nun wieder dabei ist, versteckt zu werden:
mwt_AlreadyExists = n
Loop, %mwt_MaxWindows%
{
	if mwt_WindowID%a_index% = %mwt_ActiveID%
	{
		mwt_AlreadyExists = y
		break
	}
}

; Das Element ins Array und im Men� einf�gen:
if mwt_AlreadyExists = n
{
	Menu, Tray, add, %mwt_ActiveTitle%, RestoreFromTrayMenu
	mwt_WindowCount += 1
	Loop, %mwt_MaxWindows%  ; Nach einer freien Stelle suchen.
	{
		; Es sollte immer eine freie Stelle gefunden werden, wenn alles richtig gemacht ist.
		if mwt_WindowID%a_index% =  ; Eine leere Stelle wurde gefunden.
		{
			mwt_WindowID%a_index% = %mwt_ActiveID%
			mwt_WindowTitle%a_index% = %mwt_ActiveTitle%
			break
		}
	}
}
Return


RestoreFromTrayMenu:
Menu, Tray, delete, %A_ThisMenuItem%
; Fenster finden, basierend auf dessen eindeutigen Titel, der als Men�punktname gespeichert ist:
Loop, %mwt_MaxWindows%
{
	if mwt_WindowTitle%a_index% = %A_ThisMenuItem%  ; �bereinstimmung gefunden.
	{
		StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
		WinShow, ahk_id %IDToRestore%
		WinActivate ahk_id %IDToRestore%  ; Manchmal notwendig.
		mwt_WindowID%a_index% =  ; Leer machen, um die Stelle freizugeben.
		mwt_WindowTitle%a_index% =
		mwt_WindowCount -= 1
		break
	}
}
Return


; Damit wird das zuletzt minimierte Fenster aktiviert und sichtbar gemacht.
mwt_UnMinimize:
; Sicherstellen, dass etwas vorhanden ist, das sichtbar gemacht wird.
if mwt_WindowCount > 0 
{
	; Ermittelt die ID des zuletzt minimierten Fensters und macht es sichtbar
	StringTrimRight, IDToRestore, mwt_WindowID%mwt_WindowCount%, 0
	WinShow, ahk_id %IDToRestore%
	WinActivate ahk_id %IDToRestore%
	
	; Ermittelt den Men�namen des zuletzt minimierten Fensters und entfernt ihn
	StringTrimRight, MenuToRemove, mwt_WindowTitle%mwt_WindowCount%, 0
	Menu, Tray, delete, %MenuToRemove%
	
	; Array aufr�umen und Fensterz�hlung verringern
	mwt_WindowID%mwt_WindowCount% =
	mwt_WindowTitle%mwt_WindowCount% = 
	mwt_WindowCount -= 1
}
Return


mwt_RestoreAllThenExit:
Gosub, mwt_RestoreAll
ExitApp  ; Echtes Exit durchf�hren.


mwt_RestoreAll:
Loop, %mwt_MaxWindows%
{
	if mwt_WindowID%a_index% <>
	{
		StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
		WinShow, ahk_id %IDToRestore%
		WinActivate ahk_id %IDToRestore%  ; Manchmal notwendig.
		; Diesen Weg anstelle von DeleteAll durchf�hren, sodass die Trennlinie
		; und das erste Element erhalten bleiben:
		StringTrimRight, MenuToRemove, mwt_WindowTitle%a_index%, 0
		Menu, Tray, delete, %MenuToRemove%
		mwt_WindowID%a_index% =  ; Leer machen, um die Stelle freizugeben.
		mwt_WindowTitle%a_index% =
		mwt_WindowCount -= 1
	}
	if mwt_WindowCount = 0
		break
}
Return
