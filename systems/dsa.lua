-- DSA (Das Schwarze Auge/The Dark Eye) Ruleset Module
-- Provides comprehensive DSA game mechanics including skill checks, combat tests, and special abilities
print("[TSDiceRoller] DSA system module loading")

local input = require("roller/input")  -- Input sanitization and validation module

-- Count criticals (roll == 1) and patzers (roll == 20) in rolls
-- @param rolls: table of 3 d20 rolls
-- @return: count of criticals, count of patzers
local function countCritsAndPatz(rolls)
    print("[TSDiceRoller] countCritsAndPatz() called with rolls=[" .. table.concat(rolls, ",") .. "]")
    local krit, patz = 0, 0
    for _, r in ipairs(rolls) do
        if r == 1 then krit = krit + 1 end
        if r == 20 then patz = patz + 1 end
    end
    print("[TSDiceRoller] countCritsAndPatz result: krit=" .. tostring(krit) .. ", patz=" .. tostring(patz))
    return krit, patz
end

-- Apply attribute values to reduce remaining skill points if rolls exceed attributes
-- @param restSkill: remaining skill points
-- @param rolls: table of 3 d20 rolls
-- @param atts: table of 3 attribute values
-- @return: updated remaining skill points
local function applyAttributes(restSkill, rolls, atts)
    print("[TSDiceRoller] applyAttributes() called with restSkill=" .. tostring(restSkill) .. ", rolls=[" .. table.concat(rolls, ",") .. "], atts=[" .. table.concat(atts, ",") .. "]")
    for i = 1, 3 do
        if rolls[i] > atts[i] then
            restSkill = restSkill - (rolls[i] - atts[i])
            print("[TSDiceRoller] applyAttributes: attribute " .. tostring(i) .. " check failed, new restSkill=" .. tostring(restSkill))
        else
            print("[TSDiceRoller] applyAttributes: attribute " .. tostring(i) .. " check passed")
        end
    end
    print("[TSDiceRoller] applyAttributes result: restSkill=" .. tostring(restSkill))
    return restSkill
end

-- Determine and append the result of a skill check to the response
-- @param response: base response string
-- @param restSkill: remaining skill points after attribute checks
-- @param skill: original skill value
-- @param krit: count of criticals
-- @param patz: count of patzers
-- @return: response with appended result
local function appendResult(response, restSkill, skill, krit, patz)
    print("[TSDiceRoller] appendResult() called with restSkill=" .. tostring(restSkill) .. ", skill=" .. tostring(skill) .. ", krit=" .. tostring(krit) .. ", patz=" .. tostring(patz))
    if restSkill >= 0 and krit <= 1 and patz <= 1 then
        local taps = math.max(1, math.min(restSkill, skill))
        print("[TSDiceRoller] appendResult: SUCCESS branch (taps=" .. tostring(taps) .. ")")
        return response .. "Daher ist die Probe bestanden mit [b]" .. taps .. " TaP*[/b]"
    end

    if restSkill <= 0 and krit >1 then
        print("[TSDiceRoller] appendResult: CRITICAL SUCCESS branch")
        return response .. "[b]KRITISCHER ERFOLG[/b] mit [b]1 TaP* [/b](Aber eigentlich Misserfolg ¯\\_(ツ)_/¯)"
    end

    if patz > 1 then
        print("[TSDiceRoller] appendResult: BOTCH branch")
        if restSkill <= 0 then
            return response .. "[b]PATZER.[/b]\nNotwendige Erleichterung: " .. math.abs(restSkill)
        else
            return response .. "[b]PATZER.[/b]\n"
        end
    end

    if restSkill >= 0 and krit > 1 then
        local taps = math.max(1, math.min(restSkill, skill))
        print("[TSDiceRoller] appendResult: CRITICAL SUCCESS (restSkill positive) branch (taps=" .. tostring(taps) .. ")")
        return response .. "[b]KRITISCHER ERFOLG[/b] mit [b]" .. taps .. " TaP*[/b]"
    end

    print("[TSDiceRoller] appendResult: FAILURE branch")
    return response .. "Daher ist die Probe misslungen.\nNotwendige Erleichterung: " .. math.abs(restSkill)
end

-- Process a DSA skill check or attribute test
-- Handles both full skill checks (with 3 attributes + skill value) and simple checks
-- @param message: raw input message (e.g., "!12,14,13,8" for attributes and skill)
-- @param fromName: name of player making the check
-- @param dice: dice roller object for generating rolls
-- @return: response string with roll results and outcome
-- @return: boolean indicating message was processed
local function process(message, fromName, dice)
    print("[TSDiceRoller] DSA system process() called with message=" .. tostring(message) .. ", fromName=" .. tostring(fromName))
    
    local firstChar = input.safeSubstring(message, 1, 1)
    local content = input.safeSubstring(message, 2, 99)
    
    -- Parse parameters with trimming
    local parsedValues, validParse = input.parseCommand(content)
    
    -- Convert to numeric values with validation
    local values, allNumeric = input.extractNumericValues(parsedValues)
    
    local talentMod = false
    local simple = false
    local krit = 0
    local patz = 0
    local change = 0
    local response = ""
    if firstChar == "!" then
        local att1 = values[1]
        local att2 = values[2]
        local att3 = values[3]
        local atts = {att1, att2, att3}
        local skill = values[4] or 0
        
        -- Determine if this is a simple check (att3 == nil) or full check
        if att3 == nil then 
            simple = true 
            if att2 ~= nil then change = values[2] end
        elseif values[5] ~= nil then 
            change = values[5]            
            if change ~= 0 then talentMod = true end
        end
    print("[TSDiceRoller] DSA reporting\ntalentMod=" .. tostring(talentMod) .. "\nsimple=" .. tostring(simple) .. "\nchange=" .. tostring(change))
    print("[TSDiceRoller] DSA reporting\natt1=" .. tostring(att1) .. "\natt2=" .. tostring(att2) .. "\natt3=" .. tostring(att3) .. "\nskill=" .. tostring(skill))
        -- Roll 3d20
        local roll = dice.rollDice(3, 20)
        local roll1, roll2, roll3 = roll[1], roll[2], roll[3]
        krit, patz = countCritsAndPatz({roll1, roll2, roll3})
        
        if simple then
            response = response .. "[" .. roll1 .. "]\n"
            if roll1 == 1 or roll1 == 20 then response = response .. "Bestätigungswurf: [" .. roll2 .. "]\n" end
        else
            response = response .. "\nDie Würfe sind: [[b]" .. roll1 .. ", " .. roll2 .. ", " .. roll3 .. "[/b]]\n"
        end
        
        local restSkill = skill
        
        if simple ~= true and talentMod then
            -- Complex modification handling for talent modifications
            if change < 0 then
                change = math.abs(change)
                response = response .. "Probe [b]erleichtert[/b] um " .. change .. "\n"
                restSkill = restSkill + change
                restSkill = applyAttributes(restSkill, {roll1, roll2, roll3}, atts)
                response = appendResult(response, restSkill, skill, krit, patz)
            elseif change > 0 then
                change = math.abs(change)
                response = response .. "Probe [b]erschwert[/b] um " .. change .. "\n"
                restSkill = restSkill - change
                if restSkill < 0 then
                    -- Apply negative modification to attributes
                    att1 = att1 + restSkill
                    att2 = att2 + restSkill
                    att3 = att3 + restSkill
                    if roll1 <= att1 and roll2 <= att2 and roll3 <= att3 and krit <= 1 and patz <= 1 then
                        response = response .. "Daher ist die Probe bestanden mit [b]1 TaP*[/b]"
                    elseif roll1 <= att1 and roll2 <= att2 and roll3 <= att3 and krit > 1 then
                        response = response .. "[b]KRITISCHER ERFOLG mit [b] 1 TaP*[/b]"
                    else
                        restSkill = 0
                        if roll1 > att1 then restSkill = restSkill + (att1 - roll1) end
                        if roll2 > att2 then restSkill = restSkill + (att2 - roll2) end
                        if roll3 > att3 then restSkill = restSkill + (att3 - roll3) end
                        if restSkill < 0 and krit <= 1 and patz <= 1 then
                            response = response .. "Daher ist die Probe misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. math.abs(restSkill)
                        elseif restSkill < 0 and krit > 1 then
                            response = response .. "[b]KRITISCHER ERFOLG mit[/b] [b] 1 TaP* [/b](Aber eigentlich Misserfolg ¯\\_(ツ)_/¯)"
                        elseif restSkill < 0 and patz > 1 then
                            response = response .. "[b]PATZER.[/b] [b]\nNotwendige Erleichterung:  [/b]" .. math.abs(restSkill)
                        end
                    end
                else
                    restSkill = applyAttributes(restSkill, {roll1, roll2, roll3}, atts)
                    response = appendResult(response, restSkill, skill, krit, patz)
                end
            end
        elseif simple then
            -- Simple check logic (single attribute)
            if change ~= 0 then
                 response = "\n" .. response .. "Probe [b]" .. (change > 0 and "erschwert" or "erleichtert") .. "[/b] um " .. math.abs(change) .. "\n"
            end
            if (roll1 + change) > att1 then
                local erlei = (roll1 + change) - att1
                if roll1 == 20 then
                    if (roll2 + change) > att1 then response = response .. "PATZER. [b]\nNotwendige Erleichterung:  [/b]" .. erlei
                    else response = response .. "Misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. erlei end
                else response = response .. "Misslungen. [b]\nNotwendige Erleichterung:  [/b]" .. erlei end
            else
                local erschw = att1 - (roll1 + change)
                if roll1 == 1 then
                    if (roll2 + change) < att1 then response = response .. "KRITISCHER ERFOLG. [b]\nMaximale Erschwernis:  [/b]" .. erschw
                    else response = response .. "Bestanden. [b]\nMaximale Erschwernis:  [/b]" .. erschw end
                else response = response .. "Bestanden. [b]\nMaximale Erschwernis:  [/b]" .. erschw end
            end
        else
            -- Full skill check logic
            restSkill = applyAttributes(restSkill, {roll1, roll2, roll3}, atts)
            response = appendResult(response, restSkill, skill, krit, patz)
        end
        
        return response, true
    end
    
    return "", false
end

print("[TSDiceRoller] DSA module initialization complete")

local DSASystem = {
    _TYPE = 'module',
    _NAME = 'dsa',
    process = process,
    applyAttributes = applyAttributes,
    appendResult = appendResult,
    countCritsAndPatz = countCritsAndPatz,
}

return DSASystem

