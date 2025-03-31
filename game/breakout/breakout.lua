Paddle = require("breakout/paddle")
Ball = require("breakout/ball")
Wall = require("breakout/wall")

--- @class Breakout
--- Represents the breakout game
--- @field wallLeft Rectangle
--- @field wallRight Rectangle
--- @field wallTop Rectangle
--- @field wall Wall
--- @field player Paddle
--- @field ball Ball
--- @field ballSpeed number
--- @field area Rectangle
--- @field fallSound Audio
--- @field popSound Audio
local Breakout = {}
Breakout.__index = Breakout -- Set the metatable's __index field to itself

--- Create a new breakout / game instance
--- @param area Rectangle The rectangle of the play area
--- @param paddleSize Vector The width of the paddle
--- @param ballRadius number The radius of the ball
--- @param ballSpeed number The speed of the ball
--- @param brickSize Vector The size of a brick
--- @param brickPadding number The padding of bricks
function Breakout.new(area, paddleSize, ballRadius, ballSpeed, brickSize, brickPadding)
    local self = setmetatable({}, Breakout)

    print("Defining play area")
    local wallSize = 10

    -- Creates walls for the ball to collide with
    self.wallLeft = Rectangle.new(Vector.new(area.position.x - wallSize, area.position.y),
        Vector.new(wallSize, area.size.y))
    self.wallRight = Rectangle.new(Vector.new(area.position.x + area.size.x, area.position.y),
        Vector.new(wallSize, area.size.y))
    self.wallTop = Rectangle.new(Vector.new(area.position.x, area.position.y - wallSize),
        Vector.new(area.size.x, wallSize))

    print("Defining breakout wall")
    -- Create the wall with breakable blocks
    self.wall = Wall.new(
        Rectangle.new(
            Vector.new(area.position.x + ballRadius * 4, area.position.y + ballRadius * 4),
            Vector.new(
                area.size.x - ballRadius * 8,      -- Subtract margins on both sides
                (area.size.y - ballRadius * 8) / 2 -- Half the play area height for the wall
            )
        )
    )

    print("Generating wall")
    self.wall:generateSimple(brickSize, brickPadding)

    print("Creating paddle")
    self.player = Paddle.new(Rectangle.new(
        Vector.new((area.position.x + area.size.x / 2) - (paddleSize.x / 2),
            area.position.y + area.size.y - paddleSize.y - ballRadius * 4),
        Vector.new(paddleSize.x, paddleSize.y)))

    print("Creating ball")
    self.ball = Ball.new(
        Vector.new(area.position.x + area.size.x / 2, area.position.y + (area.size.y / 2) + ballRadius * 2),
        ballRadius)

    self.ballSpeed = ballSpeed
    self.started = false
    self.area = area

    self.fallSound = Audio.new("assets/sounds/ball_fall.mp3", false) -- Don't read beats
    self.popSound = Audio.new("assets/sounds/brick_pop.mp3", false)  -- Don't read beats
    self.popSound:setVolume(50)

    return self
end

--- Draw the game
--- @param engine GameEngine The game engine
function Breakout:paint(engine)
    self.wall:paint(engine)
    self.ball:paint(engine)
    self.player:paint(engine)
end

--- Update the game
--- @param engine GameEngine The game engine
function Breakout:tick(engine)
    self.fallSound:tick()
    self.popSound:tick()
    self.died = false

    local delta = 1.0 / engine:getFrameRate()

    -- To keep consistent with the layout adaptation stuff
    if engine:isKeyDown('D') or engine:isKeyDown('E') then
        self.player:applyForce(Vector.new(30, 0))
    end

    -- Also support azerty
    if engine:isKeyDown('A') or engine:isKeyDown('Q') then
        self.player:applyForce(Vector.new(-30, 0))
    end

    self.player:tick(delta)

    -- Invert the velocity when the player bounces against the edge
    if self.player.rectangle.position.x <= self.area.position.x then
        self.player.velocity.x = math.abs(self.player.velocity.x)
        self.player.rectangle.position = Vector.new(self.area.position.x, self.player.rectangle.position.y)
    elseif self.player.rectangle.position.x + self.player.rectangle.size.x >= self.area.position.x + self.area.size.x then
        self.player.velocity.x = math.abs(self.player.velocity.x) * -1.0
        self.player.rectangle.position = Vector.new(
            (self.area.position.x + self.area.size.x) - self.player.rectangle.size.x,
            self.player.rectangle.position.y)
    end

    if not self.started then
        self.ball.center = Vector.new(self.player.rectangle.position.x + self.player.rectangle.size.x / 2,
            self.player.rectangle.position.y - self.ball.radius)

        -- Allow the user some freedom of choice
        if engine:isKeyDown(' ') or engine:isKeyDown('C') or engine:isKeyDown('F') or engine:isKeyDown('W') then
            self.ball.velocity = Vector.new()
            self.ball.center = Vector.new(self.ball.center.x, self.ball.center.y + self.ball.radius) -- Just to make sure
            local direction = Vector.new(0, 1):normalized()
            self.ball:applyForce(direction * self.ballSpeed)
            self.started = true
        end

        return
    end

    self.ball:tick(delta)

    -- If the player collided with the ball, apply paddle influence
    if self.ball:handleRectangleCollision(self.player.rectangle) then
        local playerInfluence = self.player.velocity * 0.2
        self.ball.velocity = (self.ball.velocity + playerInfluence):normalized() * self.ballSpeed
    end

    self.ball:handleRectangleCollision(self.wallLeft)
    self.ball:handleRectangleCollision(self.wallRight)
    self.ball:handleRectangleCollision(self.wallTop)

    -- Check collision with the wall
    if self.wall:handleBallCollision(self.ball) then
        self.popSound:stop()
        self.popSound:play(0, -1)
    end

    -- If the ball leaves the screen
    if self.ball.center.y - self.ball.radius * 4 > self.area.position.y + self.area.size.y then
        self.ball.center = Vector.new(self.area.position.x + self.area.size.x / 2,
            self.area.position.y - self.area.size.y / 2)

        self.fallSound:stop()
        self.fallSound:play(0, -1)

        self.died = true
        self.started = false
    end
end

--- Get the state of the game
--- @return boolean Returns true if the wall is cleared
function Breakout:isCleared()
    return self.wall:isCleared()
end

return Breakout
