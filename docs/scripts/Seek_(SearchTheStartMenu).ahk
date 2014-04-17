; Seek -- by Phi
; http://www.autohotkey.com
; Die Navigation im Startmen� kann umst�ndlich sein, besonders
; wenn viele Programme im Laufe der Zeit installiert wurden. Mit "Seek"
; kann ein Schl�sselwort unabh�ngig von der Gro�- und Kleinschreibung angegeben werden,
; um �bereinstimmende Programme und Verzeichnisse im Startmen� herauszufiltern,
; damit das gew�nschte Programm aus der Liste einfach ge�ffnet werden kann. ;*****************************************************************
;
;  Programm : Seek
;  Coder   : Phi
;  Aktualisiert : Mon Jan 31 10:08:37 2005
;
;  Wonach suchst du, mein Freund?
;
;*****************************************************************
;
;  Ich hatte viel Spa� dabei, das hier zu programmieren, und hoffe,
;  dass es dir auch gefallen wird. Du kannst mir jederzeit eine E-Mail mit
;  Kommentaren und Feedbacks schreiben: phi1618 (*a.t*) gmail
;  :D0T: com.
;
;  Optionen:
;    -cache Die zwischengespeicherte Verzeichnisauflistung verwenden, falls verf�gbar
;           (Standardmodus, wenn keine Optionen angegeben werden)
;    -scan  Eine Verzeichnis�berpr�fung erzwingen, um die aktuellste
;           Verzeichnisauflistung zu erhalten
;    -scex  �berpr�fen & Beenden (n�tzlich, um die
;           m�glicherweise zeitraubende Verzeichnis�berpr�fung
;           im Hintergrund durchzuf�hren)
;    -help  Diese Hilfe anzeigen
;
;*****************************************************************
;
; WIE WIRD GESUCHT:
;
; 1. 'Seek' ist ein AutoHotkey-Script. Du kannst das Script entweder
;    als Seek.ahk (originales Script) oder als Seek.exe (kompilierte
;    ausf�hrbare Datei) ausf�hren.
;
;    Um Seek.exe zu erhalten, kannst du Seek.zip (enth�lt
;    sowohl den Quellcode als auch die kompilierte Bin�rdatei) von
;    http://home.ripway.com/2004-10/188589/ herunterladen.
;    Ansonsten kannst du Seek.ahk auch selbst mithilfe des
;    Ahk2Exe-Compilers von AutoHotkey kompilieren, oder von mir
;    eine Kopie per E-Mail anfordern. Die Dateigr��e liegt bei
;    ca. 200 kbytes. Ich kann damit erreicht werden: phi1618 (*a.t*)
;    gmail :D0T: com.
;
;    Damit Seek.ahk verwendet werden kann, installiere zuerst
;    AutoHotkey v1.0.25 oder h�her auf deinem PC (von
;    http://www.autohotkey.com herunterladen). Als n�chstes den Befehl ausf�hren:
;
;    C:\Programme\AutoHotkey\AutoHotkey.exe C:\MeineScripts\Seek.ahk
;
;    Denke daran, C:\Programme und C:\MeineScripts mit
;    den richtigen Verzeichnisnamen zu ersetzen.
;
; 2. Seek.exe kann von �berall ausgef�hrt
;    werden. Es keine Installation notwendig, es wird
;    nichts in deiner Registrierung geschrieben, und greift nicht
;    auf das Internet zu (nicht nach Hause telefonieren). Um das Programm
;    zu deinstallieren, l�sche einfach Seek.exe.
;
;    Es werden nur 2 Dateien im
;    TMP-Verzeichnis erstellt:
;
;      a. _Seek.key  (Cache-Datei f�r den aktuellsten Abfragestring)
;      b. _Seek.list (Cache-Datei f�r die Verzeichnisauflistung)
;
;    Wenn du ein Purist bist, dann kannst du diese Dateien manuell l�schen,
;    falls du die Absicht hast, 'Seek' vom System zu entfernen.
;
; 3. Der bequemste Weg, 'Seek' auszuf�hren, erfolgt mittels
;    einer Tastenkombination/einem Hotkey. Falls du noch kein
;    Hotkey-Verwaltungsprogramm auf deinem PC verwendest,
;    empfehle ich dringendst AutoHotkey. Wenn du kein Hotkey-Verwaltungsprogramm
;    installieren willst, dann kannst du die
;    Tastenkombinationsfunktion von Windows benutzen und
;    einen Hotkey (z. B. ALT+F1) dazu bringen, 'Seek' auszuf�hren. Das ist
;    wichtig, da du 'Seek' jederzeit und von �berall ausf�hren
;    kannst.
;
; 4. Beim erstmaligen Ausf�hren von 'Seek' wird dein
;    Startmen� �berpr�ft und die Verzeichnisauflistung in
;    eine Cache-Datei gespeichert.
;
;    Die folgenden Verzeichnisse werden mit einbezogen:
;    - %A_StartMenu%
;    - %A_StartMenuCommon%
;
;    Standardm��ig werden nachfolgende Ausf�hrungen die
;    Cache-Datei lesen, um die Ladezeit zu verringern. F�r
;    mehr Infos �ber Optionen, f�hre 'Seek.exe -help' aus. Wenn du
;    denkst, dass dein Startmen� nicht sehr viele Programme
;    enth�lt, kannst du die Zwischenspeicherung deaktivieren und
;    'Seek' anweisen, immer eine Verzeichnis�berpr�fung durchzuf�hren (mittels
;    der Option -scan).  Dadurch erh�ltst du immer die aktuelle
;    Auflistung.
;
; 5. Sobald du 'Seek' ausf�hrst, erscheint ein Fenster und wartet darauf,
;    dass du ein Schl�sselwort eintr�gst. Nachdem du einen
;    Abfragestring eingetragen hast, wird eine Liste mit
;    �bereinstimmungen angezeigt. Als n�chstes muss ein Eintrag ausgew�hlt
;    und <Enter> oder der Button '�ffnen' gedr�ckt
;    werden, um das ausgew�hlte Programm auszuf�hren
;    oder das ausgew�hlte Verzeichnis zu �ffnen.
;
;*****************************************************************
;
; TECHNISCHE HINWEISE:
;
; - 'Seek' ben�tigt Chris Mallett's AutoHotkey v1.0.25
;   oder h�her (http://www.autohotkey.com).
;   Danke an Chris f�r seine gro�artige Arbeit mit AutoHotkey. :)
;
; - Die folgenden Umgebungsvariablen m�ssen g�ltig sein:
;   a. TMP
;
;*****************************************************************
;
; BEKANNTE PROBLEME:
;
; - Nil
;
;*****************************************************************
;
; UMGESETZTE VORSCHL�GE:
;
; - Erste �bereinstimmung standardm��ig markieren, sodass
;   der Benutzer nur <Enter> zu dr�cken braucht, um sie auszuf�hren.
;   (Vorgeschlagen von Yih Yeong)
;
; - Doppelklick f�r die Auflistung der Suchergebnisse
;   erm�glichen, um das Programm auszuf�hren.
;   (Vorgeschlagen von Yih Yeong & Jack)
;
; - Automatische inkrementelle Suche in Echtzeit.
;   (Vorgeschlagen von Rajat)
;
; - Fuzzy-Suche bei Benutzereingabe von mehreren Abfragestrings,
;   durch Leerzeichen getrennt.
;   (Vorgeschlagen von Rajat)
;
;*****************************************************************
;
; VORGESCHLAGENE FUNKTIONEN (DIE VIELLEICHT UMGESETZT WERDEN):
;
; - Ausf�hrungsablauf protokollieren. Die am h�ufigsten
;   verwendeten Programme am Anfang der Suchergebnisse auflisten.
;   (Vorgeschlagen von Yih Yeong)
;
; - Anstelle einer ListBox eine Reihe von Anwendung-Icons
;   darstellen, sodass ein ToolTip mit Programminformationen
;   (Pfad usw.) angezeigt wird, sobald sich der Mauszeiger
;   �ber das Icon befindet.
;   (Vorgeschlagen von Yih Yeong)
;
; - Anstatt mit dem Text in der Mitte �bereinzustimmen, nur mit
;   Programm-/Verzeichnisnamen �bereinstimmen, die mit dem
;   Abfragestring beginnen.
;   (Vorgeschlagen von Stefan)
;
; - Verwaltung von Favoriten hinzuf�gen. Eine Gruppe von Programmen
;   bei einer einzigen Ausf�hrung starten.
;   (Vorgeschlagen von Atomhrt)
;
; - Seek in der Taskleiste/Symbolleiste integrieren, sodass
;   es immer verf�gbar ist, wodurch es unn�tig ist,
;   einen Hotkey zum Ausf�hren von Seek zu erstellen.
;   (Vorgeschlagen von Deniz Akay)
;
; - Suche mittels Platzhalter/RegEx.
;   (Vorgeschlagen von Steve)
;
;*****************************************************************
;
; �NDERUNGEN:
;
; * v1.1.0
; - Erste Ver�ffentlichung.
;
; * v1.1.1
; - Maximierungsoption entfernt, da einige Programme nicht
;   richtig damit funktionieren.
; - Doppelklickerkennung hinzugef�gt, um die �ffnen-Funktion auszul�sen.
;
; * v2.0.0
; - Das Popup-Fenster von 'Seek' wurde im Ausgabebildschirm integriert,
;   sodass der Benutzer den Abfragestring nochmals eingeben kann, um etwas
;   zu suchen, ohne dabei Seek zu beenden und wieder zu starten.
; - Button 'Startmen� �berpr�fen'  hinzugef�gt.
; - Inkrementelle Suche in Echtzeit hinzugef�gt, die �bereinstimmungen
;   bei der Benutzereingabe automatisch filtert, ohne darauf zu warten,
;   dass du <Enter> dr�ckst.
; - Internen Schalter hinzugef�gt (TrackKeyPhrase), um den Suchstring zu merken.
; - Internen Schalter hinzugef�gt (ToolTipFilename), um den Dateinamen
;   mithilfe des Tooltips anzuzeigen.
;
; * v2.0.1
; - Horizontale Bildlaufleiste zur ListBox hinzugef�gt, sodass sehr
;   lange �bereinstimmungen nicht gek�rzt werden.
;
; * v2.0.2
; - Der Benutzer kann nun seine eigene angepasste Liste mit Verzeichnissen hinzuf�gen,
;   die beim �berpr�fen mit einbezogen wird. Der Benutzer muss nur eine
;   Textdatei namens 'Seek.dir' im gleichen Verzeichnis von Seek.exe oder
;   Seek.ahk erstellen, und den vollst�ndigen Pfad des Verzeichnisses angeben,
;   ein Verzeichnis pro Zeile. Die Pfade d�rfen nicht in
;   einfache oder doppelte Anf�hrungszeichen gesetzt werden.
;
; * v2.0.3
; - /on-Option zum DIR-Befehl hinzugef�gt, um nach Name zu sortieren.
; - Fuzzy-Suche, wenn der Benutzer mehrere Abfragestrings eingibt,
;   getrennt durch Leerzeichen, zum Beispiel "med pla". Es erfolgt eine �bereinstimmung,
;   sobald alle Strings ("med" & "pla") gefunden werden. Damit wird zum Beispiel
;   "Media Player", "Macromedia Flash Player",
;   "Play Medieval King", "medpla", "plamed" gefunden.
; - Tabulator-Bewegungsablauf korrigiert, indem bereits alle Buttons
;   beim Start hinzugef�gt werden, die jedoch deaktiviert sind, bis sie
;   gebraucht werden.
; - Statusleiste hinzugef�gt, um ToolTip-Feedback zu ersetzen.
; - Veraltete interne Schalter entfernt (ToolTipFilename).
; - Das Verwenden des "dir"-Befehls wurde mit dem eigenen
;   "Loop"-Befehl von AutoHotkey ersetzt, um Verzeichnisinhalte zu �berpr�fen.
;   "dir" kann nicht mit erweiterten Zeichens�tzen umgehen, folglich
;   wurden nicht englische (z. B. deutsche) Verzeichnisse und Dateinamen
;   falsch erfasst. (Danke an Wolfgang Bujatti und
;   Sietse Fliege f�rs Testen der Modifikation)
; - Internen Schalter hinzugef�gt (ScanMode), um zu definieren, ob
;   Dateien und/oder Verzeichnisse beim �berpr�fen mit einbezogen werden.
; - Die selbst programmierte Erkennung vom Startmen�-Pfad wurde mit den
;   integrierten Variablen A_StartMenu und A_StartMenuCommon ersetzt.
;   Damit funktioniert Seek nun mit unterschiedlichen Sprachen, die
;   verschiedene Namensgebungen f�r den Startmen� haben.
;   (Danke an Wolfgang Bujatti und Sietse Fliege f�r die Hilfe
;   beim Testen der anderen Methode, bevor diese neuen Variablen
;   verf�gbar waren.)
; - Vorauswahl der zuletzt ausgef�hrten �bereinstimmung hinzugef�gt,
;   sodass sie beim zweimaligen Dr�cken von <ENTER> ausgef�hrt werden kann.
;
;*****************************************************************

;**************************
;<--- BEGINN DES PROGRAMMS --->
;**************************

;==== DEINE KONFIGURATION ===================================

; Gebt an, welches Programm beim �ffnen eines Verzeichnisses verwendet werden soll.
; Wenn das Programm nicht gefunden werden kann oder nicht angegeben ist
; (z. B. ist die Variable leer oder enth�lt einen Null-Wert),
; dann wird standardm��ig der Explorer verwendet.
dirExplorer = E:\utl\xplorer2_lite\xplorer2.exe

; Eine benutzerdefinierte Liste von zus�tzlichen Verzeichnissen,
; die beim �berpr�fen mit einbezogen wird. Der vollst�ndige Pfad darf nicht in
; einfachen oder doppelten Anf�hrungszeichen gesetzt werden. Wenn diese Datei nicht
; vorhanden ist, dann werden nur die Standardverzeichnisse �berpr�ft.
SeekMyDir = %A_ScriptDir%\Seek.dir

; Gebt den Dateinamen und den Standort des Verzeichnisses an,
; um die zwischengespeicherte Verzeichnis-/Programmauflistung zu speichern. Es ist nicht notwendig,
; das hier zu �ndern, solange es nicht der Wunsch ist.
dirListing = %A_Temp%\_Seek.list

; Gebt den Dateinamen und den Standort des Verzeichnisses an,
; um das zwischengespeicherte Schl�sselwort der letzten Suche zu speichern. Es ist nicht notwendig,
; das hier zu �ndern, solange es nicht der Wunsch ist.
keyPhrase = %A_Temp%\_Seek.key

; Suchstring merken (ON/OFF)
; Wenn ON, dann wird der zuletzt benutzte Abfragestring als
; Standardabfragestring beim n�chsten Ausf�hren von Seek wiederverwendet.
; Wenn OFF, dann wird der zuletzt benutzte Abfragestring nicht gespeichert,
; au�erdem ist beim n�chsten Ausf�hren von Seek kein
; Standardabfragestring vorhanden.
TrackKeyPhrase = ON

; Gebt an, was bei der �berpr�fung mit einbezogen werden soll.
; 0: Verzeichnisse werden ignoriert (nur Dateien).
; 1: Es werden alle Dateien und Verzeichnisse mit einbezogen.
; 2: Nur Verzeichnisse einbeziehen (keine Dateien).
ScanMode = 1

;...........................................................

; INIT
;#NoTrayIcon
StringCaseSense, Off
version = Seek v2.0.3

; HILFE ANZEIGEN
If 1 in --help,-help,/h,-h,/?,-?
{
    MsgBox,, %version%, Die Navigation im Startmen� kann umst�ndlich sein, besonders wenn viele Programme im Laufe der Zeit installiert wurden. Mit "Seek" kann ein Schl�sselwort unabh�ngig von der Gro�- und Kleinschreibung angegeben werden, um �bereinstimmende Programme und Verzeichnisse im Startmen� herauszufiltern, damit das gew�nschte Programm aus der Liste einfach ge�ffnet werden kann. Dadurch entf�llt das unn�tige Durchsuchen des Startmen�s.`n`nIch hatte viel Spa� dabei, das hier zu programmieren, und hoffe, dass es dir auch gefallen wird. Du kannst mir jederzeit eine E-Mail mit Kommentaren und Feedbacks schreiben: phi1618 (*a.t*) gmail :D0T: com.`n`nOptionen:`n  -cache`tDie zwischengespeicherte Verzeichnisauflistung verwenden, falls verf�gbar (Standardmodus, wenn keine Optionen angegeben werden)`n  -scan`tEine Verzeichnis�berpr�fung erzwingen, um die aktuellste Verzeichnisauflistung zu erhalten`n  -scex`t�berpr�fen & Beenden (n�tzlich, um die m�glicherweise zeitraubende Verzeichnis�berpr�fung im Hintergrund durchzuf�hren)`n  -help`tDiese Hilfe anzeigen
    Goto QuitNoSave
}

; �BERPR�FEN, OB DIE WICHTIGEN UMGEBUNGSVARIABLEN VORHANDEN UND G�LTIG SIND
; *TMP*
IfNotExist, %A_Temp% ; PFAD IST NICHT VORHANDEN
{
    MsgBox Diese wichtige Umgebungsvariable ist entweder nicht definiert oder ung�ltig:`n`n    TMP = %A_Temp%`n`nBitte behebt dieses Problem, damit Seek ausgef�hrt werden kann.
    Goto QuitNoSave
}

; WENN NICHT �BERPF�FEN-UND-BEENDEN
IfNotEqual 1, -scex
{
    ; DAS ZULETZT VERWENDETE SCHL�SSELWORT VON DER CACHE-DATEI ABRUFEN,
    ; DAS ALS STANDARDABFRAGESTRING BENUTZT WIRD
    If TrackKeyPhrase = ON
    {
        FileReadLine, PrevKeyPhrase, %keyPhrase%, 1
        FileReadLine, PrevOpenTarget, %keyPhrase%, 2
    }
    NewKeyPhrase = %PrevKeyPhrase%
    NewOpenTarget = %PrevOpenTarget%

    ; TEXTBOX F�R DEN BENUTZER HINZUF�GEN, DAMIT DER ABFRAGESTRING EINGEGEBEN WERDEN KANN
    Gui, 1:Add, Edit, vFilename W600, %NewKeyPhrase%

    ; MEINE LIEBLINGSZEILE HINZUF�GEN
    Gui, 1:Add, Text, X625 Y10, Wonach suchst du, mein Freund?

    ; STATUSLEISTE HINZUF�GEN, UM FEEDBACKS F�R DEN BENUTZER BEREITZUSTELLEN
    Gui, 1:Add, Text, vStatusBar X10 Y31 R1 W764

    ; AUSWAHL-LISTBOX HINZUF�GEN, UM SUCHERGEBNISSE ANZUZEIGEN
    Gui, 1:Add, ListBox, vOpenTarget gTargetSelection X10 Y53 R28 W764 HScroll Disabled, %List%

    ; DIESE BUTTONS HINZUF�GEN, ABER ERSTMAL DEAKTIVIEREN
    Gui, 1:Add, Button, gButtonOPEN vButtonOPEN Default X10 Y446 Disabled, �ffnen
    Gui, 1:Add, Button, gButtonOPENDIR vButtonOPENDIR X59 Y446 Disabled, Verzeichnis �ffnen
    Gui, 1:Add, Button, gButtonSCANSTARTMENU vButtonSCANSTARTMENU X340 Y446 Disabled, Startmen� �berpr�fen

    ; BEENDEN-BUTTON HINZUF�GEN
    Gui, 1:Add, Button, gButtonEXIT X743 Y446, Beenden

    ; ABFRAGEFENSTER ANZEIGEN
    Gui, 1:Show, Center, %version%
}

; NOCHMALIGE �BERPR�FUNG DER LETZTEN VERZEICHNISAUFLISTUNG AKTIVIEREN
If 1 in -scan,-scex
    rescan = Y
; �BERPR�FEN, OB DIE CACHE-DATEI F�R DIE VERZEICHNISAUFLISTUNG BEREITS EXISTIERT. WENN NICHT, DANN NOCHMALS �BERPR�FEN.
Else IfNotExist, %dirListing%
    rescan = Y

If rescan = Y ; NOCHMALS �BERPR�FEN
{
    ; STATUS ANZEIGEN, ES SEI DENN, DIE OPTION �BERPR�FEN-UND-BEENDEN IST AKTIV
    IfNotEqual 1, -scex
        GuiControl,, StatusBar, Verzeichnisauflistung wird �berpr�ft ...

    ; STARTMEN� �BERPR�FEN UND VERZEICHNIS-/PROGRAMMAUFLISTUNG IN DIE CACHE-DATEI SPEICHERN
    Gosub ScanStartMenu

    ; BEENDEN, WENN DIE OPTION �BERPR�FEN-UND-BEENDEN AKTIV IST
    IfEqual 1, -scex, Goto, QuitNoSave
}

GuiControl,, StatusBar, Letztes Abfrageergebnis abrufen ...

; VERGLEICHSLISTE F�R DAS ZULETZT VERWENDETE SCHL�SSELWORT ABRUFEN
Gosub SilentFindMatches

; STATUSTEXT ENTFERNEN
GuiControl,, StatusBar,

; VERZEICHNISAUFLISTUNG WURDE GELADEN. ANDERE BUTTONS WERDEN AKTIVIERT.
; DIESE BUTTONS WURDEN VORHER DEAKTIVIERT, DA SIE ERST
; FUNKTIONIEREN SOLLEN, WENN SIE GEBRAUCHT WERDEN.
GuiControl, 1:Enable, ButtonOPEN
GuiControl, 1:Enable, ButtonOPENDIR
GuiControl, 1:Enable, ButtonSCANSTARTMENU

; INKREMENTELLE SUCHE AKTIVIEREN
SetTimer, tIncrementalSearch, 500

; GUI AKTUALISIEREN
Gosub EnterQuery

Return

;***********************************************************
;                                                          *
;                 ENDE DES HAUPTPROGRAMMS                      *
;                                                          *
;***********************************************************


;=== BEGINN DES ButtonSCANSTARTMENU-EREIGNISSES =======================

ButtonSCANSTARTMENU:

Gui, 1:Submit, NoHide
GuiControl,, StatusBar, Verzeichnisauflistung wird �berpr�ft ...

; LISTBOX DEAKTIVIEREN, W�HREND �BERPR�FT WIRD
GuiControl, 1:Disable, OpenTarget
GuiControl, 1:Disable, ButtonEXIT
GuiControl, 1:Disable, ButtonOPEN
GuiControl, 1:Disable, ButtonOPENDIR
GuiControl, 1:Disable, ButtonSCANSTARTMENU

; �BERPR�FUNG DURCHF�HREN
Gosub ScanStartMenu

; BENUTZER BENACHRICHTIGEN, DASS DIE �BERPR�FUNG ABGESCHLOSSEN IST
If Filename =
{
    ; WENN ABFRAGESTRING LEER IST...
    GuiControl, 1:Enable, ButtonEXIT
    GuiControl, 1:Enable, ButtonOPEN
    GuiControl, 1:Enable, ButtonSCANSTARTMENU
    GuiControl,, StatusBar, �berpr�fung abgeschlossen.
    Gosub EnterQuery
}
Else
{
    ; WENN ABFRAGESTRING VORHANDEN IST...
    ; MIT SUCHSTRING DIE NEUE AUFLISTUNG FILTERN
    NewKeyPhrase =
    Gosub FindMatches
}
Return

;... ENDE DES ButtonSCANSTARTMENU-EREIGNISSES .........................


;=== BEGINN DER ScanStartMenu-SUBROUTINE ========================
; STARTMEN� �BERPR�FEN UND VERZEICHNIS-/PROGRAMMAUFLISTUNG
; IN DIE CACHE-DATEI SPEICHERN
ScanStartMenu:

; VERZEICHNISPFADE DEFINIEREN, DIE ABGERUFEN WERDEN.
; DER PFAD DARF NICHT IN EINFACHEN ODER DOPPELTEN ANF�HRUNGSZEICHEN GESETZT WERDEN.
;
; F�R DIE ENGLISCHE VERSION VON WINDOWS
scanPath = %A_StartMenu%|%A_StartMenuCommon%

; ZUS�TZLICHE BENUTZERDEFINIERTE PFADE BEIM �BERPR�FEN MIT EINBEZIEHEN
IfExist, %SeekMyDir%
{
    Loop, read, %SeekMyDir%
    {
        IfNotExist, %A_LoopReadLine%
            MsgBox, 8192, %version%, Benutzerdefinierte Verzeichnisliste wird bearbeitet ...`n`n"%A_LoopReadLine%" ist weder vorhanden noch beim �berpr�fen mit einbezogen.`nAktualisiert bitte [ %SeekMyDir% ].
        Else
            scanPath = %scanPath%|%A_LoopReadLine%
    }
}

; VORHANDENE DATEIEN L�SCHEN, BEVOR EINE NEUE VERSION ERSTELLT WIRD
FileDelete, %dirListing%

; VERZEICHNISAUFLISTUNG �BERPR�FEN (TRENNZEICHEN = |), WOBEI AUCH JEDES
; UNTERVERZEICHNIS MIT EINBEZOGEN WIRD. VERSTECKTE DATEIEN
; WERDEN IGNORIERT.
Loop, parse, scanPath, |
{
    Loop, %A_LoopField%\*, %ScanMode%, 1
    {
        FileGetAttrib, fileAttrib, %A_LoopFileFullPath%
        IfNotInString, fileAttrib, H ; VERSTECKTE DATEIEN IGNORIEREN
            FileAppend, %A_LoopFileFullPath%`n, %dirListing%
    }
}

Return

;... ENDE DER ScanStartMenu-SUBROUTINE ..........................


;=== BEGINN DER FindMatches-SUBROUTINE ==========================
; ALLE �BEREINSTIMMUNGEN IN DER LISTBOX ANZEIGEN
FindMatches:

Gui, 1:Submit, NoHide
CurFilename = %Filename%
GuiControl,, StatusBar,

; WENN ABFRAGESTRING LEER IST ...
If CurFilename =
{
    MsgBox, 8192, %version%, Bitte ein Schl�sselwort eingeben, mit dem gesucht wird.
    Goto EnterQuery
}

; tIncrementalSearch WURDE UNTERBROCHEN. BEENDEN LASSEN.
If NewKeyPhrase <> %CurFilename%
{
    ; BENUTZER INFORMIEREN, DASS GEDULD EINE TUGEND IST
    GuiControl,, StatusBar, Suche ...
    ResumeFindMatches = TRUE
    Return
}

If List = |
{
    ; KEINE EINZIGE �BEREINSTIMMUNG GEFUNDEN.
    ; LASS DEN BENUTZER DEN ABFRAGESTRING BEARBEITEN UND ERNEUT VERSUCHEN.
    MsgBox, 8192, %version%, Der Abfragestring "%CurFilename%" erm�glicht keine einzige �bereinstimmung. Versuche es erneut.
    GuiControl, 1:Disable, ButtonOPENDIR
    GuiControl, 1:Enable, ButtonSCANSTARTMENU
    Goto EnterQuery
}
Else
{
    ; ERSTE �BEREINSTIMMUNG AUSW�HLEN, FALLS KEINE ANDERE �BEREINSTIMMUNG AUSGEW�HLT WURDE
    Gui, 1:Submit, NoHide
    GuiControl, 1:Enable, OpenTarget
    GuiControl, 1:Enable, ButtonOPEN
    GuiControl, 1:Enable, ButtonOPENDIR
    GuiControl, 1:Enable, ButtonSCANSTARTMENU
    GuiControl, Focus, OpenTarget
    If OpenTarget =
        GuiControl, 1:Choose, OpenTarget, |1
}

; GUI AKTUALISIEREN
Gui, 1:Show, Center, %version%

Return

;... ENDE DER FindMatches-SUBROUTINE ..........................


;=== BEGINN DER SilentFindMatches-SUBROUTINE ====================

SilentFindMatches:

Gui, 1:Submit, NoHide
sfmFilename = %Filename%

; �BEREINSTIMMUNGEN FILTERN, BASIEREND AUF DEM ABFRAGESTRING
List = |
If sfmFilename <>
{
    Loop, read, %dirListing%
    {
        Gui, 1:Submit, NoHide
        tFilename = %Filename%
        If sfmFilename <> %tFilename%
        {
            ; BENUTZER HAT DEN SUCHSTRING GE�NDERT. ES MACHT KEINEN SINN,
            ; DIE SUCHE MIT DEM ALTEN STRING FORTZUSETZEN, ALSO ABBRECHEN.
            Return
        }
        Else
        {
            ; �BEREINSTIMMUNGEN AN DIE LISTE ANF�GEN
            SplitPath, A_LoopReadLine, name, dir, ext, name_no_ext, drive
            MatchFound = Y
            Loop, parse, sfmFilename, %A_Space%
            {
                IfNotInString, name, %A_LoopField%
                {
                    MatchFound = N
                    Break
                }
            }
            IfEqual, MatchFound, Y
            {
                ; �BEREINSTIMMUNG ZUR LISTE HINZUF�GEN
                List = %List%%A_LoopReadLine%|

                ; VORAUSW�HLEN, WENN DIESE �BEREINSTIMMUNG DAS ZULETZT AUSGEF�HRTE PROGRAMM ENTSPRICHT
                If (A_LoopReadLine = PrevOpenTarget && sfmFilename = PrevKeyPhrase)
                    List = %List%|
            }
        }
    }
}

; LISTE MIT SUCHERGEBNISSEN AKTUALISIEREN
GuiControl, 1:, OpenTarget, %List%

If List = |
{
    ; KEINE �BEREINSTIMMUNG GEFUNDEN
    ; LISTBOX DEAKTIVIEREN
    GuiControl, 1:Disable, OpenTarget
    GuiControl, 1:Disable, ButtonOPENDIR
}
Else
{
    ; �BEREINSTIMMUNGEN GEFUNDEN
    ; LISTBOX AKTIVIEREN
    GuiControl, 1:Enable, OpenTarget
    GuiControl, 1:Enable, ButtonOPENDIR
}

; GUI AKTUALISIEREN
Gui, 1:Show, Center, %version%

Return

;... ENDE DER SilentFindMatches-SUBROUTINE ..........................


;=== BEGINN DER EnterQuery-SUBROUTINE ===========================
; GUI AKTUALISIEREN UND DEM BENUTZER DEN SUCHSTRING EINGEBEN LASSEN
EnterQuery:
GuiControl, Focus, Filename
GuiControl, 1:Enable, ButtonOPEN
Gui, 1:Show, Center, %version%
Return
;... ENDE DER EnterQuery-SUBROUTINE ..........................


;=== BEGINN DES TargetSelection-EREIGNISSES ===========================

TargetSelection:
Gui, 1:Submit, NoHide

; DOPPELKLICKERKENNUNG, UM PROGRAMM ZU STARTEN
If A_GuiControlEvent = DoubleClick
{
    Gosub ButtonOPEN
}
Else
{
    ; PLATZHALTER - F�R ZUK�NFTIGE VERWENDUNG
    If A_GuiControlEvent = Normal
    {
        ; ERSTMAL NICHTS TUN
    }
}

Return

;... ENDE DES TargetSelection-EREIGNISSES .........................


;=== BEGINN DES ButtonOPEN-EREIGNISSES ================================

; BENUTZER HAT DEN BUTTON '�FFNEN' ODER <ENTER> GEDR�CKT
ButtonOPEN:
Gui, 1:Submit, NoHide

; HERAUSFINDEN, WO DER TASTATURFOKUS WAR. WENN ER BEIM
; TEXTFELD IST, ABFRAGE AUSF�HREN, UM �BEREINSTIMMUNGEN ZU FINDEN. ANSONSTEN IST ER
; BEI DER LISTBOX.
GuiControlGet, focusControl, 1:Focus
If focusControl = Edit1
{
    GuiControl, Focus, OpenTarget
    GuiControl, 1:Disable, OpenTarget
    GuiControl, 1:Disable, ButtonOPENDIR
    GuiControl, 1:Disable, ButtonSCANSTARTMENU
    Goto FindMatches
}

; KEINE �BEREINSTIMMUNG AUF DER LISTBOX AUSGEW�HLT
If OpenTarget =
{
    MsgBox, 8192, %version%, Bitte eine Auswahl treffen`, bevor <Enter> gedr�ckt wird.`nDr�cke <Esc>`, um zu beenden.
    Goto EnterQuery
}

; AUSGEW�HLTE �BEREINSTIMMUNG NICHT VORHANDEN  (DATEI ODER VERZEICHNIS NICHT GEFUNDEN)
IfNotExist, %OpenTarget%
{
    MsgBox, 8192, %version%, %OpenTarget% nicht vorhanden. Das hei�t`, dass der Verzeichnis-Cache nicht mehr aktuell ist. Du kannst den Button "Startmen� �berpr�fen" dr�cken`, um den Verzeichnis-Cache mit deiner neuesten Verzeichnisliste zu aktualisieren.
    Goto EnterQuery
}

; �BERPR�FEN, OB DIE AUSGEW�HLTE �BEREINSTIMMUNG EINE DATEI ODER EIN VERZEICHNIS IST
FileGetAttrib, fileAttrib, %OpenTarget%
IfInString, fileAttrib, D ; IST EIN VERZEICHNIS
{
    Gosub sOpenDir
}
Else If fileAttrib <> ; IST EINE DATEI
{
    Run, %OpenTarget%
}
Else
{
    MsgBox %OpenTarget% ist weder ein VERZEICHNIS noch eine DATEI. Das sollte nicht passieren. Die Suche kann nicht fortgesetzt werden. Beenden ...
}

Goto Quit

;... ENDE DES ButtonOPEN-EREIGNISSES .........................


;=== BEGINN DES ButtonOPENDIR-EREIGNISSES =============================

; BENUTZER HAT DEN BUTTON 'VERZEICHNIS �FFNEN' GEDR�CKT
ButtonOPENDIR:
Gui, 1:Submit, NoHide

; �BERPR�FEN, OB DER BENUTZER BEREITS EINE �BEREINSTIMMUNG AUSGEW�HLT HAT
If OpenTarget =
{
    MsgBox, 8192, %version%, Bitte zuerst eine Auswahl treffen.
    Goto EnterQuery
}

; SUBROUTINE AUSF�HREN, UM EIN VERZEICHNIS ZU �FFNEN
Gosub sOpenDir

Goto Quit

;... ENDE DES ButtonOPENDIR-EREIGNISSES .........................


;=== BEGINN DER sOpenDir-SUBROUTINE =============================

sOpenDir:

; WENN DER BENUTZER EINE DATEI�BEREINSTIMMUNG ANSTELLE EINER VERZEICHNIS�BEREINSTIMMUNG AUSW�HLT,
; DEN VERZEICHNISPFAD EXTRAHIEREN. (ICH VERWENDE DriveGet ANSTELLE VON
; FileGetAttrib, UM DAS SZENARIO ZU ERM�GLICHEN, WO OpenTarget
; UNG�LTIG IST, ABER DAS VERZEICHNIS VON OpenTarget G�LTIG IST.
DriveGet, status, status, %OpenTarget%
If status <> Ready ; KEIN VERZEICHNIS
{
    SplitPath, OpenTarget, name, dir, ext, name_no_ext, drive
    OpenTarget = %dir%
}

; �BERPR�FEN, OB VERZEICHNIS VORHANDEN IST
IfNotExist, %OpenTarget%
{
    MsgBox, 8192, %version%, %OpenTarget% nicht vorhanden. Das hei�t`, dass der Verzeichnis-Cache nicht mehr aktuell ist. Du kannst den Button "Startmen� �berpr�fen" dr�cken`, um den Verzeichnis-Cache mit deiner neuesten Verzeichnisliste zu aktualisieren.
    Goto EnterQuery
}

; DAS VERZEICHNIS �FFNEN
IfExist, %dirExplorer%
{
    Run, "%dirExplorer%" "%OpenTarget%", , Max ; MIT BENUTZERDEFINIERTEN DATEI-EXPLORER �FFNEN
}
Else
{
    Run, %OpenTarget%, , Max ; MIT DEN STANDARD-EXPLORER VON WINDOWS �FFNEN
}
Return

;... ENDE DER sOpenDir-SUBROUTINE ..........................


;=== BEGINN DES tIncrementalSearch-EREIGNISSES ========================
; AUTOMATISCH EINE INKREMENTELLE SUCHE IN ECHTZEIT DURCHF�HREN,
; UM �BEREINSTIMMUNGEN ZU FINDEN, OHNE DABEI AUF DIE BENUTZEREINGABE
; <ENTER> ZU WARTEN
tIncrementalSearch:

Loop
; SUCHE WIEDERHOLEN, BIS DER ABFRAGESTRING NICHT MEHR GE�NDERT WIRD
{
    Gui, 1:Submit, NoHide
    CurFilename = %Filename%
    If NewKeyPhrase <> %CurFilename%
    {
        OpenTarget =
        Gosub SilentFindMatches
        NewKeyPhrase = %CurFilename%
        Sleep, 100 ; NICHT DIE CPU �BERLASTEN!
    }
    Else
    {
        ; ABFRAGESTRING WIRD NICHT MEHR GE�NDERT
        Break
    }
}

; BENUTZER HAT <ENTER> GEDR�CKT, UM DIE �BEREINSTIMMUNGEN ANZUSCHAUEN.
; JETZT FindMatches AUSF�HREN.
If ResumeFindMatches = TRUE
{
    ResumeFindMatches = FALSE
    Gosub FindMatches
}

; �NDERUNGS�BERWACHUNG FORTSETZEN
SetTimer, tIncrementalSearch, 500

Return

;... ENDE DES tIncrementalSearch-EREIGNISSES .........................


;=== BEGINN DER Quit-SUBROUTINE =================================

Quit:
ButtonEXIT:
GuiClose:
GuiEscape:

Gui, 1:Submit, NoHide

; SCHL�SSELWORT F�R DIE N�CHSTE AUSF�HRUNG SPEICHERN, FALLS ES GE�NDERT WURDE
If TrackKeyPhrase = ON
{
    If (PrevKeyPhrase <> Filename || PrevOpenTarget <> OpenTarget)
    {
        FileDelete, %keyPhrase%
        FileAppend, %Filename%`n, %keyPhrase%
        FileAppend, %OpenTarget%`n, %keyPhrase%
    }
}

QuitNoSave:
ExitApp ; AUFGABE ERLEDIGT. GUTEN TAG!

;... ENDE DER Quit-SUBROUTINE ..........................


;************************
;<--- ENDE DES PROGRAMMS --->
;************************

; /* vim: set noexpandtab shiftwidth=4: */
