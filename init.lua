--
-- Testmodule initialisation, this script is called via autoload mechanism when the
-- TeamSpeak 3 client starts.
--

require("ts3init")            -- Required for ts3RegisterModule
require("roller/events")  -- Forwarded TeamSpeak 3 callbacks
require("roller/dice")  -- Dice Class
require("roller/colors")  -- Color Class
require("roller/dsa") -- DSA functions

local MODULE_NAME = "TeamspeakDiceRoller"

-- Define which callbacks you want to receive in your module. Callbacks not mentioned
-- here will not be called. To avoid function name collisions, your callbacks should
-- be put into an own package.
local registeredEvents = {
	onTextMessageEvent = roller_events.onTextMessageEvent,
}

-- Register your callback functions with a unique module name.
ts3RegisterModule(MODULE_NAME, registeredEvents)
