-- Function to roll dice
print("[TSDiceRoller] Dice module loading - seeding random number generator")
math.randomseed(os.time())
local function rollDice(times, sides)
    print("[TSDiceRoller] rollDice() called with times=" .. tostring(times) .. ", sides=" .. tostring(sides))
    local results = {}
    local sum = 0
    for i = 1, times do
        local roll = math.random(1, sides)
        results[i] = roll
        sum = sum + roll
    end
    print("[TSDiceRoller] rollDice result: sum=" .. tostring(sum) .. ", values=[" .. table.concat(results, ",") .. "]")
    return results, sum
end

local function d4()
    print("[TSDiceRoller] d4() called")
    return rollDice(1,4)
end

local function d6()
    print("[TSDiceRoller] d6() called")
    return rollDice(1,6)
end

local function d8()
    print("[TSDiceRoller] d8() called")
    return rollDice(1,8)
end

local function d10()
    print("[TSDiceRoller] d10() called")
    return rollDice(1,10)
end

local function d12()
    print("[TSDiceRoller] d12() called")
    return rollDice(1,12)
end

local function d20()
    print("[TSDiceRoller] d20() called")
    return rollDice(1,20)
end

local function d100()
    print("[TSDiceRoller] d100() called")
    return rollDice(1,100)
end

local function averageTest(size,die)
    print("[TSDiceRoller] averageTest() called with size=" .. tostring(size) .. ", die=" .. tostring(die))
    local res,avg = rollDice(size,die)
    res = avg/size
    print("[TSDiceRoller] averageTest result: " .. tostring(res))
    return res
end

print("[TSDiceRoller] Dice module initialization complete")
local dice = {
    _TYPE = 'module',
    _NAME = 'dice',
    rollDice = rollDice,
    d4 = d4,
    d6 = d6,
    d8 = d8,
    d10 = d10,
    d12 = d12,
    d20 = d20,
    d100 = d100,
    averageTest = averageTest,
}

return dice
