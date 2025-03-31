--- @class Wall
--- Represents a Wall made of multiple rectangular tiles
--- @field area Rectangle The area of the wall
--- @field _tiles table
local Wall = {}
Wall.__index = Wall -- Set the metatable's __index field to itself

--- Create a new wall
--- @param area Rectangle The area to be filled up with wall
function Wall.new(area)
    local self = setmetatable({}, Wall) -- Create a new table and set its metatable to ball

    self.area = area

    self._tiles = {} -- Initialize a private list to store tiles (rectangles)
    return self
end

--- Generate the actual tiles
--- @param tileSize Vector The size of the tiles
--- @param padding number The space between the tiles
function Wall:generateSimple(tileSize, padding)
    -- Clear potentially existing tiles from the wall
    for k, _ in pairs(self._tiles) do
        self._tiles[k] = nil
    end

    -- Calculate rows and columns based on the area size, tile size, and padding
    local areaWidth = self.area.size.x
    local areaHeight = self.area.size.y

    local columns = math.floor((areaWidth + padding) / (tileSize.x + padding))
    local rows = math.floor((areaHeight + padding) / (tileSize.y + padding))

    -- Store rows and columns for potential future use
    self.rows = rows
    self.columns = columns

    -- Generate tiles to fill the area
    for row = 1, rows do
        for col = 1, columns do
            local position = Vector.new(
                self.area.position.x + (col - 1) * (tileSize.x + padding),
                self.area.position.y + (row - 1) * (tileSize.y + padding)
            )

            local rect = Rectangle.new(position, tileSize)
            table.insert(self._tiles, rect)
        end
    end
end

--- Draw the wall
--- @param engine GameEngine The game engine
function Wall:paint(engine)
    for _, rect in ipairs(self._tiles) do
        engine:fillRect(rect.position.x, rect.position.y,
            rect.position.x + rect.size.x, rect.position.y + rect.size.y)
    end
end

--- Handles collision
--- @param ball Ball The ball to check collision with
--- @return boolean Returns true for a collision
function Wall:handleBallCollision(ball)
    -- In case the ball collides with 2 rectangles at the same time
    local hit = false

    -- Iterate through the tiles table in reverse to safely remove elements
    for i = #self._tiles, 1, -1 do
        local rect = self._tiles[i]

        -- Optimization to avoid always checking for collision
        if ball.center:distance(rect.position) < math.max(rect.size.x, rect.size.y) + ball.radius then
            if ball:handleRectangleCollision(rect) then
                -- Remove the rectangle from the table
                table.remove(self._tiles, i)
                hit = true
            end
        end
    end

    return hit
end

--- Get the state of the wall
--- @return boolean Returns true if the wall is cleared
function Wall:isCleared()
    return #self._tiles < 1
end

return Wall
