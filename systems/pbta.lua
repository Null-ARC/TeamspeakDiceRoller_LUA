local input = require("roller/input")  -- Input sanitization module
print("[TSDiceRoller] Powered by the Apocalypse system module loading")

local function process(message, fromName, dice)
    print("[TSDiceRoller] PBTA system process() called with message=" .. tostring(message) .. ", fromName=" .. tostring(fromName))
    local content = input.safeSubstring(message, 2, 99)
    print("[TSDiceRoller] PBTA system: content=" .. tostring(content))
    
    -- Parse and trim parameters
    local parsedValues, validParse = input.parseCommand(content)
    print("[TSDiceRoller] PBTA system: parsed " .. tostring(#parsedValues) .. " values")
    
    -- Convert to numeric values with default of 0 for modifier
    local values, allNumeric = input.extractNumericValues(parsedValues)
    print("[TSDiceRoller] PBTA system: extracted " .. tostring(#values) .. " numeric values")
    
    local mod = values[1] or 0
    print("[TSDiceRoller] PBTA system: modifier=" .. tostring(mod))
    local rolls = dice.rollDice(2, 6)
    print("[TSDiceRoller] PBTA system: 2d6 rolled = [" .. table.concat(rolls, ",") .. "]")
    local result = rolls[1] + rolls[2] + mod
    print("[TSDiceRoller] PBTA system: result = " .. tostring(result))
    local prefix = ""
    if mod >= 0 then prefix = "+" end
    local response = "\n[b]" .. fromName .. "[/b] würfelt 2W6 " .. prefix .. mod .. "\n([b]" .. rolls[1] .. "[/b]) + ([b]" .. rolls[2] .. "[/b]) " .. prefix .. mod .. " = [b]" .. result .. "[/b]\n"
    if result >= 10 then
        print("[TSDiceRoller] PBTA system: FULL SUCCESS (result=" .. tostring(result) .. ")")
        response = response .. "[b]Voller Erfolg![/b]"
    elseif result >= 7 then
        print("[TSDiceRoller] PBTA system: PARTIAL SUCCESS (result=" .. tostring(result) .. ")")
        response = response .. "[b]Teilerfolg![/b]"
    else
        print("[TSDiceRoller] PBTA system: FAILURE (result=" .. tostring(result) .. ")")
        response = response .. "[b]Fehlschlag![/b]"
    end
    return response, true
end

local PBTASystem = {
    _TYPE = 'module',
    _NAME = 'pbta',
    process = process,
}

return PBTASystem
