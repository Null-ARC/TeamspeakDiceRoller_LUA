local input = require("roller/input")  -- Input sanitization module
print("[TSDiceRoller] CoC system module loading")

local function process(message, fromName, dice)
    print("[TSDiceRoller] CoC system process() called with message=" .. tostring(message) .. ", fromName=" .. tostring(fromName))
    local response = ""
    local firstChar = input.safeSubstring(message, 1, 1)
    print("[TSDiceRoller] CoC system: firstChar=" .. tostring(firstChar))
    
    if firstChar == "!" then
        print("[TSDiceRoller] CoC system: '!' (skill roll) detected")
        local content = input.safeSubstring(message, 2, 99)
        
        -- Parse and trim parameters
        local parsedValues, validParse = input.parseCommand(content)
        print("[TSDiceRoller] CoC system: parsed " .. tostring(#parsedValues) .. " values")
        
        -- Convert to numeric values
        local values, allNumeric = input.extractNumericValues(parsedValues)
        print("[TSDiceRoller] CoC system: extracted numeric values - count=" .. tostring(#values))
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
                    if roll == 10 then roll = 0 end
                    response = response .. roll .. "0"
                    if roll < bonus then bonus = roll end
                    if i < modifier then response = response .. ", " end
                end
                result = (bonus*10) + math.fmod(result,10)
                if result == 0 then result = 100 end
                response = response .. "\nEndergebnis: [b]" .. result .. "[/b]\n"
            else
                local malus = math.floor(result/10)
                modifier = math.abs(modifier)
                response = response .. " mit " .. modifier .. " Maluswürfeln:\n[b]" .. result .. "[/b] - Mali: "
                for i = 1, modifier do
                    local roll = dice.d10()[1]
                    if roll == 10 then roll = 0 end
                    response = response .. roll .. "0"
                    if roll > malus then malus = roll end
                    if i < modifier then response = response .. ", " end
                end
                result = (malus*10) + math.fmod(result,10)
                response = response .. "\nEndergebnis: [b]" .. result .. "[/b]\n"
            end
        else
            response = response .. "\n[b]" .. result .. "[/b]\n"
        end
        if result == 1 then
            print("[TSDiceRoller] CoC system: result=1 (CRITICAL SUCCESS)")
            response = response .. "[b]Kritischer Erfolg![/b]\n"
        elseif result == 100 or (result >= 96 and skill <50) then
            print("[TSDiceRoller] CoC system: result=" .. tostring(result) .. " (BOTCH)")
            response = response .. "[b]Patzer![/b]\n"
        elseif result <= (skill/5) then
            print("[TSDiceRoller] CoC system: result=" .. tostring(result) .. " (EXTREME SUCCESS)")
            response = response .. "[b]Extremer Erfolg![/b]\n"
        elseif result <= (skill/2) then
            print("[TSDiceRoller] CoC system: result=" .. tostring(result) .. " (HARD SUCCESS)")
            response = response .. "[b]Schwieriger Erfolg![/b]\n"
        elseif result <= skill then
            print("[TSDiceRoller] CoC system: result=" .. tostring(result) .. " (SUCCESS)")
            response = response .. "[b]Erfolg![/b]\n"
        else
            print("[TSDiceRoller] CoC system: result=" .. tostring(result) .. " (FAILURE)")
            response = response .. "[b]Misserfolg![/b]\n"
        end
        return response, true
    elseif firstChar == "?" then
        local content = input.safeSubstring(message, 2, 99)
        
        -- Parse and trim parameters
        local parsedValues, validParse = input.parseCommand(content)
        
        -- Convert to numeric values
        local values, allNumeric = input.extractNumericValues(parsedValues)
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
        local roll, result = dice.rollDice(number,die)
        if simple then
            response = response .. "[b]" .. roll[1] .. "[/b]"
        else
            for i = 1, number do
                response = response .. roll[i]
                if i < number then response = response .. " + " end
            end
            if values[3] ~= nil then
                local modifier = values[3]
                result = result + modifier
                if modifier >= 0 then response = response .. " + " .. modifier else response = response .. " - " .. math.abs(modifier) end
            end
            response = response .. " = [b]" .. result .. "[/b]"
        end
        return response, true
    end
    return "", false
end

local COCSystem = {
    _TYPE = 'module',
    _NAME = 'coc',
    process = process,
}

return COCSystem
