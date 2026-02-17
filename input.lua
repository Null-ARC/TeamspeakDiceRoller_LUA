-- Input Sanitization and Validation Module
print("[TSDiceRoller] Input module loading")
-- Provides robust input handling for user commands with comprehensive error tolerance

-- Trim leading and trailing whitespace from a string
-- @param str: input string
-- @return: trimmed string
local function trim(str)
    if not str or str == "" then return "" end
    local result = str:match("^%s*(.-)%s*$")
    return result
end

-- Normalize input by trimming and collapsing multiple spaces into single spaces
-- Handles leading/trailing whitespace and converts to consistent format
-- @param str: input string
-- @param toLower: optional boolean to convert to lowercase (default: false)
-- @return: normalized string
local function normalize(str, toLower)
    if not str or str == "" then return "" end
    
    -- Trim leading and trailing whitespace
    str = trim(str)
    
    -- Collapse multiple consecutive spaces into single spaces
    str = str:gsub("%s+", " ")
    
    -- Optionally convert to lowercase for case-insensitive matching
    if toLower then
        str = str:lower()
    end
    
    return str
end

-- Validate that input is not empty or only whitespace
-- @param str: input string
-- @return: boolean indicating if input is valid
-- @return: error message if invalid
local function validateInput(str)
    print("[TSDiceRoller] validateInput() called with input: " .. tostring(str))
    if not str then
        print("[TSDiceRoller] validateInput ERROR: Input is nil")
        return false, "Input is nil"
    end
    
    if str == "" then
        print("[TSDiceRoller] validateInput ERROR: Input is empty")
        return false, "Input is empty"
    end
    
    if trim(str) == "" then
        print("[TSDiceRoller] validateInput ERROR: Input contains only whitespace")
        return false, "Input contains only whitespace"
    end
    
    print("[TSDiceRoller] validateInput SUCCESS: Input is valid")
    return true, nil
end

-- Safely convert string value to number with validation
-- @param value: string value to convert
-- @param defaultValue: optional default value if conversion fails
-- @return: number or default value, boolean indicating success
local function validateNumericValue(value, defaultValue)
    if not value then
        print("[TSDiceRoller] validateNumericValue: value is nil, using default=" .. tostring(defaultValue or 0))
        return defaultValue or 0, false
    end
    
    -- Trim the value before converting
    value = trim(tostring(value))
    print("[TSDiceRoller] validateNumericValue() called with value: " .. tostring(value))
    
    if value == "" then
        print("[TSDiceRoller] validateNumericValue ERROR: value is empty after trim")
        return defaultValue or 0, false
    end
    
    local num = tonumber(value)
    if num == nil then
        print("[TSDiceRoller] validateNumericValue ERROR: tonumber() returned nil")
        return defaultValue or 0, false
    end
    
    print("[TSDiceRoller] validateNumericValue SUCCESS: converted to " .. tostring(num))
    return num, true
end

-- Parse command with parameters, handling variable spacing
-- Splits input by comma and returns trimmed components
-- @param message: input message (e.g., "!2,6,3" or "! 2, 6, 3")
-- @return: table of parsed values (all trimmed)
-- @return: boolean indicating if all values are valid
local function parseCommand(message)
    if not message or message == "" then
        print("[TSDiceRoller] parseCommand: message is empty or nil")
        return {}, false
    end
    local message = message:match("^[^#]*")
    print("[TSDiceRoller] parseCommand() called with message: " .. tostring(message))
    local values = {}
    local allValid = true
    
    -- Split by comma and trim each value
    for value in message:gmatch("([^,]+)") do
        local trimmedValue = trim(value)
        
        if trimmedValue == "" then
            allValid = false
            print("[TSDiceRoller] parseCommand: found empty value after trim")
        else
            table.insert(values, trimmedValue)
            print("[TSDiceRoller] parseCommand: parsed value " .. tostring(#values) .. " = " .. tostring(trimmedValue))
        end
    end
    
    local isValid = allValid and #values > 0
    print("[TSDiceRoller] parseCommand result: count=" .. tostring(#values) .. ", allValid=" .. tostring(isValid))
    return values, isValid
end

-- Extract numeric values from parsed command
-- @param parsedValues: table of string values from parseCommand
-- @param minValues: optional minimum number of expected values
-- @param maxValues: optional maximum number of expected values
-- @return: table of numeric values
-- @return: boolean indicating if all values converted successfully
-- @return: error message if validation failed
local function extractNumericValues(parsedValues, minValues, maxValues)
    if not parsedValues or #parsedValues == 0 then
        print("[TSDiceRoller] extractNumericValues ERROR: No values provided")
        return {}, false, "No values provided"
    end
    
    print("[TSDiceRoller] extractNumericValues() called with " .. tostring(#parsedValues) .. " values")
    
    if minValues and #parsedValues < minValues then
        print("[TSDiceRoller] extractNumericValues ERROR: Insufficient parameters")
        return {}, false, "Insufficient parameters (expected at least " .. minValues .. ")"
    end
    
    if maxValues and #parsedValues > maxValues then
        print("[TSDiceRoller] extractNumericValues ERROR: Too many parameters")
        return {}, false, "Too many parameters (expected at most " .. maxValues .. ")"
    end
    
    local numericValues = {}
    local allValid = true
    
    for i, value in ipairs(parsedValues) do
        local num, isValid = validateNumericValue(value)
        
        if not isValid then
            allValid = false
            print("[TSDiceRoller] extractNumericValues: value " .. tostring(i) .. " conversion failed")
        else
            print("[TSDiceRoller] extractNumericValues: value " .. tostring(i) .. " = " .. tostring(num))
        end
        
        table.insert(numericValues, num)
    end
    
    print("[TSDiceRoller] extractNumericValues result: allValid=" .. tostring(allValid))
    return numericValues, allValid, nil
end

-- Check if a command matches a target (case-insensitive)
-- @param command: the command to check
-- @param target: the target to match against
-- @return: boolean indicating match
local function commandMatches(command, target)
    if not command or not target then
        print("[TSDiceRoller] commandMatches: command or target is nil")
        return false
    end
    
    local normCmd = normalize(command, true)
    local normTarget = normalize(target, true)
    local result = normCmd == normTarget
    print("[TSDiceRoller] commandMatches: " .. tostring(normCmd) .. " == " .. tostring(normTarget) .. " = " .. tostring(result))
    return result
end

-- Check if a command matches any of the targets (case-insensitive)
-- @param command: the command to check
-- @param targets: table of targets to match against
-- @return: boolean indicating if any target matched
local function commandMatchesAny(command, targets)
    if not command or not targets then
        print("[TSDiceRoller] commandMatchesAny: command or targets is nil")
        return false
    end
    
    local normalizedCommand = normalize(command, true)
    print("[TSDiceRoller] commandMatchesAny checking command: " .. tostring(normalizedCommand))
    
    for i, target in ipairs(targets) do
        local normalized = normalize(target, true)
        local match = normalizedCommand == normalized
        print("[TSDiceRoller] commandMatchesAny: target " .. tostring(i) .. " (" .. tostring(normalized) .. ") = " .. tostring(match))
        if match then
            print("[TSDiceRoller] commandMatchesAny MATCH FOUND")
            return true
        end
    end
    
    print("[TSDiceRoller] commandMatchesAny NO MATCH")
    return false
end

-- Safe substring extraction with bounds checking
-- @param str: input string
-- @param startPos: starting position
-- @param endPos: optional ending position
-- @return: substring or empty string if out of bounds
local function safeSubstring(str, startPos, endPos)
    if not str or str == "" then
        return ""
    end
    
    local len = #str
    
    if startPos < 1 or startPos > len then
        print("[TSDiceRoller] safeSubstring: startPos out of bounds")
        return ""
    end
    
    if endPos and endPos > len then
        endPos = len
    end
    
    local result = string.sub(str, startPos, endPos or len)
    print("[TSDiceRoller] safeSubstring(str, " .. tostring(startPos) .. ", " .. tostring(endPos) .. ") = " .. tostring(result))
    return result
end

-- Extract first character and rest of string safely
-- @param str: input string
-- @return: first character or empty string, rest of string or empty string
local function splitFirstChar(str)
    if not str or str == "" then
        return "", ""
    end
    
    if #str == 1 then
        return str, ""
    end
    
    return string.sub(str, 1, 1), string.sub(str, 2)
end

-- Extract pattern with case-insensitive matching and safe trimming
-- @param str: input string
-- @param pattern: Lua pattern to match
-- @return: table of capture groups (all trimmed) or nil if no match
local function matchPattern(str, pattern)
    if not str or not pattern then
        print("[TSDiceRoller] matchPattern: str or pattern is nil")
        return nil
    end
    
    print("[TSDiceRoller] matchPattern() called with str=" .. tostring(str) .. ", pattern=" .. tostring(pattern))
    local results = {}
    
    -- Use string.match to properly extract all capture groups
    local match1, match2, match3, match4, match5 = str:match(pattern)
    
    if match1 then
        table.insert(results, trim(match1))
        print("[TSDiceRoller] matchPattern: captured " .. tostring(trim(match1)))
    end
    
    if match2 then
        table.insert(results, trim(match2))
        print("[TSDiceRoller] matchPattern: captured " .. tostring(trim(match2)))
    end
    
    if match3 then
        table.insert(results, trim(match3))
        print("[TSDiceRoller] matchPattern: captured " .. tostring(trim(match3)))
    end
    
    if match4 then
        table.insert(results, trim(match4))
        print("[TSDiceRoller] matchPattern: captured " .. tostring(trim(match4)))
    end
    
    if match5 then
        table.insert(results, trim(match5))
        print("[TSDiceRoller] matchPattern: captured " .. tostring(trim(match5)))
    end
    
    if #results > 0 then
        print("[TSDiceRoller] matchPattern SUCCESS: " .. tostring(#results) .. " captures")
        return results
    else
        print("[TSDiceRoller] matchPattern: no matches found")
        return nil
    end
end

print("[TSDiceRoller] Input module initialization complete")

local Input = {
    _TYPE = 'module',
    _NAME = 'input',
    trim = trim,
    normalize = normalize,
    validateInput = validateInput,
    validateNumericValue = validateNumericValue,
    parseCommand = parseCommand,
    extractNumericValues = extractNumericValues,
    commandMatches = commandMatches,
    commandMatchesAny = commandMatchesAny,
    safeSubstring = safeSubstring,
    splitFirstChar = splitFirstChar,
    matchPattern = matchPattern,
}

return Input

