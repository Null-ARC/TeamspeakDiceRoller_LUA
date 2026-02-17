local input = require("roller/input")  -- Input sanitization module
print("[TSDiceRoller] Blades in the Dark system module loading")

local function process(message, fromName, dice)
    print("[TSDiceRoller] BITD system process() called with message=" .. tostring(message) .. ", fromName=" .. tostring(fromName))
    local content = input.safeSubstring(message, 2, 99)
    print("[TSDiceRoller] BITD system: content=" .. tostring(content))
    
    -- Parse and trim parameters
    local parsedValues, validParse = input.parseCommand(content)
    print("[TSDiceRoller] BITD system: parsed " .. tostring(#parsedValues) .. " values")
    
    -- Convert to numeric values
    local values, allNumeric = input.extractNumericValues(parsedValues)
    print("[TSDiceRoller] BITD system: extracted " .. tostring(#values) .. " numeric values")
    
    local result = 1
    local sixes = 0
    local notzero = true
    local pool = values[1]
    print("[TSDiceRoller] BITD system: pool=" .. tostring(pool))
    if pool == 0 then
        print("[TSDiceRoller] BITD system: pool is 0, setting special mode")
        notzero = false
        pool = 2
        result = 6
    end
    local response = "\n[b]" .. fromName .. "[/b] würfelt " .. pool .. "W6\n"
    for i = 1, pool do
        local roll = dice.d6()[1]
        if roll > result and notzero then
            result = roll
        elseif roll < result and notzero == false then
            result = roll
        end
        if roll == 6 then
            sixes = sixes +1
            response = response .. "[b]"
        else
            -- nothing
        end
        response = response .. roll
        if roll == 6 then response = response .. "[/b]" end
        if i < pool then response = response .. ", " end
    end
    response = response .. " => [b]" .. result .. "[/b]\n"
    if sixes >= 2 and notzero then
        print("[TSDiceRoller] BITD system: CRITICAL SUCCESS (sixes=" .. tostring(sixes) .. ")")
        response = response .. "[b]Kritischer Erfolg![/b] (" .. sixes .. ")"
    elseif result == 6 then
        print("[TSDiceRoller] BITD system: FULL SUCCESS")
        response = response .. "[b]Voller Erfolg![/b]"
    elseif result >= 4 then
        print("[TSDiceRoller] BITD system: PARTIAL SUCCESS")
        response = response .. "[b]Teilerfolg![/b]"
    else
        print("[TSDiceRoller] BITD system: FAILURE")
        response = response .. "[b]Fehlschlag![/b]"
    end
    return response, true
end

local BITDSystem = {
    _TYPE = 'module',
    _NAME = 'bitd',
    process = process,
}

return BITDSystem
