Scriptname EXUI_SleepWaitMenu extends ReferenceAlias  

EXUI_MCM Property MCM Auto

Event OnInit()
	RegisterForSingleUpdate(2.0)
EndEvent

Event OnUpdate()
	OnVersionUpdate(GetVersion())
	RegisterEvents()
EndEvent

Event OnPlayerLoadGame()
	UnregisterForAllMenus()
	OnVersionUpdate(GetVersion())
	RegisterEvents()
EndEvent

Function RegisterEvents()
	RegisterForMenu("Sleep/Wait Menu")
EndFunction

Event OnMenuOpen(string menuName)
	If(MCM.bSleepWaitMaximum)
		UI.SetFloat("Sleep/Wait Menu", "_root.SleepWaitMenu_mc.HoursSlider.maximum", MCM.fSleepWaitMaximum)
	EndIf
EndEvent

;Script versioning
Int iScriptVersion = 0

Int Function GetVersion()
	Return 1
EndFunction

String Function GetTrace(Int aiVersion)
	Return "===== Extended UI: Sleep/Wait Menu - Version " + aiVersion + " ====="
EndFunction

Function OnVersionUpdate(Int aiVersion)
	If((aiVersion >= 1) && (iScriptVersion < 1))
		Debug.Trace(GetTrace(1))
	EndIf

	iScriptVersion = aiVersion
EndFunction
