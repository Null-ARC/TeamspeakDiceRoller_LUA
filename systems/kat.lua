local input = require("roller/input")  -- Input sanitization module
print("[TSDiceRoller] KAT system module loading")

local function process(message, fromName, dice)
    print("[TSDiceRoller] KAT system process() called with message=" .. tostring(message) .. ", fromName=" .. tostring(fromName))
    local content = input.safeSubstring(message, 2, 99)
    print("[TSDiceRoller] KAT system: content=" .. tostring(content))
    
    -- Parse and trim parameters
    local parsedValues, validParse = input.parseCommand(content)
    print("[TSDiceRoller] KAT system: parsed " .. tostring(#parsedValues) .. " values")
    
    -- Convert to numeric values
    local values, allNumeric = input.extractNumericValues(parsedValues)
    print("[TSDiceRoller] KAT system: extracted " .. tostring(#values) .. " numeric values")
    
    local successes = 0
    local ones = 0
    local triggers = 0
    local botched = false
    local pool = values[1]
    print("[TSDiceRoller] KAT system: pool=" .. tostring(pool))
    local response = "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. pool .. "W6\n"
    local mod = values[2]
    if mod == nil then
    elseif mod >= 0 then
        response = response .. "+" .. mod .. "\n"
    else
        response = response .. mod .. "\n"
    end
    if pool > 12 then
        successes = (pool - 12)
        pool = 12
    end
    for i = 1, pool do
        local roll = dice.d6()[1]
        response = response .. roll
        if i < pool then response = response .. ", " end
        if roll >= 4 then successes = successes+1 end
        if roll == 6 then triggers = triggers+1 end
        if roll == 1 then ones = ones+1 end
    end
    if ones > successes then botched = true end
    if botched then
        print("[TSDiceRoller] KAT system: BOTCHED (ones=" .. tostring(ones) .. " > successes=" .. tostring(successes) .. ")")
        response = response .. "[b] \nPatzer![/b] \nErfolge: [b]" .. successes .. "[/b] \nTrigger: [b]" .. triggers .. "[/b]"
    else
        print("[TSDiceRoller] KAT system: normal completion (successes=" .. tostring(successes) .. ", triggers=" .. tostring(triggers) .. ")")
        response = response .. "\nErfolge: [b]" .. successes .. "[/b] \nTrigger: [b]" .. triggers .. "[/b]"
    end
    return response, true
end

local KATSystem = {
    _TYPE = 'module',
    _NAME = 'kat',
    process = process,
}

return KATSystem
