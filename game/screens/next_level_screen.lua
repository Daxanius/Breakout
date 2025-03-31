Utils = require("utils")
GameOverScreen = require("screens/game_over_screen")
WinScreen = require("screens/win_screen")
GameScreen = require("screens/game_screen")

--- @class NextLevelScreen
--- @field startScreenFactory function
--- @field level LevelSettings
--- @field whoosh Audio
local NextLevelScreen = {}
NextLevelScreen.__index = NextLevelScreen

--- Create a next level screen
--- @param levelSettings LevelSettings The settings for the levels
--- @param startScreenFactory fun() The start screen factory
function NextLevelScreen.new(levelSettings, startScreenFactory)
    local self = setmetatable({}, NextLevelScreen)

    self.startScreenFactory = startScreenFactory
    self.level = levelSettings
    self.whoosh = Audio.new("assets/sounds/whoosh.mp3", false)

    return self
end

--- When the screen is actually started
--- @param engine GameEngine The game engine
--- @param screenManager ScreenManager The screen to set
function NextLevelScreen:start(engine, screenManager)
    self.screenManager = screenManager

    if not self.level.nextLevel then
        self.screenManager:setScreen(engine, WinScreen.new(self.startScreenFactory))
        return
    end

    self.ticks = 0
    self.animationTicks = engine:getFrameRate() -- Anim takes some time
    self.totalTicks = engine:getFrameRate() * 2 -- Wait until for next screen thing

    self.whoosh:play(0, -1)
end

--- Draw the screen
--- @param engine GameEngine The game engine
function NextLevelScreen:paint(engine)
    engine:clear(0, 0, 0)
    engine:setColor(255, 255, 255)

    local ticks = math.min(self.ticks, self.animationTicks)
    local posX = Utils.easeOutBack(ticks, engine:getWidth(), -(engine:getWidth() / 2 + 45), self.animationTicks)
    engine:drawString("STAGE CLEAR", posX, (engine:getHeight() / 2) - 100)
end

--- Update the screen
--- @param engine GameEngine The game engine
function NextLevelScreen:tick(engine)
    self.whoosh:tick()

    self.ticks = self.ticks + 1

    if self.ticks > self.totalTicks then
        self.gameScreen = GameScreen.new(self.level.nextLevel, NextLevelScreen.new, GameOverScreen.new,
            self.startScreenFactory)
        self.gameScreen:load(engine)
        self.screenManager:setScreen(engine, self.gameScreen)
    end
end

return NextLevelScreen
