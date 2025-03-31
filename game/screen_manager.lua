--- @class ScreenManager
--- Manages game screens, allowing for transitions and updates between different screens.
--- @field parent ScreenManager|nil The parent screen manager, if any
local ScreenManager = {}
ScreenManager.__index = ScreenManager -- Set the metatable's __index field to itself

--- Create a level instance
function ScreenManager.new()
    local self = setmetatable({}, ScreenManager)
    return self
end

--- Set a different screen as the active screen
--- @param engine GameEngine The game engine
--- @param screen table The screen to set
function ScreenManager:setScreen(engine, screen)
    self._screen = screen
    self._screen:start(engine, self) -- Provide self to screen
end

--- Start the screen manager, optionally as a child of another screen manager
--- @param engine GameEngine The game engine
--- @param screenManager ScreenManager|nil The parent screen manager (optional)
function ScreenManager:start(engine, screenManager)
    self.parent = screenManager
end

--- Draw the current active screen
--- @param engine GameEngine The game engine
function ScreenManager:paint(engine)
    if self._screen then
        self._screen:paint(engine)
    end
end

--- Update the current active screen
--- @param engine GameEngine The game engine
function ScreenManager:tick(engine)
    if self._screen then
        self._screen:tick(engine) -- Provide self in tick for set screen
    end
end

return ScreenManager
