﻿import Shared.GlobalFunc;
import gfx.io.GameDelegate;

class Console extends MovieClip
{
	static var PREVIOUS_COMMANDS: Number = 32;
	static var HistoryCharBufferSize: Number = 8192;
	static var ConsoleInstance = null;
	
	/* Stage Elements */
	var Background: MovieClip;
	
	var CurrentSelection: TextField;
	var CommandHistory: TextField;
	var CommandEntry: TextField;
	var CurrentCell: TextField;
	
	var Commands: Array = new Array();
	
	var Animating: Boolean;
	var Hiding: Boolean;
	var Shown: Boolean;
	
	var CurrentSelectionYOffset: Number;
	var OriginalHeight: Number;
	var OriginalWidth: Number;
	var PreviousCommandOffset: Number;
	var ScreenPercent: Number;
	var TextXOffset: Number;
	

	function Console()
	{
		super();
		_global.gfxExtensions = true;
		GlobalFunc.MaintainTextFormat();
		
		CurrentSelectionYOffset = _height + CurrentSelection._y;
		TextXOffset = CommandEntry._x;
		
		OriginalHeight = Stage.height;
		OriginalWidth = Stage.width;
		
		ScreenPercent = 100 * (_height / Stage.height);
		PreviousCommandOffset = 0;
		
		Shown = false;
		Animating = false;
		Hiding = false;
		
		CommandEntry.setNewTextFormat(CommandEntry.getTextFormat());
		CommandEntry.text = "";
		CommandEntry.noTranslate = true;
		
		CurrentSelection.setNewTextFormat(CurrentSelection.getTextFormat());
		CurrentSelection.text = "Selected reference: None";
		CurrentSelection.noTranslate = true;
		
		CommandHistory.setNewTextFormat(CommandHistory.getTextFormat());
		CommandHistory.text = "";
		CommandHistory.noTranslate = true;
		
		CurrentCell.setNewTextFormat(CurrentCell.getTextFormat());
		CurrentCell.text = "Current cell: None";
		CurrentCell.noTranslate = true;
		
		Stage.align = "BL";
		Stage.scaleMode = "noScale";
		
		Stage.addListener(this);
		Key.addListener(this);
		
		Console.ConsoleInstance = this;
		
		onResize();
	}

	static function Show(): Void
	{
		if (Console.ConsoleInstance != null && !Console.ConsoleInstance.Animating) {
			Console.ConsoleInstance._parent._y = Console.ConsoleInstance.OriginalHeight;
			Console.ConsoleInstance._parent.gotoAndPlay("show_anim");
			Selection.setFocus(Console.ConsoleInstance.CommandEntry, 0);
			Console.ConsoleInstance.Animating = true;
			Selection.setSelection(Console.ConsoleInstance.CommandEntry.length, Console.ConsoleInstance.CommandEntry.length);
		}
	}

	static function ShowComplete(): Void
	{
		if (Console.ConsoleInstance != null) {
			Console.ConsoleInstance.Shown = true;
			Console.ConsoleInstance.Animating = false;
		}
	}

	static function Hide(): Void
	{
		if (Console.ConsoleInstance != null && !Console.ConsoleInstance.Animating) {
			Console.ConsoleInstance._parent.gotoAndPlay("hide_anim");
			Selection.setFocus(null, 0);
			Console.ConsoleInstance.ResetCommandEntry();
			Console.ConsoleInstance.Animating = true;
			Console.ConsoleInstance.Hiding = true;
		}
	}

	static function HideComplete(): Void
	{
		if (Console.ConsoleInstance != null) {
			Console.ConsoleInstance.Shown = false;
			Console.ConsoleInstance.Animating = false;
			Console.ConsoleInstance.Hiding = false;
			GameDelegate.call("HideComplete", []);
		}
	}

	static function Minimize(): Void
	{
		if (Console.ConsoleInstance != null) 
			Console.ConsoleInstance._parent._y = Console.ConsoleInstance.OriginalHeight - Console.ConsoleInstance.CommandHistory._y;
	}

	static function SetCurrentSelection(selectionText: String): Void
	{
		if (Console.ConsoleInstance != null) {
			if(selectionText != "") {
				var refID: String = selectionText.substr((selectionText.indexOf("(", 0) + 1), 8);
				Console.ConsoleInstance.CurrentSelection.text = "Selected reference: " + selectionText.substring(0, (selectionText.indexOf("(", 0) - 1)) + " (ReferenceID " + refID.toUpperCase() + ")";
			} else {
				Console.ConsoleInstance.CurrentSelection.text = "Selected reference: None";
			}
		}
	}

	static function QShown(): Boolean
	{
		return Console.ConsoleInstance != null && Console.ConsoleInstance.Shown && !Console.ConsoleInstance.Animating;
	}

	static function QHiding(): Boolean
	{
		return Console.ConsoleInstance != null && Console.ConsoleInstance.Hiding;
	}

	static function PreviousCommand(): Void
	{
		if (Console.ConsoleInstance != null) {
			if (Console.ConsoleInstance.PreviousCommandOffset < Console.ConsoleInstance.Commands.length) 
				++Console.ConsoleInstance.PreviousCommandOffset;
			if (0 != Console.ConsoleInstance.Commands.length && 0 != Console.ConsoleInstance.PreviousCommandOffset) 
				Console.ConsoleInstance.CommandEntry.text = Console.ConsoleInstance.Commands[Console.ConsoleInstance.Commands.length - Console.ConsoleInstance.PreviousCommandOffset];
				Selection.setSelection(Console.ConsoleInstance.CommandEntry.length, Console.ConsoleInstance.CommandEntry.length);
		}
	}

	static function NextCommand(): Void
	{
		if (Console.ConsoleInstance != null) {
			if (Console.ConsoleInstance.PreviousCommandOffset > 1) 
				--Console.ConsoleInstance.PreviousCommandOffset;
			if (0 != Console.ConsoleInstance.Commands.length && 0 != Console.ConsoleInstance.PreviousCommandOffset) 
				Console.ConsoleInstance.CommandEntry.text = Console.ConsoleInstance.Commands[Console.ConsoleInstance.Commands.length - Console.ConsoleInstance.PreviousCommandOffset];
				Selection.setSelection(Console.ConsoleInstance.CommandEntry.length, Console.ConsoleInstance.CommandEntry.length);
		}
	}

	static function AddHistory(aText: String): Void
	{
		if (Console.ConsoleInstance != null) {
			Console.ConsoleInstance.CommandHistory.text = Console.ConsoleInstance.CommandHistory.text + aText;
			if (Console.ConsoleInstance.CommandHistory.text.length > Console.HistoryCharBufferSize) 
				Console.ConsoleInstance.CommandHistory.text = Console.ConsoleInstance.CommandHistory.text.substr(0 - Console.HistoryCharBufferSize);
			Console.ConsoleInstance.CommandHistory.scroll = Console.ConsoleInstance.CommandHistory.maxscroll;
		}
	}

	static function ClearHistory(): Void
	{
		if (Console.ConsoleInstance != null) 
			Console.ConsoleInstance.CommandHistory.text = "";
	}

	static function SetHistoryCharBufferSize(aNumChars: Number): Void
	{
		Console.HistoryCharBufferSize = aNumChars;
	}

	static function SetTextColor(aColor: Number): Void
	{
		Console.ConsoleInstance.CommandEntry.textColor = aColor;
		Console.ConsoleInstance.CurrentSelection.textColor = aColor;
		Console.ConsoleInstance.CurrentCell.textColor = aColor;
	}

	static function SetTextSize(aPointSize: Number): Void
	{
		var textFormat: TextFormat = undefined;
		
		textFormat = Console.ConsoleInstance.CurrentSelection.getNewTextFormat();
		textFormat.size = Math.max(1, aPointSize);
		Console.ConsoleInstance.CurrentSelection.setTextFormat(textFormat);
		Console.ConsoleInstance.CurrentSelection.setNewTextFormat(textFormat);
		
		textFormat = Console.ConsoleInstance.CommandHistory.getNewTextFormat();
		textFormat.size = Math.max(1, aPointSize - 2);
		Console.ConsoleInstance.CommandHistory.setTextFormat(textFormat);
		Console.ConsoleInstance.CommandHistory.setNewTextFormat(textFormat);
		
		textFormat = Console.ConsoleInstance.CommandEntry.getNewTextFormat();
		textFormat.size = Math.max(1, aPointSize);
		Console.ConsoleInstance.CommandEntry.setTextFormat(textFormat);
		Console.ConsoleInstance.CommandEntry.setNewTextFormat(textFormat);
		
		textFormat = Console.ConsoleInstance.CurrentCell.getNewTextFormat();
		textFormat.size = Math.max(1, aPointSize);
		Console.ConsoleInstance.CurrentCell.setTextFormat(textFormat);
		Console.ConsoleInstance.CurrentCell.setNewTextFormat(textFormat);
		
		Console.PositionTextFields();
	}

	static function SetHistoryTextColor(aColor: Number): Void
	{
		Console.ConsoleInstance.CommandHistory.textColor = aColor;
	}

	static function SetSize(aPercent: Number): Void
	{
		Console.ConsoleInstance.ScreenPercent = aPercent;
		aPercent = aPercent / 100;
		Console.ConsoleInstance.Background._height = Stage.height * aPercent;
		
		Console.PositionTextFields();
	}

	static function PositionTextFields(): Void
	{
		Console.ConsoleInstance.CurrentSelection._y = Console.ConsoleInstance.CurrentSelectionYOffset - Console.ConsoleInstance.Background._height;
		Console.ConsoleInstance.CommandHistory._y = Console.ConsoleInstance.CurrentSelection._y + Console.ConsoleInstance.CurrentSelection._height;
		Console.ConsoleInstance.CommandHistory._height = Console.ConsoleInstance.CommandEntry._y - Console.ConsoleInstance.CommandHistory._y;
		
		Console.ConsoleInstance.CurrentCell._y = Console.ConsoleInstance.CurrentSelection._y - Console.ConsoleInstance.CurrentCell._height;
		Console.ConsoleInstance.CurrentCell._x = Console.ConsoleInstance.CurrentSelection._x;
	}

	function ResetCommandEntry(): Void
	{
		CommandEntry.text = "";
		PreviousCommandOffset = 0;
	}

	function onKeyDown(): Void
	{
		if (Key.getCode() == 13 || Key.getCode() == 108) {
			if (CommandEntry.text.length != 0) {
				if (Commands.length >= Console.PREVIOUS_COMMANDS) 
					Commands.shift();
				Commands.push(CommandEntry.text);
				Console.AddHistory(CommandEntry.text + "\n");
				if(CommandEntry.text.substr(0, 5).toLowerCase() == "exui_") {
					var exuiCommand: String = CommandEntry.text.substr(5).toLowerCase();
					if(exuiCommand == "fullscreen") {
						setFullscreen();
						ResetCommandEntry();
						return;
					} else if(exuiCommand == "help") {
						var sMessage: String = "exui_fullscreen - Expand the console to cover the entire screen.\n";
						sMessage += "exui_loadmenu: FILEPATH - Open the given .swf file as a new menu. The path is relative to '\\Skyrim\\Data\\Interface' and should not include the file extension. Call again to close the menu.\n";
						sMessage += "exui_log: MESSAGE - Write MESSAGE to the Papyrus log.\n";
						sMessage += "exui_getcrosshairref - Get information regarding the reference, provided that it can be activated, currently in the crosshairs.\n";
						sMessage += "exui_sendmodevent: EVENTNAME, STRINGARG, NUMARG - Send an SKSE mod event with the given event name, string argument, and number argument.\n";
						Console.AddHistory(sMessage);
										   
						ResetCommandEntry();
						return;
					} else if(exuiCommand.substr(0, 5) == "log: ") {
						skse.SendModEvent("EXUI_WriteToPapyrusLog", exuiCommand.substr(5));
						
						ResetCommandEntry();
						return;
					} else if(exuiCommand.substr(0, 15) == "getcrosshairref") {
						skse.SendModEvent("EXUI_GetCurrentCrosshairRef");
						
						ResetCommandEntry();
						return;
					} else if(exuiCommand.substr(0, 10) == "loadmenu: ") {
						exuiCommand = exuiCommand.substr(10);
						skse.SendModEvent("EXUI_LoadMenu", exuiCommand);
						
						ResetCommandEntry();
						return;
					} else if(exuiCommand.substr(0, 13) == "sendmodevent:") {
						exuiCommand = CommandEntry.text.substr(19);
						
						sendEvent(exuiCommand.split(", "));
						ResetCommandEntry();
						return;
					}
				}
				GameDelegate.call("ExecuteCommand", [CommandEntry.text]);
				ResetCommandEntry();
			}
			return;
		}
		if (Key.getCode() == 33) {
			var imaxScrollIndex: Number = CommandHistory.bottomScroll - CommandHistory.scroll;
			var iminScrollIndex: Number = CommandHistory.scroll - imaxScrollIndex;
			CommandHistory.scroll = iminScrollIndex <= 0 ? 0 : iminScrollIndex;
			return;
		}
		if (Key.getCode() == 34) {
			imaxScrollIndex = CommandHistory.bottomScroll - CommandHistory.scroll;
			iminScrollIndex = CommandHistory.scroll + imaxScrollIndex;
			CommandHistory.scroll = iminScrollIndex > CommandHistory.maxscroll ? CommandHistory.maxscroll : iminScrollIndex;
		}
	}
	
	private function sendEvent(parameters: Array): Void
	{
		if((parameters.length <= 3) && (parameters.length > 0)) {
			if(parameters[2] != undefined)
				parameters[2] = Number(parameters[2]);
				
			if(parameters.length == 1)
				skse.SendModEvent(parameters[0]);
				
			if(parameters.length == 2)
				skse.SendModEvent(parameters[0], parameters[1]);
				
			if(parameters.length == 3)
				skse.SendModEvent(parameters[0], parameters[1], parameters[2]);
		}
	}

	function onResize(): Void
	{
		Background._width = Stage.width;
		CommandEntry._width = CommandHistory._width = CurrentSelection._width = CurrentCell._width = Stage.width - TextXOffset * 2;
		Console.SetSize(ScreenPercent);
	}

	public function setCurrentCell(/* values */): Void
	{
		arguments[1] = generateFormID(arguments[1]);
		if (Console.ConsoleInstance != null) 
			Console.ConsoleInstance.CurrentCell.text = "Current cell: '" + arguments[0] + "' (FormID " + arguments[1] + ")";
	}
	
	public function setCurrentCrosshairRef(/* values */): Void
	{
		arguments[1] = generateFormID(arguments[1]);
		arguments[2] = generateFormID(arguments[2]);
		var sMessage: String = "Current crosshair reference: '" + arguments[0] + "' (ReferenceID " + arguments[2] + ", FormID " + arguments[1] + ")";
		Console.AddHistory(sMessage + "\n");
	}
	
	private function generateFormID(anFormID: Number): String
	{
		var asFormID: String = anFormID.toString(16).toUpperCase();
		while(asFormID.length < 8) {
			asFormID = "0" + asFormID;
		}
		return asFormID;
	}
	
	public function setFullscreen(): Void
	{
		Background._height = Stage.height * 2;
		CurrentCell._y = -Stage.height;
		CurrentSelection._y = CurrentCell._y + CurrentCell._height;
		CommandHistory._y = CurrentSelection._y + CurrentSelection._height;
		CommandHistory._height = Math.abs(CommandEntry._y - CommandHistory._y);
	}
}
