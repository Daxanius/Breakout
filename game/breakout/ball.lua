--- @class Ball
--- Represents a Ball
--- @field center Vector The the center position of the ball
--- @field radius number The radius of the ball
--- @field velocity Vector The velocity of the ball
--- @field hitSound Audio The hitSound
local Ball = {}
Ball.__index = Ball -- Set the metatable's __index field to itself

--- Create a new ball
--- @param center Vector The center of the ball
--- @param radius number The radius of the ball
function Ball.new(center, radius)
    local self = setmetatable({}, Ball) -- Create a new table and set its metatable to ball

    self.center = center
    self.radius = radius

    self.velocity = Vector.new()

    -- Load the hit sound
    self.hitSound = Audio.new("assets/sounds/ball_hit.mp3", false) -- Don't read beats
    return self
end

--- Draw the ball
--- @param engine GameEngine The game engine
function Ball:paint(engine)
    engine:fillOval(self.center.x - self.radius, self.center.y - self.radius,
        self.center.x + self.radius, self.center.y + self.radius)
end

--- Update the ball
--- @param delta number The delta time
function Ball:tick(delta)
    self.hitSound:tick()
    self.center = self.center + (self.velocity * delta) -- Apply the velocity
end

--- Push the ball in a direction
--- @param force Vector The force to add
function Ball:applyForce(force)
    self.velocity = self.velocity + force -- Hopefully this works?
end

--- Push the ball in a direction
--- @param speed number the speed of the ball
function Ball:setSpeed(speed)
    self.velocity = self.velocity:normalized()
    self.velocity = self.velocity * speed
end

--- Handles collision with a rectangle
--- @param rectangle Rectangle The rectangle to check and handle collision with
--- @return boolean Returns true for a collision
function Ball:handleRectangleCollision(rectangle)
    -- Check for direction of ball heading
    local direction = self.velocity:normalized()
    local ray = Ray.new(self.center, direction, self.radius)

    -- Check for intersection in rectangle direction
    local intersect = rectangle:intersect(ray)

    if (intersect.hit) then
        self.velocity = self.velocity:reflection(intersect.normal)
        self.center = intersect.hitPoint + (direction * -1) * self.radius

        self.hitSound:stop()
        self.hitSound:play(0, -1)
        return true
    end

    -- Check for direction to rectangle
    direction = Vector.new(rectangle.center.x - self.center.x, rectangle.center.y - self.center.y)
        :normalized()
    ray.direction = direction

    -- Check for intersection in ball direction
    intersect = rectangle:intersect(ray)

    if (intersect.hit) then
        self.velocity = self.velocity:reflection(intersect.normal)
        self.center = intersect.hitPoint + (direction * -1) * self.radius

        self.hitSound:stop()
        self.hitSound:play(0, -1)
        return true
    end

    return false
end

return Ball
