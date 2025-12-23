
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

local CK_image = AnimatedImage.new("CK.png", {delay = 250, loop = true})
local CK_sprite = gfx.sprite.new(CK_image)
local CK_position = geometry.point.new(playdate.display.getWidth(), math.random(10, 80))


local myShackImage = gfx.image.new("assets/Shack_1")
local myShack1Sprite = sprite.new(myShackImage)

local myTreeImage = gfx.image.new("assets/Trees")
local myTreeSprite = sprite.new(myTreeImage)

local myPylonImage = gfx.image.new("assets/Pylon")
local myPylonSprite = sprite.new(myPylonImage)

-- Defining player variables
local playerVelocity = 1
local playerX, playerY = 10, 180

local function init()

    CK_sprite:add()
    CK_sprite:setCollideRect(0,0, CK_image:getSize())
    CK_sprite:moveWithCollisions( CK_position.x, CK_position.y )
    CK_sprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap

    myShack1Sprite:add()
    myShack1Sprite:moveTo(100,100)
    myShack1Sprite:setCollideRect(0,0, myShack1Sprite:getSize())

    myTreeSprite:add()
    myTreeSprite:moveTo(100,150)
    myTreeSprite:setCollideRect(0,0, myTreeSprite:getSize())

    myPylonSprite:add()
    myPylonSprite:moveTo(70,25)
    myPylonSprite:setCollideRect(0,0, myPylonSprite:getSize())
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

    local movingRight = true

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
        playerX = ring(playerX, -64, 400 + 64)
        playerY = ring(playerY, -64, 240 + 64)

        -- Flip CZ is moving left
            if xVelocity < 0 then
       movingRight = false
    end
    end

    gfx.sprite.update()

    -- Player
    CK_sprite:moveWithCollisions( playerX, playerY )

    if movingRight then
     CK_image:draw( playerX, playerY, "flipX" )
    else
     CK_image:draw( playerX, playerY )
    end

    -- TEST COLLISION = increment score
    local collisions = CK_sprite.allOverlappingSprites()
    for i = 1, #collisions do
        local collisionPair = collisions[i]
        local sprite1 = collisionPair[1]
        local sprite2 = collisionPair[2]
        -- do something with the colliding sprites
       sprite1:setCollisionsEnabled(false)

        Score.update(1)
    end

    -- Draw score
    fontDefault:drawTextAligned(tostring(Score.read()), 5, 5, kTextAlignment.left)

end
