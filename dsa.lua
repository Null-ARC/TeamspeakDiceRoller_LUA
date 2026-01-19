-- Used to count Critical Rolls for DSA
local function countCritsAndPatz(rolls)
	local krit, patz = 0, 0
	print("dsa.lua counting...")
	for _, r in ipairs(rolls) do
		print("In for " .. _ .. " " .. r)
		if r == 1 then krit = krit + 1 end
		if r == 20 then patz = patz + 1 end
	end
	print("dsa.lua krit: " .. krit .. " Patz: " .. patz) 
	return krit, patz
end

local function applyAttributes(restSkill, rolls, atts)
	for i = 1, 3 do
		if rolls[i] > atts[i] then
			restSkill = restSkill - (rolls[i] - atts[i])
		end
	end
	return restSkill
end

local function appendResult(response, restSkill, skill, krit, patz)
	if restSkill >= 0 and krit <= 1 and patz <= 1 then
		local taps = math.max(1, math.min(restSkill, skill))
		return response .. "Daher ist die Probe bestanden mit [b]" .. taps .. " TaP*[/b]"
	end

	if restSkill <= 0 and krit >1 then
		--taps = skill
		return response .. "[b]KRITISCHER ERFOLG[/b] mit [b]1 TaP* [/b](Aber eigentlich Misserfolg ¯\\_(ツ)_/¯)"
	end

	if patz > 1 then
		if restSkill <= 0 then
			return response .. "[b]PATZER.[/b]\nNotwendige Erleichterung: " .. math.abs(restSkill)
		else
			return response .. "[b]PATZER.[/b]\n"
		end
	end

	if restSkill >= 0 and krit > 1 then
		local taps = math.max(1, math.min(restSkill, skill))
		return response .. "[b]KRITISCHER ERFOLG[/b] mit [b]" .. taps .. " TaP*[/b]"
	end

	return response .. "Daher ist die Probe misslungen.\nNotwendige Erleichterung: " .. math.abs(restSkill)
end	

local dsa = {
	_TYPE = 'module',
	_NAME = 'dsa',
	rollDice = rollDice,
	d4 = d4,
	d6 = d6,
	d8 = d8,
	d10 = d10,
	d12 = d12,
	d20 = d20,
	d100 = d100,
	applyAttributes = applyAttributes,
	appendResult = appendResult,
	countCritsAndPatz = countCritsAndPatz,
};

return dsa;