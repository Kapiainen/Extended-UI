import Shared.ButtonChange;
import Components.Meter;
import gfx.io.GameDelegate;
import Shared.GlobalFunc;
import mx.utils.Delegate;
import flash.filters.GlowFilter;

class StatsMenu extends MovieClip
{
	static var StatsMenuInstance: StatsMenu = null;

	static var MAGICKA_METER: Number = 0;
	static var HEALTH_METER: Number = 1;
	static var STAMINA_METER: Number = 2;
	static var CURRENT_METER_TEXT: Number = 0;
	static var MAX_METER_TEXT: Number = 1;
	static var ALTERATION: Number = 0;
	static var CONJURATION: Number = 1;
	static var DESTRUCTION: Number = 2;
	static var MYSTICISM: Number = 3;
	static var RESTORATION: Number = 4;
	static var ENCHANTING: Number = 5;
	static var LIGHT_ARMOR: Number = 6;
	static var PICKPOCKET: Number = 7;
	static var LOCKPICKING: Number = 8;
	static var SNEAK: Number = 9;
	static var ALCHEMY: Number = 10;
	static var SPEECHCRAFT: Number = 11;
	static var ONE_HANDED_WEAPONS: Number = 12;
	static var TWO_HANDED_WEAPONS: Number = 13;
	static var MARKSMAN: Number = 14;
	static var BLOCK: Number = 15;
	static var SMITHING: Number = 16;
	static var HEAVY_ARMOR: Number = 17;
	static var SkillStatsA = new Array();
	static var PerkNamesA = new Array();
	static var BeginAnimation: Number = 0;
	static var EndAnimation: Number = 1000;
	static var STATS: Number = 0;
	static var LEVEL_UP: Number = 1;

	static var MaxPerkNameHeight: Number = 16; //115 is the vanilla value
	static var MaxPerkNameHeightLevelMode: Number = 38; //175 is the vanilla value
	static var MaxPerkNamesDisplayed: Number = 64;

	static var SkillsA: Array;
	static var SkillRing_mc: MovieClip;
	static var MagickaMeterBase: MovieClip;
	static var HealthMeterBase: MovieClip;
	static var StaminaMeterBase: MovieClip;
	static var MagickaMeter: Meter;
	static var HealthMeter: Meter;
	static var StaminaMeter: Meter;
	static var MeterText: Array;

	var CameraUpdateInterval: Number = 0;

	var AddPerkButtonInstance: MovieClip;
	var CameraMovementInstance: MovieClip;
	var CurrentPerkFrame: Number;
	var DescriptionCardMeter: Meter;
	var LevelMeter: Meter;
	var PerkEndFrame: Number;
	var PerkName0: MovieClip;
	var PerksLeft: Number;
	var Platform: Number;
	var SkillsListInstance: MovieClip;
	var State: Number; 

	var DescriptionCardInstance: MovieClip; // Skill and perk descriptions
	
	var SkillMarkers: Array;
	
	var backgroundBarUpper: MovieClip;
	var backgroundBarLower: MovieClip;
	var perkNotification: MovieClip;

	var highlightingInitialized: Boolean = false;
	
	var bHideLegendaryPrompts: Boolean = false;
	var bShowSkillModifiers: Boolean = false;
	var AttributesA: Array;
	var SkillBasesA: Array;
	
	// Player info
	var playerName: String = "";
	var playerRace: String = "";
	var playerLevel: Number = 1;
	var playerLevelProgress: Number = 0;
	var bPlayerInfoUpdateRequested: Boolean = false;
	
	// Skill/perk descriptions
	var previousDescription: String = "Init";
	
	// Skill meters
	static var SKILLMARKER_ALPHA_REGULAR = 50;
	static var SKILLMARKER_ALPHA_HIGHLIGHTED = 100;
	private var bPerkMode: Boolean = false;
	var highlightSkillIndex: Number = 76;
	var highlightSkillAngle: Number = 300;
	
	// Misc
	var currentAngle: Number = 300;
	
	// ==== Private functions ====
	// Initialization
	
	function StatsMenu()
	{
		super();
		StatsMenu.StatsMenuInstance = this;
		DescriptionCardMeter = new Meter(StatsMenu.StatsMenuInstance.DescriptionCardInstance.animate);
		StatsMenu.SkillsA = new Array();
		StatsMenu.SkillRing_mc = SkillsListInstance;
		var playerInfoCard: MovieClip = backgroundBarUpper.BottomBarInstance.BottomBarPlayerInfoInstance.PlayerInfoCardInstance;
		StatsMenu.MagickaMeterBase = playerInfoCard.MagickaMeterInstance;
		StatsMenu.HealthMeterBase = playerInfoCard.HealthMeterInstance;
		StatsMenu.StaminaMeterBase = playerInfoCard.StaminaMeterInstance;
		StatsMenu.MagickaMeter = new Meter(StatsMenu.MagickaMeterBase.MagickaMeter_mc);
		StatsMenu.HealthMeter = new Meter(StatsMenu.HealthMeterBase.HealthMeter_mc);
		StatsMenu.StaminaMeter = new Meter(StatsMenu.StaminaMeterBase.StaminaMeter_mc);
		StatsMenu.MagickaMeterBase.Magicka.gotoAndStop("Pause");
		StatsMenu.HealthMeterBase.Health.gotoAndStop("Pause");
		StatsMenu.StaminaMeterBase.Stamina.gotoAndStop("Pause");
		StatsMenu.MeterText = [playerInfoCard.magicValue, playerInfoCard.healthValue, playerInfoCard.enduranceValue];
		SetMeter(StatsMenu.MAGICKA_METER, 50, 100);
		SetMeter(StatsMenu.HEALTH_METER, 75, 100);
		SetMeter(StatsMenu.STAMINA_METER, 25, 100);
		Platform = ButtonChange.PLATFORM_PC;
		AddPerkButtonInstance._alpha = 0;

		for (var i: Number = 0; i < StatsMenu.MaxPerkNamesDisplayed; i++) {
			var perkName: MovieClip = attachMovie("PerkName", "PerkName" + i, getNextHighestDepth());
			perkName._x = -100 - _x;
		}

		backgroundBarUpper.TopPlayerInfo.swapDepths(getNextHighestDepth());
		SetStatsMode(true, 0);
		CurrentPerkFrame = 0;
		PerkName0.gotoAndStop("Visible");
		PerkEndFrame = PerkName0._currentFrame;
		PerkName0.gotoAndStop("Invisible");
		StatsMenu.StatsMenuInstance.gotoAndStop(48);
		StatsMenu.StatsMenuInstance.gotoAndPlay("Skills");
		bPerkMode = false;
		SkillMarkers = new Array();
		SkillBasesA = new Array();
		perkNotification.AddPerkTextInstance.buttonPCSpaceInstance._alpha = 0;
		perkNotification.AddPerkTextInstance.buttonX360YInstance._alpha = 0;
		perkNotification.AddPerkTextInstance.buttonPS3YInstance._alpha = 0;
	}
	
	function InitExtensions(): Void
	{
		GlobalFunc.SetLockFunction();
		GlobalFunc.MaintainTextFormat();
		GameDelegate.addCallBack("SetDescriptionCard", this, "SetDescriptionCard");
		GameDelegate.addCallBack("SetPlayerInfo", this, "SetPlayerInfo");
		GameDelegate.addCallBack("UpdateSkillList", this, "UpdateSkillList");
		GameDelegate.addCallBack("SetDirection", this, "SetDirection");
		GameDelegate.addCallBack("SetStatsMode", this, "SetStatsMode");
		GameDelegate.addCallBack("SetPerkCount", this, "SetPerkCount");
	}
	
	static function SetPlatform(): Void
	{
		/*
			arguments[0] = ? : Number
			arguments[1] = ? : Boolean
		*/		
		StatsMenu.StatsMenuInstance.AddPerkButtonInstance.SetPlatform(arguments[0], arguments[1]);
		StatsMenu.StatsMenuInstance.Platform = arguments[0];
	}
	
	// Misc

	function GetSkillClip(aSkillName: String): TextField
	{
		return SkillsListInstance.BaseRingInstance[aSkillName].Val.ValText;
	}

	function SetStatsMode(): Void
	{
		State = arguments[0] ? StatsMenu.STATS : StatsMenu.LEVEL_UP;
		PerksLeft = arguments[1];
		if (arguments[1] != undefined) {
			SetPerkCount(arguments[1]);
		}
	}
	
	function UpdateCamera(): Void
	{
		if (StatsMenu.StatsMenuInstance.CameraMovementInstance._currentFrame < 100) {
			var nextFrame: Number = StatsMenu.StatsMenuInstance.CameraMovementInstance._currentFrame + 8;
			if (nextFrame > 100) {
				nextFrame = 100;
			}
			GameDelegate.call("MoveCamera", [CameraMovementInstance.CameraPositionAlpha._alpha / 100]);
			return;
		}
		clearInterval(CameraUpdateInterval);
		CameraUpdateInterval = 0;
	}

	static function StartCameraAnimation(): Void
	{		
		clearInterval(StatsMenu.StatsMenuInstance.CameraUpdateInterval);
		GameDelegate.call("MoveCamera", [0]);
		StatsMenu.StatsMenuInstance.CameraUpdateInterval = setInterval(Delegate.create(StatsMenu.StatsMenuInstance, StatsMenu.StatsMenuInstance.UpdateCamera), 41);
	}
	
	function SetDirection(): Void //aAngle: Number): Void
	{
		/*
			arguments[0] = Angle: Number
		*/
		currentAngle = arguments[0];
	}
	
	// Perk and legendary skills
	
	function UpdatePerkText(abShow: Boolean): Void
	{
		if (abShow == true || abShow == undefined) {
			var perkIdx: Number = 0;
			var perkAdded: Boolean = false;
			for (var i: Number = 0; i < StatsMenu.PerkNamesA.length; i += 3) {
				
				if (StatsMenu.PerkNamesA[i] == undefined) {
					if (!perkAdded && this["PerkName" + perkIdx] != undefined) {
						this["PerkName" + perkIdx].gotoAndStop("Invisible");
					}
				} else if (GlobalFunc.Lerp(0, 720, 0, 1, StatsMenu.PerkNamesA[i + 2]) > (State == StatsMenu.LEVEL_UP ? StatsMenu.MaxPerkNameHeightLevelMode : StatsMenu.MaxPerkNameHeight)) {
					this["PerkName" + perkIdx].PerkNameClipInstance.NameText.html = true;
					this["PerkName" + perkIdx].PerkNameClipInstance.NameText.htmlText = "<font face=\'$EverywhereMediumFont\'>" + StatsMenu.PerkNamesA[i] + "</font>";
					this["PerkName" + perkIdx]._xscale = StatsMenu.PerkNamesA[i + 2] * 165 + 10;
					this["PerkName" + perkIdx]._yscale = StatsMenu.PerkNamesA[i + 2] * 165 + 10;
					this["PerkName" + perkIdx]._x = GlobalFunc.Lerp(0, 1280, 0, 1, StatsMenu.PerkNamesA[i + 1]) - _x;
					this["PerkName" + perkIdx]._y = GlobalFunc.Lerp(0, 720, 0, 1, StatsMenu.PerkNamesA[i + 2]) - _y;
					this["PerkName" + perkIdx].bPlaying = true;
					if (this["PerkName" + perkIdx] != undefined) {
						this["PerkName" + perkIdx].gotoAndStop(CurrentPerkFrame);
					}
					perkIdx++;
					perkAdded = true;
				}
			}

			for (var j: Number = perkIdx; j <= StatsMenu.MaxPerkNamesDisplayed; j++) {
				if (this["PerkName" + j] != undefined) {
					this["PerkName" + j].gotoAndStop("Invisible");
				}
			}

			if (CurrentPerkFrame <= PerkEndFrame) {
				CurrentPerkFrame++;
			}
			return;
		}

		if (abShow == false) {
			CurrentPerkFrame = 0;
			for (var i: Number = 0; i < StatsMenu.MaxPerkNamesDisplayed; i++) {
				if (this["PerkName" + i] != undefined) {
					this["PerkName" + i].gotoAndStop("Invisible");
				}
			}
		}
	}

	function SetPerkCount(): Void
	{
		/*
			arguments[0] = Perk points : Number
		*/		
		// Show number of unassigned perk points
		perkNotification.AddPerkTextInstance.buttonPCSpaceInstance._alpha = 0;
		perkNotification.AddPerkTextInstance.buttonX360YInstance._alpha = 0;
		perkNotification.AddPerkTextInstance.buttonPS3YInstance._alpha = 0;
		perkNotification.AddPerkTextInstance.AddPerkTextField._x = 69.25;
			
		if(bPerkMode == false) {
			if (SkillStatsA[(highlightSkillIndex - 1)] != undefined) {
				if ((SkillStatsA[(highlightSkillIndex - 1)] >= 100) && (!bHideLegendaryPrompts)) {
					ShowLegendarySkill(true, arguments[0]);
					return;
				} else {				
					// Legendary counter
					ShowLegendaryCounter();
					
					if (arguments[0] <= 0) {
						ShowLegendarySkill(false, arguments[0]);
						return;
					}
				}
			}
		}
		
		if (arguments[0] > 0) {
			perkNotification.AddPerkTextInstance._alpha = 100;
			SetPerkNotification(_root.PerksInstance.text + " " + arguments[0]);
			return;
		}
		// Hide number of unassigned perk points
		perkNotification.AddPerkTextInstance._alpha = 0;
	}
	
	function SetPerkNotification(asString: String) {
		perkNotification.AddPerkTextInstance.AddPerkTextField.html = true;
		perkNotification.AddPerkTextInstance.AddPerkTextField.htmlText = "<font face=\'$EverywhereMediumFont\' size=\'20\' color=\'#FFFFFF\'>" + asString + "</font>";
	}
	
	function ShowLegendarySkill(abShow: Boolean, aiPerkCount: Number): Void
	{
		if(abShow == true) {
			SetPerkNotification("$Legendary");
			
			if (StatsMenu.StatsMenuInstance.Platform == 0) {
				SetLegendaryButton(perkNotification.AddPerkTextInstance.buttonPCSpaceInstance);
			} else if (StatsMenu.StatsMenuInstance.Platform == 3) {
				SetLegendaryButton(perkNotification.AddPerkTextInstance.buttonPS3YInstance);
			} else {
				SetLegendaryButton(perkNotification.AddPerkTextInstance.buttonX360YInstance);
			}
			
			perkNotification.AddPerkTextInstance._alpha = 100;
		} else {
			if(aiPerkCount <= 0) {
				perkNotification.AddPerkTextInstance._alpha = 0;
			}
		}
	}
	
	function ShowLegendaryCounter(): Void
	{
		var skillLegendaryCount: Number = highlightSkillIndex + 3;
		var descriptionCard: MovieClip = StatsMenu.StatsMenuInstance.DescriptionCardInstance;
		if (SkillStatsA[skillLegendaryCount] != undefined) {
			if ((SkillStatsA[skillLegendaryCount] > 0) && (!bHideLegendaryPrompts))
			{
				descriptionCard.legendaryCounter.counterTextField.html = true;
				descriptionCard.legendaryCounter.counterTextField.htmlText = SkillStatsA[skillLegendaryCount];
				descriptionCard.legendaryCounter._x = -8.5;
				descriptionCard.legendaryCounter._y = descriptionCard.CardDescriptionTextInstance._y - 10.0;
				descriptionCard.legendaryCounter._alpha = 100;
			} else {
				descriptionCard.legendaryCounter._alpha = 0;
			}
		} else {
			descriptionCard.legendaryCounter._alpha = 0;
		}
	}
	
	function SetLegendaryButton(akButton: Object) {
		var xSpacer: Number = 10.0;
		
		perkNotification.AddPerkTextInstance.AddPerkTextField._x = 69.25 + ((akButton._width + xSpacer) / 2.0);
		akButton._x = perkNotification.AddPerkTextInstance.AddPerkTextField._x + ((perkNotification.AddPerkTextInstance.AddPerkTextField._width - perkNotification.AddPerkTextInstance.AddPerkTextField.textWidth) / 2.0) - xSpacer;

		akButton._alpha = 100;
	}
	
	// Skill meters

	function UpdateSkillList(): Void // Set the names of skills here
	{
		/*
			Each skill has 5 elements in StatsMenu.SkillStatsA (90 elements / 18 skills).
			
			Example:
			[0] = 15 (Skill level)
			[1] = Enchanting (Skill name)
			[2] = 0 (Progress to next level of this skill)
			[3] = #FFFFFF (Color)
			[4] = 0 (Number of times a skill has been made legendary)
		*/			
		if(SkillMarkers.length <= 0) {
			//var markerSpacer: Number = 125;
			var markerScale: Number = (150.0 / 216.45) * 100;

			for(var i: Number = 0; i < 18; i++) {
				var skillMarkerNew = backgroundBarLower[("SkillMarker" + i)];
				skillMarkerNew._alpha = StatsMenu.SKILLMARKER_ALPHA_REGULAR;
				skillMarkerNew._xscale = markerScale;
				skillMarkerNew._yscale = markerScale;

				SkillMarkers.push(skillMarkerNew);
			}

			setAspectRatio(0);
			
			if(highlightingInitialized == false) {
				skse.SendModEvent("EXUI_OnStatsMenuOpen");
			}
		}
		
		if (!bShowSkillModifiers)
		{
			setSkillMarkerLabels();
		}
	}
	
	function setSkillMarkerLabels(): Void
	{
		for(var i: Number = 0; i < 18; i++) {
			var skillLevel: Number = (i * 5);
			var skillName: Number = skillLevel + 1;
			var skillProgress: Number = skillLevel + 2;
			var skillColor: Number = skillLevel + 3;
			SkillMarkers[i].LabelInstance.html = true;
			if ((SkillBasesA != null) && (SkillBasesA.length > 0))
			{
				var modifier: Number = Math.round(StatsMenu.SkillStatsA[skillLevel] - SkillBasesA[i]);
				if ((!isNaN(modifier)) && (modifier != 0))
				{
					if (modifier > 0)
					{
						SkillMarkers[i].LabelInstance.htmlText = "<font face=\'$EverywhereMediumFont\'>" + (StatsMenu.SkillStatsA[skillName].toString().toUpperCase())  + "</font> <font color=\'#FFFFFF\'>" + SkillBasesA[i].toString().toUpperCase() + " (+" + modifier.toString().toUpperCase() + ")</font>";
					}
					else
					{
						SkillMarkers[i].LabelInstance.htmlText = "<font face=\'$EverywhereMediumFont\'>" + (StatsMenu.SkillStatsA[skillName].toString().toUpperCase())  + "</font> <font color=\'#FFFFFF\'>" + SkillBasesA[i].toString().toUpperCase() + " (" + modifier.toString().toUpperCase() + ")</font>";
					}
				}
				else
				{
					SkillMarkers[i].LabelInstance.htmlText = "<font face=\'$EverywhereMediumFont\'>" + (StatsMenu.SkillStatsA[skillName].toString().toUpperCase())  + "</font> <font color=\'#FFFFFF\'>" + SkillBasesA[i].toString().toUpperCase() + "</font>";
				}
			}
			else
			{
				SkillMarkers[i].LabelInstance.htmlText = "<font face=\'$EverywhereMediumFont\'>" + (StatsMenu.SkillStatsA[skillName].toString().toUpperCase())  + "</font> <font color=\'" + StatsMenu.SkillStatsA[skillColor] + "\'>" + StatsMenu.SkillStatsA[skillLevel].toString().toUpperCase() + "</font>";
			}
			var ShortBar: Meter = new Meter(SkillMarkers[i].ShortBar);
			ShortBar.SetPercent(StatsMenu.SkillStatsA[skillProgress]);
		}
	}
	
	function SetMeter(): Void
	{
		/*
			arguments[0] = Meter: Number (0 -> Magicka, 1 -> Health, 2 -> Stamina)
			arguments[1] = Current: Number
			arguments[2] = Max: Number
			arguments[3] = Color: Number (string?)
		*/
		if (arguments[0] >= StatsMenu.MAGICKA_METER && arguments[0] <= StatsMenu.STAMINA_METER) {
			var meterPercent: Number = 100 * (Math.max(0, Math.min(arguments[1], arguments[2])) / arguments[2]);
			
			switch (arguments[0]) {
				case StatsMenu.MAGICKA_METER:
					StatsMenu.MagickaMeter.SetPercent(meterPercent);
					break;
				case StatsMenu.HEALTH_METER:
					StatsMenu.HealthMeter.SetPercent(meterPercent);
					break;
				case StatsMenu.STAMINA_METER:
					StatsMenu.StaminaMeter.SetPercent(meterPercent);
					break;
			}
			
			StatsMenu.MeterText[arguments[0]].html = true;
			StatsMenu.MeterText[arguments[0]].SetText("<font face=\'$EverywhereMediumFont\' color=\'" + arguments[3] + "\'>" + arguments[1] + "/" + arguments[2] + "</font>", true);
			StatsMenu.MagickaMeter.Update();
			StatsMenu.HealthMeter.Update();
			StatsMenu.StaminaMeter.Update();
		}
	}

	function updateHighlightedSkill(): Void
	{
		if(backgroundBarLower._alpha == 100) {
			if(highlightingInitialized == true) {
				highlightSkillAngle = ((highlightSkillIndex - 1) / 5) * 20;
			} else {
				highlightSkillAngle = currentAngle;
			}
			
			for(var i: Number = 0; i < SkillMarkers.length; i++) {
				SkillMarkers[i]._alpha = StatsMenu.SKILLMARKER_ALPHA_REGULAR;
			}
			SkillMarkers[((highlightSkillIndex - 1) / 5)]._alpha = StatsMenu.SKILLMARKER_ALPHA_HIGHLIGHTED;
			skse.SendModEvent("EXUI_OnSkillHighlightChange", null, ((highlightSkillIndex - 1) / 5));
		}
	}	
	
	function updateHighlightedIndex(): Void
	{
		if(backgroundBarLower._alpha == 100) {
			if(currentAngle < highlightSkillAngle) {
				if(currentAngle < 20) {
					highlightSkillIndex = 1;
				} else {
					highlightSkillIndex -= 5;
				}
			} else if(currentAngle > highlightSkillAngle) {
				if(currentAngle > 340) {
					if(highlightSkillAngle > 0) {
						highlightSkillIndex = 1;
					} else {
						highlightSkillIndex = 86;
					}
				} else {
					highlightSkillIndex += 5;
				}
			}
		}
	}
	
	// Player info
	
	function SetPlayerInfo(): Void
	{
		/*
			arguments[0] = Player name: string
			arguments[1] = Player level: number
			arguments[2] = Player level progress in percent: number
			arguments[3] = Player race: string
			arguments[4] = Magicka current: number
			arguments[5] = Magicka max: number
			arguments[6] = Magicka color: number
			arguments[7] = Health current: number
			arguments[8] = Health max: number
			arguments[9] = Health color: number
			arguments[10] = Stamina current: number
			arguments[11] = Stamina max: number
			arguments[12] = Stamina color: number
		*/		
		playerName = arguments[0];
		playerRace = arguments[3];
		playerLevel = arguments[1];
		playerLevelProgress = arguments[2];
		
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.FirstLastLabel.textAutoSize = "shrink";
		
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.FirstLastLabel.html = true;
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.FirstLastLabel.htmlText = "<font face=\'$EverywhereMediumFont\'>" + arguments[0] + "</font>";
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.LevelNumberLabel.html = true;
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.LevelNumberLabel.htmlText = "<font face=\'$EverywhereMediumFont\'>" + arguments[1] + "</font>";
		if (LevelMeter == undefined) {
			LevelMeter = new Meter(StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.animate);
		}
		LevelMeter.SetPercent(arguments[2]);
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.RacevalueLabel.html = true;
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.RacevalueLabel.htmlText = "<font face=\'$EverywhereMediumFont\'>" + arguments[3] + "</font>";

		AttributesA = new Array();
		AttributesA.push(arguments[4]);
		AttributesA.push(arguments[5]);
		AttributesA.push(arguments[6]);
		AttributesA.push(arguments[7]);
		AttributesA.push(arguments[8]);
		AttributesA.push(arguments[9]);
		AttributesA.push(arguments[10]);
		AttributesA.push(arguments[11]);
		AttributesA.push(arguments[12]);
		
		if (!bPlayerInfoUpdateRequested)
		{
			bPlayerInfoUpdateRequested = true;
			skse.SendModEvent("EXUI_OnPlayerInfoUpdate");
		}
		
		updatePlayerInfo();
		if(StatsMenu.SkillStatsA.length <= 0) {
			backgroundBarLower._alpha = 0;
		}
	}
	
	function updatePlayerInfo(): Void
	{
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.FirstLastLabel.SetText(playerName);
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.RacevalueLabel.SetText(playerRace);
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.LevelNumberLabel.SetText(playerLevel);
		if (LevelMeter == undefined) {
			LevelMeter = new Meter(StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.animate);
		}
		LevelMeter.SetPercent(playerLevelProgress);
	}
	
	// Skill/perk descriptions

	function SetDescriptionCard(): Void
	{
		/*			
			arguments[0] = True -> Perk mode, False -> Skill mode: Boolean
			arguments[1] = Perk name: String (Perks only)
			arguments[2] = ?: Number (Perks only)
			arguments[3] = Perk/skill description: String
			arguments[4] = Perk required skill level: String
			arguments[5] = Relevant skill level : Number
			arguments[6] = Perk relevant skill level: String
			arguments[7] = ?: Number (Skills only)
		*/		
		if(previousDescription != arguments[3]) {
			previousDescription = arguments[3];
			if(arguments[0]) {
				// Perk
				var skillName: String = arguments[6].substr(0, arguments[6].indexOf(" <", 0));
				for(var i = 1; i < StatsMenu.SkillStatsA.length; i += 5) {
					if(StatsMenu.SkillStatsA[i] == skillName) {
						highlightSkillIndex = i;
						updateHighlightedSkill();
						break;
					}
				}
			}
			
			if(bPerkMode != arguments[0]) {
				bPerkMode = arguments[0];
				if(!bPerkMode) {
					updateHighlightedSkill();
				}
				if (StatsMenu.StatsMenuInstance != undefined) {
					StatsMenu.StatsMenuInstance.gotoAndPlay(arguments[0] ? "Perks" : "Skills");
				}
			} else {
				 if(!arguments[0]) {
					// Skill
					if(highlightingInitialized == true) {
						updateHighlightedIndex();
						updateHighlightedSkill();
					}
				}
			}

			var descriptionCard: MovieClip = StatsMenu.StatsMenuInstance.DescriptionCardInstance;

			// Skill mode
			if (!arguments[0]) {
				if (SkillStatsA[highlightSkillIndex] == undefined) {
					SetCardDescriptionText("<font color=\'#FFFFFF\'>" + arguments[3] + "</font>");
				} else {
					SetCardDescriptionText("<font size=\'28\' color=\'#999999\'>" + SkillStatsA[highlightSkillIndex] + "</font>\n" + "<font color=\'#FFFFFF\'>" + arguments[3] + "</font>");
				}
				descriptionCard.CardDescriptionTextInstance._y = 15.0 - descriptionCard.CardDescriptionTextInstance._height;
				
				// Legendary counter
				ShowLegendaryCounter();
				
				descriptionCard.CardNameTextInstance.html = true;
				descriptionCard.CardNameTextInstance.htmlText = "<font face=\'$EverywhereMediumFont\'>" + arguments[1].toUpperCase() + "</font>" + " <font face=\'$EverywhereBoldFont\' size=\'32\' color=\'#FFFFFF\'>" + arguments[5] + "</font>";
				StatsMenu.StatsMenuInstance.DescriptionCardMeter.SetPercent(arguments[7]);
				return;
			}
			// Perk mode
			SetCardDescriptionText(arguments[3]);
			descriptionCard.CardDescriptionTextInstance._y = descriptionCard.CardNameTextInstance._y + descriptionCard.CardNameTextInstance._height;
			descriptionCard.CardNameTextDivider._y = descriptionCard.CardDescriptionTextInstance._y + descriptionCard.CardDescriptionTextInstance._height + 8.0;
			descriptionCard.SkillRequirementText._y = descriptionCard.CardNameTextDivider._y + 8.0;
			descriptionCard.firstSkillval._y = descriptionCard.SkillRequirementText._y + 20.0;
			descriptionCard.secondSkillval._y = descriptionCard.SkillRequirementText._y + 20.0;
			descriptionCard.secondSkill._y = descriptionCard.SkillRequirementText._y + 24.0;
			
			
			descriptionCard.CardNameTextInstance.SetText("");
			descriptionCard.SkillRequirementText.html = true;
			descriptionCard.SkillRequirementText.htmlText = arguments[6].toUpperCase() + "          " + arguments[4].toUpperCase(); //10 spaces
			if (PerksLeft != undefined) {
				SetPerkCount(PerksLeft);
			}
			descriptionCard.Perktype.SetText(arguments[6]);
		}
	}
	
	function SetCardDescriptionText(asString: String): Void
	{
		var descriptionCard: MovieClip = StatsMenu.StatsMenuInstance.DescriptionCardInstance;
		descriptionCard.CardDescriptionTextInstance.html = true;
		descriptionCard.CardDescriptionTextInstance.htmlText = "<font face=\'$EverywhereMediumFont\'>" + asString + "</font>";
		descriptionCard.CardDescriptionTextInstance._height = descriptionCard.CardDescriptionTextInstance.textHeight + 4.0;
	}
	
	// ==== Public functions ====
	// Papyrus API
	
	// Sets whether or not UI elements related to Legendary skills should be hidden.
	public function setHideLegendaryPrompts(abFlag: Boolean): Void
	{
		bHideLegendaryPrompts = abFlag;
	}
	
	// Sets whether or not to show the values of skills with modifiers (true) or modified text colors (false).
	public function setShowSkillModifiers(abFlag: Boolean): Void
	{
		bShowSkillModifiers = abFlag;
	}
	
	// Shows (de)buffed attributes with modified text colors.
	public function setMetersOriginal(): Void
	{
		SetMeter(0, AttributesA[0], AttributesA[1], AttributesA[2]);
		SetMeter(1, AttributesA[3], AttributesA[4], AttributesA[5]);
		SetMeter(2, AttributesA[6], AttributesA[7], AttributesA[8]);
	}
	
	// Shows (de)buffed attributes with modifiers.
	public function setMetersModified(): Void
	{
		/*
			0 = Base value magicka
			1 = Base value health
			2 = Base value stamina
		*/		
		for (var i: Number = 0; i < 3; i++)
		{
			var percent: Number = 100 * (Math.max(0, Math.min(AttributesA[3 * i], AttributesA[3 * i + 1])) / AttributesA[3 * i + 1]);
			var modifier: Number = AttributesA[3 * i + 1] - arguments[i];
			var skillText: String = "<font face=\'$EverywhereMediumFont\'>" + Math.ceil(AttributesA[3 * i]) + "/" + Math.ceil(arguments[i]);
			if ((!isNaN(modifier)) && (modifier != 0))
			{
				skillText += " (";
				if (modifier > 0)
				{
					skillText += "+";
				}
				skillText += modifier + ")";
			}
			skillText += "</font>";
			
			if (i == 0)
			{
				StatsMenu.MagickaMeter.SetPercent(percent);
				StatsMenu.MeterText[0].html = true;				
				StatsMenu.MeterText[0].SetText(skillText, true);
				StatsMenu.MagickaMeter.Update();
			}
			else if (i == 1)
			{
				StatsMenu.HealthMeter.SetPercent(percent);
				StatsMenu.MeterText[1].html = true;
				StatsMenu.MeterText[1].SetText(skillText, true);
				StatsMenu.HealthMeter.Update();
			}
			else if (i == 2)
			{
				StatsMenu.StaminaMeter.SetPercent(percent);
				StatsMenu.MeterText[2].html = true;
				StatsMenu.MeterText[2].SetText(skillText, true);
				StatsMenu.StaminaMeter.Update();
			}
		}
	}
	
	// Base values of skills are sent here when skill modifiers should be shown.
	public function setSkillBaseLevels(): Void
	{
		if (arguments.length > 0)
		{
			SkillBasesA = new Array();
			for (var i: Number = 0; i < arguments.length; i++)
			{
				SkillBasesA.push(arguments[i]);
			}
			setSkillMarkerLabels();
		}		
	}
	
	// Sets which skill marker should be highlighted. New Skyrim sessions reset to highlighting Destruction, but bookkeeping is necessary during a session.
	public function initializeHighlighting(aIndex: Number): Void
	{
		if(aIndex >= 0){
			highlightSkillIndex = (aIndex * 5) +1;
		}
		updateHighlightedSkill();
		highlightingInitialized = true;
	}

	// Places UI elements so that they fit the given aspect ratio.
	public function setAspectRatio(aIndex: Number): Void
	{
		var xOrigin: Number = Math.abs(backgroundBarLower.background._x) + 11; // = backgroundBarLower.background._x
		var yOrigin: Number = 0; // 82
		var yOffset: Number = 0; // 45
		var xMultiplier: Number = 1.0; // 0.75
		var slotWidth: Number = 150.0;
		var markerWidth: Number = SkillMarkers[0]._width * SkillMarkers[0]._xscale;
		
		// Set values used to place skill markers relative to each other
		if(aIndex == 0) // 4:3
		{
			xOrigin += 160;
			yOrigin = 82;
			yOffset = 45;
			xMultiplier = 0.75;
			slotWidth = ((720 / 3.0) * 4.0) / 6.0;
		}
		else if(aIndex == 1) // 5:4
		{
			xOrigin += 190;
			yOrigin = 82;
			yOffset = 45;
			xMultiplier = 0.75;
			slotWidth = ((720 / 4.0) * 5.0) / 6.0;
		}
		else if(aIndex == 2) // 16:9
		{
			xOrigin += 0;
			yOrigin = 82;
			yOffset = 45;
			xMultiplier = 1.0;
			slotWidth = ((720 / 9.0) * 16.0) / 6.0;
		}
		else if(aIndex == 3) // 16:10
		{
			xOrigin += 64;
			yOrigin = 82;
			yOffset = 45;
			xMultiplier = 1.0;
			slotWidth = ((720 / 10.0) * 16.0) / 6.0;
		}
		
		var markerSpacer: Number = (slotWidth - markerWidth) / 2.0;

		// Place skill markers
		// Bottom row = Mage skills
		SkillMarkers[13]._x = xOrigin + slotWidth / 2.0;
		SkillMarkers[13]._y = yOrigin;
		for(var i: Number = 14; i < 18; i++) {
			SkillMarkers[i]._x = SkillMarkers[i - 1]._x + slotWidth;
			SkillMarkers[i]._y = SkillMarkers[13]._y;
		}
		SkillMarkers[0]._x = SkillMarkers[17]._x + slotWidth;
		SkillMarkers[0]._y = SkillMarkers[13]._y;
		
		// Middle row = Thief skills
		SkillMarkers[7]._x = SkillMarkers[13]._x;
		SkillMarkers[7]._y = SkillMarkers[13]._y - yOffset;
		for(var i: Number = 8; i < 13; i++) {
			SkillMarkers[i]._x = SkillMarkers[i - 1]._x + slotWidth;
			SkillMarkers[i]._y = SkillMarkers[7]._y;
		}
		
		// Top row = Warrior skills
		SkillMarkers[1]._x = SkillMarkers[13]._x;
		SkillMarkers[1]._y = SkillMarkers[7]._y - yOffset;
		for(var i: Number = 2; i < 7; i++) {
			SkillMarkers[i]._x = SkillMarkers[i - 1]._x + slotWidth;
			SkillMarkers[i]._y = SkillMarkers[1]._y;
		}
	}
}
