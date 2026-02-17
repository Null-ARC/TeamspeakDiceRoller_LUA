# TeamspeakDiceRoller
## Overview

**TeamspeakDiceRoller** is a specialized tool for tabletop RPG players using TeamSpeak 3 to coordinate gameplay. It provides deterministic, fair dice rolling across multiple game systems, with role-specific formatting, custom user colors, and system-agnostic generic rolls.

## Features

### Game Systems Supported

The tool supports dedicated rule implementations for:

- **DSA 4.1** (Das schwarze Auge 4.1) – German d20/d20/d20 skill system with critical successes/failures and talent points
- **Shadowrun 5** (SR5) – Pool-based d6 system with glitch detection and edge explosions
- **Call of Cthulhu (7th Edition)** – d100 percentile system with difficulty scaling and critical/fumble mechanics
- **KatharSys** (Degenesis Rebirth) – Modified pool system with automatic successes and trigger tracking
- **Blades in the Dark** (BitD) – d6 pool with critical success on multiple sixes
- **Powered by the Apocalypse** (PBtA) – 2d6 + modifier with tiered success thresholds
- **Generic Dice** – Flexible `XdY[±modifier]` notation for any system or ad-hoc rolls

## Installation

### Requirements

- **TeamSpeak 3 Client** (version with Lua plugin support)
- **Lua Plugin** installed in TeamSpeak 3 (see [official Lua addon](https://www.myteamspeak.com/addons/L2FkZG9ucy8xZWE2ODBmZC1kZmQyLTQ5ZWYtYTI1OS03NGQyNzU5M2I4Njc%3D))
- **File system access** to TeamSpeak 3 plugins directory

### Installation Steps

1. **Open TeamSpeak 3 Client**

2. **Install Lua Plugin** (if not present)
   - Press `ALT+P` to open Options
   - Navigate to "Addons"
   - If Lua is not listed, download the latest version from the [official TeamSpeak addon site](https://www.myteamspeak.com/addons/L2FkZG9ucy8xZWE2ODBmZC1kZmQyLTQ5ZWYtYTI1OS03NGQyNzU5M2I4Njc%3D)

3. **Locate Plugin Directory**
   - **Windows**: `%APPDATA%\TS3Client\plugins\lua_plugin` (or `%LOCALAPPDATA%\TS3Client\plugins\lua_plugin` on older installs)
   - **Linux**: `~/.ts3client/plugins/lua_plugin`
   - **macOS**: `~/Library/Application Support/TeamSpeak 3/plugins/lua_plugin`

4. **Extract Release Package**
   - Extract the provided release `.zip` into the lua_plugin directory
   - You should now have a folder structure: `lua_plugin/roller/` containing:
     - `init.lua`
     - `events.lua`
     - `dice.lua`
     - `colors.lua`
     - `dsa.lua`
     - `systems/` (subdirectory with modular system handlers)

5. **Restart TeamSpeak 3**

6. **Verify Installation**
   - Press `ALT+P` → Addons → Lua (Settings)
   - Ensure only `"roller"` is checked
   - If other Lua modules are checked, the DiceRoller may conflict

## Usage

### Quick Reference: All Commands

**Note:** Commands requiring **[Owner Only]** can only be executed by the tool owner (the client who activated the plugin). All other commands work when the tool is enabled.

#### Activation & Control (Owner Only)

| Command | Syntax | Description |
|---------|--------|-------------|
| **Activation** | `!on` or `!dice` | Activate the addon; enables all dice rolling and game mode features |
| **Deactivation** | `!off` | Deactivate the addon; stops responding to commands |
| **Help** | `!help` or `!hilfe` | Show available commands and quick reference |

#### Simple Rolls (Always Active When Enabled)

These quick-access rolls work in any system mode and require no parameters.

| Command | Result | Description |
|---------|--------|-------------|
| `!` | 1d20 | Roll a single 20-sided die |
| `?` | 1d6 | Roll a single 6-sided die |
| `!!` | 1d100 | Roll a single percentile die (d100) |
| `??` | 1d66 (2d6) | Roll two 6-sided dice combined as two-digit result; useful for 1W66 pools |

#### Game System Selection (Owner Only)

Switch the active game system. Each system has specialized dice mechanics and result interpretation.

| Command | System | Mechanics |
|---------|--------|-----------|
| `!dsa` or `!dsa4` | DSA 4.1 (Das Schwarze Auge) | German 3d20 skill system with attributes, talent points, critical success/botch detection |
| `!sr` or `!sr5` | Shadowrun 5 | Pool-based d6 system; successes on 5+, glitch detection, optional edge mode with exploding 6s |
| `!coc` or `!call` | Call of Cthulhu 7E | d100 percentile system with difficulty tiers and bonus/malus dice |
| `!kat` or `!deg` | KatharSys (Degenesis) | Modified d6 pool; auto-successes on high pools, threshold 4+, triggers on 6 |
| `!bitd` or `!blades` | Blades in the Dark | d6 pool; outcome determined by highest die result |
| `!pbta` or `!apoc` | Powered by the Apocalypse | 2d6 + modifier system with tiered success outcomes |

#### Color System

| Command | Syntax | Description |
|---------|--------|-------------|
| **Set Color** | `!farbe <color_name>` | Set your user color for formatted responses (works with space separators) |
| | `!farbe <hex_code>` | Use hex color codes, e.g., `!farbe #FF5733` |

**Supported color names:** See [Color System](#color-system-1) section below for the complete list of named colors (gold, blau/blue, gruen/green, rot/red, violett/violet, petrol, teal, white/weiss/weiß, bordeaux, and extended CSS-like colors).

#### Diagnostics (Owner Only)

| Command | Syntax | Description |
|---------|--------|-------------|
| **Statistics Check** | `!statcheck` | Run RNG verification test: rolls 100,000 dice of each type (d4, d6, d8, d10, d12, d20, d100) to validate random distribution |

---

## Detailed Command Examples

### DSA 4.1 (Das Schwarze Auge / The Dark Eye)

German d20/d20/d20-based skill system with attributes, talent points, and special critical/botch mechanics.

#### Simple Attribute Check (1d20)

A single roll against one attribute (e.g., strength, cunning).

**Syntax:**
```
!<attribute_value>
!<attribute_value>,<modifier>
```

**Examples:**
- `!14` — Roll d20 against attribute 14
- `!14,-2` — Roll against attribute 14 with -2 bonus
- `!12,1` — Roll against attribute 12 with +1 penalty

**Output:** Shows the d20 result. If the result is 1 or 20, prompts a confirmation roll (second d20).

#### Full Talent Check (3d20 + Skill)

A complete skill check involving three attributes and a skill value. Used for complex actions in DSA.

**Syntax:**
```
!<att1>,<att2>,<att3>,<skill_value>
!<att1>,<att2>,<att3>,<skill_value>,<modifier>
```

**Examples:**
- `!12,13,14,8` — Check three attributes (12, 13, 14) against skill value 8
- `!12,13,14,8,-1` — Same check with -1 difficulty modifier
- `!12,13,14,8,2` — With +2 difficulty modifier

**Output:** Rolls 3d20. Compares each roll to the corresponding attribute. Calculates remaining talent points (TaP) and determines success/failure. Special results include:
- **Kritischer Erfolg** (Critical Success): Multiple critical rolls (1s)
- **Patzer** (Botch): Multiple botch rolls (20s)

#### Hit Zone Roll (Trefferzonenwurf)

DSA-specific combat mechanic to determine where on an opponent's body an attack lands.

**Syntax:**
```
!treffer
```

**Output:** Rolls 1d20 and maps the result to a hit zone:
- 1, 3, 5: Linkes Bein (Left Leg)
- 2, 4, 6: Rechtes Bein (Right Leg)
- 7–8: Bauch (Abdomen)
- 9, 11, 13: Schildarm (Shield Arm)
- 10, 12, 14: Schwertarm (Sword Arm)
- 15–18: Brust (Chest)
- 19–20: Kopf (Head)

---

### Shadowrun 5 (Pool-Based d6 System)

Matrix/Shadowrun d6 pool system where successes are dice showing 5 or 6, and glitches occur when half or more dice show 1s.

**Syntax:**
```
!<pool_size>
!<pool_size>,e
```

**Examples:**
- `!6` — Roll 6d6, count successes (5+)
- `!6,e` — Roll 6d6 with edge: 6s explode (add extra dice)
- `!10,e` — Roll 10d6 with edge

**Output:**
- Shows each die rolled
- Counts successes (dice ≥ 5) and ones (glitch indicator)
- Marks result as **GLITCHED** if ≥ 50% of dice are 1s
- With edge: shows exploded dice and additional successes

---

### Call of Cthulhu 7E (d100 Percentile System)

Horror RPG using d100 (percentile) rolls with difficulty scaling and critical/fumble mechanics.

**Syntax (Skill Check):**
```
!<skill_value>
!<skill_value>,<bonus_dice>
!<skill_value>,<-malus_dice>
```

**Examples:**
- `!45` — Roll d100 vs skill 45
- `!45,2` — Roll with 2 bonus dice (reroll tens under original)
- `!45,-1` — Roll with 1 malus die (take highest tens)

**Output:** Shows d100 result. Determines outcome based on tiers:
- **Kritischer Erfolg** (1): Critical success
- **Extremer Erfolg** (≤ Skill/5): Extreme success
- **Schwieriger Erfolg** (≤ Skill/2): Hard success
- **Erfolg** (≤ Skill): Regular success
- **Misserfolg** (> Skill): Failure
- **Patzer** (96–99 or 100): Botch/Fumble

**Generic Pool Mode (within CoC):**
```
?<num_dice>,<die_size>
?<num_dice>,<die_size>,<modifier>
```

Examples:
- `?3,6` — Roll 3d6
- `?4,6,1` — Roll 4d6 + 1

---

### KatharSys / Degenesis (Modified d6 Pool)

Degenesis system with auto-success mechanics, 4+ threshold, and trigger tracking on 6s.

**Syntax:**
```
!<pool_size>
```

**Examples:**
- `!5` — Roll 5d6
- `!12` — Roll 12d6 (or auto-succeed if pool is very high)

**Output:**
- Rolls specified number of d6
- Counts successes on 4+
- Tracks triggers on 6s
- Applies auto-success rules for pools exceeding threshold

---

### Blades in the Dark (d6 Pool + Highest Die)

Powered by the Apocalypse-adjacent system where the highest die determines outcome severity.

**Syntax:**
```
!<pool_size>
```

**Examples:**
- `!3` — Roll 3d6
- `!2` — Roll 2d6

**Output:** Rolls pool of d6s. Outcome determined by **highest die**:
- **Critical Success** (multiple 6s)
- **Full Success** (6+)
- **Partial Success** (4–5)
- **Miss** (1–3)

---

### Powered by the Apocalypse (2d6 + Modifier)

PBtA-based system using 2d6 + modifier with tiered success outcomes.

**Syntax:**
```
!<modifier>
```

**Examples:**
- `!0` — Roll 2d6 + 0
- `!1` — Roll 2d6 + 1
- `!-1` — Roll 2d6 - 1

**Output:** Rolls 2d6, applies modifier, determines outcome:
- **Voller Erfolg** (Full Success): 10+
- **Teilerfolg** (Partial Success): 7–9
- **Fehlschlag** (Failure/Miss): 6 or less

---

### Generic Dice Rolls (Fallback for Any System)

When in a system without a matching roll pattern, or for ad-hoc rolls, use generic notation.

#### XdY Total (Sum)

**Syntax:**
```
!<num>,<die>
!<num>,<die>,<modifier>
```

**Examples:**
- `!3,6` — Roll 3d6, sum result
- `!2,20` — Roll 2d20, sum result
- `!4,6,3` — Roll 4d6, add +3 modifier

**Output:** Shows each die rolled, sum, and final result (with modifier if provided).

#### XdY Pool (Success Threshold)

Roll XdY and count successes against a threshold value.

**Syntax:**
```
?<num>,<die>,<threshold>
```

**Examples:**
- `?5,6,4` — Roll 5d6, count dice ≥ 4 as successes
- `?8,10,5` — Roll 8d10, count dice ≥ 5 as successes
- `?4,6,1` — Roll 4d6, count all as auto-successes (threshold 1)

**Output:**
- Shows each die result (bold for successes, italics for 1s)
- Counts and displays total successes
- Notes any 1s rolled

---

## Color System

Every player can set a custom color to make their rolled results stand out in the TeamSpeak channel chat. Colors are applied to the entire response output.

### Setting Your Color

**Command:**
```
!farbe <color_name>
!farbe <hex_code>
```

**Examples:**
```
!farbe gold           # Use named color "gold"
!farbe blau           # Use German alias for blue
!farbe #FF5733        # Use hex color code
!farbe weiss          # German spelling (ß or ss both work)
```

### Available Named Colors

The addon includes 100+ color names (English and German aliases)

### Hex Color Format

Use hex color codes for precise color selection:
- Format: `#RRGGBB` (6 hexadecimal digits)
- Example: `!farbe #FF00FF` (magenta)

---

## License

MIT License – See [LICENSE](LICENSE) file for details.

## Authors

- **Alick | Alex**
- **Null-ARC | Fenrir**
