Scriptname EXUI_ConsoleMenu extends ReferenceAlias  

Actor PlayerRef
EXUI_MCM Property MCM Auto

;Events
Event OnInit()
	RegisterForSingleUpdate(2.0)
EndEvent

Event OnUpdate()
	PlayerRef = Game.GetPlayer()
	OnVersionUpdate(GetVersion())
	RegisterEvents()
EndEvent

Event OnPlayerLoadGame()
	UnregisterForAllMenus()
	UnregisterForAllModEvents()
	OnVersionUpdate(GetVersion())
	RegisterEvents()
EndEvent

Function RegisterEvents()
	RegisterForMenu("Console")
	RegisterForModEvent("EXUI_GetCurrentCrosshairRef", "OnGetCrosshairRef")
	RegisterForModEvent("EXUI_WriteToPapyrusLog", "OnWriteToLog")
	RegisterForModEvent("EXUI_LoadMenu", "OnLoadMenu")
EndFunction

;Set cell name and FormID when opening the console
Event OnMenuOpen(string menuName)
	;Fullscreen
	If(MCM.bConsoleFullscreen)
		UI.Invoke("Console", "_root.ConsoleMenu_mc.ConsoleInstance_mc.setFullscreen");
	EndIf

	;Current cell
	If(PlayerRef != None)
		Cell kCell = PlayerRef.GetParentCell()
		If(kCell != None)
			String sCellName = kCell.GetName()
			Int iCellFormID = kCell.GetFormID()
			Int iHandle = UICallback.Create("Console", "_root.ConsoleMenu_mc.ConsoleInstance_mc.setCurrentCell")
			If(iHandle)
				UICallback.PushString(iHandle, sCellName)
				UICallback.PushInt(iHandle, iCellFormID)
				UICallback.Send(iHandle)
			EndIf
		EndIf
	EndIf
EndEvent

;Get the name, ReferenceID, and FormID of the reference currently in the crosshair
Event OnGetCrosshairRef(string asEventName, string asStringArg, float afNumArg, form akSender)
	;Current crosshair ref
	ObjectReference kCurrentCrosshairRef = Game.GetCurrentCrosshairRef()
	If(kCurrentCrosshairRef != None)
		Form kCurrentCrosshairRefBase = kCurrentCrosshairRef.GetBaseObject()
		String sCurrentCrosshairRefName = kCurrentCrosshairRefBase.GetName()
		Int iCurrentCrosshairRefFormID = kCurrentCrosshairRefBase.GetFormID()
		Int iCurrentCrosshairRefReferenceID = kCurrentCrosshairRef.GetFormID()
		Int iHandle = UICallback.Create("Console", "_root.ConsoleMenu_mc.ConsoleInstance_mc.setCurrentCrosshairRef")
		If(iHandle)
			UICallback.PushString(iHandle, sCurrentCrosshairRefName)
			UICallback.PushInt(iHandle, iCurrentCrosshairRefFormID)
			UICallback.PushInt(iHandle, iCurrentCrosshairRefReferenceID)
			UICallback.Send(iHandle)
		EndIf
	EndIf
EndEvent

;Write asStringArg to Papyrus log
Event OnWriteToLog(string asEventName, string asStringArg, float afNumArg, form akSender)
	Debug.Trace(asStringArg)
EndEvent

;Open and close custom menus with asStringArg being the file to load
Event OnLoadMenu(string asEventName, string asStringArg, float afNumArg, form akSender)
	If(UI.IsMenuOpen("CustomMenu"))
		UI.CloseCustomMenu()
	Else
		If(asStringArg != "")
			UI.OpenCustomMenu(asStringArg)
		EndIf
	EndIf
EndEvent

;Script versioning
Int iScriptVersion = 0

Int Function GetVersion()
	Return 2
EndFunction

String Function GetTrace(Int aiVersion)
	Return "===== Extended UI: Console Menu - Version " + aiVersion + " ====="
EndFunction

Function OnVersionUpdate(Int aiVersion)
	If((aiVersion >= 1) && (iScriptVersion < 1))
		Debug.Trace(GetTrace(1))
	EndIf

	If((aiVersion >= 2) && (iScriptVersion < 2))
		Debug.Trace(GetTrace(2))
		If(PlayerRef == None)
			PlayerRef = Game.GetPlayer()
		EndIf
	EndIf

	iScriptVersion = aiVersion
EndFunction
