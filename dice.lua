-- Function to roll dice
math.randomseed(os.time())
local function rollDice(times, sides)
	local results = {}
	local sum = 0
	for i = 1, times do
		local roll = math.random(1, sides)
		results[i] = roll
		sum = sum + roll
	end
	return results, sum
end

-- Rolls a D4
local function d4()
	return rollDice(1,4)
end

-- Rolls a D6
local function d6()
	return rollDice(1,6)
end

-- Rolls a D8
local function d8()
	return rollDice(1,8)
end

-- Rolls a D10
local function d10()
	return rollDice(1,10)
end

-- Rolls a D12
local function d12()
	return rollDice(1,12)
end

-- Rolls a D20
local function d20()
	return rollDice(1,20)
end

-- Rolls a D100
local function d100()
	return rollDice(1,100)
end

-- Tests a dice for statistical anomalies
local function averageTest(size,die)
	local res,avg = rollDice(size,die)
	res = avg/size
	return res
end

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
};

return dice;