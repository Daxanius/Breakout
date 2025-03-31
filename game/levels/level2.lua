LevelSettings = require("level_settings")
local nextLevel = require("levels/level3")

local colors = {
    { r = 3,   g = 7, b = 30 },
    { r = 55,  g = 6, b = 23 },
    { r = 106, g = 4, b = 15 },
    { r = 157, g = 2, b = 8 },
    { r = 208, g = 0, b = 0 },
}

local background = {
    type = "color",
    items = {
        { r = 220, g = 47,  b = 2 },
        { r = 232, g = 93,  b = 4 },
        { r = 244, g = 140, b = 6 },
        { r = 250, g = 163, b = 7 },
        { r = 255, g = 186, b = 8 },
    }
}

return LevelSettings.new(
    "Stage 2",
    colors,
    background,
    "assets/sounds/level_2_music.mp3",
    400,
    Vector.new(40, 10),
    Vector.new(40, 10),
    15,
    5,
    4,
    nextLevel
)
