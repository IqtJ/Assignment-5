-----------------------------------------------------------------------------------------
--
-- Iqtina Jaber
--
-----------------------------------------------------------------------------------------

-- a game where the user uses stars to explode clouds
----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

--background sky
local background = display.newImageRect("assets/sky.jpg", 350, 600)
background.x = display.contentCenterX
background.y = display.contentCenterY
background.id = "background"


--game UI
local gameUI = require("gameUI")


---physics
local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 ) -- no gravity in any direction

--score
local score = 0
local scoreText = display.newText( "Score:" .. score, display.contentCenterX, display.contentCenterY + 250, native.labelFont, 20 )
scoreText.id = "score text"
scoreText:setFillColor( 0, 0, 255 )

--sounds
local expolsionSound = audio.loadStream( "assets/explosion.wav" )


-- Table that holds the players Stars
local playerStars = {} 


 
---Button to make stars
local spawnButton = display.newImageRect("assets/spawn.png", 220, 70)
spawnButton.x = display.contentCenterX
spawnButton.y = display.contentCenterY + 220
spawnButton.id = "spawn text"


----cloud 
local cloud = display.newImageRect("assets/cloud.png", 150, 100)
cloud.x = display.contentCenterX
cloud.y = display.contentCenterY - 200
cloud.id = "cloud"
physics.addBody( cloud, "static", { 
    friction = 0.5, 
    bounce = 0 
    } )

--star
local star = display.newImageRect("assets/star.png", 50, 50)
star.x = display.contentCenterX
star.y = display.contentCenterY + 160
star.id = "star"
physics.addBody( star, "dynamic", {
   	density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )


--------------------------
----functions

-------drag objects
local function dragBody( event )
	return gameUI.dragBody( event )

end





--function for when star hits a cloud

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        local whereCollisonOccurredX = obj1.x
        local whereCollisonOccurredY = obj1.y
        star:setLinearVelocity( 0, 0 )


        if ( ( obj1.id == "cloud" and obj2.id == "star" ) or
             ( obj1.id == "star" and obj2.id == "cloud" ) ) then
            -- Remove both the laser and asteroid
            --display.remove( obj1 )
            --display.remove( obj2 )
 			
 			--pause physics
 			--physics.pause()

 			-- remove the star
 			local starCounter = nil
 			
            for starCounter = #playerStars, 1, -1 do
                if ( playerStars[starCounter] == obj1 or playerStars[starCounter] == obj2 ) then
                    playerStars[starCounter]:removeSelf()
                    playerStars[starCounter] = nil
                    table.remove( playerStars, starCounter )
                    break
                end
            end

            --remove cloud
            cloud:removeSelf()
            cloud = nil

            --remove star
            star:removeSelf()
            star = nil 


            -- score
            score = score + 1
            scoreText.text = ("Score:"..score)

            -- make an explosion sound effect
            local explosionChannel = audio.play( expolsionSound )

            -- make an explosion happen
            -- Table of emitter parameters
			local emitterParams = {
			    startColorAlpha = 1,
			    startParticleSizeVariance = 25,
			    startColorGreen = 0.3031555,
			    yCoordFlipped = -1,
			    blendFuncSource = 770,
			    rotatePerSecondVariance = 153.95,
			    particleLifespan = 0.7237,
			    tangentialAcceleration = -1440.74,
			    finishColorBlue = 0.3699196,
			    finishColorGreen = 0.5443883,
			    blendFuncDestination = 1,
			    startParticleSize = 50,
			    startColorRed = 0.8373094,
			    textureFileName = "assets/fire.png",
			    startColorVarianceAlpha = 1,
			    maxParticles = 25,
			    finishParticleSize = 50,
			    duration = 0.25,
			    finishColorRed = 1,
			    maxRadiusVariance = 50.63,
			    finishParticleSizeVariance = 100,
			    gravityy = -671.05,
			    speedVariance = 90.79,
			    tangentialAccelVariance = -420.11,
			    angleVariance = -142.62,
			    angle = -244.11
			}
			local emitter = display.newEmitter( emitterParams )
			emitter.x = whereCollisonOccurredX
			emitter.y = whereCollisonOccurredY

        end
    end
end

---create stars and clouds
function spawnButton:touch( event )
    if ( event.phase == "began" ) then
        --star
        star = display.newImageRect("assets/star.png", 50, 50)
		star.x = display.contentCenterX
		star.y = display.contentCenterY + 140
		star.id = "star"
		physics.addBody( star, "dynamic", {
   			density = 3.0, 
    		friction = 0.5, 
    		bounce = 0.3 
    		} )
	star:addEventListener( "touch", dragBody )

		--cloud
		cloud = display.newImageRect("assets/cloud.png", 150, 100)
		cloud.x = math.random(50, 300)
		cloud.y = math.random(1, 280)
		cloud.id = "cloud"
		physics.addBody( cloud, "static", { 
    		friction = 0.5, 
    		bounce = 0 
    		} )
		--start physics
		physics.setScale(10)
		physics.start()
	end

	return true 
end


	cloud.x = math.random(50, 300)
	cloud.y = math.random(1, 280)



--check if any starsare out of bounds and deletes them
function checkPlayerStarsOutOfBounds()
	-- check if any bullets have gone off the screen
	local starCounter

    if #playerStars > 0 then
        for starCounter = #playerStars, 1 ,-1 do
            if playerStars[starCounter].x > display.contentWidth + 1000 then
                playerStars[starCounter]:removeSelf()
                playerStars[starCounter] = nil
                table.remove(playerStars, starCounter)
                print("remove star")
            end
        end
    end
end




--event listeners
Runtime:addEventListener( "enterFrame", checkPlayerStarsOutOfBounds )
Runtime:addEventListener( "collision", onCollision )

spawnButton:addEventListener( "touch", spawnButton )


star:addEventListener( "touch", dragBody )
