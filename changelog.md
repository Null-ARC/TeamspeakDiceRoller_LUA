# Changelog - TeamspeakDiceRoller

## Release 1.0.0 - 2026-02-17
The British Museum Update (Removed most Pyramids)
### Overview
Initial stable production release of TeamspeakDiceRoller. This release represents the first "feature-complete", tested, and documented version of the addon, combining contributions from multiple developers into a cohesive, modular system for facilitating TTRPG gameplay sessions over TeamSpeak 3.

### Added

#### Game Systems (Core Feature)
- **DSA 4.1 (Das schwarze Auge)** – Complete German d20/d20/d20 skill system with:
  - Attribute checks (single and multiple)
  - Talent checks with skill point calculations
  - Critical success and botch (Patzer) detection
  - Hit zone determination (Trefferzonenwurf) with anatomical mappings
  - Automatic success/failure determination based on rule system

- **Shadowrun 5 (SR5)** – Pool-based d6 system with:
  - Success counting (5+ per die)
  - Glitch detection (≥50% ones)
  - Edge mode with exploding 6s
  - Specialized glitch reporting

- **Call of Cthulhu 7th Edition** – d100 percentile system featuring:
  - Success tiers (Critical, Extreme, Hard, Regular, Failure, Fumble)
  - Bonus and malus die mechanics
  - Difficulty-scaled outcomes
  - Skill-based probability evaluation

- **KatharSys (Degenesis Rebirth)** – Modified d6 pool system with:
  - Automatic success thresholds for large pools
  - 4+ success counting
  - Trigger tracking on 6s
  - Threshold-based mechanics

- **Blades in the Dark** – d6 pool with outcome severity levels:
  - Critical Success, Full Success, Partial Success, Miss mechanics
  - Highest die result determination for outcome scaling
  - Position and effect positioning support

- **Powered by the Apocalypse (PBtA)** – 2d6 + modifier system with:
  - Tiered success outcomes (10+, 7-9, 6 or less)
  - Modifier application
  - Intent-based roll interpretation

- **Generic Dice System** – Flexible notation for ad-hoc rolls:
  - XdY sum rolls with optional modifiers
  - XdY pool rolls with success threshold counting
  - Support for arbitrary die types (d4-d100)
  - One-command rapid expressions

#### Color System
- User-customizable color system with 100+ named colors
- English and German color name aliases (gold, blau/blue, gruen/green, rot/red, etc.)
- Hex color code support (#RRGGBB format)
- Persistent user color preferences
- Automatic color application to all responses

#### Command System
- **Owner-only commands**: Tool activation (!on/!dice), deactivation (!off), system selection, statistics
- **Universal quick rolls**: !  (1d20), ? (1d6), !! (1d100), ?? (1d66)
- **System-specific commands**: Dedicated syntax for each game system
- **Help system**: !help / !hilfe for command reference
- **Diagnostic tools**: !statcheck for RNG verification across 7 die types

#### Module Architecture
- Modular system design with dedicated `/systems/` directory
- Standardized `process(message, fromName, dice)` interface for all game systems
- Clean separation of concerns (input parsing, game logic, output formatting)
- Easy extensibility framework for adding new game systems
- Centralized dispatcher pattern in events.lua

#### Input Processing & Validation
- Robust input sanitization and validation
- Pattern matching for complex multi-parameter commands
- Support for optional modifiers and parameters
- Case-insensitive command matching
- Comma and space separator support

#### Random Number Generation
- Dedicated dice rolling engine with support for d4, d6, d8, d10, d12, d20, d100
- Statistically verified RNG with optional distribution testing
- Efficient pooled die rolling for large pools
- Consistent random source across all systems

#### Documentation
- Comprehensive user README with command reference and examples
- German translation (README_german.md) for international accessibility
- Detailed system-specific documentation with syntax and output examples
- Tests reference guide (tests.md) for validation and testing procedures
- Inline code comments and function documentation

### Changed
- Refactored DSA implementation from scattered inline code to dedicated modular `systems/dsa.lua`
- Reorganized codebase into flat, clean dispatcher pattern to reduce nesting and improve readability
- Standardized all game system modules to use consistent interface and naming conventions
- Improved color pattern matching from comma-separated to space-separated syntax for better UX
- Enhanced events.lua dispatcher to use unified system lookup table

### Fixed
- **DSA Color Command Pattern**: Fixed `!farbe` pattern matching from incorrect comma separator to proper space-based CLI convention
- **Multi-capture Pattern Matching**: Corrected input.lua matchPattern() function to use string.match() instead of gmatch() for proper capture group handling
- **DSA Mali/Bonus Application**: Enabled single attribute checks to properly handle positive and negative modifiers
- Color pattern validation now correctly extracts color names/codes
- Improved error handling for malformed color specifications

### Removed
- Duplicate DSA skill check implementations between different modules
- Redundant pattern matching code across command handlers
- Scatter archive of inline game system implementations (consolidated into `/systems/`)

### Technical Improvements
- Reduced code duplication from ~92 lines of redundant DSA code through consolidation
- Increased maintainability by establishing clear module boundaries
- Added 100+ color palette entries from ~16 base colors
- Implemented comprehensive test-ready command structure
- Established clear contribution patterns for future game system additions

### Dependencies
- Lua 5.1+ (provided by TeamSpeak 3 Lua plugin)
- TeamSpeak 3 API (ts3, ts3defs)
- No external libraries required

---

## Beta Changelog

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


-- From `nullArc-changes/changelog.md` --

## Beta 1.4.3

### Features
- generic rolls mode now supports 2 different types of generic rolls:
- use !<number>,<die>,<modifier> in Generic Mode to roll <number>D<die> & add them up together with an optional <modifier> (If only 1 number given, it'll roll 1 Die with <input> sides)
- use ?<number>,<die>,<threshold> in Generic Mode to roll <number>D<die> & count all dice scoring <threshold> or above as sucesses (also counts 1s separately)
- minor refactoring to open for broader syntax use

## Beta 1.4.2
Colors for everyone!
###
- User can now set colors for themselves
- Implemented !treffer for DSA ("DSA Trefferzonen")
- Refactorings to reduce code duplication and optimize readability
- Fixes some bugs by replacing them with brand new ones.
