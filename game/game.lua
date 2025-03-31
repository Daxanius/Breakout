ScreenManager = require("screen_manager")
StartScreen = require("screens/start_screen")

-- Screen manager... managing things.. such as screens...
screenManager = ScreenManager

function Init(settings)
    -- Modify settings
    settings.title = "Breakout"
    settings.width = 420
    settings.height = 420
    settings.frameRate = 165
end

function Start(engine)
    -- Initialze the first screen
    screenManager = ScreenManager.new()
    screenManager:setScreen(engine, StartScreen.new())
end

function Paint(engine, _)
    engine:clear(0, 0, 0)
    screenManager:paint(engine)
end

function Tick(engine)
    screenManager:tick(engine)
end
