-- Function to roll dice
math.randomseed(os.time())
local function rollDice(times, sides)	
	print("Hi1")
	local results = {}
	local sum = 0
	for i = 1, times do
		local roll = math.random(1, sides)
		results[i] = roll
		sum = sum + roll
		print("Hi2")
	end
	print("Hi3")
	return results, sum
end

local function d4()
	return rollDice(1,4)
end

local function d6()
	return rollDice(1,6)
end

local function d8()
	return rollDice(1,8)
end

local function d10()
	return rollDice(1,10)
end

local function d12()
	return rollDice(1,12)
end

local function d20()
	return rollDice(1,20)
end

local function d100()
	return rollDice(1,100)
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
};

return dice;