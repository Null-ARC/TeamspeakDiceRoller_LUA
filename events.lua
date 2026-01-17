--[===[
    Roller Skript
    ------------------
    A simple and reusable Lua-based dice rolling utility.
    Designed for online roleplaying using Teamspeak 3

      Authors:
        Alick | Alex // DK_Alick
		Null-ARC | Fenrir

	Version:
		Beta 1.3
	
    Disclaimer:
        This software is provided "as is", without warranty of any kind,
        express or implied. The author is not liable for any damages
        arising from the use of this software.
		
	ToDo:
		- Kritische Treffer / Patzer für DSA
		- Nutzbare Code Kommentare
		- Bessere Zufallsmethoden
		- OOP
		- maybe Syntax von Lule übernehmen
--]===]
local dice = require("roller/dice")
local aktiv = false
local response = ""
local system = nil
local OWNER_UNIQUE_ID = nil

-- Funktion um den Owner der TS INstanz festzulegen
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
	if fromName == "Alick | Alex" then
		print("Gold")
		response = "[color=#998811]"
		
	elseif (fromName == "Null-ARC | Fenrir" or fromName == "Tarek ben Nizar | NARC") then
		print("Blau")
		response = "[color=#4848FF]"
		
	elseif fromName == "Sir Kilmawa" then
		print("Grün")
		response = "[color=#116611]"
		
	elseif (fromName == "Engelsleiche" or fromName == "Jadira saba Nagar" or fromName == "Cassandra vom Düsterhain") then
		print("Petrol")
		response = "[color=#037c6e]"
	else
		print("Default")
		response = ""
	end
	-- Simple D20 Roll from every mode
	if aktiv and message == "!" then
		print("-------- \nGeneric D20 \n--------\n")
		-- Stupid W20 Roll
		response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt 1W20 - "
		response = response .. "[b]" .. dice.d20()[1] .. "[/b]"
		ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
	end

	-- Simple D6 Roll from every mode
	if aktiv and message == "?" then
		print("-------- \nGeneric D6 \n--------\n")
		response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt 1W6 - "
		response = response .. "[b]" .. dice.d6()[1] .. "[/b]"
		ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
	end

	-- Dice Roll System used in DSA mode
	if aktiv and system == "dsa" and string.sub(message, 1, 1) == "!" and tonumber(string.sub(message, 2, 2)) then -- message ~= "!off" and message ~= "!sr" and message ~= "!sr5" and message ~= "!kat" and message ~= "!deg" then
	--if string.sub(message, 1, 1) == "!" then				
		print("-------- \nDSA Probe gestartet \n--------\n")
		local content = string.sub(message, 2, 99)
		
		local values = {}
		local talentMod = false
		local simple = false
		
		for value in string.gmatch(content, "([^,]+)") do
			table.insert(values, tonumber(value))
		end
		local att1 = values[1]
		local att2 = values[2]
		local att3 = values[3]
		local skill = values[4]
		local change = values[5]
		
		if att2 == nil and att3 == nil and skill == nil then
			simple = true
		end
		print("Attribut 1: " .. att1)
		if simple ~= true then
			print("Attribut 2: " .. att2)
			print("Attribut 3: " .. att3)
			print("TaW: " .. skill)
		end
		
		if change ~= nil then
			talentMod = true
			if change < 0 then
			response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt eine DSA Talentprobe erleichtert um " .. math.abs(change) .. "\n"
			elseif change > 0 then
			response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt eine DSA Talentprobe erschwert um " .. change .. "\n"
			end
		elseif simple ~= true then
			response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt eine DSA Talentprobe \n"
		elseif simple then
			response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt eine DSA Probe: "
		end
		
		local roll = dice.rollDice(3,20)
		local roll1 = roll[1]
		local roll2 = roll[2]
		local roll3 = roll[3]
		print("Die Ergebnisse sind: [" .. roll1 .. ", " .. roll2 .. ", " .. roll3 .. "]")
		if simple then
			response = response .. "[" .. roll1 .. "]\n" 
		else
			response = response .. " Die Würfe sind: [" .. roll1 .. ", " .. roll2 .. ", " .. roll3 .. "]\n" 
		end
	
		local restSkill = skill
		
		if talentMod then
			if change < 0 then
				print("Probe erleichtert")
				change = math.abs(change)
				restSkill = restSkill+change
				if roll1 > att1 then
					local result1 = roll1-att1
					restSkill = restSkill-result1
				end
				if roll2 > att2 then
					local result2 = roll2-att2
					restSkill = restSkill-result2
				end
				if roll3 > att3 then
					local result3 = roll3-att3
					restSkill = restSkill-result3
				end
				print("Rest Skill: " .. restSkill)
				print("Att1: " .. att1 .. " Att2: " .. att2 .. " Att3: " .. att3)
				print("W1: " .. roll1 .. " W2: " .. roll2 .. " W3: " .. roll3)
				if restSkill >= 0 and restSkill <= skill then
					taps = restSkill
					response = response .. "Daher ist die Probe bestanden mit [b] " .. taps .. "* [/b] "
					print("Mit " .. taps .. " TaP* bestanden")		
				elseif restSkill >= 0 and restSkill > skill then
					taps = skill
					response = response .. "Daher ist die Probe bestanden mit [b] " .. taps .. "* [/b] "
					print("Mit " .. taps .. " TaP* bestanden")		
				elseif restSkill < 0 then
					response = response .. "Daher ist die Probe misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. math.abs(restSkill)
					print("Notwendige Erleichterung: " .. math.abs(restSkill))
				end
			elseif change > 0 then
				-- Erschwert um
				print("Probe erschwert")
				change = math.abs(change)
				restSkill = restSkill-change
				if restSkill < 0 then
					print("Attributserschwernis")
					att1 = att1+restSkill
					att2 = att2+restSkill
					att3 = att3+restSkill
					if roll1 <= att1 and roll2 <= att2 and roll3 <= att3 then
						response = response .. "Daher ist die Probe bestanden"
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
						if restSkill < 0 then
							response = response .. "Daher ist die Probe misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. math.abs(restSkill)
							print("Notwendige Erleichterung: " .. math.abs(restSkill))
						end
					end
					print("Rest Skill: " .. restSkill)
					print("Att1: " .. att1 .. " Att2: " .. att2 .. " Att3: " .. att3)
					print("W1: " .. roll1 .. " W2: " .. roll2 .. " W3: " .. roll3)
				else
					print("Talenterschwernis")
					if roll1 > att1 then
						local result1 = roll1-att1
						restSkill = restSkill-result1
					end
					if roll2 > att2 then
						local result2 = roll2-att2
						restSkill = restSkill-result2
					end
					if roll3 > att3 then
						local result3 = roll3-att3
						restSkill = restSkill-result3
					end
					print("Rest Skill: " .. restSkill)
					print("Att1: " .. att1 .. " Att2: " .. att2 .. " Att3: " .. att3)
					print("W1: " .. roll1 .. " W2: " .. roll2 .. " W3: " .. roll3)
					if restSkill >= 0 and restSkill <= skill then
						taps = restSkill
						response = response .. "Daher ist die Probe bestanden mit [b] " .. taps .. "* [/b] "
						print("Mit " .. taps .. " TaP* bestanden")		
					elseif restSkill >= 0 and restSkill > skill then
						taps = skill
						response = response .. "Daher ist die Probe bestanden mit [b] " .. taps .. "* [/b] "
						print("Mit " .. taps .. " TaP* bestanden")		
					elseif restSkill < 0 then
						response = response .. "Daher ist die Probe misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. math.abs(restSkill)
						print("Notwendige Erleichterung: " .. math.abs(restSkill))
					end
				end
			end
			print("-------- \nDSA Probe mit Mod beendet \n--------\n")
		elseif simple then
			print("Simple Probe")
			if roll1 > att1 then
				local erlei = roll1-att1
				response = response .. "Misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. erlei				
			else
				local erschw = att1-roll1	
				response = response .. "Bestanden. [b]\nMaximale Erschwernis:  [/b]" ..  erschw
			end
			print("Att1: " .. att1)
			print("W1: " .. roll1)
			print("-------- \nDSA Probe beendet \n--------\n")
		else
			print("Probe normal")
			if roll1 > att1 then
				local result1 = roll1-att1
				restSkill = restSkill-result1
			end
			if roll2 > att2 then
				local result2 = roll2-att2
				restSkill = restSkill-result2
			end
			if roll3 > att3 then
				local result3 = roll3-att3
				restSkill = restSkill-result3
			end		
			print("Rest Skill: " .. restSkill)
			print("Att1: " .. att1 .. " Att2: " .. att2 .. " Att3: " .. att3)
			print("W1: " .. roll1 .. " W2: " .. roll2 .. " W3: " .. roll3)
			if restSkill >= 0 and restSkill <= skill then
				taps = restSkill			
				response = response .. "Daher ist die Probe bestanden mit [b] " .. taps .. "* [/b] "
				print("Mit " .. taps .. " TaP* bestanden")		
			elseif restSkill < 0 then
				response = response .. "Daher ist die Probe misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. math.abs(restSkill)
				--print("Notwendige Erleichterung: " .. math.abs(restSkill))
			end
			print("-------- \nDSA Probe beendet \n--------\n")
		end
		--response = fromName .. " würfelt eine " .. roll1 .. ", " .. roll2 .. ", " .. roll3 .. "]" 
		ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
	end
	
	-- Dice Roll System used in SR mode
	if aktiv and system == "sr" and string.sub(message, 1, 1) == "!" and tonumber(string.sub(message, 2, 2)) then -- message ~= "!off" and message ~= "!dsa" and message ~= "!dsa4" and message ~= "!kat" and message ~= "!deg" then
		print("Generic Dice Roll for SR")
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
	end
	
	-- Generic Dice Roll System
	if aktiv and string.sub(message, 1, 1) == "?" then
		print("Generic Dice Roll")
		local content = string.sub(message, 2, 99)
		local values = {}
		for value in string.gmatch(content, "([^,]+)") do
			table.insert(values, tonumber(value))
		end
		local number = values[1]
		local die = values[2]		
		response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. number .. "W" .. die .. "\n"
		print("Rolling " .. number .. "d" .. die)
		local roll, result = dice.rollDice(number,die)
		for i = 1, number do					
			response = response .. roll[i]
			if i < number then response = response .. " + " end		
		end		
		response = response .. " = " .. result
		ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
	end
	
	-- Dice Roll System used in KatharSys mode (aka Degenesis)
	if aktiv and system == "kat" and string.sub(message, 1, 1) == "!" and tonumber(string.sub(message, 2, 2)) then -- message ~= "!off" and message ~= "!dsa" and message ~= "!dsa4" and message ~= "!sr" and message ~= "!sr5" then
		print("Generic Dice Roll for KatharSys")
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
		response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. pool .. "W6\n"
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
	end
	
	-- Powerswitch & Systemswitch
	if fromUniqueIdentifier == owner then
		if message == "!on" or message == "!dice" then 
			aktiv = true
			print("Tool Aktiv")
			response = "[b]Tool Aktiv[/b]\n !help -> Zeigt Commands an"
			--response = "[b]Tool Aktiv[/b]\nFolgende Befehle sind funktional \n!dsa - System DSA \n!sr- System Shadowrun \n?[Menge],[Würfel] \n!off - Tool aus"
			ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
		elseif aktiv then
			if message == "!help" then
				response = response .. "\nFolgende Befehle sind funktional \n!dsa - System DSA \n!sr- System Shadowrun \n?[Menge],[Würfel] \n!off - Tool aus\n"
				response = response .. "\n[b]System DSA[/b] \n![Wert] -> 1w20 Probe\n" 
				response = response .. "![Attributwert],[Attributwert],[Attributwert],[Talentwert],<optional Mod> -> 3w20 Probe\n"
				response = response .. "\n[b]System Shadowrun[/b] \n![Wert] -> [Wert]w6 Probe\n" 
				response = response .. "![Wert],e -> Exploding w6 Probe\n"
				response = response .. "[b]Generisch[/b] \n?[Menge],[Würfel]\n? -> 1w6 \n! -> 1w20"
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			elseif message == "!dsa" or message == "!dsa4" then
				system = "dsa"
				print("System DSA 4.1")
				response = response .. "\n[b]System DSA 4.1[/b]"
				--response = response .. "\n[b]System DSA[/b] \n![Wert] -> 1w20 Probe\n" 
				--response = response .. "![Attributwert],[Attributwert],[Attributwert],[Talentwert],<optional Mod> -> 3w20 Probe\n"
				--response = response .. "[b]Generisch[/b] \n? -> 1w6 \n! -> 1w20"
				--response = response .. "\n?[Menge],[Würfel]"
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			elseif message == "!sr" or message == "!sr5" then
				system = "sr"
				print("System Shadowrun 5")
				response = response .. "\n[b]System Shadowrun 5[/b]"
				--response = response .. "\n[b]System Shadowrun[/b] \n![Wert] -> [Wert]w6 Probe\n" 
				--response = response .. "![Wert],e -> Exploding w6 Probe\n"
				--response = response .. "[b]Generisch[/b] \n?[Menge],[Würfel]"
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			elseif message == "!kat" or message == "!deg" then
				system = "kat"
				print("System KatharSys aka	Degenesis")
				response = response .. "\n[b]System KatharSys aka Degenesis[/b]"
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, response, 0)
			elseif message == "!off" then
				aktiv = false
				system = nil
				print("Tool Aus")
				ts3.requestSendChannelTextMsg(serverConnectionHandlerID, "[b]Tool Aus[/b]", 0)
			else
			end
		else
		end
	end
	print("Roller: onTextMessageEvent: " .. serverConnectionHandlerID .. " " .. targetMode .. " " .. toID .. " " .. fromID .. " " .. fromName .. " " .. fromUniqueIdentifier .. " " .. message .. " " .. ffIgnored)
	return 0
end

roller_events = {
	onTextMessageEvent = onTextMessageEvent,
}







