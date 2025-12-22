
-- Importing libraries  
import "CoreLibs/object"
import "CoreLibs/ui"
import "Corelibs/sprites"
import "Corelibs/graphics"
import "Corelibs/animation"
import "animatedimage"
import "Score"

-- Localizing commonly used globals
local gfx <const> = playdate.graphics
local sprite <const> = gfx.sprite
local geometry <const> = playdate.geometry

local fontDefault <const> = gfx.getFont()

local shyguy_image = AnimatedImage.new("shyguy.png", {delay = 50, loop = true})
local shyguy_position = geometry.point.new(playdate.display.getWidth(), math.random(10, 80))
local shyguy_speed = math.random(1, 5)
local shyguy_scale = math.random(1, 4)

local czImage = gfx.image.new("assets/Crankzilla_0")
local czSprite = sprite.new(czImage)

local myShackImage = gfx.image.new("assets/Shack_1")
local myShack1Sprite = sprite.new(myShackImage)

local score=0

-- Defining player variables
local playerSize = 20
local playerVelocity = 1
local playerX, playerY = 200, 120

local function init()

    czSprite:add()
    czSprite:moveTo(playerX,playerY)
    czSprite:setCollideRect(0,0, czSprite:getSize())

    myShack1Sprite:add()
    myShack1Sprite:moveTo(100,100)
    myShack1Sprite:setCollideRect(0,0, myShack1Sprite:getSize())
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
    gfx.clear(gfx.kColorWhite)

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

    gfx.sprite.update()

     -- Dustin anim stuff --
	if shyguy_position.x < -100 then
		shyguy_position.x = playdate.display.getWidth()
		shyguy_position.y = math.random(10, 80)
		shyguy_scale = math.random(1, 4)
	end
	shyguy_position.x -= shyguy_speed
    shyguy_image:drawScaled(shyguy_position.x, shyguy_position.y, shyguy_scale)


     -- TEST COLLISION = increment score
    local collisions = gfx.sprite.allOverlappingSprites()

    for i = 1, #collisions do
        local collisionPair = collisions[i]
        local sprite1 = collisionPair[1]
        local sprite2 = collisionPair[2]
        -- do something with the colliding sprites

        Score.update(1)
    end

    -- Draw score
    fontDefault:drawTextAligned(tostring(Score.read()), 5, 5, kTextAlignment.left)
end
