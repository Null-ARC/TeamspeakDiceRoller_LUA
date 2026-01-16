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
- !on    -> Aktiviert das Tool
- !off   -> Deaktiviert das Tool
- !dsa   -> Setzt das Würfelsystem in den „DSA“-Modus (für das deutsche TTRPG „Das schwarze Auge“)
- !sr    -> Setzt das Würfelsystem in den „SR“-Modus (für das TTRPG „Shadowrun“)
- ?      -> Würfelt 1d6
- ?\<number1>,\<number2>   -> Würfelt \<number1>d\<number2> / Wird z. B. wie ?1,20 verwendet, um 1d20 zu würfeln (weitere Beispiele wären ?5,6 für 5d6 usw.)
### DSA-Modus
- !\<stat1>  -> 1d20 gegen stat1
- !\<stat1>,\<stat2>,\<stat3>,\<skill> -> 3d20-Wurf, wie er im DSA-System verwendet wird
- !\<stat1>,\<stat2>,\<stat3>,\<skill>,\<modifier> -> Modifizierter 3d20-Wurf, wie er im DSA-System verwendet wird
- !          -> 1d20
### Shadowrun-Modus
- !\<pool>   -> \<pool>d6, wobei 5en oder 6en als Erfolge zählen und es als Glitch zählt, wenn die Hälfte oder mehr der Würfe 1en sind
- !\<pool>,e -> Wie oben, jedoch mit explodierenden d6 bei einer 6
