; WinLIRC-Client
; http://www.autohotkey.com
; Dieses Script empf�ngt Nachrichten von WinLIRC,
; sobald eine Taste der Fernbedienung gedr�ckt wird. Au�erdem kann damit Winamp,
; Windows Media Player und so weiter automatisiert werden. Es ist einfach zu konfigurieren. Wenn zum Beispiel
; WinLIRC eine Schaltfl�che namens "VolUp" auf der Fernbedienung erkennt,
; dann wird ein Label namens VolUp erstellt und der Befehl
; "SoundSet +5" darunter verwendet, um die Lautst�rke der Soundkarte um 5 % zu erh�hen.

; Hier die Schritte, um dieses Script zu verwenden:
; 1) Konfiguriert WinLIRC, damit die Fernbedienung und deren Tasten erkannt werden.
;    WinLIRC kann auf http://winlirc.sourceforge.net gefunden werden
; 2) Bearbeitet den WinLIRC-Pfad, die Adresse und den Port im unteren Konfigurationsbereich.
; 3) Startet das Script. Es wird je nach Bedarf der WinLIRC-Server gestartet.
; 4) Dr�ckt einige Tasten auf der Fernbedienung. Ein kleines Fenster wird
;    angezeigt, mit dem Namen jeder gedr�ckten Taste.
; 5) Konfiguriert die Tasten, damit sie Tastatureingaben und Mausklicks an
;    Fenstern wie Winamp, Media Player und so weiter senden. Siehe untere Beispiele.

; Dieses Script ben�tigt AutoHotkey 1.0.38.04 oder h�her.
; �NDERUNGEN
; 2. M�rz 2007:
; - Zuverl�ssigkeit mithilfe von "Critical" in ReceiveData() verbessert.
; 5. Oktober 2005:
; - Winsock-Warnmeldung "10054" beim Herunterfahren/Abmelden des Systems beseitigt.
; - Option "DelayBetweenButtonRepeats" hinzugef�gt, um die Wiederholungsgeschwindigkeit zu drosseln.

; -------------------------------------------------
; KONFIGURATIONSBEREICH: Hier die Einstellungen vornehmen.
; -------------------------------------------------
; Einige Fernbedienungen wiederholen schnell das Signal, w�hrend
; eine Taste gedr�ckt gehalten wird. Das macht es schwierig, die Fernbedienung dazu zu bringen,
; nur ein Signal zu senden. Die folgende Einstellung l�st dieses Problem, indem wiederholende Signale
; ignoriert werden, bis die angegebene Zeit erreicht ist. 200 ist meistens gut genug.  Setzt sie
; auf 0, um diese Funktion zu deaktivieren.
DelayBetweenButtonRepeats = 200

; Gebt den Pfad zu WinLIRC an, wie z. B. C:\WinLIRC\winlirc.exe
WinLIRC_Path = %A_ProgramFiles%\WinLIRC\winlirc.exe

; Bestimmt die Adresse und den Port von WinLIRC. H�ufig wird 127.0.0.1 (localhost) und 8765 verwendet.
WinLIRC_Address = 127.0.0.1
WinLIRC_Port = 8765

; �ndert nicht die folgenden zwei Zeilen. �berspringt sie einfach.
Gosub WinLIRC_Init
Return

; --------------------------------------------
; AKTIONEN F�R DIE FERNBEDIENUNGSTASTEN ZUWEISEN
; --------------------------------------------
; Konfiguriert die unten genannten Tasten der Fernbedienung. Verwendet die Tastennamen
; von WinLIRC, die in der WinLIRC-Konfigurationsdatei (.cf file) gefunden
; werden k�nnen -- oder dr�ckt eine beliebige Taste auf der Fernbedienung,
; um die Tastennamen in einem kleinen Fenster kurz anzuzeigen.
; 
; Hier dazu einige Beispiele. Sie k�nnen je nach Belieben �berarbeitet und
; gel�scht werden.

VolUp:
SoundSet +5  ; Gesamtlautst�rke um 5 % erh�hen. In Vista oder h�her sollte diese Zeile ersetzt werden mit: Send {Volume_Up}
Return

VolDown:
SoundSet -5  ; Gesamtlautst�rke um 5 % verringern. In Vista oder h�her sollte diese Zeile ersetzt werden mit: Send {Volume_Down}
Return

ChUp:
WinGetClass, ActiveClass, A
if ActiveClass in Winamp v1.x,Winamp PE  ; Winamp ist aktiv.
	Send {right}  ; Die rechte Pfeiltaste senden.
else  ; Irgendein anderes Fenster ist aktiv.
	Send {WheelUp}  ; Das Mausrad eine Rasterung nach oben drehen.
Return

ChDown:
WinGetClass, ActiveClass, A
if ActiveClass in Winamp v1.x,Winamp PE  ; Winamp ist aktiv.
	Send {left}  ; Die linke Pfeiltaste senden.
else  ; Irgendein anderes Fenster ist aktiv.
	Send {WheelDown}  ; Das Mausrad eine Rasterung nach unten drehen.
Return

Menu:
IfWinExist, Unbenannt - Editor
{
	WinActivate
}
Else
{
	Run, Notepad
	WinWait, Unbenannt - Editor
	WinActivate
}
Send Hier einige gesendete Tastatureingaben im Editor.{Enter}
Return

; Die oben genannten Beispiele geben einen Eindruck davon, wie h�ufige Aufgaben durchgef�hrt werden.
; Um die Grundlagen von AutoHotkey zu lernen, siehe Schnellstart-Tutorial
; auf http://de.autohotkey.com/docs/Tutorial.htm

; ----------------------------
; ENDE DES KONFIGURATIONSBEREICHS
; ----------------------------
; Hier danach keine �nderungen durchf�hren, es sei denn,
; die allgemeine Funktionalit�t des Scripts soll ge�ndert werden.

WinLIRC_Init:
OnExit, ExitSub  ; Um die Verbindung zu beenden.

; WinLIRC starten, falls noch nicht getan:
Process, Exist, winlirc.exe
if not ErrorLevel  ; Keine PID f�r WinLIRC gefunden.
{
	IfNotExist, %WinLIRC_Path%
	{
		MsgBox Die Datei "%WinLIRC_Path%" ist nicht vorhanden. Bitte diesen Script bearbeiten, um den Standort festzulegen.
		ExitApp
	}
	Run %WinLIRC_Path%
	Sleep 200  ; Gibt WinLIRC Zeit, zu starten (wahrscheinlich nie notwendig, nur zur Sicherheit).
}

; Mit WinLIRC verbinden (oder beliebiger Server-Typ f�r diese Angelegenheit):
socket := ConnectToAddress(WinLIRC_Address, WinLIRC_Port)
if socket = -1  ; Verbindung fehlgeschlagen (der Grund wird bereits angezeigt).
	ExitApp

; Das Hauptfenster vom Script finden:
Process, Exist  ; Dadurch enth�lt ErrorLevel die PID des Scripts (wird auf diese Weise durchgef�hrt, um kompilierte Scripts zu unterst�tzen).
DetectHiddenWindows On
ScriptMainWindowId := WinExist("ahk_class AutoHotkey ahk_pid " . ErrorLevel)
DetectHiddenWindows Off

; Sobald das Betriebssystem dem Script meldet, dass eingehende Daten darauf warten,
; empfangen zu werden, wird eine Funktion ausgef�hrt, um die Daten zu lesen:
NotificationMsg = 0x5555  ; Eine beliebige Nachrichtenzahl, aber gr��er als 0x1000.
OnMessage(NotificationMsg, "ReceiveData")

; Die Verbindung einstellen, um den Script zu benachrichtigen, sobald neue Daten eingetroffen sind.
; Dadurch wird verhindert, dass die Verbindung abgefragt werden muss, daher verringert sich der Ressourcenverbrauch.
FD_READ = 1     ; Wird empfangen, falls lesbare Daten verf�gbar sind.
FD_CLOSE = 32   ; Wird empfangen, falls die Verbindung unterbrochen wurde.
if DllCall("Ws2_32\WSAAsyncSelect", "UInt", socket, "UInt", ScriptMainWindowId, "UInt", NotificationMsg, "Int", FD_READ|FD_CLOSE)
{
	MsgBox % "WSAAsyncSelect() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError")
	ExitApp
}
Return



ConnectToAddress(IPAddress, Port)
; Damit k�nnen die meisten TCP-Server angesteuert werden, nicht nur WinLIRC.
; Gibt bei Misserfolg eine -1 (INVALID_SOCKET) und bei Erfolg die Sockel-ID zur�ck.
{
	VarSetCapacity(wsaData, 400)
	result := DllCall("Ws2_32\WSAStartup", "UShort", 0x0002, "UInt", &wsaData) ; Winsock 2.0 (0x0002) anfordern
	; Da WSAStartup() wahrscheinlich die erste aufgerufene Winsock-Funktion des Scripts ist,
	; wird ErrorLevel �berpr�ft, ob Winsock 2.0 verf�gbar ist:
	if ErrorLevel
	{
		MsgBox WSAStartup() konnte aufgrund des Fehlers %ErrorLevel% nicht aufgerufen werden. Es wird Winsock 2.0 oder h�her ben�tigt.
		return -1
	}
	if result  ; Ungleich 0, das hei�t Misserfolg (die meisten Winsock-Funktionen geben bei Erfolg eine 0 zur�ck).
	{
		MsgBox % "WSAStartup() kennzeichnet Winsock-Fehler " . DllCall("Ws2_32\WSAGetLastError")
		return -1
	}

	AF_INET = 2
	SOCK_STREAM = 1
	IPPROTO_TCP = 6
	socket := DllCall("Ws2_32\socket", "Int", AF_INET, "Int", SOCK_STREAM, "Int", IPPROTO_TCP)
	if socket = -1
	{
		MsgBox % "socket() kennzeichnet Winsock-Fehler " . DllCall("Ws2_32\WSAGetLastError")
		return -1
	}

	; F�r die Verbindung vorbereiten:
	SizeOfSocketAddress = 16
	VarSetCapacity(SocketAddress, SizeOfSocketAddress)
	InsertInteger(2, SocketAddress, 0, AF_INET)   ; sin_family
	InsertInteger(DllCall("Ws2_32\htons", "UShort", Port), SocketAddress, 2, 2)   ; sin_port
	InsertInteger(DllCall("Ws2_32\inet_addr", "Str", IPAddress), SocketAddress, 4, 4)   ; sin_addr.s_addr

	; Verbindungsversuch:
	if DllCall("Ws2_32\connect", "UInt", socket, "UInt", &SocketAddress, "Int", SizeOfSocketAddress)
	{
		MsgBox % "connect() kennzeichnet Winsock-Fehler " . DllCall("Ws2_32\WSAGetLastError") . ". Wird WinLIRC ausgef�hrt?"
		return -1
	}
	return socket  ; Kennzeichnet Erfolg, indem eine g�ltige Sockel-ID anstelle von -1 zur�ckgegeben wird.
}



ReceiveData(wParam, lParam)
; Durch OnMessage() wird diese Funktion automatisch aufgerufen, sobald neue Daten
; bei der Verbindung eingetroffen sind.  Sie lie�t die Daten von WinLIRC und f�hrt entsprechende Aktionen abh�ngig
; vom Inhalt durch.
{
	Critical  ; Verhindert, dass die Nachricht von einer anderen Nachricht verworfen wird, da der Thread bereits ausgef�hrt wird.
	socket := wParam
	ReceivedDataSize = 4096  ; Hoher Wert, falls viele Daten zwischengespeichert werden, weil eine Verz�gerung beim Verarbeiten der vorherigen Daten auftreten kann.

	VarSetCapacity(ReceivedData, ReceivedDataSize, 0)  ; Mit einer 0 im letzten Parameter wird der String terminiert, damit er f�r recv() verwendet werden kann.
	ReceivedDataLength := DllCall("Ws2_32\recv", "UInt", socket, "Str", ReceivedData, "Int", ReceivedDataSize, "Int", 0)
	if ReceivedDataLength = 0  ; Die Verbindung wurde ordnungsgem�� unterbrochen, vielleicht weil WinLIRC beendet wurde.
		ExitApp  ; Die OnExit-Subroutine wird f�r uns WSACleanup() aufrufen.
	if ReceivedDataLength = -1
	{
		WinsockError := DllCall("Ws2_32\WSAGetLastError")
		if WinsockError = 10035  ; WSAEWOULDBLOCK, das hei�t "keine zu lesenden Daten mehr".
			return 1
		if WinsockError <> 10054 ; WSAECONNRESET, dass passieren kann, wenn WinLIRC durch das Herunterfahren/Abmelden des Systems geschlossen wird.
			; Da das ein unerwarteter Fehler ist, muss er gemeldet werden.  Au�erdem beenden, um eine Endlosschleife zu verhindern.
			MsgBox % "recv() kennzeichnet Winsock-Fehler " . WinsockError
		ExitApp  ; Die OnExit-Subroutine wird f�r uns WSACleanup() aufrufen.
	}
	; Ansonsten die empfangenen Daten bearbeiten. Tests zeigen, dass es m�glich ist, mehr als eine Zeile gleichzeitig zu erhalten
	; (selbst beim direkten Senden eines IR-Signals), wodurch die folgende Mehthode richtig behandelt wird.
	; Empfangene Daten von WinLIRC sehen z. B. wie folgt aus (siehe Dokumentation zu WinLIRC f�r Details):
	; 0000000000eab154 00 Tastenname Fernbedienungsname
	Loop, parse, ReceivedData, `n, `r
	{
		if A_LoopField in ,BEGIN,SIGHUP,END  ; Leere Zeilen und Startnachricht von WinLIRC ignorieren.
			Continue
		ButtonName =  ; Leer machen, falls weniger als 3 Felder unten gefunden werden.
		Loop, parse, A_LoopField, %A_Space%  ; Tastenname extrahieren, der sich im dritten Feld befindet.
			if A_Index = 3
				ButtonName := A_LoopField
		global DelayBetweenButtonRepeats  ; Globale Variablen deklarieren, damit sie f�r diese Funktion verf�gbar sind.
		static PrevButtonName, PrevButtonTime, RepeatCount  ; Diese Variablen merken sich ihre Werte zwischen den Aufrufen.
		if (ButtonName != PrevButtonName || A_TickCount - PrevButtonTime > DelayBetweenButtonRepeats)
		{
			if IsLabel(ButtonName)  ; Es ist eine Subroutine vorhanden, die sich auf diese Taste bezieht.
				Gosub %ButtonName%  ; Die Subroutine starten.
			else ; Falls keine entsprechende Subroutine vorhanden ist, kurz anzeigen, welche Taste gedr�ckt wurde.
			{
				if (ButtonName == PrevButtonName)
					RepeatCount += 1
				Else
					RepeatCount = 1
				SplashTextOn, 150, 20, Taste von WinLIRC, %ButtonName% (%RepeatCount%)
				SetTimer, SplashOff, 3000  ; Dadurch k�nnen mehr Signale beim Anzeigen des Fensters verarbeitet werden.
			}
			PrevButtonName := ButtonName
			PrevButtonTime := A_TickCount
		}
	}
	return 1  ; Dem Programm melden, dass die Nachricht nicht weiter verarbeitet werden muss.
}



SplashOff:
SplashTextOff
SetTimer, SplashOff, Off
Return



InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4)
; Der Aufrufer muss sicherstellen, das pDest ausreichend Kapazit�t hat.  Um vorhandene Inhalte in pDest zu erhalten,
; wird nur die Anzahl an Bytes in pSize beginnend bei pOffset ge�ndert.
{
	Loop %pSize%  ; Jeden Byte im Integer als unbearbeitete Bin�rdaten in die Struktur kopieren.
		DllCall("RtlFillMemory", "UInt", &pDest + pOffset + A_Index-1, "UInt", 1, "UChar", pInteger >> 8*(A_Index-1) & 0xFF)
}



ExitSub:  ; Diese Subroutine wird automatisch aufgerufen, falls das Script aus irgendeinem Grund beendet wird.
; MSDN: "Jeder offene Sockel wird mit WSACleanup zur�ckgesetzt und automatisch
; freigegeben, als wurde closesocket aufgerufen."
DllCall("Ws2_32\WSACleanup")
ExitApp
