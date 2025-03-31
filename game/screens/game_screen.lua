Level = require("level")

--- @class GameScreen
--- Represents the game screen, which keeps track of and renders levels
--- @field nextLevelScreenFactory fun(LevelSettings, function)
--- @field gameOverScreenFactory fun(function)
--- @field startScreenFactory fun()
--- @field levelSettings LevelSettings
local GameScreen = {}
GameScreen.__index = GameScreen -- Set the metatable's __index field to itself

--- Create a level instance
--- @param levelSettings LevelSettings # The level to load
--- @param nextLevelScreenFactory fun(LevelSettings) # The function that constructs the next level screen
--- @param gameOverScreenFactory fun(function) # The function that constructs the game over screen
--- @param startScreenFactory fun() # The function that constructs the start screen
function GameScreen.new(levelSettings, nextLevelScreenFactory, gameOverScreenFactory, startScreenFactory)
    local self = setmetatable({}, GameScreen)

    self.nextLevelScreenFactory = nextLevelScreenFactory
    self.gameOverScreenFactory = gameOverScreenFactory
    self.startScreenFactory = startScreenFactory
    self.levelSettings = levelSettings

    return self
end

--- Allow the level to be preloaded
--- @param engine GameEngine The game engine
function GameScreen:load(engine)
    self.level = Level.new(engine, self.levelSettings)
end

--- When the screen is actually started
--- @param _ GameEngine The game engine
--- @param screenManager ScreenManager The screen to set
function GameScreen:start(_, screenManager)
    self.screenManager = screenManager
    self.level:start()
end

--- Draw the screen
--- @param engine GameEngine The game engine
function GameScreen:paint(engine)
    self.level:paint(engine)
end

--- Update the screen
--- @param engine GameEngine The game engine
function GameScreen:tick(engine)
    self.level:tick(engine)

    local state = self.level:getState()

    -- Load the next level on a win
    if state == "win" or engine:isKeyDown('P') then
        self.level.music:stop()
        self.level.music:tick()
        local nextScreen = self.nextLevelScreenFactory(self.levelSettings, self.startScreenFactory)
        self.screenManager:setScreen(engine, nextScreen)
    end

    if state == "loss" or engine:isKeyDown('K') then
        self.level.music:stop()
        self.level.music:tick()
        local gameOverScreen = self.gameOverScreenFactory(self.startScreenFactory)
        self.screenManager:setScreen(engine, gameOverScreen)
    end
end

return GameScreen
