--[===[
    Roller Skript
    ------------------
    A simple and reusable Lua-based dice rolling utility.
    Designed for online roleplaying using Teamspeak 3

      Authors:
        Alick | Alex // DK_Alick
		Null-ARC | Fenrir

	Version:
		Beta 1.4.6
	
    Disclaimer:
        This software is provided "as is", without warranty of any kind,
        express or implied. The author is not liable for any damages
        arising from the use of this software.
		
	ToDo:
		- Nutzbare Code Kommentare
		- Bessere Zufallsmethoden
		- OOP
		- maybe Syntax von Lule übernehmen
--]===]
local dice = require("roller/dice")
local colors = require("roller/colors")
local dsaFunc = require("roller/dsa")
local aktiv = false
local response = ""
local system = nil
local memory = nil
local OWNER_UNIQUE_ID = nil

local version = "Beta 1.4.6"

-- Funktion um den Owner der TS Instanz festzulegen
function detectOwner(serverConnectionHandlerID)
	if OWNER_UNIQUE_ID ~= nil then
        return OWNER_UNIQUE_ID
    end
    local myClientID = ts3.getClientID(serverConnectionHandlerID)
    local uid = ts3.getClientVariableAsString(serverConnectionHandlerID, myClientID, ts3defs.ClientProperties.CLIENT_UNIQUE_IDENTIFIER)
    return uid
    
end

-- function to respond to messages (bloated as fuck, needs to be tamed)
local function onTextMessageEvent(serverConnectionHandlerID, targetMode, toID, fromID, fromName, fromUniqueIdentifier, message, ffIgnored)
	--print("Message received")    --ENABLE THIS FOR DEBUGGING ONLY
	--print("Roller: onTextMessageEvent: " .. serverConnectionHandlerID .. " " .. targetMode .. " " .. toID .. " " .. fromID .. " " .. fromName .. " " .. fromUniqueIdentifier .. " " .. message .. " " .. ffIgnored)
	local owner = detectOwner(serverConnectionHandlerID)

	-- Special Humans get color output
	--local specialUserColor = colors.specialUserColor(fromUniqueIdentifier, fromName)
	--if specialUserColor ~= nil then
	--	response = specialUserColor
	--else
	response = colors.getUserColor(fromUniqueIdentifier, fromName)
	--end
	--[===[
	if fromUniqueIdentifier == "wBjkylbtGYAuCFrysq6xlVxNAI4=" or fromName == "Alick | Alex" then
		print("Gold")
		response = "[color=#998811]"
		
	if fromUniqueIdentifier == "yFt2I8EVb8yUb5pGKJsKrGAYkGY=" then --or (fromName == "Null-ARC | Fenrir" or fromName == "Tarek ben Nizar | NARC") then
		print("Blau")
		response = "[color=#4848FF]"
		
	elseif fromUniqueIdentifier == "Iq7EpOG3uYOh50FnZLSD2Plmmlc=" or fromName == "Sir Kilmawa | Richard" then
		print("Grün")
		response = "[color=#116611]"
		
	elseif fromUniqueIdentifier == "HigFMJk7fVRuTBuV84J6vG+Zhow=" or fromName == "Dr. Clean// Protheos | David" then
		print("Emperor's Children Lila")
		response = "[color=#ff00ff]"
		
	elseif fromUniqueIdentifier == "2YVwwiIafvcpx8HCDN+V7sSm5k8=" then --or (fromName == "Engelsleiche" or fromName == "Jadira saba Nagar" or fromName == "Cassandra vom Düsterhain") then
		print("Petrol")
		response = "[color=#037c6e]"
		
	elseif fromName == "Basti" then
		print("Teal")
		response = "[color=#025043]"
	else
		print("Default Color")
		response = ""
	end
	--]===]
	
	-- Simple Rolls from every mode
	if aktiv then
		if message == "!" then
			print("-------- \nGeneric D20\n--------\n")
			-- Stupid W20 Roll
			response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt 1W20 - [b]" .. dice.d20()[1] .. "[/b]"
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
		elseif message == "?" then
			print("-------- \nGeneric D6\n--------\n")
			response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt 1W6 - [b]" .. dice.d6()[1] .. "[/b]"
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
		elseif message == "!!" then
			print("-------- \nGeneric D100\n--------\n")
			response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt 1W100 - [b]" .. dice.d100()[1] .. "[/b]"
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
		elseif message == "??" then
			print("-------- \nGeneric D66 (2D6)\n--------\n")
			rolls = dice.rollDice(2, 6)
			response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt 1W66 (2W6) - [b]" .. rolls[1] .. rolls[2] .. "[/b]"
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
		elseif message == "!help" or message == "!hilfe" then
			response = response .. "\nFolgende Befehle sind funktional:\n!farbe,[farbe] - Setzt eine Farbe per User\n!(<Input>) oder ?(<Input>) -> Würfelt den <Input> als Generischen Wurf\n!off - Tool aus\n"
			response = response .. "\n[b]Allgemeine Würfe[/b] (immer gültig)\n! -> 1W20\n? -> 1W6\n!! -> 1W100\n?? -> '1W66'(2W6)-Probe\n"
			response = response .. "\n[b]unterstützte System-Modi[/b]\n!dsa oder !dsa4 -> DSA 4.1\n!sr oder !sr5 -> ShadowRun 5\n!coc oder !call -> Call of Cthulhu (7. Edition)\n"
			response = response .. "!kat oder !deg -> KatharSys (aka Degenesis Rebirth)\n!bitd oder !blades -> Blades in the Dark\n!pota oder !apoc -> Powered by the Apocalypse\n"
			response = response .. "\n[b]System DSA[/b] \n![Wert],[i]<optionaler Modifikator>[/i] -> 1w20 Probe\n" 
			response = response .. "![Attributwert],[Attributwert],[Attributwert],[Talentwert],[i]<optionaler Modifikator>[/i] -> 3w20 Probe\n"
			response = response .. "?[Wert],[i][optionaler Modifikator][/i]\n? -> [Wert]W6 [i](+Modifikator falls vorhanden)[/i]\n"
			response = response .. "\n[b]System Shadowrun[/b] \n![Wert] -> [Wert]W6-Probe\n"
			response = response .. "![Wert],e -> Explodierende W6 Probe\n"
			response = response .. "\n[b]System Call of Cthulhu[/b]\n![Wert] -> [Wert]W100-Probe\n" 
			response = response .. "?[Menge],[Würfel],[i][optionaler Modifikator][/i] -> [Menge]W[Würfel] [i](+Modifikator falls vorhanden)[/i]\n"
			response = response .. "\n[b]System KatharSys (aka Degenesis)[/b]\n![Wert] -> [Wert]W6-Probe\n"
			response = response .. "\n[b]System Blades In The Dark[/b]\n![Wert] -> [Wert]W6-Probe\n"
			response = response .. "\n[b]System Powered By The Apocalypse[/b]\n![Wert] -> 2W6-Probe +[Wert]\n"
			response = response .. "\n[b]Generische Würfe[/b]\n![Menge],[Würfel],[i]<optionaler Modifikator>[/i] -> [Menge]W[Würfel] [i](+Modifikator falls vorhanden)[/i]\n"
			response = response .. "?[Menge],[Würfel],[Erfolgsschwelle] -> Würfelt [Menge]W[Würfel] & zählt alle Würfe ab [Erfolgsschwelle] als Erfolge (sowie 1en separat)"
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
		end
	end
	
	-- Workaround Solution to create "generic override"
	if aktiv and string.sub(message, 2, 2) == "(" and string.sub(message, -1) == ")" then
		message = string.sub(message, 1, 1) .. string.sub(message, 3, -2)
		memory = system
		system = nil
	end
	
	if aktiv and tonumber(string.sub(message, 2, 2)) then
	
		-- Dice Roll System used in DSA mode
		if system == "dsa4" then --and string.sub(message, 1, 1) == "!" then --and aktiv and tonumber(string.sub(message, 2, 2)) then --and message ~= "!off" and message ~= "!sr" and message ~= "!sr5" and message ~= "!kat" and message ~= "!deg" then
			--if string.sub(message, 1, 1) == "!" then				
			print("-------- \nDSA Probe gestartet \n--------\n")
			local content = string.sub(message, 2, 99)
			
			local values = {}
			local talentMod = false
			local simple = false
			local krit = 0
			local patz = 0
			local change = 0
			
			for value in string.gmatch(content, "([^,]+)") do
				table.insert(values, tonumber(value))
			end
				
			if string.sub(message, 1, 1) == "!" then
				
				local att1 = values[1]
				local att2 = values[2]
				local att3 = values[3]
				local atts = {att1, att2, att3}
				local skill
				if values[4] ~= nil then
					skill = values[4]
				else
					skill = 0
				end
				
				if att3 == nil then
					simple = true
					if att2 ~= nil then
						change = values[2]
					end
				elseif values[5] ~= nil then
					change = values[5]
				else
				end
				
				print("Attribut 1: " .. att1)
				if simple ~= true then
					print("Attribut 2: " .. att2)
					print("Attribut 3: " .. att3)
					print("TaW: " .. skill)
				end
				
				if simple then
					if change < 0 then
						response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt eine DSA Eigenschaftsprobe erleichtert um " .. math.abs(change) .. "\n"
					elseif change > 0 then
						response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt eine DSA Eigenschaftsprobe erschwert um " .. change .. "\n"
					else response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt eine DSA Eigenschaftsprobe \n"
					end
				else
					if change < 0 then
						talentMod = true
						response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt eine DSA Talentprobe erleichtert um " .. math.abs(change) .. "\n"
					elseif change > 0 then
						talentMod = true
						response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt eine DSA Talentprobe erschwert um " .. change .. "\n"
					else response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt eine DSA Talentprobe\n"
					end
				end
				
				local roll = dice.rollDice(3,20)
				local roll1 = roll[1]
				local roll2 = roll[2]
				local roll3 = roll[3]
				local roll = {roll1, roll2, roll3}
				
				krit, patz = dsaFunc.countCritsAndPatz(roll)
				
				if simple then
					response = response .. "[" .. roll1 .. "]\n" 
					if roll1 == 1 or roll1 == 20 then
						response = response .. "Bestätigungswurf: [" .. roll2 .. "]\n"
					end
				else
					response = response .. " Die Würfe sind: [" .. roll1 .. ", " .. roll2 .. ", " .. roll3 .. "]\n" 
				end
			
				local restSkill = skill
				
				if simple ~= true and talentMod then
					if change < 0 then
						print("Probe erleichtert")
						
						change = math.abs(change)
						restSkill = restSkill+change
						restSkill = dsaFunc.applyAttributes(restSkill,roll,atts)
						
						print("Rest Skill: " .. restSkill)
						print("Att1: " .. att1 .. " Att2: " .. att2 .. " Att3: " .. att3)
						print("W1: " .. roll1 .. " W2: " .. roll2 .. " W3: " .. roll3)
						
						response = dsaFunc.appendResult(response, restSkill, skill, krit, patz)
						
					elseif change > 0 then
						-- Erschwert um
						print("Probe erschwert")
						change = math.abs(change)
						restSkill = restSkill-change
						-- This section is kept through refactorings to make the difference in calculations obvious
						-- This is used for Attributserschwernis
						if restSkill < 0 then
							print("Attributserschwernis")
							att1 = att1+restSkill
							att2 = att2+restSkill
							att3 = att3+restSkill
							if roll1 <= att1 and roll2 <= att2 and roll3 <= att3 and krit <=1 and patz <=1 then
								response = response .. "Daher ist die Probe bestanden mit[/b] [b]1 TaP*[/b]"
							elseif roll1 <= att1 and roll2 <= att2 and roll3 <= att3 and krit >1 then
								response = response .. "[b]KRITISCHER ERFOLG mit[/b] [b] 1 TaP*[/b]"
							else
								restSkill = 0
								if roll1 > att1 then
									local result1 = att1-roll1
									restSkill = restSkill+result1
								end
								if roll2 > att2 then
									local result2 = att2-roll2
									restSkill = restSkill+result2
								end
								if roll3 > att3 then
									local result3 = att3-roll3
									restSkill = restSkill+result3
								end
								if restSkill < 0 and krit <=1 and patz <=1 then
									response = response .. "Daher ist die Probe misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. math.abs(restSkill)
									print("Notwendige Erleichterung: " .. math.abs(restSkill))
								elseif restSkill < 0 and krit >1 then
									response = response .. "[b]KRITISCHER ERFOLG mit[/b] [b] 1 TaP* [/b](Aber eigentlich Misserfolg ¯\\_(ツ)_/¯)"
								elseif restSkill < 0 and patz >1 then
									response = response .. "[b]PATZER.[/b] [b]\nNotwendige Erleichterung:  [/b]" .. math.abs(restSkill)
									print("Notwendige Erleichterung: " .. math.abs(restSkill))
								end
							end
							print("Rest Skill: " .. restSkill)
							print("Att1: " .. att1 .. " Att2: " .. att2 .. " Att3: " .. att3)
							print("W1: " .. roll1 .. " W2: " .. roll2 .. " W3: " .. roll3)
						else
							print("Talenterschwernis")
							
							restSkill = dsaFunc.applyAttributes(restSkill,roll,atts)
							
							print("Rest Skill: " .. restSkill)
							print("Att1: " .. att1 .. " Att2: " .. att2 .. " Att3: " .. att3)
							print("W1: " .. roll1 .. " W2: " .. roll2 .. " W3: " .. roll3)
							
							response = dsaFunc.appendResult(response, restSkill, skill, krit, patz)
						end
					end
					print("-------- \nDSA Probe mit Mod beendet \n--------\n")
				-- This section is kept through refactorings to make the difference in calculations obvious
				-- This is used for checks using only 1 die
				elseif simple then
					print("Simple Probe")
					if (roll1 + change) > att1 then
						local erlei = (roll1 + change) - att1
						if roll1 == 20 then
							if (roll2 + change) > att1 then
								response = response .. "PATZER. [b]\nNotwendige Erleichterung:  [/b]" .. erlei
							else
								response = response .. "Misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. erlei
							end	
						else
							response = response .. "Misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. erlei
						end			
					else
						local erschw = att1 - (roll1 + change)	
						if roll1 == 1 then
							if (roll2 + change) < att1 then
								response = response .. "KRITISCHER ERFOLG. [b]\nMaximale Erschwernis:  [/b]" ..  erschw
							else
								response = response .. "Bestanden. [b]\nMaximale Erschwernis:  [/b]" ..  erschw
							end	
						else
							response = response .. "Bestanden. [b]\nMaximale Erschwernis:  [/b]" ..  erschw
						end	
					end
					print("Att1: " .. att1)
					print("W1: " .. roll1)
					print("-------- \nDSA Probe beendet \n--------\n")
				else
					print("Probe normal")
					restSkill = dsaFunc.applyAttributes(restSkill,roll,atts)
					print("Rest Skill: " .. restSkill)
					print("Att1: " .. att1 .. " Att2: " .. att2 .. " Att3: " .. att3)
					print("W1: " .. roll1 .. " W2: " .. roll2 .. " W3: " .. roll3)
					response = dsaFunc.appendResult(response, restSkill, skill, krit, patz)
					print("-------- \nDSA Probe beendet \n--------\n")
				end
				--response = fromName .. " würfelt eine " .. roll1 .. ", " .. roll2 .. ", " .. roll3 .. "]" 
			-- This function rolls d6 specific for the DSA subsystem
			elseif string.sub(message, 1, 1) == "?" then
				local pool = values[1]
				local mod = values[2]
				local result = 0
				response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. pool .. "W6\n"
				local roll, result = dice.rollDice(pool,6)
				for i = 1, pool do
					response = response .. roll[i]
					if i < pool then 
						response = response .. " + "
					end					
				end
				if mod then response = response .. " + " .. mod end	
				if mod then
					print("Ergebnismodifikator: " .. mod .. "\n")
					result = result + mod
				end
				print("Ergebnis: " .. result .. "\n")
				response = response .. "\n[b]Ergebnis: " .. result .. "[/b]\n" --.. fromUniqueIdentifier .. "\n"
				print("-------- \nDSA W6er-Probe beendet \n--------\n")
			end
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			-- end of DSA block
		
			-- Dice Roll System used in ShadowRun 5 mode
		elseif system == "sr5" and string.sub(message, 1, 1) == "!" then --and aktiv and tonumber(string.sub(message, 2, 2)) then --and message ~= "!off" and message ~= "!dsa" and message ~= "!dsa4" and message ~= "!kat" and message ~= "!deg" then
			print("Pool Roll for SR")
			local content = string.sub(message, 2, 99)
			local values = {}
			local successes = 0
			local ones = 0
			local glitched = false
			local edge = false
			for value in string.gmatch(content, "([^,]+)") do
				if value == "e" then edge = true end
				table.insert(values, tonumber(value))
			end
			local pool = values[1]
			if edge ~= true then
				response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. pool .. "W6\n"
				for i = 1, pool do
					local roll = dice.d6()[1]
					response = response .. roll
					if i < pool then 
						response = response .. ", "
					end		
					if roll >= 5 then
						successes = successes+1
					end
					if roll == 1 then
						ones = ones+1
					end
				end
				if ones >= math.ceil(pool/2) then
					glitched = true
				end
				if glitched then
					response = response .. "[b] \nGLITCHED[/b] \nErfolge: [b]" .. successes .. "[/b]"
				else
					response = response .. "\nErfolge: [b]" .. successes .. "[/b]"
				end
			else
				response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. pool .. "W6 mit [b]Edge[/b]\n"
				local i = 1
				local diceToRoll = pool
				while i <= diceToRoll do
					local roll = dice.d6()[1]
					response = response .. roll						
					if roll >= 5 then
						successes = successes+1
					end
					if roll == 6 then
						diceToRoll = diceToRoll+1
					end
					if i < diceToRoll then 
						response = response .. ", "
					end			
					if roll == 1 and i <= pool then
						ones = ones+1
					end
					i = i+1
				end
				response = response .. "\n" .. diceToRoll-pool .. " Würfel explodiert"
				if ones >= math.ceil(pool/2) then
					glitched = true
				end
				if glitched then
					response = response .. "[b] \nGLITCHED[/b] \nErfolge: [b]" .. successes .. "[/b]"
				else
					response = response .. "\nErfolge:[b]" .. successes .. "[/b]"
				end
			end
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			-- end of ShadowRun block
		
			-- Dice Roll System used in Call of Cthulhu mode
		elseif system == "coc" then
			if string.sub(message, 1, 1) == "!" then
				print("CoC Skill Check")
				
				local content = string.sub(message, 2, 99)
				local values = {}
				for value in string.gmatch(content, "([^,]+)") do
					table.insert(values, tonumber(value))
				end			
				local skill = values[1]
				local result = dice.d100()[1]
				local modifier = values[2]
				
				response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt einen W100 gegen " .. skill
				
				if modifier ~= nil then
					if modifier >= 0 then
						local bonus = math.floor(result/10)
						response = response .. " mit " .. modifier .. " Bonuswürfeln\n[b]" .. result .. "[/b] - Boni: "
						for i = 1, modifier do
							local roll = dice.d10()[1]
							if roll == 10 then
								roll = 0
							end
							response = response .. roll .. "0"
							if roll < bonus then
								bonus = roll
							end
							if i < modifier then 
							response = response .. ", "
							end
						end
						result = (bonus*10) + math.fmod(result,10)
						if result == 0 then
							result = 100
						end
						response = response .. "\nEndergebnis: [b]" .. result .. "[/b]\n"
					else
						local malus = math.floor(result/10)
						modifier = math.abs(modifier)
						response = response .. " mit " .. modifier .. " Maluswürfeln:\n[b]" .. result .. "[/b] - Mali: "
						for i = 1, modifier do
							local roll = dice.d10()[1]
							if roll == 10 then
								roll = 0
							end
							response = response .. roll .. "0"
							if roll > malus then
								malus = roll
							end
							if i < modifier then 
							response = response .. ", "
							end
						end
						result = (malus*10) + math.fmod(result,10)
						response = response .. "\nEndergebnis: [b]" .. result .. "[/b]\n"
					end
				else
					response = response .. "\n[b]" .. result .. "[/b]\n"
				end
				
				if result == 1 then
					print("Critical Success!")
					response = response .. "[b]Kritischer Erfolg![/b]\n"
				elseif result == 100 or (result >= 96 and skill <50) then
					print("Fumble!")
					response = response .. "[b]Patzer![/b]\n"
				elseif result <= (skill/5) then
					print("Extreme Success!")
					response = response .. "[b]Extremer Erfolg![/b]\n"
				elseif result <= (skill/2) then
					print("Hard Success!")
					response = response .. "[b]Schwieriger Erfolg![/b]\n"
				elseif result <= skill then
					print("Regular Success!")
					response = response .. "[b]Erfolg![/b]\n"
				else
					print("Failure!")
					response = response .. "[b]Misserfolg![/b]\n"
				end
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
				
			elseif string.sub(message, 1, 1) == "?" then
				print("Generic Dice Roll for CoC")
				
				local content = string.sub(message, 2, 99)
				local values = {}
				for value in string.gmatch(content, "([^,]+)") do
					table.insert(values, tonumber(value))
				end
				local number = 1
				local die = 1
				local simple = false
				
				if values[2] ~= nil then
					number = values[1]
					die = values[2]
				else
					die = values[1]
					simple = true
				end
				response = response .. "\n[b]" .. fromName .. "[/b] würfelt " .. number .. "W" .. die .. "\n"
				print("Rolling " .. number .. "d" .. die)
				local roll, result = dice.rollDice(number,die)

				if simple then
					response = response .. "[b]" .. roll[1] .. "[/b]"
				else
					for i = 1, number do					
						response = response .. roll[i]
						if i < number then
							response = response .. " + "	
						end
					end
					if values[3] ~= nil then
						local modifier = values[3]
						result = result + modifier
						if mod >= 0 then
							response = response .. " + " .. modifier
						else
							response = response .. " - " .. math.abs(modifier)
						end
					end
					response = response .. " = [b]" .. result .. "[/b]"
				end
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0) 
			end
			-- end of CoC block
		
			-- Dice Roll System used in KatharSys mode (aka Degenesis)
		elseif system == "kat" and string.sub(message, 1, 1) == "!" then --and aktiv and tonumber(string.sub(message, 2, 2)) then --and message ~= "!off" and message ~= "!dsa" and message ~= "!dsa4" and message ~= "!sr" and message ~= "!sr5" then
			print("Pool Roll for KatharSys")
			
			local content = string.sub(message, 2, 99)
			local values = {}
			local successes = 0
			local ones = 0
			local triggers = 0
			local botched = false
			local edge = false
			for value in string.gmatch(content, "([^,]+)") do
				table.insert(values, tonumber(value))
			end
			local pool = values[1]
			
			response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. pool .. "W6"
			if mod == nil then
			elseif mod >= 0 then
				response = response .. "+" .. mod
			else
				response = response .. mod
			end
			response = response .. "\n"
			if pool > 12 then
				successes = (pool - 12)
				pool = 12
			end
			for i = 1, pool do
				local roll = dice.d6()[1]
				response = response .. roll
				if i < pool then 
					response = response .. ", "
				end		
				if roll >= 4 then
					successes = successes+1
				end
				if roll == 6 then
					triggers = triggers+1
				end
				if roll == 1 then
					ones = ones+1
				end
			end
			if ones > successes then
				botched = true
			end
			if botched then
				response = response .. "[b] \nPatzer![/b] \nErfolge: [b]" .. successes .. "[/b] \nTrigger: [b]" .. triggers .. "[/b]"
			else
				response = response .. "\nErfolge: [b]" .. successes .. "[/b] \nTrigger: [b]" .. triggers .. "[/b]"
			end
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			--end of KatharSys block
		
			-- Dice Roll System used in Blades In The Dark mode
		elseif system == "bitd" and string.sub(message, 1, 1) == "!" then
			print("Blades Skill Check")
			local content = string.sub(message, 2, 99)
			local values = {}
			local result = 1
			local sixes = 0
			local notzero = true
			local six = false
			
			for value in string.gmatch(content, "([^,]+)") do
				table.insert(values, tonumber(value))
			end
			local pool = values[1]
			if pool == 0 then
				notzero = false
				pool = 2
				result = 6
			end
			print("Rolling " .. pool .. "D6")
			response = response .. "\n[b]" .. fromName .. "[/b] würfelt " .. pool .. "W6\n"
			for i = 1, pool do
				local roll = dice.d6()[1]
				if roll > result and notzero then
					result = roll
				elseif roll < result and notzero == false then
					result = roll
				else
				end
				if roll == 6 then
					sixes = sixes +1
					six = true
					response = response .. "[b]"
				else
					six = false
				end
				response = response .. roll
				if six then
					response = response .. "[/b]"
				end
				if i < pool then
					response = response .. ", "
				end
			end
			response = response .. " => [b]" .. result .. "[/b]\n"
			if sixes >= 2 and notzero then
				print("Critical Success! - " .. sixes)
				response = response .. "[b]Kritischer Erfolg![/b] (" .. sixes .. ")"
			elseif result == 6 then
				print("Success!")
				response = response .. "[b]Voller Erfolg![/b]"
			elseif result >= 4 then
				print("Partial Success!")
				response = response .. "[b]Teilerfolg![/b]"
			else
				print("Failure!")
				response = response .. "[b]Fehlschlag![/b]"
			end
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			-- end of Blades block
		 
			-- Dice Roll System used in Powered By The Apocalpyse mode
		elseif system == "pbta" and string.sub(message, 1, 1) == "!" then
			print("PbtA Skill Check")
			local content = string.sub(message, 2, 99)
			local values = {}
			local prefix = ""
			for value in string.gmatch(content, "([^,]+)") do
				table.insert(values, tonumber(value))
			end
			
			local mod = values[1]
			local rolls = dice.rollDice(2, 6)
			local result = rolls[1] + rolls[2] + mod
			
			if mod >= 0 then
				prefix = "+"
			end
			print("Rolling 2d6 " .. mod)
			response = response .. "\n[b]" .. fromName .. "[/b] würfelt 2W6 " .. prefix .. mod .. "\n([b]" .. rolls[1] .. "[/b]) + ([b]" .. rolls[2] .. "[/b]) " .. prefix .. mod .. " = [b]" .. result .. "[/b]\n"
			
			if result >= 10 then
				print("Success!")
				response = response .. "[b]Voller Erfolg![/b]"
			elseif result >= 7 then
				print("Partial Success!")
				response = response .. "[b]Teilerfolg![/b]"
			else
				print("Failure!")
				response = response .. "[b]Fehlschlag![/b]"
			end
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			-- end of PbtA block
		
			-- Generic Dice Roll System
		else
			print("Generic Dice Roll")
			if string.sub(message, 1, 1) == "!" then
				print("Total")
				local content = string.sub(message, 2, 99)
				local values = {}
				for value in string.gmatch(content, "([^,]+)") do
					table.insert(values, tonumber(value))
				end
				local number = 1
				local die = 1
				local simple = false
				local prefix = ""
				if values[2] ~= nil then
					number = values[1]
					die = values[2]
				else
					die = values[1]
					simple = true
				end
				print("Rolling " .. number .. "d" .. die)
				response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. number .. "W" .. die .. "\n"
				local roll, result = dice.rollDice(number, die)
				if simple then
					response = response .. "[b]" .. roll[1] .. "[/b]"
				else
					for i = 1, number do					
						response = response .. roll[i]
						if i < number then
							response = response .. " + "
						end	
					end
					if values[3] ~= nil then
						local mod = values[3]
						result = result + mod
						if mod >= 0 then
							prefix = "+"
						end
						response = response .. " " .. prefix .. mod
					end
					response = response .. " = [b]" .. result .. "[/b]"
				end
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)

			elseif string.sub(message, 1, 1) == "?" then
				print("Pool")
				local content = string.sub(message, 2, 99)
				local values = {}
				for value in string.gmatch(content, "([^,]+)") do
					table.insert(values, tonumber(value))
				end
				local successes = 0
				local ones = 0
				local number = values[1]
				local die = values[2]
				local threshold = values[3]

				if threshold <= die and threshold >= 2 then
					response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. number .. "W" .. die .. "\n mit einer Erfolgsschwelle von " .. threshold .. "\n"
					print("Rolling " .. number .. "d" .. die)
					local roll = dice.rollDice(number,die)
					for i = 1, number do
						if roll[i] >= threshold then
							successes = successes +1
							response = response .. "[b]" .. roll[i] .. "[/b]" 
						elseif roll[i] == 1 then
							ones = ones +1
							response = response .. "[i]" .. roll[i] .. "[/i]"
						else
							response = response .. roll[i]
						end
						if i < number then 
							response = response .. ", "
						end
					end
					response = response .. "\n Erfolge: [b]" .. successes .. "[/b]\n Einsen: [b]" .. ones .. "[/b]"
				elseif threshold == 1 then
					response = response .. "\n[b]" .. fromName .. "[/b] macht [b]" .. number .. "[/b] Autoerfolge, das braucht man nicht würfeln!\n"
					print(number .. " auto-successes on D" .. die)
				else
					response = response .. "\nMan kann mit einem W" .. die .. " keine " .. threshold .. " erwürfeln!\n"
					print(threshold .. " is out of range of a D".. die)
				end
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			end
			if memory ~= nil then
				system = memory
				memory = nil
			end
		end
	end
	
	-- Color Picker (Special way of reading the command, dont touch)
	if aktiv then
		local colorCmd, colorName = string.match(message:lower(), "^!(farbe),([^%s]+)")
		if colorCmd then
			print("Color " .. colorName .. " set for user " .. fromName)
			response = response .. colors.setUserColor(fromUniqueIdentifier,colorName)
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			--userColor = setUserColor(fromUniqueIdentifier,colorName)
			--response = response .. userColor
		end
	end
	
	-- Non 2nd char numerical non only-owner commands
	if aktiv then
		if system == "dsa4" and message == "!treffer" then
			print("Treff")
			local tz = dice.d20()[1]
			print("Treffer" .. tz)
			response = response .. "DSA Trefferzonenwürfel: " .. tz .. "\n Treffer gegen: [b]"
			if tz == 1 or tz == 3 or tz == 5 then response = response .. "Linkes Bein"
			elseif tz == 2 or tz == 4 or tz == 6 then response = response .. "Rechtes Bein"
			elseif tz <= 8 then response = response .. "Bauch"
			elseif tz ==9 or tz == 11 or tz == 13 then  response = response .. "Schildarm"
			elseif tz ==10 or tz == 12 or tz == 14 then  response = response .. "Schwertarm"
			elseif tz <=18 then response = response .. "Brust"
			elseif tz <=20 then response = response .. "Kopf" 
			end
		response = response .. "[/b]"
		ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
		end
	end
	-- "Admin" Commands (Powerswitch, Systemswitch)
	if fromUniqueIdentifier == owner then
		if not aktiv and message == "!on" or message == "!dice" then 
			aktiv = true
			print("Tool Aktiv")
			response = "[b]Tool Aktiv[/b] (" .. version .. ")\n !help -> Zeigt Commands an"
			--response = "[b]Tool Aktiv[/b]\nFolgende Befehle sind funktional \n!dsa - System DSA \n!sr- System Shadowrun \n?[Menge],[Würfel] \n!off - Tool aus"
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			print(version)
		elseif aktiv then
			if message == "!dsa" or message == "!dsa4" then
				system = "dsa4"
				print("System DSA 4.1")
				response = response .. "\n[b]System DSA 4.1[/b]"
				--response = response .. "\n[b]System DSA[/b] \n![Wert] -> 1w20 Probe\n" 
				--response = response .. "![Attributwert],[Attributwert],[Attributwert],[Talentwert],<optional Mod> -> 3w20 Probe\n"
				--response = response .. "[b]Generisch[/b] \n? -> 1w6 \n! -> 1w20"
				--response = response .. "\n?[Menge],[Würfel]"
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			elseif message == "!sr" or message == "!sr5" then
				system = "sr5"
				print("System Shadowrun 5")
				response = response .. "\n[b]System Shadowrun 5[/b]"
				--response = response .. "\n[b]System Shadowrun[/b] \n![Wert] -> [Wert]w6 Probe\n" 
				--response = response .. "![Wert],e -> Exploding w6 Probe\n"
				--response = response .. "[b]Generisch[/b] \n?[Menge],[Würfel]"
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			elseif message == "!coc" or message == "!call" then
				system = "coc"
				print("System Call of Cthulhu 7th Edition")
				response = response .. "\n[b]System Call of Cthulhu[/b]"
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			elseif message == "!kat" or message == "!deg" then
				system = "kat"
				print("System KatharSys aka	Degenesis")
				response = response .. "\n[b]System KatharSys aka Degenesis[/b]"
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			elseif message == "!bitd" or message == "!blades" then
				system = "bitd"
				print("System Blades In The Dark")
				response = response .. "\n[b]System Blades In The Dark[/b]"
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			elseif message == "!pbta" or message == "!apoc" then
				system = "pbta"
				print("System Powered By The Apocalypse")
				response = response .. "\n[b]System Powered By The Apocalypse[/b]"
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			elseif message == "!off" then
				aktiv = false
				system = nil
				print("Tool Aus")
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, "[b]Tool Aus[/b]", 0)
			elseif 	message == "!statcheck" and aktiv then
				local res4 = dice.averageTest(100000,4)
				local res6 = dice.averageTest(100000,6)
				local res8 = dice.averageTest(100000,8)
				local res10 = dice.averageTest(100000,10)
				local res12 = dice.averageTest(100000,12)
				local res20 = dice.averageTest(100000,20)
				local res100 = dice.averageTest(100000,100)
				response = response .. "\n100000 D4 gewürfelt Durchschnitt: " .. res4
				response = response .. "\n100000 D6 gewürfelt Durchschnitt: " .. res6
				response = response .. "\n100000 D8 gewürfelt Durchschnitt: " .. res8
				response = response .. "\n100000 D10 gewürfelt Durchschnitt: " .. res10
				response = response .. "\n100000 D12 gewürfelt Durchschnitt: " .. res12
				response = response .. "\n100000 D20 gewürfelt Durchschnitt: " .. res20
				response = response .. "\n100000 D100 gewürfelt Durchschnitt: " .. res100
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			end
		end
	end
end

roller_events = {
	onTextMessageEvent = onTextMessageEvent,
}