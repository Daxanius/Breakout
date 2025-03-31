--- @class GameOverScreen
--- @field startScreenFactory fun() The object responsible for creating a start screen
--- @field music Audio Music to play
--- @field textWidth number
--- @field textHeight number
local GameOverScreen = {}
GameOverScreen.__index = GameOverScreen

--- Create a game over screen
--- @param startScreenFactory fun() The function that constructs the start screen
function GameOverScreen.new(startScreenFactory)
    local self = setmetatable({}, GameOverScreen)

    self.startScreenFactory = startScreenFactory

    self.music = Audio.new("assets/sounds/game_over_music.mp3", false)
    self.music:setRepeat(true)

    -- DVD bounce parameters
    self.textPosX = 100
    self.textPosY = 100
    self.velX = 75
    self.velY = 75
    self.textWidth = 80
    self.textHeight = 20

    return self
end

--- When the screen is actually started
--- @param engine GameEngine The game engine
--- @param screenManager ScreenManager The screen to set
function GameOverScreen:start(engine, screenManager)
    self.screenManager = screenManager

    self.music:play(0, -1)
end

--- Draw the screen
--- @param engine GameEngine The game engine
function GameOverScreen:paint(engine)
    engine:clear(0, 0, 0)
    engine:setColor(255, 0, 0)

    -- Draw the bouncing text
    engine:drawString("GAME OVER", self.textPosX, self.textPosY)
end

--- Update the screen
--- @param engine GameEngine The game engine
function GameOverScreen:tick(engine)
    self.music:tick()

    local delta = 1.0 / engine:getFrameRate()

    -- Update text position
    self.textPosX = self.textPosX + self.velX * delta
    self.textPosY = self.textPosY + self.velY * delta

    -- Check for collisions with screen edges
    if self.textPosX <= 0 or self.textPosX + self.textWidth >= engine:getWidth() then
        self.velX = -self.velX -- Reverse horizontal direction
    end

    if self.textPosY <= 0 or self.textPosY + self.textHeight >= engine:getHeight() then
        self.velY = -self.velY -- Reverse vertical direction
    end

    -- Change the screen when the user presses space
    if engine:isKeyDown(' ') then
        self.music:stop()
        self.music:tick()

        local startScreen = self.startScreenFactory()
        self.screenManager:setScreen(engine, startScreen)
    end
end

return GameOverScreen
