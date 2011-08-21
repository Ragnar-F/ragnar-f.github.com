; Einfacher Zugriff auf Lieblingsordner -- von Savage
; http://www.autohotkey.com
; Wenn die mittlere Maustaste gedr�ckt wird, w�hrend bestimmte
; Fenstertypen aktiv sind, dann zeigt dieses Script ein Men� mit den Lieblingsordnern an.
;  Nachdem ein Ordner ausgew�hlt wurde, wechselt das Script
; wechselt das Script innerhalb des aktiven Fensters sofort auf diesen Ordner.  Die folgenden
; Fenstertypen werden unterst�tzt: 1) Standard-Dialogfenster zum �ffnen oder Speichern von Dateien;
; 2) Explorer-Fenster; 3) Konsolenfenster (Eingabeaufforderung).
; Das Men� kann optional auch f�r nicht unterst�tzte Fenstertypen angezeigt werden,
; in diesem Fall wird der ausgew�hlte Ordner in einem neuen
; Explorer-Fenster ge�ffnet.

; Hinweis: Wenn "Ansicht > Symbolleisten > Adressleiste" im Fenster-Explorer deaktiviert ist,
; dann wird das Men� nicht angezeigt, wenn der unten ausgew�hlte Hotkey
; ein Tilde-Zeichen hat.  Wenn ein Tilde-Zeichen vorhanden ist, dann wird das Men� angezeigt,
; aber der Ordner bleibt wird in einem neuen Explorer-Fenster ge�ffnet, anstatt
; das aktive Fenster auf diesen Ordner zu wechseln.

; KONFIGURATION: HOTKEY AUSW�HLEN
; Wenn die aktuelle Maus mehr als 3 Tasten hat, dann kann
; XButton1 (die 4.) oder XButton2 (die 5.) anstelle von MButton ausprobiert werden.
; Modifizierte Maustasten (wie ^MButton) oder
; ein Tastatur-Hotkey k�nnen auch verwendet werden.  Im Falle von MButton sollte das Tilde-Zeichen (~) als Pr�fix
; verwendet werden, damit die normale Funktionalit�t von MButton nicht verloren geht,
; sobald andere Fenstertypen wie ein Browser angeklickt werden.  Das Vorhandensein
; eines Tilde-Zeichens hindert das Script daran, das Men� f�r
; nicht unterst�tzte Fenstertypen anzuzeigen.  Wenn mit anderen Worten kein Tilde-Zeichen vorhanden ist,
; dann zeigt der Hotkey das Men� immer an; und nach dem Ausw�hlen
; eines Lieblingsordners, w�hrend ein nicht unterst�tzter Fenstertyp aktiv ist,
; wird ein neues Explorer-Fenster ge�ffnet, um den Inhalt des Ordners anzuzeigen.
;
f_Hotkey = ~MButton

; KONFIGURATION: LIEBLINGSORDNER AUSW�HLEN
; Aktualisiert den unteren Sonderkommentarbereich, um die Lieblingsordner auszuw�hlen.
;  Bestimmt zuerst den Namen des Men�punkts, gefolgt von einem
; Semikolon und dem Namen des aktuellen Pfads vom Lieblingsordner.
; Verwendet eine leere Zeile f�r eine Trennlinie.

/*
MEN�ELEMENTE <-- Diesen String nicht �ndern.
Desktop      ; %A_Desktop%
Favoriten    ; %A_Desktop%\..\Favorites
Eigene Dokumente ; %A_MyDocuments%

Programme ; %A_ProgramFiles%
*/


; ENDE DES KONFIGURATIONSBEREICHS
; Hier danach keine �nderungen durchf�hren, es sei denn, die allgemeine
; Funktionalit�t des Scripts soll ge�ndert werden.

#SingleInstance  ; Notwendig, da der Hotkey dynamisch erstellt wird.

Hotkey, %f_Hotkey%, f_DisplayMenu
StringLeft, f_HotkeyFirstChar, f_Hotkey, 1
if f_HotkeyFirstChar = ~  ; Men� nur f�r bestimmte Fenstertypen anzeigen.
	f_AlwaysShowMenu = n
Else
	f_AlwaysShowMenu = y

; Wird verwendet, um zuverl�ssig festzustellen, ob das Script kompiliert ist:
SplitPath, A_ScriptName,,, f_FileExt
if f_FileExt = Exe  ; Men�punkte von einer externen Datei lesen.
	f_FavoritesFile = %A_ScriptDir%\Favorites.ini
else  ; Men�punkte direkt von diesem Script lesen.
	f_FavoritesFile = %A_ScriptFullPath%

;----Konfigurationsdatei lesen.
f_AtStartingPos = n
f_MenuItemCount = 0
Loop, Read, %f_FavoritesFile%
{
	if f_FileExt <> Exe
	{
		; Da die Men�punkte direkt von diesem Script gelesen werden,
		; werden alle Zeilen �bersprungen, bis die Startzeile
		; erreicht wird.
		if f_AtStartingPos = n
		{
			IfInString, A_LoopReadLine, MEN�ELEMENTE
				f_AtStartingPos = y
			continue  ; Neuen Schleifendurchlauf starten.
		}
		; Ansonsten kennzeichnet das schlie�ende Kommentarsymbol das Ende der Liste.
		if A_LoopReadLine = */
			break  ; Schleife unterbrechen
	}
	; Men�trennlinien m�ssen auch mitgez�hlt werden, damit die Kompatibilit�t
	; mit A_ThisMenuItemPos gew�hrleistet wird:
	f_MenuItemCount++
	if A_LoopReadLine =  ; Leer kennzeichnet eine Trennlinie.
		Menu, Favorites, Add
	Else
	{
		StringSplit, f_line, A_LoopReadLine, `;
		f_line1 = %f_line1%  ; F�hrende und nachfolgende Leerzeichen entfernen.
		f_line2 = %f_line2%  ; F�hrende und nachfolgende Leerzeichen entfernen.
		; Referenzen auf Variablen innerhalb jeden Feldes aufl�sen, und
		; ein neues Array-Element mit dem Ordnerpfad erstellen:
		Transform, f_path%f_MenuItemCount%, deref, %f_line2%
		Transform, f_line1, deref, %f_line1%
		Menu, Favorites, Add, %f_line1%, f_OpenFavorite
	}
}
Return ;----Ende des automatischen Ausf�hrungsbereichs.


;----Ausgew�hlten Lieblingsordner �ffnen
f_OpenFavorite:
; Array-Element abfangen, das dem ausgew�hlten Men�punkt entspricht:
StringTrimLeft, f_path, f_path%A_ThisMenuItemPos%, 0
if f_path =
	Return
if f_class = #32770    ; Es ist ein Dialogfenster.
{
	if f_Edit1Pos <>   ; Und hat ein Edit1-Steuerelement.
	{
		; Aktiviert das Fenster, sodass nachfolgende Klicks auch au�erhalb des Dialogfensters
		; funktionieren, falls der Benutzer die mittlere Maustaste dr�ckt:
		WinActivate ahk_id %f_window_id%
		; Ermittelt jeden Dateinamen, der bereits im Feld vorhanden ist,
		; sodass er wiederhergestellt werden kann, nachdem zum neuen Ordner gewechselt wurde:
		ControlGetText, f_text, Edit1, ahk_id %f_window_id%
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		ControlSend, Edit1, {Enter}, ahk_id %f_window_id%
		Sleep, 100  ; Bei einigen Dialogfenstern oder in einigen F�llen wird zus�tzliche Zeit ben�tigt.
		ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
		Return
	}
	; dann springe ans Ende der Subroutine, um die Standardaktion auszuf�hren.
}
else if f_class in ExploreWClass,CabinetWClass  ; Ordner im Explorer wechseln.
{
	if f_Edit1Pos <>   ; Und hat ein Edit1-Steuerelement.
	{
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		; Tekl hat Folgendes berichtet: "Wenn ich auf den Ordner L:\folder wechseln will,
		; dann zeigt die Adressleiste http://www.L:\folder.com. Als �bergangsl�sung
		; habe ich {right} vor {Enter} hinzugef�gt":
		ControlSend, Edit1, {Right}{Enter}, ahk_id %f_window_id%
		Return
	}
	; dann springe ans Ende der Subroutine, um die Standardaktion auszuf�hren.
}
else if f_class = ConsoleWindowClass ; CD im Konsolenfenster verwenden, um auf das Verzeichnis zu springen.
{
	WinActivate, ahk_id %f_window_id% ; Weil es durch mclick manchmal deaktiviert wird.
	SetKeyDelay, 0  ; ; Nur w�hrend des Hotkey-Threads wirksam.
	IfInString, f_path, :  ; Es enth�lt einen Laufwerksbuchstaben
	{
		StringLeft, f_path_drive, f_path, 1
		Send %f_path_drive%:{enter}
	}
	Send, cd %f_path%{Enter}
	Return
}
; Da oben keine R�ckgabe erfolgt, gilt eins der folgenden Angaben:
; 1) Es ist ein nicht unterst�tzter Fenstertyp, aber f_AlwaysShowMenu ist y (ja).
; 2) Es ist ein unterst�tzter Fenstertyp, es fehlt jedoch ein Edit1-Steuerelement,
;    um die benutzerdefinierte Aktion zu erleichtern, daher soll stattdessen die untere Standardaktion durchgef�hrt werden.
Run, Explorer %f_path%  ; K�nnte ohne Anf�hrungszeichen mit mehr Systemen funktionieren.
Return


;----Das Men� anzeigen
f_DisplayMenu:
; Diese ersten paar Variablen werden hier bestimmt und von f_OpenFavorite verwendet:
WinGet, f_window_id, ID, A
WinGetClass, f_class, ahk_id %f_window_id%
if f_class in #32770,ExploreWClass,CabinetWClass  ; Dialogfenster oder Explorer.
	ControlGetPos, f_Edit1Pos,,,, Edit1, ahk_id %f_window_id%
if f_AlwaysShowMenu = n  ; Das Men� sollte nur selektiv angezeigt werden.
{
	if f_class in #32770,ExploreWClass,CabinetWClass  ; Dialogfenster oder Explorer.
	{
		if f_Edit1Pos =  ; Das Steuerelement ist nicht vorhanden, daher das Men� nicht anzeigen
			Return
	}
	else if f_class <> ConsoleWindowClass
		return ; Wenn anderer Fenstertyp, dann Men� nicht anzeigen.
}
; Ansonsten sollte das Men� f�r diesen Fenstertyp pr�sentiert werden:
Menu, Favorites, show
Return
