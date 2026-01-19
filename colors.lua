local function specialUserColor(identifier, nickname)
	if identifier == "wBjkylbtGYAuCFrysq6xlVxNAI4=" or nickname == "Alick | Alex" then
		print("Gold")
		return "[color=#998811]"
	elseif identifier == "yFt2I8EVb8yUb5pGKJsKrGAYkGY=" then -- Null-ARC
		print("Blau")
		return "[color=#4848FF]"
		
	elseif identifier == "Iq7EpOG3uYOh50FnZLSD2Plmmlc=" or nickname == "Sir Kilmawa | Richard" then
		print("Grün")
		return "[color=#116611]"
		
	elseif identifier == "HigFMJk7fVRuTBuV84J6vG+Zhow=" or nickname == "Dr. Clean// Protheos | David" then
		print("Emperor's Children Lila")
		return "[color=#ff00ff]"
		
	elseif identifier == "2YVwwiIafvcpx8HCDN+V7sSm5k8=" then -- Engelsleiche
		print("Petrol")
		return "[color=#037c6e]"
		
	elseif nickname == "Basti" then
		print("Teal")
		return "[color=#025043]"
	else
		print("Default Color")
		return nil
	end
end

local colorMap = {
	gold   = "#998811",
	blue   = "#4848FF",
	blau   = "#4848FF",
	green  = "#116611",
	gruen  = "#116611",
	lila   = "#ff00ff",
	purple = "#ff00ff",
	petrol = "#037c6e",
	teal   = "#025043",
	white  = "#ffffff"
}

local userColors = {}

-- Setting a user color from either HEX code or preset name from colorMap
local function setUserColor(identifier, colorName)	
	print("colors.lua: Starting")
	if string.sub(colorName, 1, 1) == "#" then
		print("colors.lua input hex")
		local hexMatch = string.match(colorName:lower(), "^#?(%x%x%x%x%x%x)$")
		print("colors.lua: colorHex " .. hexMatch)
		if hexMatch then
			hex = "#" .. hexMatch:upper()
			print("colors.lua: Hex erkannt " .. hex)
			userColors[identifier] = hex
			return "[color=" .. hex .. "][b]Farbe gesetzt:[/b] " .. colorName
		end
	else 
		print("colors.lua input non hex")
		local hex = colorMap[colorName]
		if hex then
			print("colors.lua: Farbe gesetzt " .. colorName)
			userColors[identifier] = hex
			return "[color=" .. hex .. "] [b]Farbe gesetzt:[/b] " .. colorName
		else
			print("colors.lua: Unbekannte Farbe")
			return "[b]Unbekannte Farbe:[/b] " .. colorName
		end
	end
end

-- Returning either a set user color or logging to console that no user color is set.
local function getUserColor(uid, nickname)
	if userColors[uid] then
		print("Returning User Color " .. userColors[uid])
		return "[color=" .. userColors[uid] .. "]"
	elseif specialUserColor(uid, nickname) then
		print("Returning User Color " .. specialUserColor(uid, nickname))
		return specialUserColor(uid, nickname)
	else
		print("No set user color")
		return ""
	end	
end

local colors = {
	_TYPE = 'module',
	_NAME = 'colors',
	specialUserColor = specialUserColor,
	getUserColor = getUserColor,
	setUserColor = setUserColor,
};

return colors;