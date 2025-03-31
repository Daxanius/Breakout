Utils = require("utils")
GameScreen = require("screens/game_screen")
NextLevelScreen = require("screens/next_level_screen")
GameOverScreen = require("screens/game_over_screen")
level1 = require("levels/level1")

--- @class StartScreen
--- @field music Audio
--- @field textWidth number
--- @field textHeight number
local StartScreen = {}
StartScreen.__index = StartScreen

--- Create a start screen
function StartScreen.new()
    local self = setmetatable({}, StartScreen)

    self.music = Audio.new("assets/sounds/start_music.mp3", false)
    self.music:setVolume(50)
    self.music:setRepeat(true)

    -- DVD bounce parameters
    self.textPosX = 100
    self.textPosY = 100
    self.velX = 50
    self.velY = 50
    self.textWidth = 150
    self.textHeight = 20

    -- Color settings
    self.color = {
        r = 255,
        g = 255,
        b = 255
    }

    self.background = {
        r = 0,
        g = 0,
        b = 0
    }

    return self
end

--- When the screen is actually started
--- @param engine GameEngine The game engine
--- @param screenManager ScreenManager The screen to set
function StartScreen:start(engine, screenManager)
    self.screenManager = screenManager

    self.music:play(0, -1)

    -- Preload the game screen
    self.gameScreen = GameScreen.new(Utils.deepCopy(level1), NextLevelScreen.new, GameOverScreen.new, StartScreen.new)
    self.gameScreen:load(engine)
end

--- Draw the screen
--- @param engine GameEngine The game engine
function StartScreen:paint(engine)
    engine:clear(self.background.r, self.background.g, self.background.b)
    engine:setColor(self.color.r, self.color.g, self.color.b)

    -- Draw the bouncing text
    engine:drawString("Breakout - Press Space", self.textPosX, self.textPosY)
end

--- Update the screen
--- @param engine GameEngine The game engine
function StartScreen:tick(engine)
    self.music:tick()

    local delta = 1.0 / engine:getFrameRate()

    -- Update text position
    local bounced = false
    self.textPosX = self.textPosX + self.velX * delta
    self.textPosY = self.textPosY + self.velY * delta

    -- Check for collisions with screen edges
    if self.textPosX <= 0 or self.textPosX + self.textWidth >= engine:getWidth() then
        self.velX = -self.velX -- Reverse horizontal direction
        bounced = true
    end

    if self.textPosY <= 0 or self.textPosY + self.textHeight >= engine:getHeight() then
        self.velY = -self.velY -- Reverse vertical direction
        bounced = true
    end

    -- Change color on bounce
    if bounced then
        local color = self.color
        self.color = self.background
        self.background = color
    end

    -- Change the screen when the user presses space
    if engine:isKeyDown(' ') then
        self.music:stop()
        self.music:tick()
        self.screenManager:setScreen(engine, self.gameScreen)
    end
end

return StartScreen
