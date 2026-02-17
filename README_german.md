# TeamspeakDiceRoller
## Überblick

**TeamspeakDiceRoller** ist ein spezialisiertes Werkzeug für Tabletop-RPG-Spieler, die TeamSpeak 3 zur Spielkoordination nutzen. Es bietet deterministische, faire Würfeln über mehrere Spielsysteme hinweg, mit rollenbezogener Formatierung, benutzerdefinierten Spielerfarben und systemagnostischen generischen Würfeln.

## Funktionen

### Unterstützte Spielsysteme

Das Tool bietet dedizierte Regelimplementierungen für:

- **DSA 4.1** (Das schwarze Auge 4.1)  Deutsches d20/d20/d20-System mit kritischen Erfolgen/Misserfolgen und Talentwerten
- **Shadowrun 5** (SR5)  Poolbasiertes d6-System mit Glitch-Erkennung und Kanten-Explosionen
- **Call of Cthulhu (7. Edition)**  d100-Perzentil-System mit Schwierigkeitsskalierung und kritischen/Patzer-Mechaniken
- **KatharSys** (Degenesis Rebirth)  Modifiziertes Pool-System mit automatischen Erfolgen und Trigger-Tracking
- **Blades in the Dark** (BitD)  d6-Pool mit kritischem Erfolg bei mehreren Sechsen
- **Powered by the Apocalypse** (PBtA)  2d6 + Modifikator mit gestuften Erfolgsschwellen
- **Generische Würfel**  Flexible Notation `XdY[Modifikator]` für jedes System

## Installation

### Voraussetzungen

- **TeamSpeak 3 Client** (Version mit Lua-Plugin-Unterstützung)
- **Lua-Plugin** in TeamSpeak 3 installiert (siehe [offizielles Lua-Add-on](https://www.myteamspeak.com/addons/L2FkZG9ucy8xZWE2ODBmZC1kZmQyLTQ5ZWYtYTI1OS03NGQyNzU5M2I4Njc%3D))
- **Dateisystem-Zugriff** auf TeamSpeak 3 Plugin-Verzeichnis

### Installationsschritte

1. **Öffne TeamSpeak 3 Client**

2. **Installiere Lua-Plugin** (falls nicht vorhanden)
   - Drücke `ALT+P`, um Optionen zu öffnen
   - Navigiere zu "Add-ons"
   - Falls Lua nicht aufgelistet ist, lade die neueste Version von der [offiziellen TeamSpeak-Site](https://www.myteamspeak.com/addons/L2FkZG9ucy8xZWE2ODBmZC1kZmQyLTQ5ZWYtYTI1OS03NGQyNzU5M2I4Njc%3D) herunter

3. **Lokalisiere Plugin-Verzeichnis**
   - **Windows**: `%APPDATA%\TS3Client\plugins\lua_plugin` (oder `%LOCALAPPDATA%\TS3Client\plugins\lua_plugin` bei älteren Installationen)
   - **Linux**: `~/.ts3client/plugins/lua_plugin`
   - **macOS**: `~/Library/Application Support/TeamSpeak 3/plugins/lua_plugin`

4. **Extrahiere Release-Paket**
   - Extrahiere die bereitgestellte `.zip` in das lua_plugin-Verzeichnis
   - Du solltest nun folgende Ordnerstruktur haben: `lua_plugin/roller/` mit:
     - `init.lua`
     - `events.lua`
     - `dice.lua`
     - `colors.lua`
     - `dsa.lua`
     - `systems/` (Unterverzeichnis mit modularen System-Handlern)

5. **Starte TeamSpeak 3 neu**

6. **Verifiziere Installation**
   - Drücke `ALT+P`  Add-ons  Lua (Einstellungen)
   - Stelle sicher, dass nur `"roller"` aktiviert ist
   - Falls andere Lua-Module aktiviert sind, kann der DiceRoller in Konflikt geraten

## Verwendung

### Schnellreferenz: Alle Befehle

**Hinweis:** Befehle mit **[Nur Besitzer]** können nur vom Werkzeug-Besitzer (dem Client, der das Plugin aktiviert hat) ausgeführt werden. Alle anderen Befehle funktionieren, wenn das Tool aktiviert ist.

#### Aktivierung & Steuerung (Nur Besitzer)

| Befehl | Syntax | Beschreibung |
|--------|--------|-------------|
| **Aktivierung** | `!on` oder `!dice` | Aktiviere das Add-on; aktiviert alle Würfelrollen und Spielmodus-Funktionen |
| **Deaktivierung** | `!off` | Deaktiviere das Add-on; stoppt das Reagieren auf Befehle |
| **Hilfe** | `!help` oder `!hilfe` | Zeige verfügbare Befehle und Schnellreferenz an |

#### Schnelle Würfe (Immer aktiv, wenn aktiviert)

Diese schnellen Zugriffswürfe funktionieren in jedem Systemmodus und benötigen keine Parameter.

| Befehl | Ergebnis | Beschreibung |
|--------|----------|-------------|
| `!` | 1W20 | Würfle einen einzelnen 20-seitigen Würfel |
| `?` | 1W6 | Würfle einen einzelnen 6-seitigen Würfel |
| `!!` | 1W100 | Würfle einen einzelnen prozentualen Würfel (W100) |
| `??` | 1W66 (2W6) | Würfle zwei 6-seitige Würfel als zweistelliges Ergebnis; nützlich für 1W66-Pools |

#### Spielsystem-Auswahl (Nur Besitzer)

Wechsle das aktive Spielsystem. Jedes System hat spezialisierte Würfelmechaniken und Ergebnis-Interpretationen.

| Befehl | System | Mechanik |
|--------|--------|----------|
| `!dsa` oder `!dsa4` | DSA 4.1 (Das Schwarze Auge) | Deutsches 3W20-Geschicklichkeitssystem mit Attributen, Talentwerten, Kritischer Erfolg/Patzer-Erkennung |
| `!sr` oder `!sr5` | Shadowrun 5 | Poolbasiertes d6-System; Erfolge auf 5+, Glitch-Erkennung, optionaler Kanten-Modus mit explodierenden 6en |
| `!coc` oder `!call` | Call of Cthulhu 7E | W100-Perzentil-System mit Schwierigkeitsstufen und Bonus-/Malus-Würfel |
| `!kat` oder `!deg` | KatharSys (Degenesis) | Modifiziertes d6-Pool; automatische Erfolge bei hohen Pools, Schwelle 4+, Trigger auf 6 |
| `!bitd` oder `!blades` | Blades in the Dark | d6-Pool; Ausgang wird durch höchsten Würfel bestimmt |
| `!pbta` oder `!apoc` | Powered by the Apocalypse | 2W6 + Modifikator-System mit gestuften Erfolgsergebnissen |

#### Farbsystem

| Befehl | Syntax | Beschreibung |
|--------|--------|-------------|
| **Farbe setzen** | `!farbe <Farbname>` | Setze deine Benutzerfarbe für formatierte Antworten (funktioniert mit Leerzeichen-Trennzeichen) |
| | `!farbe <Hex-Code>` | Verwende Hex-Farbcodes, z.B. `!farbe #FF5733` |

**Unterstützte Farbnamen:** Siehe [Farbsystem](#farbsystem-1) Abschnitt unten für die vollständige Liste der benannten Farben (gold, blau/blue, gruen/green, rot/red, violett/violet, petrol, teal, white/weiss/weiß, bordeaux und erweiterte CSS-ähnliche Farben).

#### Diagnostik (Nur Besitzer)

| Befehl | Syntax | Beschreibung |
|--------|--------|-------------|
| **Statistik-Überprüfung** | `!statcheck` | Führe RNG-Verifikationstest aus: würfele 100.000 Würfel jedes Typs (W4, W6, W8, W10, W12, W20, W100) um die Zufallsverteilung zu validieren |

---

## Ausführliche Befehlbeispiele

### DSA 4.1 (Das Schwarze Auge / The Dark Eye)

Deutsches d20/d20/d20-basiertes Geschicklichkeitssystem mit Attributen, Talentwerten und speziellen Kritisch/Patzer-Mechaniken.

#### Einfache Eigenschaftsprobe (1W20)

Ein einzelner Wurf gegen ein Attribut (z.B. Stärke, Gewandtheit).

**Syntax:**
```
!<attributswert>
!<attributswert>,<modifikator>
```

**Beispiele:**
- `!14`  Würfle W20 gegen Attribut 14
- `!14,-2`  Würfle gegen Attribut 14 mit -2 Bonus
- `!12,1`  Würfle gegen Attribut 12 mit +1 Mali

**Ausgabe:** Zeigt das W20-Ergebnis. Wenn das Ergebnis 1 oder 20 ist, fordert einen Bestätigungswurf auf (zweiter W20).

#### Vollständige Talentprobe (3W20 + Geschicklichkeit)

Eine vollständige Geschicklichkeitsprobe mit drei Attributen und einem Talentwert. Wird für komplexe Aktionen in DSA verwendet.

**Syntax:**
```
!<att1>,<att2>,<att3>,<talentwert>
!<att1>,<att2>,<att3>,<talentwert>,<modifikator>
```

**Beispiele:**
- `!12,13,14,8`  Überprüfe drei Attribute (12, 13, 14) gegen Talentwert 8
- `!12,13,14,8,-1`  Gleiche Prüfung mit -1 Schwierigkeitsmodifikator
- `!12,13,14,8,2`  Mit +2 Schwierigkeitsmodifikator

**Ausgabe:** Würfelt 3W20. Vergleicht jeden Wurf mit dem entsprechenden Attribut. Berechnet verbleibende Talentwerte (TaP) und bestimmt Erfolg/Misserfolg. Spezielle Ergebnisse sind:
- **Kritischer Erfolg**: Mehrere kritische Würfe (1en)
- **Patzer**: Mehrere Patzer-Würfe (20en)

#### Trefferzonenwurf

DSA-spezifische Kampfmechanik, um zu bestimmen, wo auf dem Körper des Gegners ein Angriff trifft.

**Syntax:**
```
!treffer
```

**Ausgabe:** Würfelt 1W20 und ordnet das Ergebnis einer Trefferzone zu:
- 1, 3, 5: Linkes Bein
- 2, 4, 6: Rechtes Bein
- 78: Bauch
- 9, 11, 13: Schildarm
- 10, 12, 14: Schwertarm
- 1518: Brust
- 1920: Kopf

---

### Shadowrun 5 (Poolbasiertes d6-System)

Matrix/Shadowrun d6-Pool-System, bei dem Erfolge Würfel sind, die 5 oder 6 zeigen, und Glitches treten auf, wenn die Hälfte oder mehr der Würfel 1en zeigen.

**Syntax:**
```
!<pool_größe>
!<pool_größe>,e
```

**Beispiele:**
- `!6`  Würfle 6W6, zähle Erfolge (5+)
- `!6,e`  Würfle 6W6 mit Kante: 6en explodieren (add zusätzliche Würfel)
- `!10,e`  Würfle 10W6 mit Kante

**Ausgabe:**
- Zeigt jeden gewürfelten Würfel
- Zählt Erfolge (Würfel  5) und Einsen (Glitch-Indikator)
- Markiert Ergebnis als **GLITCHED**, wenn  50% der Würfel 1en sind
- Mit Kante: zeigt explodierte Würfel und zusätzliche Erfolge

---

### Call of Cthulhu 7E (W100 Perzentil-System)

Horror-RPG mit W100 (Perzentil)-Würfen mit Schwierigkeitsskalierung und Kritisch/Patzer-Mechaniken.

**Syntax (Geschicklichkeitsprüfung):**
```
!<geschicklichkeitswert>
!<geschicklichkeitswert>,<bonus_würfel>
!<geschicklichkeitswert>,<-malus_würfel>
```

**Beispiele:**
- `!45`  Würfle W100 gg Geschicklichkeit 45
- `!45,2`  Würfle mit 2 Bonus-Würfeln (Neuwurfzehner unter Original-Zehner)
- `!45,-1`  Würfle mit 1 Malus-Würfel (nimm höchste Zehner)

**Ausgabe:** Zeigt W100-Ergebnis. Bestimmt Ausgang basierend auf Stufen:
- **Kritischer Erfolg** (1): Kritischer Erfolg
- **Extremer Erfolg** ( Geschicklichkeit/5): Extremer Erfolg
- **Schwieriger Erfolg** ( Geschicklichkeit/2): Schwerer Erfolg
- **Erfolg** ( Geschicklichkeit): Normaler Erfolg
- **Misserfolg** (> Geschicklichkeit): Misserfolg
- **Patzer** (9699 oder 100): Patzer/Fiasko

**Generischer Pool-Modus (innerhalb CoC):**
```
?<num_würfel>,<würfeltyp>
?<num_würfel>,<würfeltyp>,<modifikator>
```

Beispiele:
- `?3,6`  Würfle 3W6
- `?4,6,1`  Würfle 4W6 + 1

---

### KatharSys / Degenesis (Modifiziertes d6-Pool)

Degenesis-System mit automatischen Erfolgs-Mechaniken, 4+ Schwelle und Trigger-Tracking bei 6en.

**Syntax:**
```
!<pool_größe>
```

**Beispiele:**
- `!5`  Würfle 5W6
- `!12`  Würfle 12W6 (oder automatischer Erfolg, wenn Pool sehr hoch ist)

**Ausgabe:**
- Würfelt angegebene Anzahl von W6en
- Zählt Erfolge auf 4+
- Verfolgt Trigger bei 6en
- Wendet automatische Erfolgsregeln für Pools an, die Schwelle überschreiten

---

### Blades in the Dark (d6 Pool + Höchster Würfel)

Powered by the Apocalypse-ähnliches System, bei dem der höchste Würfel das Ergebnis bestimmt.

**Syntax:**
```
!<pool_größe>
```

**Beispiele:**
- `!3`  Würfle 3W6
- `!2`  Würfle 2W6

**Ausgabe:** Würfelt Pool von W6en. Ausgang wird durch **höchsten Würfel** bestimmt:
- **Kritischer Erfolg** (mehrere 6en)
- **Vollständiger Erfolg** (6+)
- **Teilweiser Erfolg** (45)
- **Fehlschlag** (13)

---

### Powered by the Apocalypse (2W6 + Modifikator)

PBtA-basiertes System mit 2W6 + Modifikator und gestuften Erfolgsergebnissen.

**Syntax:**
```
!<modifikator>
```

**Beispiele:**
- `!0`  Würfle 2W6 + 0
- `!1`  Würfle 2W6 + 1
- `!-1`  Würfle 2W6 - 1

**Ausgabe:** Würfelt 2W6, wendet Modifikator an, bestimmt Ausgang:
- **Voller Erfolg** (Full Success): 10+
- **Teilerfolg** (Partial Success): 79
- **Fehlschlag** (Failure/Miss): 6 oder weniger

---

### Generische Würfelwürfe (Fallback für jedes System)

Wenn Sie sich in einem System ohne passendes Wurf-Muster befinden oder für Ad-hoc-Würfe generische Notation verwenden.

#### XdY Summe

**Syntax:**
```
!<num>,<würfel>
!<num>,<würfel>,<modifikator>
```

**Beispiele:**
- `!3,6`  Würfle 3W6, summiere Ergebnis
- `!2,20`  Würfle 2W20, summiere Ergebnis
- `!4,6,3`  Würfle 4W6, addiere +3 Modifikator

**Ausgabe:** Zeigt jeden gewürfelten Würfel, Summe und endgültiges Ergebnis (mit Modifikator falls vorhanden).

#### XdY Pool (Erfolgs-Schwelle)

Würfle XdY und zähle Erfolge gegen einen Schwellwert.

**Syntax:**
```
?<num>,<würfel>,<schwelle>
```

**Beispiele:**
- `?5,6,4`  Würfle 5W6, zähle Würfel  4 als Erfolge
- `?8,10,5`  Würfle 8W10, zähle Würfel  5 als Erfolge
- `?4,6,1`  Würfle 4W6, zähle alle als automatische Erfolge (Schwelle 1)

**Ausgabe:**
- Zeigt jedes Wurfel-Ergebnis (fett für Erfolge, kursiv für 1en)
- Zählt und zeigt Gesamt-Erfolge
- Vermerkt alle 1en, die gewürfelt wurden

---

## Farbsystem

Jeder Spieler kann eine benutzerdefinierte Farbe setzen, um seine gewürfelten Ergebnisse im TeamSpeak-Kanal-Chat hervorzuheben. Farben werden auf die gesamte Antwort-Ausgabe angewendet.

### Deine Farbe setzen

**Befehl:**
```
!farbe <Farbname>
!farbe <Hex-Code>
```

**Beispiele:**
```
!farbe gold           # Verwende benannte Farbe "gold"
!farbe blau           # Verwende Germanialias für blue
!farbe #FF5733        # Verwende Hex-Farbcode
!farbe weiss          # Deutsche Schreibweise (ß oder ss funktionieren beide)
```

### Verfügbare benannte Farben

Das Add-on enthält 100+ Farbnamen (Englisch und deutsche Aliase)

### Hex-Farb-Format

Verwende Hex-Farbcodes für genaue Farbauswahl:
- Format: `#RRGGBB` (6 hexadezimale Ziffern)
- Beispiel: `!farbe #FF00FF` (Magenta)

---

## Lizenz

MIT-Lizenz  Siehe [LICENSE](LICENSE)-Datei für Details.

## Autoren

- **Alick | Alex**
- **Null-ARC | Fenrir**
