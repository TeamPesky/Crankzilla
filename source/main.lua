
-- Importing libraries  
import "CoreLibs/object"
import "CoreLibs/ui"
import "Corelibs/sprites"
import "Corelibs/graphics"
import "Corelibs/animation"

-- Localizing commonly used globals
local gfx <const> = playdate.graphics
local sprite <const> = gfx.sprite

local czImage = gfx.image.new("assets/Crankzilla_0")
local czSprite = sprite.new(czImage)

local myShackImage = gfx.image.new("assets/Shack_1")
local myShack1Sprite = sprite.new(myShackImage)

-- Defining player variables
local playerSize = 20
local playerVelocity = 1
local playerX, playerY = 200, 120

local function init()

    czSprite:add()
    czSprite:moveTo(playerX,playerY)

    myShack1Sprite:add()
    myShack1Sprite:moveTo(100,100)

end

-- Defining helper function
local function ring(value, min, max)
	if (min > max) then
		min, max = max, min
	end
	return min + (value - min) % (max - min)
end

init()

-- playdate.update function is required in every project!
function playdate.update()

    -- Clear screen
    gfx.clear()

    gfx.sprite.update()

    -- Draw crank indicator if crank is docked
    if playdate.isCrankDocked() then
        playdate.ui.crankIndicator:draw()
    else
        -- Calculate velocity from crank angle 
        local crankPosition = playdate.getCrankPosition() - 90
        local xVelocity = math.cos(math.rad(crankPosition)) * playerVelocity
        local yVelocity = math.sin(math.rad(crankPosition)) * playerVelocity
        -- Move player
        playerX += xVelocity
        playerY += yVelocity
        -- Loop player position
        playerX = ring(playerX, -playerSize, 400 + playerSize)
        playerY = ring(playerY, -playerSize, 240 + playerSize)
    end

    -- Draw player
    czSprite:moveTo(playerX, playerY)

        -- Draw score
    gfx.drawTextAligned("SCORE 00000", 5, 5, kTextAlignment.left)

end
