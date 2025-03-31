--- @class LevelSettings
--- Represents settings for a breakout level, including colors, background, music, and game-specific configurations.
--- @field name string The name of the level
--- @field colors table[] A list of colors for the level
--- @field background table[] The background(s) for the level
--- @field music string The music file for the level
--- @field ballSpeed number The ball speed
--- @field paddleSize Vector The size of the paddle
--- @field brickSize Vector The size of the generated bricks
--- @field brickPadding number The padding between the bricks
--- @field ballRadius number The radius of the ball
--- @field lives integer The amount of lives the user gets in this level
--- @field nextLevel LevelSettings? The next level in line
local LevelSettings = {}
LevelSettings.__index = LevelSettings -- Set the metatable's __index field to itself

--- Level settings
--- @param name string The name of the lebel
--- @param colors table[] A list of colors for the level
--- @param background table[] The background(s) for the level
--- @param music string The music file for the level
--- @param ballSpeed number The base ball speed
--- @param paddleSize Vector The size of the paddle
--- @param brickSize Vector The sice of the bricks
--- @param brickPadding number The padding between the bricks
--- @param ballRadius number The radius of the ball
--- @param lives integer The amount of lives in this level
--- @param nextLevel LevelSettings? The next level in line
function LevelSettings.new(name, colors, background, music, ballSpeed, paddleSize, brickSize, brickPadding, ballRadius,
                           lives, nextLevel)
    local self = setmetatable({}, LevelSettings)

    self.name = name
    self.colors = colors         -- Expecting a list of tables, each representing an RGB color.
    self.background = background -- Flexible table for background data (e.g., color list, image paths).
    self.music = music
    self.ballSpeed = ballSpeed
    self.paddleSize = paddleSize
    self.brickSize = brickSize
    self.brickPadding = brickPadding
    self.ballRadius = ballRadius
    self.lives = lives
    self.nextLevel = nextLevel -- Reference to the next level's settings. Truly next level guys.

    return self
end

return LevelSettings
