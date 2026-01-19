# TeamspeakDiceRoller_LUA
Ein einfaches und wiederverwendbares, Lua-basiertes Würfelwurf-Tool. Entwickelt für Online-Rollenspiele mit dem veralteten LUA-Plugin von Teamspeak 3
## Installation
1. Öffne den Teamspeak-3-Client
2. Drücke ALT+P (Öffnet das Optionsmenü)
3. Gehe zu „Addons“
4. Falls das „Lua“-Addon nicht vorhanden ist, installiere die neueste Version von der offiziellen [Teamspeak-Seite](https://www.myteamspeak.com/addons/L2FkZG9ucy8xZWE2ODBmZC1kZmQyLTQ5ZWYtYTI1OS03NGQyNzU5M2I4Njc%3D)
5. Gehe in den Lua-Plugin-Ordner von Teamspeak (Standardmäßig unter Windows: %APPDATA%\TS3Client\plugins\lua_plugin | bei älteren Installationen eventuell %LOCALAPPDATA%\TS3Client\plugins\lua_plugin)
5.1 Unter Linux sollte sich der Plugin-Ordner unter ~/.ts3client/plugins/lua_plugin befinden
6. Kopiere die .zip-Datei aus den Releases in diesen Ordner und entpacke sie
7. Es sollte nun ein Ordner lua_plugin/roller existieren, der 2 .lua-Dateien enthält (init.lua und events.lua)
8. Starte den Teamspeak-3-Client neu
9. Drücke ALT+P (Öffnet das Optionsmenü)
10. Gehe zu „Addons“
11. Klicke bei dem Lua-Addon auf „Settings“
12. Stelle sicher, dass nur „roller“ aktiviert ist. Der Name wird von mir in zukünftigen Releases geändert. Falls etwas anderes aktiviert ist, kann ich nicht garantieren, dass der DiceRoller funktioniert.
## Verwendung
Alle grundlegenden Befehle funktionieren weiterhin in beiden spezifischen Modi
### Grundlegende Befehle
- !on oder !dice	-> Aktiviert das Tool
- !off   			-> Deaktiviert das Tool
- !help -> Zeigt die Hilfeseite an
- !farbe,\<farbe> -> Setzt die Farbe für den User
- !dsa oder !dsa4	-> Setzt das Würfelsystem in den „DSA 4.1“-Modus (für das deutsche Pen&Paper RPG „Das schwarze Auge“ in der Edition 4.1)
- !sr oder !sr5		-> Setzt das Würfelsystem in den „ShadowRun 5“-Modus (für das Pen&Paper RPG „Shadowrun“ in der 5. Edition)
- !kat oder !deg	-> Setzt das Würfelsystem in den "KatharSys"-Modus (für das Pen&Paper RPG "Degenesis" in der Rebirth-Version)
### Generische Würfelwürfe
- !      			-> Würfelt 1W20
- ?      			-> Würfelt 1W6
- !!				-> Würfelt 1W100
- ??				-> Würfelt einen sogenannten "W66" aka 2W6 aber als zweistellige Hexalzahl gelesen
- ?\<number1>,\<number2>   -> Würfelt \<number1>d\<number2> / Wird z. B. wie ?1,20 verwendet, um 1d20 zu würfeln (weitere Beispiele wären ?5,6 für 5d6 usw.)
### DSA-Modus
- !\<stat1>  -> 1d20 gegen stat1
- !\<stat1>,\<modifier> -> modifizierter 1d20 gegen stat1, wie er im DSA-System verwendet wird
- !\<stat1>,\<stat2>,\<stat3>,\<skill> -> 3d20-Wurf, wie er im DSA-System verwendet wird
- !\<stat1>,\<stat2>,\<stat3>,\<skill>,\<modifier> -> Modifizierter 3d20-Wurf, wie er im DSA-System verwendet wird
- ?\<anzahl> -> wirft Anzahl an W6ern & summiert sie auf
- ?\<anzahl>,\<modifikator> -> wirft Anzahl an W6ern, summiert sie auf & addiert Modifikator
- !treffer -> "Trefferzonenwurf"
### ShadowRun-Modus
- !\<anzahl> -> wirft Anzahl an W6ern, wobei 5en oder 6en als Erfolge zählen und es als Glitch zählt, wenn die Hälfte oder mehr der Würfe 1en sind
- !\<anzahl>,e -> Wie oben, jedoch mit explodierenden d6 bei einer 6
### KatharSys-Modus
- !\<anzahl> -> wirft Anzahl an W6ern (maximal jedoch 12, überzählige werden automatisch zu Erfolgen), wobei 4en, 5en oder 6en als Erfolge zählen, 6en zusätzlich noch als Trigger, und es als Patzer zählt, wenn mehr 1en als Erfolge erwürfelt werden
