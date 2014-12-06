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

	static var MaxPerkNameHeight: Number = 16; //115;
	static var MaxPerkNameHeightLevelMode: Number = 38; //175;
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
	//var AddPerkTextInstance: MovieClip; // Amount of perks to distribute
	//var BottomBarInstance: MovieClip; // Magicka, health, stamina
	var CameraMovementInstance: MovieClip;
	var CurrentPerkFrame: Number;
	var DescriptionCardMeter: Meter;
	var LevelMeter: Meter; // Level progress
	var PerkEndFrame: Number;
	var PerkName0: MovieClip;
	var PerksLeft: Number;
	var Platform: Number;
	var SkillsListInstance: MovieClip;
	var State: Number; 
	//var TopPlayerInfo: MovieClip; // Name, level, race


	var DescriptionCardInstance: MovieClip; // Skill and perk descriptions
	//var AnimatingSkillTextInstance: AnimatedSkillText;
	
	var SkillMarkers: Array;
	
	var backgroundBarUpper: MovieClip;
	var backgroundBarLower: MovieClip;
	var perkNotification: MovieClip;
	
	static var SKILLMARKER_ALPHA_REGULAR = 50;
	static var SKILLMARKER_ALPHA_HIGHLIGHTED = 100;

	function StatsMenu()
	{
		super();
		StatsMenu.StatsMenuInstance = this;
		DescriptionCardMeter = new Meter(StatsMenu.StatsMenuInstance.DescriptionCardInstance.animate);
		StatsMenu.SkillsA = new Array();
		StatsMenu.SkillRing_mc = SkillsListInstance;
		//SetDirection(0);
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
		perkNotification.AddPerkTextInstance.buttonPCSpaceInstance._alpha = 0;
		perkNotification.AddPerkTextInstance.buttonX360YInstance._alpha = 0;
		perkNotification.AddPerkTextInstance.buttonPS3YInstance._alpha = 0;
		//skse.Log("===== StatsMenu =====");
		
		//setInterval(Delegate.create(StatsMenu.StatsMenuInstance, StatsMenu.StatsMenuInstance.FakePress), 500);
	}
	
	/*
	var gotoSkillId_: Number;
	
	public function gotoSkill(skill: Number): Void
	{
		// Left or right, which is the shortest route?
		var Distance: Number = skill - ((highlightSkillIndex - 1) / 5);
		if(Math.abs(Distance) > 9)
			Distance = Distance * -1;
		gotoSkillId_ = setInterval(this, "transitioningToAngle", 20, skill, Distance);
	}
	
	function transitioningToAngle(skill: Number, transitionDirection: Number): Void
	{
		_global.skse.ApplyStatsMenuTransition(transitionDirection, 0);
		//_global.skse.ApplyStatsMenuTransition(1000, 0);
		if(highlightSkillIndex == ((skill * 5) + 1)) {
			clearInterval(gotoSkillId_);
			_global.skse.ApplyStatsMenuTransition(0, 1);
		}
	}
	*/
	
	/*
	function FakePress()
	{
		this.onEnterFrame = function()
		{
			_global.skse.ApplyStatsMenuTransition(150, 0);
		};
	}
	*/

	function GetSkillClip(aSkillName: String): TextField
	{
		/*
		skse.Log("===== GetSkillClip =====");
		for(var i = 0; i < arguments.length; i++) {
			skse.Log("arguments[" + i + "] = " + arguments[i]);
		}
		*/
		
		return SkillsListInstance.BaseRingInstance[aSkillName].Val.ValText;
	}

	function UpdatePerkText(abShow: Boolean): Void
	{
		//skse.Log("===== UpdatePerkText =====");
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
					//this["PerkName" + perkIdx].PerkNameClipInstance.NameText.SetText(StatsMenu.PerkNamesA[i], true);
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

	function InitExtensions(): Void
	{
		//skse.Log("===== InitExtensions =====");
		GlobalFunc.SetLockFunction();
		GlobalFunc.MaintainTextFormat();
		GameDelegate.addCallBack("SetDescriptionCard", this, "SetDescriptionCard");
		GameDelegate.addCallBack("SetPlayerInfo", this, "SetPlayerInfo");
		GameDelegate.addCallBack("UpdateSkillList", this, "UpdateSkillList");
		GameDelegate.addCallBack("SetDirection", this, "SetDirection");
		GameDelegate.addCallBack("HideRing", this, "HideRing");
		GameDelegate.addCallBack("SetStatsMode", this, "SetStatsMode");
		GameDelegate.addCallBack("SetPerkCount", this, "SetPerkCount");
	}

	function SetStatsMode(): Void
	{
		/*
			arguments[0] = ? : Boolean
			arguments[1] = Perk points : Number
		*/
		/*
			skse.Log("===== SetStatsMode =====");
			for(var i = 0; i < arguments.length; i++) {
				skse.Log("arguments[" + i + "] = " + arguments[i]);
			}
		*/
		
		State = arguments[0] ? StatsMenu.STATS : StatsMenu.LEVEL_UP;
		PerksLeft = arguments[1];
		if (arguments[1] != undefined) {
			SetPerkCount(arguments[1]);
		}
	}

	function SetPerkCount(): Void
	{
		/*
			arguments[0] = Perk points : Number
		*/
		/*
			skse.Log("===== SetPerkCount =====");
			for(var i = 0; i < arguments.length; i++) {
				skse.Log("arguments[" + i + "] = " + arguments[i]);
			}
		*/
		
		// Show number of unassigned perk points
		//skse.Log("Highlighted skill level = " + SkillStatsA[(highlightSkillIndex - 1)]);
		perkNotification.AddPerkTextInstance.buttonPCSpaceInstance._alpha = 0;
		perkNotification.AddPerkTextInstance.buttonX360YInstance._alpha = 0;
		perkNotification.AddPerkTextInstance.buttonPS3YInstance._alpha = 0;
		perkNotification.AddPerkTextInstance.AddPerkTextField._x = 69.25;
			
		if(bPerkMode == false) {
			if (SkillStatsA[(highlightSkillIndex - 1)] != undefined) {
				if (SkillStatsA[(highlightSkillIndex - 1)] >= 100) {
					//skse.Log("Skill is eligible for Legendary treatment");
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
			//"<font face=\'$EverywhereMediumFont\' color=\'" + arguments[3] + "\'>" + arguments[1] + "/" + arguments[2] + "</font>"
			//perkNotification.AddPerkTextInstance.AddPerkTextField.html = true;
			//perkNotification.AddPerkTextInstance.AddPerkTextField.htmlText = "<font face=\'$EverywhereMediumFont\' size=\'20\' color=\'#FFFFFF\'>" + _root.PerksInstance.text + " " + arguments[0] + "</font>";
			//perkNotification.AddPerkTextInstance.AddPerkTextField.text = _root.PerksInstance.text + " " + arguments[0];
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
			/*
			var xSpacer: Number = -10.0;
			var xPos: Number = perkNotification.AddPerkTextInstance.AddPerkTextField._x + ((perkNotification.AddPerkTextInstance.AddPerkTextField._width - perkNotification.AddPerkTextInstance.AddPerkTextField.textWidth) / 2.0) + xSpacer;
			if (StatsMenu.StatsMenuInstance.Platform == 0) {
				perkNotification.AddPerkTextInstance.buttonPCSpaceInstance._x = xPos;
				perkNotification.AddPerkTextInstance.AddPerkTextField._x = perkNotification.AddPerkTextInstance.AddPerkTextField._x + (perkNotification.AddPerkTextInstance.buttonPCSpaceInstance._width / 2.0);
				perkNotification.AddPerkTextInstance.buttonPCSpaceInstance._alpha = 100;
			} else if (StatsMenu.StatsMenuInstance.Platform == 3) {
				perkNotification.AddPerkTextInstance.buttonPS3YInstance._x = xPos;
				
				perkNotification.AddPerkTextInstance.buttonPS3YInstance._alpha = 100;
			} else {
				perkNotification.AddPerkTextInstance.buttonX360YInstance._x = xPos;
				perkNotification.AddPerkTextInstance.buttonX360YInstance._alpha = 100;
			}
			*/
			
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
	
	function SetLegendaryButton(akButton: Object) {
		var xSpacer: Number = 10.0;
		
		perkNotification.AddPerkTextInstance.AddPerkTextField._x = 69.25 + ((akButton._width + xSpacer) / 2.0);
		akButton._x = perkNotification.AddPerkTextInstance.AddPerkTextField._x + ((perkNotification.AddPerkTextInstance.AddPerkTextField._width - perkNotification.AddPerkTextInstance.AddPerkTextField.textWidth) / 2.0) - xSpacer;

		akButton._alpha = 100;
	}

	static function SetPlatform(): Void
	{
		/*
			arguments[0] = ? : Number
			arguments[1] = ? : Boolean
		*/
		/*
			skse.Log("===== SetPlatform =====");
			for(var i = 0; i < arguments.length; i++) {
				skse.Log("arguments[" + i + "] = " + arguments[i]);
			}
		*/
		
		StatsMenu.StatsMenuInstance.AddPerkButtonInstance.SetPlatform(arguments[0], arguments[1]);
		StatsMenu.StatsMenuInstance.Platform = arguments[0];
	}

	function UpdateCamera(): Void
	{
		/*
		skse.Log("===== UpdateCamera =====");
		for(var i = 0; i < arguments.length; i++) {
			skse.Log("arguments[" + i + "] = " + arguments[i]);
		}
		*/
		
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
		/*
		skse.Log("===== StartCameraAnimation =====");
		for(var i = 0; i < arguments.length; i++) {
			skse.Log("arguments[" + i + "] = " + arguments[i]);
		}
		*/
		
		clearInterval(StatsMenu.StatsMenuInstance.CameraUpdateInterval);
		GameDelegate.call("MoveCamera", [0]);
		StatsMenu.StatsMenuInstance.CameraUpdateInterval = setInterval(Delegate.create(StatsMenu.StatsMenuInstance, StatsMenu.StatsMenuInstance.UpdateCamera), 41);
	}

	function UpdateSkillList(): Void // Set the names of skills here
	{
		/*
			skse.Log("===== UpdateSkillList =====");		
			//for(var i = 1; i < StatsMenu.SkillStatsA.length; i += 5) {
			for(var i = 0; i < StatsMenu.SkillStatsA.length; i += 1) {
				skse.Log("SkillStatsA[" + i + "] = " + StatsMenu.SkillStatsA[i]);
			}
		*/
		
		/*
			Each skill has 5 elements in StatsMenu.SkillStatsA (90 elements / 18 skills).
			
			Example:
			[0] = 15 (Skill level)
			[1] = Enchanting (Skill name)
			[2] = 0 (Progress to next level of this skill)
			[3] = #FFFFFF (Color)
			[4] = 0 (Number of times a skill has been made legendary)
		*/
		//StatsMenu.StatsMenuInstance.AnimatingSkillTextInstance.InitAnimatedSkillText(StatsMenu.SkillStatsA);				
		if(SkillMarkers.length <= 0) {
			var markerSpacer: Number = 125;
			//var markerScale: Number = 150.0 / SkillMarker0._width;
			var markerScale: Number = (150.0 / 216.45) * 100;
			
			//skse.Log("Generating markers");
			for(var i: Number = 0; i < 18; i++) {
				var skillMarkerNew = backgroundBarLower[("SkillMarker" + i)];//backgroundBarLower.attachMovie("SkillText_mc", "SkillText" + i, getNextHighestDepth());
				/*
				var skillLevel: Number = (i * 5);
				var skillName: Number = skillLevel + 1;
				var skillProgress: Number = skillLevel + 2;
				var skillColor: Number = skillLevel + 3;
				*/
				
				//skillMarkerNew.LabelInstance.html = true;
				
				//skillMarkerNew.LabelInstance.htmlText = "<font face=\'$EverywhereMediumFont\'>" + (StatsMenu.SkillStatsA[skillName].toString().toUpperCase())  + "</font>" + " <font color=\'" + StatsMenu.SkillStatsA[skillColor] + "\'>" + StatsMenu.SkillStatsA[skillLevel].toString().toUpperCase() + "</font>";
				skillMarkerNew._alpha = StatsMenu.SKILLMARKER_ALPHA_REGULAR;
				skillMarkerNew._xscale = markerScale;
				skillMarkerNew._yscale = markerScale;

				//var ShortBar: Meter = new Meter(skillMarkerNew.ShortBar);
				//ShortBar.SetPercent(StatsMenu.SkillStatsA[skillProgress]);
				SkillMarkers.push(skillMarkerNew);
				//skse.Log("SkillMarker" + i + ", x = " + SkillMarkers[i]._x + ", y = " + SkillMarkers[i]._y);
			}
			
			//3x6
			//Bottom row
			//SkillMarkers[13]._x = 190 + 190 - 8 + 22 + SkillMarkers[0]._width / 4.0 * 3.0;
			SkillMarkers[13]._x = 190 + 190 + 19 + SkillMarkers[0]._width / 4.0 * 3.0;
			SkillMarkers[13]._y = 82;
			for(var i: Number = 14; i < 18; i++) {
				SkillMarkers[i]._x = SkillMarkers[i - 1]._x + SkillMarkers[0]._width / 4.0 * 3.0;
				SkillMarkers[i]._y = SkillMarkers[13]._y;
			}
			SkillMarkers[0]._x = SkillMarkers[17]._x + SkillMarkers[0]._width / 4.0 * 3.0;
			SkillMarkers[0]._y = SkillMarkers[13]._y;
			
			//Middle row
			SkillMarkers[7]._x = SkillMarkers[13]._x;
			SkillMarkers[7]._y = SkillMarkers[13]._y - 45;
			for(var i: Number = 8; i < 13; i++) {
				SkillMarkers[i]._x = SkillMarkers[i - 1]._x + SkillMarkers[0]._width / 4.0 * 3.0;
				SkillMarkers[i]._y = SkillMarkers[7]._y;
			}
			
			//Top row
			SkillMarkers[1]._x = SkillMarkers[13]._x;
			SkillMarkers[1]._y = SkillMarkers[7]._y - 45;
			for(var i: Number = 2; i < 7; i++) {
				SkillMarkers[i]._x = SkillMarkers[i - 1]._x + SkillMarkers[0]._width / 4.0 * 3.0;
				SkillMarkers[i]._y = SkillMarkers[1]._y;
			}
			
			if(highlightingInitialized == false) {
				//highlightingInitialized = true;
				skse.SendModEvent("EXUI_OnStatsMenuOpen");
			}
		}
		
		for(var i: Number = 0; i < 18; i++) {
			var skillLevel: Number = (i * 5);
			var skillName: Number = skillLevel + 1;
			var skillProgress: Number = skillLevel + 2;
			var skillColor: Number = skillLevel + 3;
			SkillMarkers[i].LabelInstance.html = true;
			SkillMarkers[i].LabelInstance.htmlText = "<font face=\'$EverywhereMediumFont\'>" + (StatsMenu.SkillStatsA[skillName].toString().toUpperCase())  + "</font>" + " <font color=\'" + StatsMenu.SkillStatsA[skillColor] + "\'>" + StatsMenu.SkillStatsA[skillLevel].toString().toUpperCase() + "</font>";
			var ShortBar: Meter = new Meter(SkillMarkers[i].ShortBar);
			ShortBar.SetPercent(StatsMenu.SkillStatsA[skillProgress]);
			//SkillMarkers[i].ShortBar.SetPercent(StatsMenu.SkillStatsA[skillProgress]);
		}
	}
	
	public function initializeHighlighting(aIndex: Number): Void
	{
		//skse.Log("===== initializeHighlighting = " + aIndex + " =====");
		if(aIndex >= 0){
			highlightSkillIndex = (aIndex * 5) +1;
		}
		updateHighlightedSkill();
		highlightingInitialized = true;
	}
	
	var highlightingInitialized: Boolean = false;

	function HideRing(): Void
	{
		//skse.Log("===== HideRing =====");
		//StatsMenu.StatsMenuInstance.AnimatingSkillTextInstance.HideRing();
	}
	

	function SetDirection(): Void //aAngle: Number): Void
	{
		//skse.Log("===== SetDirection (frame: " + StatsMenu.StatsMenuInstance._currentframe + ") =====");
		/*
			arguments[0] = Angle: Number
			
		skse.Log("===== SetDirection =====");
		for(var i = 0; i < arguments.length; i++) {
			skse.Log("arguments[" + i + "] = " + arguments[i]);
		}
		*/
		
		
		//StatsMenu.StatsMenuInstance.AnimatingSkillTextInstance.SetAngle(arguments[0]);
		//highlightSkill(arguments[0]);
		currentAngle = arguments[0];
		//skse.Log("Updating angle to " + currentAngle);
	}
	
	var currentAngle: Number = 300;

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
		/*
		skse.Log("===== SetPlayerInfo =====");
		for(var i = 0; i < arguments.length; i++) {
			skse.Log("arguments[" + i + "] = " + arguments[i]);
		}
		*/
		
		playerName = arguments[0];
		playerRace = arguments[3];
		playerLevel = arguments[1];
		playerLevelProgress = arguments[2];
		
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.FirstLastLabel.textAutoSize = "shrink";
		
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.FirstLastLabel.html = true;
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.FirstLastLabel.htmlText = "<font face=\'$EverywhereMediumFont\'>" + arguments[0] + "</font>";
		//StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.FirstLastLabel.SetText(arguments[0]);
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.LevelNumberLabel.html = true;
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.LevelNumberLabel.htmlText = "<font face=\'$EverywhereMediumFont\'>" + arguments[1] + "</font>";
		//StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.LevelNumberLabel.SetText(arguments[1]);
		if (LevelMeter == undefined) {
			LevelMeter = new Meter(StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.animate);
		}
		LevelMeter.SetPercent(arguments[2]);
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.RacevalueLabel.html = true;
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.RacevalueLabel.htmlText = "<font face=\'$EverywhereMediumFont\'>" + arguments[3] + "</font>";
		//StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.RacevalueLabel.SetText(arguments[3]);
		SetMeter(0, arguments[4], arguments[5], arguments[6]);
		SetMeter(1, arguments[7], arguments[8], arguments[9]);
		SetMeter(2, arguments[10], arguments[11], arguments[12]);
		
		updatePlayerInfo();
		if(StatsMenu.SkillStatsA.length <= 0) {
			backgroundBarLower._alpha = 0;
		}
	}
	
	var playerName: String = "";
	var playerRace: String = "";
	var playerLevel: Number = 1;
	var playerLevelProgress: Number = 0;
	
	function updatePlayerInfo(): Void
	{
		//skse.Log("===== updatePlayerInfo =====");
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.FirstLastLabel.SetText(playerName);
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.RacevalueLabel.SetText(playerRace);
		StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.LevelNumberLabel.SetText(playerLevel);
		if (LevelMeter == undefined) {
			LevelMeter = new Meter(StatsMenu.StatsMenuInstance.backgroundBarUpper.TopPlayerInfo.animate);
		}
		LevelMeter.SetPercent(playerLevelProgress);
	}

	function SetMeter(): Void
	{
		//skse.Log("===== SetMeter =====");
		/*
			arguments[0] = Meter: Number (0 -> Magicka, 1 -> Health, 2 -> Stamina)
			arguments[1] = Current: Number
			arguments[2] = Max: Number
			arguments[3] = Color: Number (string?)
		*/
		/*
			skse.Log("===== SetMeter =====");
			for(var i = 0; i < arguments.length; i++) {
				skse.Log("arguments[" + i + "] = " + arguments[i]);
			}
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
			if (arguments[3] == undefined) {
				StatsMenu.MeterText[arguments[0]].SetText("<font face=\'$EverywhereMediumFont\' color=\'" + arguments[3] + "\'>" + arguments[1] + "/" + arguments[2] + "</font>", true);
				//StatsMenu.MeterText[arguments[0]].SetText("<font face=\'$EverywhereBoldFont\' color=\'" + arguments[3] + "\'>" + arguments[1] + "/" + arguments[2] + "</font>", true);
			} else {
				StatsMenu.MeterText[arguments[0]].SetText("<font face=\'$EverywhereMediumFont\' color=\'" + arguments[3] + "\'>" + arguments[1] + "/" + arguments[2] + "</font>", true);
				//StatsMenu.MeterText[arguments[0]].SetText("<font face=\'$EverywhereBoldFont\' color=\'" + arguments[3] + "\'>" + arguments[1] + "/" + arguments[2] + "</font>", true);
			}
			StatsMenu.MagickaMeter.Update();
			StatsMenu.HealthMeter.Update();
			StatsMenu.StaminaMeter.Update();
		}
	}

	private var bPerkMode: Boolean = false;
	var highlightSkillIndex: Number = 76;
	var highlightSkillAngle: Number = 300;

	function updateHighlightedSkill(): Void
	{
		if(backgroundBarLower._alpha == 100) {
			//skse.Log("===== updateHighlightedSkill =====");
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
			
			//StatsMenu.StatsMenuInstance.AnimatingSkillTextInstance.highlightSkill(highlightSkillIndex);
			
			//StatsMenu.StatsMenuInstance.TopPlayerInfo.FirstLastLabel.SetText(StatsMenu.SkillStatsA[highlightSkillIndex]);
			//skse.Log("New highlight angle is " + highlightSkillAngle);
		}
	}	
	
	function updateHighlightedIndex(): Void
	{
		if(backgroundBarLower._alpha == 100) {
			//skse.Log("===== updateHighlightedIndex =====");
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
	
	var previousDescription: String = "Init";

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
		/*
			skse.Log("===== SetDescriptionCard =====");
			for(var i = 0; i < arguments.length; i++) {
				skse.Log("arguments[" + i + "] = " + arguments[i]);
			}
		*/
		//skse.Log("Current angle is " + currentAngle);
		
		if(previousDescription != arguments[3]) {
			previousDescription = arguments[3];
			if(arguments[0]) {
				// Perk
				var skillName: String = arguments[6].substr(0, arguments[6].indexOf(" <", 0));
				//skse.Log("Skill name = " + skillName);
				for(var i = 1; i < StatsMenu.SkillStatsA.length; i += 5) {
					if(StatsMenu.SkillStatsA[i] == skillName) {
						highlightSkillIndex = i;
						//skse.Log("Index = " + highlightSkillIndex);
						updateHighlightedSkill();
						break;
					}
				}
			}
			
			if(bPerkMode != arguments[0]) {
				bPerkMode = arguments[0];
				if(bPerkMode) {
					//skse.Log("Switching to 'Perks' frame");
				} else {
					//skse.Log("Switching to 'Skills' frame");
					updateHighlightedSkill();
				}
				if (StatsMenu.StatsMenuInstance != undefined) {
					//updatePlayerInfo();
					StatsMenu.StatsMenuInstance.gotoAndPlay(arguments[0] ? "Perks" : "Skills");
				}
			} else {
				 if(!arguments[0]) {
					// Skill
					//skse.Log("Previous highlight angle is " + highlightSkillAngle);
					if(highlightingInitialized == true) {
						updateHighlightedIndex();
						updateHighlightedSkill();
					}
				}
			}
			/*
			for(var i = 0; i < arguments.length; i++) {
				skse.Log("arguments[" + i + "] = " + arguments[i]);
			}
			*/
			var descriptionCard: MovieClip = StatsMenu.StatsMenuInstance.DescriptionCardInstance;
			
			//descriptionCard.CardDescriptionTextInstance.html = true;
			//descriptionCard.CardDescriptionTextInstance.htmlText = "<font face=\'$EverywhereMediumFont\'>" + arguments[3] + "</font>";
			//descriptionCard.CardDescriptionTextInstance.SetText(arguments[3]);
			
			//descriptionCard.CardDescriptionTextInstance._height = descriptionCard.CardDescriptionTextInstance.textHeight + 4.0;
			
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
	
	function ShowLegendaryCounter(): Void
	{
		var skillLegendaryCount: Number = highlightSkillIndex + 3;
		var descriptionCard: MovieClip = StatsMenu.StatsMenuInstance.DescriptionCardInstance;
		if (SkillStatsA[skillLegendaryCount] != undefined) {
			if (SkillStatsA[skillLegendaryCount] > 0) {
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
}
