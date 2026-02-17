-- Refactored events.lua: flattened dispatcher and system-specific modules
print("[TSDiceRoller] Events module loading - requiring dependencies")

print("[TSDiceRoller] Events module: attempting to require roller/dice")
local dice = require("roller/dice")
print("[TSDiceRoller] Events module: dice module required successfully")

print("[TSDiceRoller] Events module: attempting to require roller/colors")
local colors = require("roller/colors")
print("[TSDiceRoller] Events module: colors module required successfully")

print("[TSDiceRoller] Events module: attempting to require roller/input")
local input = require("roller/input")  -- Input sanitization and validation module
print("[TSDiceRoller] Events module: input module required successfully")

print("[TSDiceRoller] Events module: attempting to require system modules")
local systems = {
    dsa4 = require("roller/systems/dsa"),
    sr5 = require("roller/systems/sr5"),
    coc = require("roller/systems/coc"),
    kat = require("roller/systems/kat"),
    bitd = require("roller/systems/bitd"),
    pbta = require("roller/systems/pbta"),
    generic = require("roller/systems/generic"),
}
print("[TSDiceRoller] Events module: all system modules required successfully")

local aktiv = false
local response = ""
local system = nil
local memory = nil
local OWNER_UNIQUE_ID = nil

local version = "1.0.0"

function detectOwner(serverConnectionHandlerID)
    print("[TSDiceRoller] detectOwner() called with serverConnectionHandlerID=" .. tostring(serverConnectionHandlerID))
    if OWNER_UNIQUE_ID ~= nil then
        print("[TSDiceRoller] detectOwner: cached OWNER_UNIQUE_ID returned: " .. tostring(OWNER_UNIQUE_ID))
        return OWNER_UNIQUE_ID
    end
    print("[TSDiceRoller] detectOwner: fetching client ID")
    local myClientID = ts3.getClientID(serverConnectionHandlerID)
    print("[TSDiceRoller] detectOwner: myClientID=" .. tostring(myClientID))
    local uid = ts3.getClientVariableAsString(serverConnectionHandlerID, myClientID, ts3defs.ClientProperties.CLIENT_UNIQUE_IDENTIFIER)
    print("[TSDiceRoller] detectOwner: determined owner UID=" .. tostring(uid))
    return uid
end

local function sendResponse(serverConnectionHandlerID, resp)
    print("[TSDiceRoller] sendResponse() called with serverConnectionHandlerID=" .. tostring(serverConnectionHandlerID) .. ", resp length=" .. tostring(#(resp or "")))
    if resp and resp ~= "" then
        print("[TSDiceRoller] sendResponse: sending message to channel")
        ts3.requestSendChannelTextMsg(serverConnectionHandlerID, resp, 0)
    else
        print("[TSDiceRoller] sendResponse: response empty or nil, skipping send")
    end
end

local function handleSimpleRolls(serverConnectionHandlerID, message, fromName)
    print("[TSDiceRoller] handleSimpleRolls() called, message=" .. tostring(message) .. ", fromName=" .. tostring(fromName))
    -- Normalize message for comparison (trim whitespace)
    local normalizedMsg = input.normalize(message, false)
    print("[TSDiceRoller] handleSimpleRolls: normalized message=" .. tostring(normalizedMsg))
    
    -- Handle simple single-character rolls (with robust whitespace handling)
    if normalizedMsg == "!" then
        print("[TSDiceRoller] handleSimpleRolls: matched single '!' (1W20 roll)")
        local resp = "\n[b]" .. fromName .. "[/b] würfelt 1W20 - [b]" .. dice.d20()[1] .. "[/b]"
        sendResponse(serverConnectionHandlerID, response .. resp)
        return true
    elseif normalizedMsg == "?" then
        print("[TSDiceRoller] handleSimpleRolls: matched single '?' (1W6 roll)")
        local resp = "\n[b]" .. fromName .. "[/b] würfelt 1W6 - [b]" .. dice.d6()[1] .. "[/b]"
        sendResponse(serverConnectionHandlerID, response .. resp)
        return true
    elseif normalizedMsg == "!!" then
        print("[TSDiceRoller] handleSimpleRolls: matched '!!' (1W100 roll)")
        local resp = "\n[b]" .. fromName .. "[/b] würfelt 1W100 - [b]" .. dice.d100()[1] .. "[/b]"
        sendResponse(serverConnectionHandlerID, response .. resp)
        return true
    elseif normalizedMsg == "??" then
        print("[TSDiceRoller] handleSimpleRolls: matched '??' (2W6 roll)")
        local rolls = dice.rollDice(2,6)
        local resp = "\n[b]" .. fromName .. "[/b] würfelt 1W66 (2W6) - [b]" .. rolls[1] .. rolls[2] .. "[/b]"
        sendResponse(serverConnectionHandlerID, response .. resp)
        return true
    end
    print("[TSDiceRoller] handleSimpleRolls: no simple roll pattern matched")
    return false
end

local function onTextMessageEvent(serverConnectionHandlerID, targetMode, toID, fromID, fromName, fromUniqueIdentifier, message, ffIgnored)
    print("[TSDiceRoller] onTextMessageEvent() called")
    print("[TSDiceRoller] onTextMessageEvent params - targetMode=" .. tostring(targetMode) .. ", fromName=" .. tostring(fromName) .. ", message=" .. tostring(message))
    
    -- Validate and normalize input
    local isValid, errMsg = input.validateInput(message)
    print("[TSDiceRoller] onTextMessageEvent: input validation result - isValid=" .. tostring(isValid) .. ", error=" .. tostring(errMsg))
    if not isValid then
        print("[TSDiceRoller] onTextMessageEvent: returning - invalid input")
        return  -- Silently ignore invalid input (nil, empty, or whitespace-only)
    end
    
    if targetMode ~= 2 then 
        print("[TSDiceRoller] onTextMessageEvent: returning - targetMode not 2 (targetMode=" .. tostring(targetMode) .. ")")
        return 
    end
    local owner = detectOwner(serverConnectionHandlerID)
    print("[TSDiceRoller] onTextMessageEvent: owner detected as " .. tostring(owner) .. ", fromUniqueIdentifier=" .. tostring(fromUniqueIdentifier))
    response = colors.getUserColor(fromUniqueIdentifier, fromName)
    
    -- Normalize message for case-insensitive processing
    local normalizedMsg = input.normalize(message, true)
    print("[TSDiceRoller] onTextMessageEvent: normalized message (lowercase)=" .. tostring(normalizedMsg))

    -- Simple generic rolls & help when active
    if aktiv then
        print("[TSDiceRoller] onTextMessageEvent: tool is ACTIVE")
        if handleSimpleRolls(serverConnectionHandlerID, message, fromName) then 
            print("[TSDiceRoller] onTextMessageEvent: simple roll handled, returning")
            return 
        end
        if input.commandMatchesAny(message, {"!help", "!hilfe"}) then
            print("[TSDiceRoller] onTextMessageEvent: help command detected")
            local help = "\nFolgende Befehle sind funktional:\n!farbe,[farbe] - Setzt eine Farbe per User\n!(<Input>) oder ?(<Input>) -> Würfelt den <Input> als Generischen Wurf\n!off - Tool aus\n"
            help = help .. "\n[b]Allgemeine Würfe[/b] (immer gültig)\n! -> 1W20\\n? -> 1W6\\n!! -> 1W100\n?? -> '1W66'(2W6)-Probe\n"
            sendResponse(serverConnectionHandlerID, response .. help)
            return
        end
        if input.commandMatchesAny(message, {"!treffer", "!treff"}) then
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
		    sendResponse(serverConnectionHandlerID, response)
            return
        end

        -- Generic override parentheses handling (with safe substring checks)
        local firstChar = input.safeSubstring(message, 1, 1)
        local secondChar = input.safeSubstring(message, 2, 2)
        local lastChar = input.safeSubstring(message, -1)
        
        if secondChar == "(" and lastChar == ")" then
            message = firstChar .. input.safeSubstring(message, 3, #message - 1)
            memory = system
            system = nil
        end

        -- System-specific handling when second char numeric
        local secondCharNum = tonumber(input.safeSubstring(message, 2, 2))
        if secondCharNum then
            print("[TSDiceRoller] onTextMessageEvent: numeric second character detected, attempting system dispatch")
            
            -- Dispatch to modular handlers (including DSA)
            local handler = systems[system] or systems.generic
            local resp, send = handler.process(message, fromName, dice)
            if send then sendResponse(serverConnectionHandlerID, response .. resp) end
            if memory ~= nil then system = memory memory = nil end
            return
        end  -- End of: if secondCharNum then

        -- Color Picker (with improved parsing)
        print("[TSDiceRoller] onTextMessageEvent: checking for color picker command (!farbe)")
        -- Use safe pattern matching with whitespace handling
        -- Pattern: ^%!farbe%s+(%S+)$ - matches "!farbe" followed by one or more spaces, then captures the color name
        local colorMatches = input.matchPattern(input.normalize(message, true), "^%!farbe%s*%W%s*(%S+)$")
        if colorMatches and #colorMatches > 0 then
            local colorName = colorMatches[1]
            print("[TSDiceRoller] onTextMessageEvent: color command matched, colorName=" .. tostring(colorName))
            response = response .. colors.setUserColor(fromUniqueIdentifier, colorName)
            sendResponse(serverConnectionHandlerID, response)
            return
        else
            print("[TSDiceRoller] onTextMessageEvent: no color command pattern matched")
        end
    end  -- End of: if aktiv then

    -- Admin commands (owner-only)
    if fromUniqueIdentifier == owner then
        print("[TSDiceRoller] onTextMessageEvent: admin/owner command processing")
        print("[TSDiceRoller] onTextMessageEvent: aktiv status=" .. tostring(aktiv))
        if (not aktiv and input.commandMatchesAny(message, {"!on", "!dice"})) then
            print("[TSDiceRoller] onTextMessageEvent: activating tool")
            aktiv = true
            local resp = "[b]Tool Aktiv[/b] (" .. version .. ")\\n !help -> Zeigt Commands an"
            sendResponse(serverConnectionHandlerID, resp)
            return
        elseif aktiv then
            print("[TSDiceRoller] onTextMessageEvent: tool active, checking system commands")
            -- Use case-insensitive command matching for all system selection commands
            if input.commandMatchesAny(message, {"!dsa", "!dsa4"}) then 
                print("[TSDiceRoller] onTextMessageEvent: setting system to DSA4")
                system = "dsa4" 
                sendResponse(serverConnectionHandlerID, response .. "\n[b]System DSA 4.1[/b]") 
                return 
            end
            if input.commandMatchesAny(message, {"!sr", "!sr5"}) then 
                print("[TSDiceRoller] onTextMessageEvent: setting system to SR5")
                system = "sr5" 
                sendResponse(serverConnectionHandlerID, response .. "\n[b]System Shadowrun 5[/b]") 
                return 
            end
            if input.commandMatchesAny(message, {"!coc", "!call"}) then 
                print("[TSDiceRoller] onTextMessageEvent: setting system to COC")
                system = "coc" 
                sendResponse(serverConnectionHandlerID, response .. "\n[b]System Call of Cthulhu[/b]") 
                return 
            end
            if input.commandMatchesAny(message, {"!kat", "!deg"}) then 
                print("[TSDiceRoller] onTextMessageEvent: setting system to KAT")
                system = "kat" 
                sendResponse(serverConnectionHandlerID, response .. "\n[b]System KatharSys aka Degenesis[/b]") 
                return 
            end
            if input.commandMatchesAny(message, {"!bitd", "!blades"}) then 
                print("[TSDiceRoller] onTextMessageEvent: setting system to BITD")
                system = "bitd" 
                sendResponse(serverConnectionHandlerID, response .. "\n[b]System Blades In The Dark[/b]") 
                return 
            end
            if input.commandMatchesAny(message, {"!pbta", "!apoc"}) then 
                print("[TSDiceRoller] onTextMessageEvent: setting system to PBTA")
                system = "pbta" 
                sendResponse(serverConnectionHandlerID, response .. "\n[b]System Powered By The Apocalypse[/b]") 
                return 
            end
            if input.commandMatchesAny(message, {"!generic"}) then 
                print("[TSDiceRoller] onTextMessageEvent: setting system to Generic")
                system = nil
                sendResponse(serverConnectionHandlerID, response .. "\n[b]System Generic[/b]") 
                return 
            end
            if input.commandMatches(message, "!off") then 
                print("[TSDiceRoller] onTextMessageEvent: deactivating tool")
                aktiv = false 
                system = nil 
                sendResponse(serverConnectionHandlerID, "[b]Tool Aus[/b]") 
                return 
            end
            if input.commandMatches(message, "!statcheck") and aktiv then
                print("[TSDiceRoller] onTextMessageEvent: running statcheck diagnostic")
                local res4 = dice.averageTest(100000,4)
                local res6 = dice.averageTest(100000,6)
                local res8 = dice.averageTest(100000,8)
                local res10 = dice.averageTest(100000,10)
                local res12 = dice.averageTest(100000,12)
                local res20 = dice.averageTest(100000,20)
                local res100 = dice.averageTest(100000,100)
                local msg = "\n100000 D4 gewürfelt Durchschnitt: " .. res4
                msg = msg .. "\n100000 D6 gewürfelt Durchschnitt: " .. res6
                msg = msg .. "\n100000 D8 gewürfelt Durchschnitt: " .. res8
                msg = msg .. "\n100000 D10 gewürfelt Durchschnitt: " .. res10
                msg = msg .. "\n100000 D12 gewürfelt Durchschnitt: " .. res12
                msg = msg .. "\n100000 D20 gewürfelt Durchschnitt: " .. res20
                msg = msg .. "\n100000 D100 gewürfelt Durchschnitt: " .. res100
                sendResponse(serverConnectionHandlerID, msg)
                return
            end
        end
    end
end

roller_events = { onTextMessageEvent = onTextMessageEvent }
