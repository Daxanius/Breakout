--- @meta

-- VECTOR CLASS
--- @class Vector
--- Represents a vector with `x` and `y` components.
--- @field x number The X component of the vector
--- @field y number The Y component of the vector
Vector = {}

--- Creates a new vector instance.
--- @param x number The X component
--- @param y number The Y component
--- @return Vector
function Vector.new(x, y) end

--- Creates a new vector instance.
--- @return Vector
function Vector.new() end

--- Calculates the squared length of the vector.
--- @return number
function Vector:lengthSquared() end

--- Calculates the length of the vector.
--- @return number
function Vector:length() end

--- Creates a normalized version of the vector.
--- @return Vector
function Vector:normalized() end

--- Calculates the distance to another vector.
--- @param other Vector The other vector
--- @return number
function Vector:distance(other) end

--- Calculate the reflection
--- @param normal Vector The normal to reflect against
--- @return Vector
function Vector:reflection(normal) end

-- RAY CLASS
--- @class Ray
--- Represents a a ray for an intersection
--- @field direction Vector The direction of the ray
--- @field origin Vector The origin position of the ray
--- @field length number The distance of the ray
Ray = {}

--- Creates a new ray instance.
--- @param center Vector
--- @param direction Vector
--- @param distance number
--- @return Ray
function Ray.new(center, direction, distance) end

-- HIT INFO CLASS
--- @class HitInfo
--- Represents a hit result of an intersection
--- @field hitPoint Vector The point where the info hit
--- @field normal Vector The normal of the hit info
--- @field t number Distance along the ray hit occurred
--- @field hit boolean Whether the info actually hit anything
HitInfo = {}

-- RECTANGLE CLASS
--- @class Rectangle
--- Represents a rectangle with a position and a size
--- @field position Vector The top left position of the rectangle
--- @field size Vector The size of the rectangle
--- @field center Vector Readonly, center of the rectangle
--- @field halfSize Vector Readonly, half size of the rectangle
Rectangle = {}

--- Creates a new vector instance.
--- @param position Vector  The X component
--- @param size Vector The Y component
--- @return Rectangle
function Rectangle.new(position, size) end

--- Checks if a ray intersects with the rectangle
--- @param ray Ray The ray of the triangle intersection
--- @return HitInfo
function Rectangle:intersect(ray) end

-- FONT CLASS
--- @class Font
--- Represents a font
--- @field name string The name / file of the font
--- @field bold boolean
--- @field italic boolean
--- @field underline boolean
--- @field size integer
Font = {}

-- AUBIO DATA CLASS
--- @class AubioData
--- Represents a aubio data
--- @field lastMs number Milliseconds since last beat
--- @field lastS number Seconds since last beat
--- @field last integer Last beat sample
--- @field bpm number The beats per minute detected
--- @field confidence number The confidence in the prediction
--- @field wasTatum integer 2 means it was a beat, 1 means it was a tatum
AubioData = {}

-- AUDIO CLASS
--- @class Audio
--- Represents an audio class
Audio = {}

--- Creates a new audio class
--- @param filename string The audio file
--- @param readBeats boolean Should read aubio data (not recommended unless you want to detect beats)
--- @return Audio
function Audio.new(filename, readBeats) end

--- Plays audio
--- @param msecStart integer The place to start playing
--- @param msecStop integer -1 to play until the end. The seconds to stop playing at
function Audio:play(msecStart, msecStop) end

--- Gets if the audio is playing
--- @return boolean
function Audio:isPlaying() end

--- Gets if the audio is paused
--- @return boolean
function Audio:isPaused() end

--- Stops audio from playing
function Audio:stop() end

--- Pause audio
function Audio:pause() end

--- Tick audio
function Audio:tick() end

--- Sets the volume
--- @param volume integer Volume in 0 - 100 range
function Audio:setVolume(volume) end

--- Set the audio to repeating
--- @param value boolean
function Audio:setRepeat(value) end

--- Gets the volume
--- @return integer Volume Volume in 0 - 100 range
function Audio:getVolume(volume) end

--- Gets if the audio exists
--- @return boolean
function Audio:exists() end

--- Gets the audio duration
--- @return integer
function Audio:getDuration() end

--- Gets if the audio is repeating
--- @return boolean
function Audio:getRepeat() end

--- Gets aubio data by sample index
--- @param index integer The sample index
--- @return AubioData
function Audio:getDataByIndex(index) end

--- Get the current audio playback position in milliseconds
--- @return integer
function Audio:getPlaybackPosition() end

--- Gets the sample data size of aubio
--- @return integer
function Audio:getDataSize() end

--- Attempts to get the current aubio sample related to the current playing position
--- @return AubioData
function Audio:getCurrentDataSample() end

-- GAME ENGINE CLASS
--- @class GameEngine
--- Represents the main game engine used for everything
GameEngine = {}

--- Fills a rectangle
--- @param left number
--- @param top number
--- @param right number
--- @param bottom number
function GameEngine:fillRect(left, top, right, bottom) end

--- Draws a rectangle
--- @param left number
--- @param top number
--- @param right number
--- @param bottom number
function GameEngine:drawRect(left, top, right, bottom) end

--- Fills an oval
--- @param x1 number First point x position
--- @param y1 number First point y position
--- @param x2 number Second point x position
--- @param y2 number Seconds point y position
function GameEngine:drawLine(x1, y1, x2, y2) end

--- Draws an oval
--- @param left number
--- @param top number
--- @param right number
--- @param bottom number
function GameEngine:drawOval(left, top, right, bottom) end

--- Fills an oval
--- @param left number
--- @param top number
--- @param right number
--- @param bottom number
function GameEngine:fillOval(left, top, right, bottom) end

--- Shows a message box
--- @param text string Message to display
function GameEngine:messageBox(text) end

--- Shows a message continue?
--- @param text string Message to display
function GameEngine:messageContinue(text) end

--- Sets the engine drawing color
--- @param r integer
--- @param g integer
--- @param b integer
function GameEngine:messageContinue(r, g, b) end

--- Sets the engine drawing color
--- @param r integer
--- @param g integer
--- @param b integer
function GameEngine:setColor(r, g, b) end

--- Clears the engine to a color
--- @param r integer
--- @param g integer
--- @param b integer
function GameEngine:clear(r, g, b) end

--- Gets the framerate
--- @return number
function GameEngine:getFrameRate() end

--- Checks if a key is held
--- @param key string The character (utf8) that is presse
--- @return boolean
function GameEngine:isKeyDown(key) end

--- Draws text
--- @param text string Message to display
--- @param left number Left position
--- @param top number Top position
function GameEngine:drawString(text, left, top) end

--- Draws text
--- @param text string Message to display
--- @param left number Left position
--- @param top number Top position
--- @param right number Right position
--- @param bottom number Bottom position
function GameEngine:drawString(text, left, top, right, bottom) end

--- Sets the drawing font
--- @param font Font
function GameEngine:drawString(font) end

--- Quits the game
function GameEngine:quit() end

--- Gets the window width
--- @return integer
function GameEngine:getWidth() end

--- Sets the window height
--- @return integer
function GameEngine:getHeight() end

--- Sets the showMouse
--- @param value boolean
function GameEngine:showMouse(value) end

--- Go fullscreen
--- @return boolean
function GameEngine:goFullScreen() end

--- Go windowed
--- @return boolean
function GameEngine:goWindowed() end
