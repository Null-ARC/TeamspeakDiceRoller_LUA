-- Testmodule initialisation for merged roller

print("[TSDiceRoller] Initialization started")

print("[TSDiceRoller] Loading ts3init module")
require("ts3init")            -- Required for ts3RegisterModule
print("[TSDiceRoller] ts3init loaded successfully")

print("[TSDiceRoller] Loading events module")
require("roller/events")  -- Forwarded TeamSpeak 3 callbacks
print("[TSDiceRoller] Events module loaded successfully")

print("[TSDiceRoller] Loading dice module")
require("roller/dice")  -- Dice Class
print("[TSDiceRoller] Dice module loaded successfully")

print("[TSDiceRoller] Loading colors module")
require("roller/colors")  -- Color Class
print("[TSDiceRoller] Colors module loaded successfully")

print("[TSDiceRoller] Loading dsa module")
require("roller/systems/dsa") -- DSA functions
print("[TSDiceRoller] DSA module loaded successfully")

local MODULE_NAME = "TeamspeakDiceRoller"
print("[TSDiceRoller] Module name set to: " .. tostring(MODULE_NAME))

print("[TSDiceRoller] Registering event handlers")
local registeredEvents = {
    onTextMessageEvent = roller_events.onTextMessageEvent,
}
print("[TSDiceRoller] Event handler registration table created")
print("[TSDiceRoller] Calling ts3RegisterModule with module name: " .. tostring(MODULE_NAME))

ts3RegisterModule(MODULE_NAME, registeredEvents)
print("[TSDiceRoller] Initialization completed successfully")
