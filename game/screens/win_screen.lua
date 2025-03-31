Utils = require("utils")

--- @class WinScreen
--- @field startScreenFactory fun()
--- @field victory Audio
local WinScreen = {}
WinScreen.__index = WinScreen

--- Create a next level screen
--- @param startScreenFactory fun() # The start screen factory
function WinScreen.new(startScreenFactory)
    local self = setmetatable({}, WinScreen)

    self.startScreenFactory = startScreenFactory

    self.victory = Audio.new("assets/sounds/victory.mp3", false)

    return self
end

--- When the screen is actually started
--- @param engine GameEngine The game engine
--- @param screenManager ScreenManager The screen to set
function WinScreen:start(engine, screenManager)
    self.screenManager = screenManager

    self.ticks = 0
    self.animationTicks = engine:getFrameRate() -- Anim takes some time
    self.totalTicks = engine:getFrameRate() * 4 -- Wait before reset

    self.victory:play(0, -1)
end

--- Draw the screen
--- @param engine GameEngine The game engine
function WinScreen:paint(engine)
    engine:clear(0, 0, 0)
    engine:setColor(255, 255, 255)

    local ticks = math.min(self.ticks, self.animationTicks)
    local posY = Utils.easeOutBack(ticks, 0, engine:getHeight() / 2 - 100, self.animationTicks)
    engine:drawString("VICTORY", engine:getWidth() / 2 - 30, posY)
end

--- Update the screen
--- @param engine GameEngine The game engine
function WinScreen:tick(engine)
    self.victory:tick()

    self.ticks = self.ticks + 1

    if self.ticks > self.totalTicks then
        local startScreen = self.startScreenFactory()
        self.screenManager:setScreen(engine, startScreen)
    end
end

return WinScreen
