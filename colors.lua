local function specialUserColor(identifier, nickname)
    print("[TSDiceRoller] specialUserColor() called with identifier=" .. tostring(identifier) .. ", nickname=" .. tostring(nickname))
    if identifier == "wBjkylbtGYAuCFrysq6xlVxNAI4=" or nickname == "Alick | Alex" then
        print("[TSDiceRoller] specialUserColor matched: Alick | Alex (gold)")
        return "[color=#998811]"
    elseif identifier == "yFt2I8EVb8yUb5pGKJsKrGAYkGY=" then -- Null-ARC
        print("[TSDiceRoller] specialUserColor matched: Null-ARC (blue)")
        return "[color=#4848FF]"
    elseif identifier == "Iq7EpOG3uYOh50FnZLSD2Plmmlc=" or nickname == "Sir Kilmawa | Richard" then
        print("[TSDiceRoller] specialUserColor matched: Sir Kilmawa | Richard (green)")
        return "[color=#116611]"
    elseif identifier == "HigFMJk7fVRuTBuV84J6vG+Zhow=" or nickname == "Dr. Clean// Protheos | David" then
        print("[TSDiceRoller] specialUserColor matched: Dr. Clean// Protheos | David (purple)")
        return "[color=#ff00ff]"
    elseif identifier == "2YVwwiIafvcpx8HCDN+V7sSm5k8=" then -- Engelsleiche
        print("[TSDiceRoller] specialUserColor matched: Engelsleiche (petrol)")
        return "[color=#037c6e]"
    elseif identifier == "oxtuWklz3+nHhcJ/b7GEim6nSss=" then -- Elli
        print("[TSDiceRoller] specialUserColor matched: Elli (violet)")
        return "[color=#8800ff]"
    elseif identifier == "wf75QK+Js6anWTt0nx2NQ/A27tQ=" then -- J4NU5
        print("[TSDiceRoller] specialUserColor matched: J4NU5 (red)")
        return "[color=#ff0000]"
    elseif identifier == "tAUPmNZeiIs8wG2xUCo5i0lWzKs=" or nickname == "Basti" then
        print("[TSDiceRoller] specialUserColor matched: Basti (teal)")
        return "[color=#025043]"
    else
        print("[TSDiceRoller] specialUserColor: no match found")
        return nil
    end
end

local colorMap = {
    -- Core/basic colors (English / German aliases)
    black     = "#000000",
    schwarz   = "#000000",

    white     = "#ffffff",
    weiss     = "#ffffff",

    red       = "#ff0000",
    rot       = "#ff0000",

    green     = "#116611", -- keep existing chosen green tone
    gruen     = "#116611",

    blue      = "#4848FF",
    blau      = "#4848FF",

    yellow    = "#FFFF00",
    gelb      = "#FFFF00",

    orange    = "#FFA500",

    pink      = "#FFC0CB",
    rosa      = "#FFC0CB",

    purple    = "#ff00ff",
    lila      = "#ff00ff",
    magenta   = "#ff00ff",

    violet    = "#8800ff",
    violett   = "#8800ff",

    brown     = "#A52A2A",
    braun     = "#A52A2A",

    beige     = "#F5F5DC",

    gray      = "#808080",
    grey      = "#808080",
    grau      = "#808080",

    silver    = "#C0C0C0",
    silber    = "#C0C0C0",

    cyan      = "#00FFFF",
    turkis    = "#40E0D0",
    turquoise  = "#40E0D0",

    teal      = "#025043",
    petrol    = "#037c6e",

    olive     = "#808000",
    oliv      = "#808000",

    navy      = "#000080",
    maroon    = "#800000",

    gold      = "#998811",

    -- Extended CSS-like named colors (sensible set)
    aliceblue            = "#F0F8FF",
    antiquewhite         = "#FAEBD7",
    aqua                 = "#00FFFF",
    aquamarine           = "#7FFFD4",
    azure                = "#F0FFFF",
    bisque               = "#FFE4C4",
    blanchedalmond       = "#FFEBCD",
    blueviolet           = "#8A2BE2",
    burlywood            = "#DEB887",
    cadetblue            = "#5F9EA0",
    chartreuse           = "#7FFF00",
    chocolate            = "#D2691E",
    coral                = "#FF7F50",
    cornflowerblue       = "#6495ED",
    cornsilk             = "#FFF8DC",
    crimson              = "#DC143C",
    darkblue             = "#00008B",
    darkcyan             = "#008B8B",
    darkgoldenrod        = "#B8860B",
    darkgray             = "#A9A9A9",
    darkgreen            = "#006400",
    darkgrey             = "#A9A9A9",
    darkkhaki            = "#BDB76B",
    darkmagenta          = "#8B008B",
    darkolivegreen       = "#556B2F",
    darkorange           = "#FF8C00",
    darkorchid           = "#9932CC",
    darkred              = "#8B0000",
    darksalmon           = "#E9967A",
    darkseagreen         = "#8FBC8F",
    darkslateblue        = "#483D8B",
    darkslategray        = "#2F4F4F",
    darkturquoise        = "#00CED1",
    darkviolet           = "#9400D3",
    deeppink             = "#FF1493",
    deepskyblue          = "#00BFFF",
    dimgray              = "#696969",
    dodgerblue           = "#1E90FF",
    firebrick            = "#B22222",
    floralwhite          = "#FFFAF0",
    forestgreen          = "#228B22",
    fuchsia              = "#FF00FF",
    gainsboro            = "#DCDCDC",
    ghostwhite           = "#F8F8FF",
    goldenrod            = "#DAA520",
    greenyellow          = "#ADFF2F",
    honeydew             = "#F0FFF0",
    hotpink              = "#FF69B4",
    indianred            = "#CD5C5C",
    indigo               = "#4B0082",
    ivory                = "#FFFFF0",
    khaki                = "#F0E68C",
    lavender             = "#E6E6FA",
    lavenderblush        = "#FFF0F5",
    lawngreen            = "#7CFC00",
    lemonchiffon         = "#FFFACD",
    lightblue            = "#ADD8E6",
    lightcoral           = "#F08080",
    lightcyan            = "#E0FFFF",
    lightgoldenrodyellow = "#FAFAD2",
    lightgray            = "#D3D3D3",
    lightgreen           = "#90EE90",
    lightgrey            = "#D3D3D3",
    lightpink            = "#FFB6C1",
    lightsalmon          = "#FFA07A",
    lightseagreen        = "#20B2AA",
    lightskyblue         = "#87CEFA",
    lightslategray       = "#778899",
    lightsteelblue       = "#B0C4DE",
    lime                 = "#00FF00",
    limegreen            = "#32CD32",
    linen                = "#FAF0E6",
    mediumaquamarine     = "#66CDAA",
    mediumblue           = "#0000CD",
    mediumorchid         = "#BA55D3",
    mediumpurple         = "#9370DB",
    mediumseagreen       = "#3CB371",
    mediumslateblue      = "#7B68EE",
    mediumspringgreen    = "#00FA9A",
    mediumturquoise      = "#48D1CC",
    mediumvioletred      = "#C71585",
    midnightblue         = "#191970",
    mintcream            = "#F5FFFA",
    mistyrose            = "#FFE4E1",
    moccasin             = "#FFE4B5",
    navajowhite          = "#FFDEAD",
    navyblue             = "#000080",
    oldlace              = "#FDF5E6",
    olivedrab            = "#6B8E23",
    orangered            = "#FF4500",
    orchid               = "#DA70D6",
    palegoldenrod        = "#EEE8AA",
    palegreen            = "#98FB98",
    paleturquoise        = "#AFEEEE",
    palevioletred        = "#DB7093",
    papayawhip           = "#FFEFD5",
    peachpuff            = "#FFDAB9",
    peru                 = "#CD853F",
    plum                 = "#DDA0DD",
    powderblue           = "#B0E0E6",
    rebeccapurple        = "#663399",
    rosybrown            = "#BC8F8F",
    royalblue            = "#4169E1",
    saddlebrown          = "#8B4513",
    salmon               = "#FA8072",
    sandybrown           = "#F4A460",
    seagreen             = "#2E8B57",
    seashell             = "#FFF5EE",
    sienna               = "#A0522D",
    skyblue              = "#87CEEB",
    slateblue            = "#6A5ACD",
    slategray            = "#708090",
    snow                 = "#FFFAFA",
    springgreen          = "#00FF7F",
    steelblue            = "#4682B4",
    tan                  = "#D2B48C",
    thistle              = "#D8BFD8",
    tomato               = "#FF6347",
    turquoise            = "#40E0D0",
    violetcss            = "#EE82EE",
    wheat                = "#F5DEB3",
    whitesmoke           = "#F5F5F5",
    yellowgreen          = "#9ACD32",

    -- German aliases for some extended/common names
    hellblau    = "#ADD8E6", -- lightblue
    dunkelblau  = "#00008B", -- darkblue
    hellgruen   = "#90EE90", -- lightgreen
    dunkelgruen = "#006400", -- darkgreen
    hellgrau    = "#D3D3D3", -- lightgray
    dunkelgrau  = "#696969", -- dimgray

    -- Keep existing special shades mapping if present
    bordeaux    = "#53292a",
}

local userColors = {}

local function setUserColor(identifier, colorName)
    print("[TSDiceRoller] setUserColor() called with identifier=" .. tostring(identifier) .. ", colorName=" .. tostring(colorName))
    if colorName == nil then 
        print("[TSDiceRoller] setUserColor ERROR: colorName is nil")
        return "[b]Unbekannte Farbe:[/b] nil" 
    end
    if string.sub(colorName, 1, 1) == "#" then
        print("[TSDiceRoller] setUserColor: hex color format detected")
        local hexMatch = string.match(colorName:lower(), "^#?(%x%x%x%x%x%x)$")
        if hexMatch then
            local hex = "#" .. hexMatch:upper()
            userColors[identifier] = hex
            print("[TSDiceRoller] setUserColor: hex color set to " .. tostring(hex))
            return "[color=" .. hex .. "][b]Farbe gesetzt:[/b] " .. colorName
        else
            print("[TSDiceRoller] setUserColor ERROR: invalid hex format")
        end
    else
        print("[TSDiceRoller] setUserColor: named color format detected")
        local hex = colorMap[colorName]
        if hex then
            userColors[identifier] = hex
            print("[TSDiceRoller] setUserColor: named color set to " .. tostring(hex))
            return "[color=" .. hex .. "] [b]Farbe gesetzt:[/b] " .. colorName
        else
            print("[TSDiceRoller] setUserColor ERROR: unknown color name " .. tostring(colorName))
            return "[b]Unbekannte Farbe:[/b] " .. colorName
        end
    end
end

local function getUserColor(uid, nickname)
    print("[TSDiceRoller] getUserColor() called with uid=" .. tostring(uid) .. ", nickname=" .. tostring(nickname))
    if userColors[uid] then
        print("[TSDiceRoller] getUserColor: found custom user color")
        return "[color=" .. userColors[uid] .. "]"
    elseif specialUserColor(uid, nickname) then
        print("[TSDiceRoller] getUserColor: found special user color")
        return specialUserColor(uid, nickname)
    else
        print("[TSDiceRoller] getUserColor: no color defined")
        return ""
    end
end

local colors = {
    _TYPE = 'module',
    _NAME = 'colors',
    specialUserColor = specialUserColor,
    getUserColor = getUserColor,
    setUserColor = setUserColor,
}

return colors
