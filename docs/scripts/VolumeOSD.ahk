; Lautst�rke-Bildschirmanzeige (OSD) -- von Rajat
; http://www.autohotkey.com
; Dieses Script erm�glicht beliebige Hotkeys, die Gesamt- und/oder Wave-Lautst�rke
; zu erh�hen oder zu verringern.  Beide Lautst�rken werden als Balkendiagramme
; mit unterschiedlichen Farben angezeigt.

;_________________________________________________ 
;_______Benutzereinstellungen_____________________________ 

; Nur in diesem Bereich oder Hotkey-Bereich �nderungen durchf�hren!! 

; Der Prozentwert, um wieviel die Lautst�rke jedes Mal erh�ht oder verringert wird:
vol_Step = 4

; Wie lange die Balkendiagramme der Lautst�rken angezeigt werden sollen:
vol_DisplayTime = 2000

; Balkenfarbe der Gesamtlautst�rke (siehe Hilfe-Datei, um pr�zisere
; Farbt�ne anzugeben):
vol_CBM = Red

; Balkenfarbe der Wave-Lautst�rke
vol_CBW = Blue

; Hintergrundfarbe
vol_CW = Silver

; Balkenposition auf dem Bildschirm.  Verwendet -1, um den Balken in dieser Abmessung zu zentrieren:
vol_PosX = -1
vol_PosY = -1
vol_Width = 150  ; Balkenbreite
vol_Thick = 12   ; Balkendicke

; Wenn die aktuelle Tastatur Multimedia-Tasten f�r die Lautst�rke hat, dann
; kannst du versuchen, die unteren Hotkeys so zu �ndern, dass sie
; Volume_Up, ^Volume_Up, Volume_Down und ^Volume_Down verwenden:
HotKey, #Up, vol_MasterUp      ; Win+Pfeil nach oben
HotKey, #Down, vol_MasterDown
HotKey, +#Up, vol_WaveUp       ; Umschalt+Win+Pfeil nach oben
HotKey, +#Down, vol_WaveDown


;___________________________________________
;_____automatischer Ausf�hrungsbereich_________ 

; HIER DANACH KEINE �NDERUNGEN DURCHF�HREN (es sei denn, du wei�t, was du tust).

vol_BarOptionsMaster = 1:B ZH%vol_Thick% ZX0 ZY0 W%vol_Width% CB%vol_CBM% CW%vol_CW%
vol_BarOptionsWave   = 2:B ZH%vol_Thick% ZX0 ZY0 W%vol_Width% CB%vol_CBW% CW%vol_CW%

; Wenn die X-Position angegeben wurde, dann wird sie zu den Optionen hinzugef�gt.
; Ansonsten wird sie weggelassen, um den Balken horizontal zu zentrieren:
if vol_PosX >= 0
{
    vol_BarOptionsMaster = %vol_BarOptionsMaster% X%vol_PosX%
    vol_BarOptionsWave   = %vol_BarOptionsWave% X%vol_PosX%
}

; Wenn die Y-Position angegeben wurde, dann wird sie zu den Optionen hinzugef�gt.
; Ansonsten wird sie weggelassen, um sie sp�ter zu berechnen:
if vol_PosY >= 0
{
    vol_BarOptionsMaster = %vol_BarOptionsMaster% Y%vol_PosY%
    vol_PosY_wave = %vol_PosY%
    vol_PosY_wave += %vol_Thick%
    vol_BarOptionsWave = %vol_BarOptionsWave% Y%vol_PosY_wave%
}

#SingleInstance
SetBatchLines, 10ms
Return


;___________________________________________ 

vol_WaveUp:
SoundSet, +%vol_Step%, Wave
Gosub, vol_ShowBars
return

vol_WaveDown:
SoundSet, -%vol_Step%, Wave
Gosub, vol_ShowBars
return

vol_MasterUp:
SoundSet, +%vol_Step%
Gosub, vol_ShowBars
return

vol_MasterDown:
SoundSet, -%vol_Step%
Gosub, vol_ShowBars
return

vol_ShowBars:
; Um den Blinkeffekt zu unterdr�cken, wird nur das Balkenfenster erstellt,
; falls noch nicht vorhanden:
IfWinNotExist, vol_Wave
    Progress, %vol_BarOptionsWave%, , , vol_Wave
IfWinNotExist, vol_Master
{
    ; Falls sich die Bildschirmaufl�sung �ndert, wird hier die Position berechnet,
    ; w�hrend das Script l�uft:
    if vol_PosY < 0
    {
        ; Wave-Balken direkt �ber den Balken der Gesamtlautst�rke erstellen:
        WinGetPos, , vol_Wave_Posy, , , vol_Wave
        vol_Wave_Posy -= %vol_Thick%
        Progress, %vol_BarOptionsMaster% Y%vol_Wave_Posy%, , , vol_Master
    }
    else
        Progress, %vol_BarOptionsMaster%, , , vol_Master
}
; Sobald beide Lautst�rken vom Benutzer oder von einem externen Programm ge�ndert werden, werden die neuen Lautst�rken abgerufen:
SoundGet, vol_Master, Master
SoundGet, vol_Wave, Wave
Progress, 1:%vol_Master%
Progress, 2:%vol_Wave%
SetTimer, vol_BarOff, %vol_DisplayTime%
return

vol_BarOff:
SetTimer, vol_BarOff, off
Progress, 1:Off
Progress, 2:Off
return
