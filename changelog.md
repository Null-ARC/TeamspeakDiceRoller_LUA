# Changelog
## Beta 1.5
Colors for everyone!
###
- User can now set colors for themselves
- Implemented !treffer for DSA ("DSA Trefferzonen")
- Refactorings to reduce code duplication and optimize readability
- Fixes some bugs by replacing them with brand new ones.
## Beta 1.4.1
Fixing DSA (as usual for 4.1)
### Features
- more user colours / unique IDs
- different modes (rule systems) now covered in an if-elseif-else-wrapper for cleaner running
- now "simple" single stat checks in DSA also can have boni or mali (as they're supposed to!)
- Surprisingly severe refactoring of the DSA mode code section to facilitate that
- succeeding a DSA skill check with 0 skill points remaining will round up to 1 point as supposed to by the rules
- The only actual new features:
- Multi D6 rolls with or without modifier can now be done in DSA mode via ?<dice> or ?<dice>,<modifier> for eg Regeneration, Damage, Patzertabelle, etc
- Generic dice rolls are expanded by "!!" for 1d100 & "??" for 1d66 aka 2d6 read as 2-digit hexal number
- Addendum: Version tracking in events.lua on activation of the tool has been added (still needs to be set manually though)
## Beta 1.4
Critical Update ;)
### Features
- Krit/Patzer System for DSA
- !statcheck implemented
- Custom color now also decided by uniqueID
- Hotfix for Syntax Error in Beta 1.3
- Fixes some bugs by replacing them with brand new ones.
## Beta 1.3
KatharSys and Catharsis
### Features
- some additional users get colour output now
- syntax was expanded to future-proof for additonal versions of existing games aswell as other tools (FULLY BACKWARDS COMPATIBLE): !sr5 same as !sr, !dsa4 same as !dsa, !dice same as !on
- KatharSys Mode aka Degenesis support added (activated with !kat or !deg)
- mode specific roles now only work if the beginning of the command ("!") is immediately followed by a numerical digit (0-9) (to avoid system commands getting miscaught)
- system commands like !off or mode change can now be only used by the owner
- some refactoring of the system command block
- Fixes some bugs by replacing them with brand new ones.
## Beta 1.2
Small Content update and refactoring
### Features
- dice.lua was added to centralize rolls
- !help command was added to not spam the chat with manual every use
- some code comments were added
- generic d20 now possible in every mode
- some users now have color output
- Small Typos fixed
- Fixes some bugs by replacing them with brand new ones.
## Beta 1.1
First Public appearance of this tool
Includes Readme in Eng and Ger.
### Features
- DSA Mode
- ShadowRun Mode
- Generic Dice Roller
- "!" rolls 1d20 (only DSA mode)
- "?" rolls 1d6 (in all modes)
