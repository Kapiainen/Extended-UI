Scriptname EXUI_StatsMenu extends ReferenceAlias  

MiscObject Property kSkillDummy Auto
Int iHighlightedSkill = -1

;Events
Event OnInit()
	OnVersionUpdate(GetVersion())
	RegisterEvents()
EndEvent

Event OnPlayerLoadGame()
	UnregisterForAllModEvents()
	UnregisterForAllMenus()
	OnVersionUpdate(GetVersion())
	RegisterEvents()
EndEvent

;Stats menu was opened, send back the skill that was the last to be highlighed when stats menu was last open
Event OnStatsMenuOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	iHighlightedSkill = kSkillDummy.GetWeight() as Int
	UI.InvokeNumber("StatsMenu", "_root.StatsMenuBaseInstance.initializeHighlighting", iHighlightedSkill as Float)
EndEvent

Event OnSkillHighlightChange(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	iHighlightedSkill = afNumArg as Int
EndEvent

Event OnMenuClose(string menuName)
	kSkillDummy.SetWeight(iHighlightedSkill as Float)
EndEvent

;Functions
Function RegisterEvents()
	RegisterForModEvent("EXUI_OnStatsMenuOpen", "OnStatsMenuOpen")
	RegisterForModEvent("EXUI_OnSkillHighlightChange", "OnSkillHighlightChange")
	RegisterForMenu("StatsMenu")
EndFunction

;Script versioning
Int iScriptVersion = 0

Int Function GetVersion()
	Return 1
EndFunction

String Function GetTrace(Int aiVersion)
	Return "===== Extended UI: Stats Menu - Version " + aiVersion + " ====="
EndFunction

Function OnVersionUpdate(Int aiVersion)
	If((aiVersion >= 1) && (iScriptVersion < 1))
		Debug.Trace(GetTrace(aiVersion))
	EndIf

	iScriptVersion = aiVersion
EndFunction
