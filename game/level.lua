Breakout = require("breakout/breakout")

--- @class Level
--- Represents a breakout level
--- @field settings LevelSettings The settings for the level
--- @field breakout Breakout The breakout game instance
--- @field music Audio The music object
--- @field colorIndex integer The current index for colors
--- @field backgroundIndex integer The current index for background items
--- @field sampleIndex integer The current index for beat samples
--- @field maxLives integer The maximum number of lives for the level
--- @field gameOver boolean Whether the game is over
local Level = {}
Level.__index = Level -- Set the metatable's __index field to itself

--- Create a level instance
--- @param engine GameEngine The game engine
--- @param settings LevelSettings The settings for the level
--- @return Level A new Level instance
function Level.new(engine, settings)
    local self = setmetatable({}, Level)

    print("Loading level")
    self.settings = settings
    self.colorIndex = 1
    self.backgroundIndex = 1
    self.sampleIndex = 0
    self.maxLives = self.settings.lives

    -- Leave space at the top for text (score etc)
    local area = Rectangle.new(Vector.new(0, 15), Vector.new(engine:getWidth(), engine:getHeight() - 15))
    self.breakout = Breakout.new(area, self.settings.paddleSize, self.settings.ballRadius, self.settings.ballSpeed,
        self.settings.brickSize, self.settings.brickPadding)

    print("Loading music")
    self.music = Audio.new(self.settings.music, true) -- Kevengine does not like wav files :(
    self.music:setVolume(50)
    self.music:setRepeat(true)
    return self
end

--- Start the level
function Level:start()
    self.music:play(0, -1)
    self.settings.lives = self.maxLives
end

--- Draw the level
--- @param engine GameEngine The game engine
function Level:paint(engine)
    if self.settings.background.type == "color" then
        engine:clear(
            self.settings.background.items[self.backgroundIndex].r,
            self.settings.background.items[self.backgroundIndex].g,
            self.settings.background.items[self.backgroundIndex].b)
    end

    engine:setColor(
        self.settings.colors[self.colorIndex].r,
        self.settings.colors[self.colorIndex].g,
        self.settings.colors[self.colorIndex].b
    )

    engine:drawString(self.settings.name, 20, 10)
    engine:drawString("Lives: " .. self.settings.lives, engine:getWidth() - 80, 10)
    self.breakout:paint(engine)
end

--- Update the level
--- @param engine GameEngine The game engine
function Level:tick(engine)
    self.music:tick()

    -- Check the beat
    if self.music:isPlaying() then
        local playbackTimeMs = self.music:getPlaybackPosition()

        if playbackTimeMs ~= -1 then
            -- Process beat samples that have occurred up to this playback time
            local sample = self.music:getDataByIndex(self.sampleIndex)
            while math.floor(sample.lastMs) < playbackTimeMs and self.sampleIndex < self.music:getDataSize() - 1 do
                if sample.wasTatum > 0 then
                    self.colorIndex = (self.colorIndex % #self.settings.colors) + 1

                    -- If items is not nil
                    if self.settings.background.items then
                        self.backgroundIndex = (self.backgroundIndex % #self.settings.background.items) + 1
                    end
                end

                self.sampleIndex = self.sampleIndex + 1
                sample = self.music:getDataByIndex(self.sampleIndex)
            end
        end
    else
        self.sampleIndex = 0
    end

    self.breakout:tick(engine)

    if self.breakout.died then
        self.settings.lives = self.settings.lives - 1
        if self.settings.lives < 0 then
            self.gameOver = true
        end
    end
end

--- Get the state of the level
--- @return string # String, can be "win", "loss" or "busy"
function Level:getState()
    if self.breakout:isCleared() then
        return "win"
    end

    if self.gameOver then
        return "loss"
    end

    return "busy"
end

return Level
