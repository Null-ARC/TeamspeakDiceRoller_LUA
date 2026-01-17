# TeamspeakDiceRoller_LUA
A simple and reusable Lua-based dice rolling utility. Designed for online roleplaying using Teamspeak 3's deprecated LUA plugin
## Installation
1. Open Teamspeak 3 Client
2. Press ALT+P (Open the Options Menu)
3. Go to "Addons"
4. If the "Lua" Addon is not present, install the latest version from the offical [Teamspeak Page ](https://www.myteamspeak.com/addons/L2FkZG9ucy8xZWE2ODBmZC1kZmQyLTQ5ZWYtYTI1OS03NGQyNzU5M2I4Njc%3D)
5. Go to your Teamspeaks Lua plugin folder (Per default on windows it should be %APPDATA%\TS3Client\plugins\lua_plugin | on older installations it could be %LOCALAPPDATA%\TS3Client\plugins\lua_plugin)
5.1 On Linux the plugin folder should be ~/.ts3client/plugins/lua_plugin
6. Paste the .zip from the releases into that folder and unpack it
7. There should now be a folder lua_plugin/roller which contains 2 .lua files (init.lua and events.lua)
8. Restart Teamspeak 3 Client
9. Press ALT+P (Open the Options Menu)
10. Go to "Addons"
11. Click "Settings" for the Lua Addon
12. Check and make sure that only "roller" is checked. The name is to be changed by me in future releases. If anything else is checked, I cannot guarantee that the DiceRoller will work.
## How to use
All basic commands do still work in both specific modes
### Basic Commands
- !on or !dice	-> Enable the Tool
- !off 			-> Disable the Tool
- !dsa or !dsa4	-> Set the dice rolling system to "DSA 4.1" mode (for the german TTRPG "Das schwarze Auge" in version 4.1)
- !sr or !sr5	-> Set the dice rolling system to "Shadowrun 5" mode  (for the TTRPG "Shadowrun" in version 5)
- !kat or !deg	-> Set the dice rolling system to "KatharSys" mode (for the TTRPG "Degenesis Rebirth") 
- ! 			-> 1d20
- ?				-> Rolls 1d6
- ?\<number1>,\<number2>   -> Rolls \<number1>d\<number2> / Is used like ?1,20 to roll 1d20 for example (more example would include ?5,6 for 5d6 and so on)
### DSA Mode
- !\<stat1>  -> 1d20 against stat1
- !\<stat1>,\<stat2>,\<stat3>,\<skill> -> 3d20 roll used in the DSA system
- !\<stat1>,\<stat2>,\<stat3>,\<skill>,\<modifier> -> modified 3d20 roll used in the DSA system
### ShadowRun Mode
- !\<pool> -> \<pool>d6 where 5s or 6s count as success and if half or more of the rolls are 1s it counts as glitched
- !\<pool>,e -> same as above, but with exploding d6 on the 6
### KatharSys Mode
- !\<pool> -> \<pool>d6 (but max 12, additonal dice become automatic successes instead) where 4s, 5s or 6s count as success, 6s additionally also as triggers, and if more 1s as successes are rolled, the roll is botched
