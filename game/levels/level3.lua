LevelSettings = require("level_settings")
local nextLevel = require("levels/level4")

local colors = {
    { r = 254, g = 215, b = 0 },
    { r = 33,  g = 176, b = 254 },
    { r = 254, g = 33,  b = 139 },
}

local background = {
    type = "color",
    items = {
        { r = 254, g = 33,  b = 139 },
        { r = 254, g = 215, b = 0 },
        { r = 33,  g = 176, b = 254 },
    }
}

return LevelSettings.new(
    "Stage 3",
    colors,
    background,
    "assets/sounds/level_3_music.mp3",
    500,
    Vector.new(30, 10),
    Vector.new(10, 10),
    20,
    5,
    10,
    nextLevel
)
