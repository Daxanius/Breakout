LevelSettings = require("level_settings")
local nextLevel = require("levels/level2")

local colors = {
    { r = 191, g = 255, b = 252 },
    { r = 65,  g = 254, b = 255 },
    { r = 255, g = 0,   b = 254 },
    { r = 238, g = 1,   b = 143 },
    { r = 62,  g = 19,  b = 64 },
}

local background = {
    type = "color",
    items = {
        { r = 62,  g = 19,  b = 64 },
        { r = 238, g = 1,   b = 143 },
        { r = 191, g = 255, b = 252 },
        { r = 65,  g = 254, b = 255 },
        { r = 191, g = 255, b = 252 },
    }
}

return LevelSettings.new(
    "Stage 1",
    colors,
    background,
    "assets/sounds/level_1_music.mp3",
    300,
    Vector.new(50, 10),
    Vector.new(45, 15),
    10,
    5,
    3,
    nextLevel
)
