--- @class Paddle
--- Represents a paddle
--- @field rectangle Rectangle The paddle rectangle
--- @field velocity Vector The velocity of the paddle
local Paddle = {}
Paddle.__index = Paddle

--- Create a new paddle
--- @param rectangle Rectangle The starting position of the paddle
function Paddle.new(rectangle)
    local self = setmetatable({}, Paddle)

    self.rectangle = rectangle
    self.velocity = Vector.new()
    return self
end

--- Draw the paddle
--- @param engine GameEngine The game engine
function Paddle:paint(engine)
    engine:fillRect(self.rectangle.position.x, self.rectangle.position.y,
        self.rectangle.position.x + self.rectangle.size.x, self.rectangle.position.y + self.rectangle.size.y)
end

--- Update the paddle
--- @param delta number The delta time
function Paddle:tick(delta)
    self.rectangle.position = self.rectangle.position + (self.velocity * delta) -- Apply the velocity

    self.velocity = self.velocity * 0.95                                        -- Apply a drag force
end

--- Push the paddle
--- @param force Vector The force to add
function Paddle:applyForce(force)
    self.velocity = self.velocity + force -- Hopefully this works?
end

return Paddle
