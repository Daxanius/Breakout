LevelSettings = require("level_settings")

local colors = {
    { r = 10, g = 36,  b = 99 },
    { r = 62, g = 146, b = 204 },
}

local background = {
    type = "color",
    items = {
        { r = 216, g = 49,  b = 91 },
        { r = 255, g = 250, b = 255 },
    }
}

return LevelSettings.new(
    "Boss Stage",
    colors,
    background,
    "assets/sounds/boss_music.mp3",
    600,
    Vector.new(30, 10),
    Vector.new(5, 5),
    15,
    5,
    15,
    nil
)
