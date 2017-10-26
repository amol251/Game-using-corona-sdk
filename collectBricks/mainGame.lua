
--==============================================================================
 -- Developer: Meer Imtiyaz Ali
 -- Company: Redbytes Software Pvt. Ltd. Pune
--==============================================================================

--======Required Libraries======================================================
local composer = require( "composer" )

--======Variables Declarations==================================================
local scene = composer.newScene()

local sceneGroup
local bricks,tapRect = {},{}
local ball,slider,scoreTxt
local rslt = 0
local isMoveSlider = true
local isMoveBall = false
local flagArr = {false,false,false,false}
--======Listeners Declarations==================================================

--======Function Declarations===================================================

--======Listeners Definition====================================================
function moveSlider(event)
    if not isMoveBall then
        isMoveBall = true
        flagArr[2] = true
    end
    if isMoveSlider then
        if event.target.id == "Left" then
            if slider.contentBounds.xMin <= 0 then 
                slider.x = slider.contentWidth*.5
            else
                slider.x = slider.x - W*.08
            end
        elseif event.target.id == "Right" then
            if slider.contentBounds.xMax >= W then 
                slider.x = W - slider.contentWidth*.5
            else
                slider.x = slider.x + W*.08
            end
        end  
    end   
end

function moveBall(event)
    speed = 3
    if ball.contentBounds.yMax >= slider.contentBounds.yMin and ball.contentBounds.xMin >= slider.contentBounds.xMin and ball.contentBounds.xMax <= slider.contentBounds.xMax then
        local pos = resetFlag()
        if pos == "rightDown" then
            flagArr[1] = true  
        elseif pos == "leftDown" then
            flagArr[3] = true
        end
    elseif ball.contentBounds.yMin <= 0 then
        local pos = resetFlag()
        if pos == "rightUp" then
            flagArr[2] = true  
        elseif pos == "leftUp" then
            flagArr[4] = true
        end
    elseif ball.contentBounds.xMax >= W then
        local pos = resetFlag()
        if pos == "rightDown" then
            flagArr[4] = true  
        elseif pos == "rightUp" then
            flagArr[3] = true
        end
    elseif ball.contentBounds.xMin <= 0 then
        local pos = resetFlag()
        if pos == "leftUp" then
            flagArr[1] = true  
        elseif pos == "leftDown" then
            flagArr[2] = true
        end
    elseif ball.contentBounds.yMax > slider.contentBounds.yMin  then
        resetFlag()

        isMoveSlider = false

        local bgrect = display.newRect(W*.5,H*.5,W,H)
        bgrect:setFillColor(0.7)
        sceneGroup:insert(bgrect)

        local GMOverTxt = display.newText("Game Over",W*.5,H*.5,native.systemFont,W*.12)
        GMOverTxt:setFillColor(0.2,0.5,0.8)
        sceneGroup:insert(GMOverTxt)

    end
    if flagArr[1] then
        ball.x = ball.x + speed
        ball.y = ball.y - speed
    elseif flagArr[2] then
        ball.x = ball.x + speed
        ball.y = ball.y + speed
    elseif flagArr[3] then
        ball.x = ball.x - speed
        ball.y = ball.y - speed
    elseif flagArr[4] then
        ball.x = ball.x - speed
        ball.y = ball.y + speed
    end
    for i=1,18 do
        if bricks[tostring(i)] ~= nil then
            if ball.y <= bricks[tostring(i)].contentBounds.yMax and ball.y >= bricks[tostring(i)].contentBounds.yMin and ball.x >= bricks[tostring(i)].contentBounds.xMin and ball.x <= bricks[tostring(i)].contentBounds.xMax then
                local pos = resetFlag()
                if pos == "rightUp" then
                    flagArr[2] = true  
                elseif pos == "leftUp" then
                    flagArr[4] = true
                elseif pos == "leftDown" then
                    flagArr[3] = true
                elseif pos == "rightDown" then
                    flagArr[1] = true
                end
                rslt = rslt + 1
                bricks[tostring(i)]:removeSelf()
                bricks[tostring(i)] = nil
                scoreTxt.text = "Score "..rslt
            end 
        end
    end    
end

--======Function Definations====================================================
function resetFlag()
    local ids = {"rightUp","rightDown","leftUp","leftDown"}
    for i=1,#flagArr do
        if flagArr[i] then
            flagArr[i] = false
            return ids[i]
        end
    end
end

function createUI()
    local grp = display.newGroup()
    slider = display.newRect(W*.5,H*.9,W*.3,H*.05)
    slider:setFillColor(1,0.5,0.6)
    grp:insert(slider)

    ball = display.newCircle(W*.1,H*.65,W*.03)
    ball:setFillColor(1,0,0)
    grp:insert(ball)

    scoreTxt = display.newText("Score 0",W*.5,H*.05,native.systemFont,W*.05)
    scoreTxt:setFillColor(0)
    grp:insert(scoreTxt)

    local xPos,yPos = W*.1,H*.2
    for i=1,18 do
        bricks[tostring(i)] = display.newRect(xPos,yPos,W*.15,H*.05)
        bricks[tostring(i)]:setFillColor(1,0,0.2)
        grp:insert(bricks[tostring(i)])
        xPos = xPos + bricks[tostring(i)].contentWidth*.5 + W*.08
        if i%6 == 0 then
            xPos = W*.1
            yPos = yPos + bricks[tostring(i)].contentHeight*.5 + H*.03
        end 
    end
    local xx = 0
    local id = {"Left","Right"}
    for i=1,2 do
        tapRect[#tapRect+1] = display.newRect(xx,0,W*.5,H)
        tapRect[#tapRect].alpha = 0.01
        tapRect[#tapRect].id = id[i]
        tapRect[#tapRect].anchorX = 0
        tapRect[#tapRect].anchorY = 0
        tapRect[#tapRect]:addEventListener("tap",moveSlider)
        xx = xx + tapRect[#tapRect].contentWidth 
    end
    return grp
end

--======Composer Functions======================================================
function scene:create( event )
    sceneGroup = self.view

    local BG = display.newRect(W*.5,H*.5,W,H)
    sceneGroup:insert(BG)

    createUI()    

end

function scene:show( event )
    sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    Runtime:addEventListener("enterFrame",moveBall)
    end
end

function scene:hide( event )
    sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then       
    elseif ( phase == "did" ) then
    end
end

function scene:destroy( event )
   sceneGroup = self.view
end

--------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
--------------------------------------------------------------------------------

return scene