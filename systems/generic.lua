local input = require("roller/input")  -- Input sanitization module
print("[TSDiceRoller] Generic system module loading")

local function process(message, fromName, dice)
    print("[TSDiceRoller] Generic system process() called with message=" .. tostring(message) .. ", fromName=" .. tostring(fromName))
    local first = input.safeSubstring(message, 1, 1)
    local content = input.safeSubstring(message, 2, 99)
    print("[TSDiceRoller] Generic system: first=" .. tostring(first) .. ", content=" .. tostring(content))
    
    -- Parse and trim parameters  
    local parsedValues, validParse = input.parseCommand(content)
    print("[TSDiceRoller] Generic system: parsed " .. tostring(#parsedValues) .. " values")
    
    -- Convert to numeric values with proper error handling
    local values, allNumeric = input.extractNumericValues(parsedValues)
    print("[TSDiceRoller] Generic system: extracted " .. tostring(#values) .. " numeric values, allNumeric=" .. tostring(allNumeric))
    local response = ""
    if first == "!" then
        print("[TSDiceRoller] Generic system: '!' (XdY roll) detected")
        local number = 1
        local die = 1
        local simple = false
        local prefix = ""
        if values[2] ~= nil then
            number = values[1]
            die = values[2]
            print("[TSDiceRoller] Generic system: multi-roll mode - number=" .. tostring(number) .. ", die=" .. tostring(die))
        else
            die = values[1]
            simple = true
            print("[TSDiceRoller] Generic system: simple roll mode - die=" .. tostring(die))
        end
        response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. number .. "W" .. die .. "\n"
        local roll, result = dice.rollDice(number, die)
        if simple then
            response = response .. "[b]" .. roll[1] .. "[/b]"
        else
            for i = 1, number do
                response = response .. roll[i]
                if i < number then response = response .. " + " end
            end
            if values[3] ~= nil then
                local mod = values[3]
                result = result + mod
                if mod >= 0 then prefix = "+" end
                response = response .. " " .. prefix .. mod
            end
            response = response .. " = [b]" .. result .. "[/b]"
        end
        return response, true
    elseif first == "?" then
        local number = values[1]
        local die = values[2]
        local threshold = values[3]
        local successes = 0
        local ones = 0
        if threshold <= die and threshold >= 2 then
            response = response .. "\n[b]" .. fromName .. "[/b]" .. " würfelt " .. number .. "W" .. die .. "\n mit einer Erfolgsschwelle von " .. threshold .. "\n"
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
                if i < number then response = response .. ", " end
            end
            response = response .. "\n Erfolge: [b]" .. successes .. "[/b]\n Einsen: [b]" .. ones .. "[/b]"
        elseif threshold == 1 then
            response = response .. "\n[b]" .. fromName .. "[/b] macht [b]" .. number .. "[/b] Autoerfolge, das braucht man nicht würfeln!\n"
        else
            response = response .. "\nMan kann mit einem W" .. die .. " keine " .. threshold .. " erwürfeln!\n"
        end
        return response, true
    end
    return "", false
end

local GenericSystem = {
    _TYPE = 'module',
    _NAME = 'generic',
    process = process,
}

return GenericSystem
