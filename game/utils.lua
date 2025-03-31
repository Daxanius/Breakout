local Utils = {}
Utils.__index = Utils

--- Perform a deep copy of a table
--- Creates a new table that recursively copies all keys and values from the original table.
--- @param origTable table The table to copy. Non-table values are returned as is.
--- @return table|any A deep copy of the original table, or the original value if it is not a table.
function Utils.deepCopy(origTable)
    local origType = type(origTable)
    if origType ~= "table" then
        return origTable -- Return non-table values directly
    end

    local copy = {}
    for key, value in pairs(origTable) do
        copy[Utils.deepCopy(key)] = Utils.deepCopy(value) -- Recursively copy keys and values
    end
    return copy
end

--- An easing function for smooth animations
--- Implements the "ease out back" formula for easing animations.
--- @param t number Current time or frame (starts from 0)
--- @param b number Starting value
--- @param c number Total change in value
--- @param d number Duration of the animation
--- @param s number|nil Overshoot amount. Defaults to 1.70158 if not provided.
--- @return number The calculated eased value
function Utils.easeOutBack(t, b, c, d, s)
    s = s or 1.70158
    t = t / d - 1
    return c * ((t * t * ((s + 1) * t + s)) + 1) + b
end

return Utils
