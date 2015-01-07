Extended UI
Version: 1.0.5
Author: MrJack

Table of contents
- Description
- Requirements
- Compatibility
- How to install
- How to uninstall
- Known issues
- Credits
- How to contact the author
- Changelog


--Description--
Extended UI is a project that attempts to fix parts of the user interface. At the moment the intent is for Extended UI to be a complementary mod to SkyUI rather than to replace parts of SkyUI.

Menus that this mod currently affects:
-Skills menu-
 - The name and progress of every skill can be seen when browsing skills. The selected skill is highlighted.
 - Superfluous UI elements slide out of the way when switching to browsing perks.
 - More perk names are visible at the same time.
 - Support for longer skill and perk descriptions.

-Sleep/wait menu-
 - Adjustable maximum sleeping/waiting value (2-720 hours).

-Console-
 - The name and FormID is shown for the cell that the player is currently in.
 - A few new commands:
 	"exui_help" - Display information about the other new commands.
 	"exui_fullscreen" - Makes the console fill the entire screen and show more information at once.
 	"exui_log: MESSAGE" - Prints MESSAGE in the Papyrus log.
 	"exui_sendmodevent: EVENTNAME, STRINGARG, NUMARG" - Send an SKSE mod event (EVENTNAME) with up to two parameters (STRINGARG, NUMARG).
 	"exui_getcrosshairref" - Returns the name, ReferenceID, and FormID of the reference that is currently in the crosshairs of the player.
 	"exui_loadmenu: FILENAME" - Opens up/closes the menu in FILENAME.swf in the "\Skyrim\Data\Interface" folder.


--Requirements--
Skyrim (>= 1.9.32.0.8)
SKSE (>= 1.7.1)

-Optional, but highly recommended-
SkyUI (>= 4.1) for configuring the mod.


--Compatibility--
Mods that edit the following files are, or may be, incompatible with Extended UI:
- statsmenu.swf
- console.swf
- sleepwaitmenu.swf


--How to install--
1. Extract all files to "\Skyrim\Data" or install with your favorite mod manager.
2. Activate Extended UI.esp.


--How to uninstall--
Uninstalling this mod in the middle of a playthrough is not officially supported. Once the files have been removed, then you should either start a new game
or revert to a save that has not seen this mod.

Remove the following files:
"\Skyrim\Data\Extended UI.esp"
"\Skyrim\Data\Extended UI.bsa"


--Known issues--
-Skills menu-
Browsing perks may sometimes lead to switching to browsing skills (can happen in vanilla skills menu as well), which can lead to the wrong skill being highlighted in the bottom part of the menu. Scrolling through the whole list of skills or restarting the game should fix this.


--Credits--
SkyUI team for making the resources, which this mod is built upon, available to the public. Special thanks to schlangster for his help and advice that made this mod possible.
SKSE team for all their hard work, which has made this mod possible.

Translations:
Polish - markosboss
Russian - kopasov

--How to contact the author--
PM MrJack on the official Bethesda forums or mrpwn on Nexus.


--Changelog--
1.05:
	- Added option in MCM to set the aspect ratio of the stats menu. Currently only used to adjust the placement of skill markers at the bottom of the screen. Default is 16:9.
	- Hopefully fixed a bug that can cause a variable to not be assigned a value and thus cause error messages in the Papyrus log.
1.0.4a:
	- Fixed a bug where the skill title for Vampire Lord and Werewolf skills would show up as "undefined" due to relevant data not being received from the game.
	- Fixed a bug where Vampire Lord and Werewolf skills would wrongly indicate that they were eligible for becoming Legendary.
1.0.4:
	- Added a Russian translation of MCM.
	- Added "exui_help" command to display information about other "exui_" commands.
	- Raised maximum possible sleep/wait value to 999.
	- Skill title added on top of the skill description.
	- Fixed issue where making a skill Legendary didn't update the affected skill's marker without needing to reopen the skills menu.
	- Added icon and counter for the Legendary status of a skill.
	- Added indicator for when a skill can be made Legendary.
1.0.3:
	- Moved the skill markers a bit to the left as it was a bit lopsided.
	- Skill/perk descriptions now support HTML tags again.
	- The numbers indicating skill levels now change color when a skill is modified by a (de)buff.
	- Added a Polish translation of MCM.
1.0.2a:
	- Updated translation files.
1.0.2:
	- Changed the fonts in the skills menu and rearranged the skill markers in the bottom bar.
	- Added toggle for fullscreen console in MCM to always open the console in fullscreen mode.
1.0.1:
	- Standardized font in the upper bar in the Skills menu.
1.0.0:
	- Initial release