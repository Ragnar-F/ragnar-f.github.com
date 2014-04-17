; Button-Namen der MsgBox �ndern
; http://www.autohotkey.com
; Das ist ein funktionierendes Beispiel-Script, das einen Timer verwendet,
; um die Namen der Buttons in einem MsgBox-Dialogfenster zu �ndern. Auch wenn
; die Button-Namen ge�ndert werden, ben�tigt der IfMsgBox-Befehl
; weiterhin den urspr�nglichen Namen des Buttons.

#SingleInstance
SetTimer, ChangeButtonNames, 50 
MsgBox, 4, Hinzuf�gen oder Entfernen, Button ausw�hlen:
IfMsgBox, YES 
	MsgBox, Hinzuf�gen ausgew�hlt. 
else
    MsgBox, Entfernen ausgew�hlt. 
return 

ChangeButtonNames: 
IfWinNotExist, Hinzuf�gen oder Entfernen
    return  ; Warten.
SetTimer, ChangeButtonNames, off
WinActivate
ControlSetText, Button1, &Hinzuf�gen
ControlSetText, Button2, &Entfernen
return
