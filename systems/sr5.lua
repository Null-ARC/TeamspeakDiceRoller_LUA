local input = require("roller/input")  -- Input sanitization module
print("[TSDiceRoller] SR5 system module loading")

local function process(message, fromName, dice)
    print("[TSDiceRoller] SR5 system process() called with message=" .. tostring(message) .. ", fromName=" .. tostring(fromName))
    local content = input.safeSubstring(message, 2, 99)
    print("[TSDiceRoller] SR5 system: content=" .. tostring(content))
    
    -- Parse and trim parameters
    local parsedValues, validParse = input.parseCommand(content)
    print("[TSDiceRoller] SR5 system: parsed " .. tostring(#parsedValues) .. " values")
    
    local values = {}
    local successes = 0
    local ones = 0
    local glitched = false
    local edge = false
    
    -- Process parsed values, checking for edge flag and numeric values
    for _, value in ipairs(parsedValues) do
        local trimmedValue = input.trim(value)
        if trimmedValue == "e" or trimmedValue == "E" then
            edge = true
            print("[TSDiceRoller] SR5 system: EDGE flag detected")
        else
            local numValue, isValid = input.validateNumericValue(trimmedValue)
            if isValid then
                table.insert(values, numValue)
            end
        end
    end
    local pool = values[1]
    local response = ""
    if edge ~= true then
        print("[TSDiceRoller] SR5 system: normal roll mode (no edge)")
        response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. pool .. "W6\n"
        for i = 1, pool do
            local roll = dice.d6()[1]
            response = response .. roll
            if i < pool then response = response .. ", " end
            if roll >= 5 then successes = successes+1 end
            if roll == 1 then ones = ones+1 end
        end
        if ones >= math.ceil(pool/2) then glitched = true end
        if glitched then
            print("[TSDiceRoller] SR5 system: GLITCHED (ones=" .. tostring(ones) .. ", threshold=" .. tostring(math.ceil(pool/2)) .. ")")
            response = response .. "[b] \nGLITCHED[/b] \nErfolge: [b]" .. successes .. "[/b]"
        else
            print("[TSDiceRoller] SR5 system: normal completion (successes=" .. tostring(successes) .. ")")
            response = response .. "\nErfolge: [b]" .. successes .. "[/b]"
        end
    else
        print("[TSDiceRoller] SR5 system: EDGE mode roll")
        response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. pool .. "W6 mit [b]Edge[/b]\n"
        local i = 1
        local diceToRoll = pool
        while i <= diceToRoll do
            local roll = dice.d6()[1]
            response = response .. roll
            if roll >= 5 then successes = successes+1 end
            if roll == 6 then diceToRoll = diceToRoll+1 end
            if i < diceToRoll then response = response .. ", " end
            if roll == 1 and i <= pool then ones = ones+1 end
            i = i+1
        end
        response = response .. "\n" .. diceToRoll-pool .. " Würfel explodiert"
        if ones >= math.ceil(pool/2) then glitched = true end
        if glitched then
            response = response .. "[b] \nGLITCHED[/b] \nErfolge: [b]" .. successes .. "[/b]"
        else
            response = response .. "\nErfolge:[b]" .. successes .. "[/b]"
        end
    end
    return response, true
end

local SR5System = {
    _TYPE = 'module',
    _NAME = 'sr5',
    process = process,
}

return SR5System
