Scriptname EXUI_StatsMenu extends ReferenceAlias  

MiscObject Property kSkillDummy Auto
Int iHighlightedSkill = -1
EXUI_MCM Property MCM Auto
Actor PlayerRef

;Events
Event OnInit()
	RegisterForSingleUpdate(2.0)
EndEvent

Event OnUpdate()
	OnVersionUpdate(GetVersion())
	RegisterEvents()
EndEvent

Event OnPlayerLoadGame()
	UnregisterForAllModEvents()
	UnregisterForAllMenus()
	OnVersionUpdate(GetVersion())
	RegisterEvents()
EndEvent

Event OnStatsMenuOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	iHighlightedSkill = kSkillDummy.GetWeight() as Int
	UI.InvokeNumber("StatsMenu", "_root.StatsMenuBaseInstance.initializeHighlighting", iHighlightedSkill as Float)
	UI.InvokeNumber("StatsMenu", "_root.StatsMenuBaseInstance.setAspectRatio", MCM.iStatsMenuAspectRatio)
	UI.InvokeBool("StatsMenu", "_root.StatsMenuBaseInstance.setHideLegendaryPrompts", MCM.bHideLegendaryPrompts)
	UI.InvokeBool("StatsMenu", "_root.StatsMenuBaseInstance.setShowSkillModifiers", MCM.bShowSkillModifiers)
	SendSkillData()
	RegisterForMenu("MessageBoxMenu")
EndEvent

Event OnSkillHighlightChange(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	iHighlightedSkill = afNumArg as Int
EndEvent

Event OnPlayerInfoUpdate(string asEventName, string asStringArg, float afNumArg, form akSender)
	SendAttributeData()
EndEvent

Function SendAttributeData()
	If(MCM.bShowAttributeModifiers)
		Float[] fBaseAttributeLevels = new Float[3]
		fBaseAttributeLevels[0] = PlayerRef.GetBaseActorValue("Magicka")
		fBaseAttributeLevels[1] = PlayerRef.GetBaseActorValue("Health")
		fBaseAttributeLevels[2] = PlayerRef.GetBaseActorValue("Stamina")
		UI.InvokeFloatA("StatsMenu", "_root.StatsMenuBaseInstance.setMetersModified", fBaseAttributeLevels)
		Return
	EndIf
	UI.Invoke("StatsMenu", "_root.StatsMenuBaseInstance.setMetersOriginal")
EndFunction

Function SendSkillData()
	If(MCM.bShowSkillModifiers)
		Float[] fBaseSkillLevels = new Float[18]
		fBaseSkillLevels[0] = PlayerRef.GetBaseActorValue("Enchanting")
		fBaseSkillLevels[1] = PlayerRef.GetBaseActorValue("Smithing")
		fBaseSkillLevels[2] = PlayerRef.GetBaseActorValue("HeavyArmor")
		fBaseSkillLevels[3] = PlayerRef.GetBaseActorValue("Block")
		fBaseSkillLevels[4] = PlayerRef.GetBaseActorValue("TwoHanded")
		fBaseSkillLevels[5] = PlayerRef.GetBaseActorValue("OneHanded")
		fBaseSkillLevels[6] = PlayerRef.GetBaseActorValue("Marksman")
		fBaseSkillLevels[7] = PlayerRef.GetBaseActorValue("LightArmor")
		fBaseSkillLevels[8] = PlayerRef.GetBaseActorValue("Sneak")
		fBaseSkillLevels[9] = PlayerRef.GetBaseActorValue("Lockpicking")
		fBaseSkillLevels[10] = PlayerRef.GetBaseActorValue("Pickpocket")
		fBaseSkillLevels[11] = PlayerRef.GetBaseActorValue("Speechcraft")
		fBaseSkillLevels[12] = PlayerRef.GetBaseActorValue("Alchemy")
		fBaseSkillLevels[13] = PlayerRef.GetBaseActorValue("Illusion")
		fBaseSkillLevels[14] = PlayerRef.GetBaseActorValue("Conjuration")
		fBaseSkillLevels[15] = PlayerRef.GetBaseActorValue("Destruction")
		fBaseSkillLevels[16] = PlayerRef.GetBaseActorValue("Restoration")
		fBaseSkillLevels[17] = PlayerRef.GetBaseActorValue("Alteration")
		UI.InvokeFloatA("StatsMenu", "_root.StatsMenuBaseInstance.setSkillBaseLevels", fBaseSkillLevels)
	EndIf
EndFunction

Event OnMenuClose(string menuName)
	If(menuName == "StatsMenu")
		kSkillDummy.SetWeight(iHighlightedSkill as Float)
		UnregisterForMenu("MessageBoxMenu")
	Elseif(menuName == "LevelUp Menu")
		OnPlayerInfoUpdate("", "", 0.0, None)
	Else
		SendSkillData()
	EndIf
EndEvent

;Functions
Function RegisterEvents()
	RegisterForModEvent("EXUI_OnStatsMenuOpen", "OnStatsMenuOpen")
	RegisterForModEvent("EXUI_OnSkillHighlightChange", "OnSkillHighlightChange")
	RegisterForModEvent("EXUI_OnPlayerInfoUpdate", "OnPlayerInfoUpdate")
	RegisterForMenu("StatsMenu")
	RegisterForMenu("LevelUp Menu")
EndFunction

;Script versioning
Int iScriptVersion = 0

Int Function GetVersion()
	Return 3
EndFunction

String Function GetTrace(Int aiVersion)
	Return "===== Extended UI: Stats Menu - Version " + aiVersion + " ====="
EndFunction

Function OnVersionUpdate(Int aiVersion)
	If((aiVersion >= 1) && (iScriptVersion < 1))
		Debug.Trace(GetTrace(1))
	EndIf

	If((aiVersion >= 2) && (iScriptVersion < 2))
		Debug.Trace(GetTrace(2))
	EndIf

	If((aiVersion >= 3) && (iScriptVersion < 3))
		Debug.Trace(GetTrace(3))
		PlayerRef = Game.GetPlayer()
	EndIf

	iScriptVersion = aiVersion
EndFunction
