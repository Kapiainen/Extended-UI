Scriptname EXUI_MCM extends SKI_ConfigBase  

;Events
Event OnConfigInit()
	ModName = "$EXUI_MODTITLE"
EndEvent

Event OnPageReset(string a_page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0)
	AddHeaderOption("$EXUI_SLEEPWAITTITLE")
	AddToggleOptionST("toggleMaximumSleepWait", "$EXUI_SLEEPWAITMODMAXVAL", bSleepWaitMaximum)
	AddSliderOptionST("sliderMaximumSleepWait", "$EXUI_SLEEPWAITMAXVAL", fSleepWaitMaximum, "$EXUI_HOURSFORMAT")
	SetCursorPosition(1)
	AddHeaderOption("$EXUI_CONSOLETITLE")
	AddToggleOptionST("toggleConsoleFullscreen", "$EXUI_CONSOLEFULLSCREEN", bConsoleFullscreen)
EndEvent

State toggleConsoleFullscreen
	Event OnSelectST()
		bConsoleFullscreen = !bConsoleFullscreen
		SetToggleOptionValueST(bConsoleFullscreen)
	EndEvent

	Event OnDefaultST()
		bConsoleFullscreen = False
		SetToggleOptionValueST(bConsoleFullscreen)	
	EndEvent
EndState

State toggleMaximumSleepWait
	Event OnSelectST()
		bSleepWaitMaximum = !bSleepWaitMaximum
		SetToggleOptionValueST(bSleepWaitMaximum)
	EndEvent

	Event OnDefaultST()
		bSleepWaitMaximum = True
		SetToggleOptionValueST(bSleepWaitMaximum)	
	EndEvent
EndState

State sliderMaximumSleepWait
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fSleepWaitMaximum)
		SetSliderDialogDefaultValue(24.0)
		SetSliderDialogRange(2.0, 999.0)
		SetSliderDialogInterval(1.0)
	EndEvent

	Event OnSliderAcceptST(float a_value)
		fSleepWaitMaximum = a_value
		SetSliderOptionValueST(fSleepWaitMaximum, "$EXUI_HOURSFORMAT")
	EndEvent

	Event OnDefaultST()
		fSleepWaitMaximum = 24.0
		SetSliderOptionValueST(fSleepWaitMaximum, "$EXUI_HOURSFORMAT")
	EndEvent
EndState

;Private variables

;Public variables
Bool Property bSleepWaitMaximum = True Auto Hidden
Float Property fSleepWaitMaximum = 24.0 Auto Hidden
Bool Property bConsoleFullscreen = False Auto Hidden

;Script versioning
Int Function GetVersion()
	Return 1
EndFunction

String Function GetTrace(Int aiVersion)
	Return "===== Extended UI: MCM - Version " + aiVersion + " ====="
EndFunction

Event OnVersionUpdate(int a_version)
	If((a_version >= 1) && (CurrentVersion < 1))
		Debug.Trace(GetTrace(a_version))
	EndIf
EndEvent
