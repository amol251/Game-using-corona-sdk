-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
display.setStatusBar(display.HiddenStatusBar)
W = display.contentWidth
H = display.contentHeight


local balloon,balloon1,balloon2,balloon3,balloon4,balloon5,scoreTxt 
local cnt = 0

local function onTap(event)
	event.target.isVisible = false
	cnt = cnt + 1
	scoreTxt.text = "Score "..cnt
end

local function translateObj(obj)
	if obj.y + obj.height*.5 <= 0 then
		obj.isVisible = true
		obj:translate(0,H+H*.2)
		obj.x = math.random(W*.1,W-W*.1)
	else
		obj.y = obj.y - H*.01
	end
end

local function onEnterFrame(event)
	translateObj(balloon)
	translateObj(balloon1)
	translateObj(balloon2)
	translateObj(balloon3)
	translateObj(balloon4)
	translateObj(balloon5)
end

local function createBalloons()

	balloon = display.newImage("balloon.png",math.random(W*.1,W-W*.1),H)
	balloon.width = W*.2
	balloon.height = W*.36
	balloon:addEventListener("tap",onTap)

	balloon1 = display.newImage("balloon.png",math.random(W*.1,W-W*.1),H+H*.1)
	balloon1.width = W*.2
	balloon1.height = W*.36
	balloon1:addEventListener("tap",onTap)

	balloon2 = display.newImage("balloon.png",math.random(W*.1,W-W*.1),H+H*.35)
	balloon2.width = W*.2
	balloon2.height = W*.36
	balloon2:addEventListener("tap",onTap)
	
	balloon3 = display.newImage("balloon.png",math.random(W*.1,W-W*.1),H+H*.55)
	balloon3.width = W*.2
	balloon3.height = W*.36
	balloon3:addEventListener("tap",onTap)

	balloon4 = display.newImage("balloon.png",math.random(W*.1,W-W*.1),H+H*.8)
	balloon4.width = W*.2
	balloon4.height = W*.36
	balloon4:addEventListener("tap",onTap)

	balloon5 = display.newImage("balloon.png",math.random(W*.1,W-W*.1),H+H*.95)
	balloon5.width = W*.2
	balloon5.height = W*.36
	balloon5:addEventListener("tap",onTap)
end

local bg = display.newRect(W*.5,H*.5,W,H)

createBalloons()

scoreTxt = display.newText("Score "..cnt,W*.5,H*.05,native.systemFontBold,W*.1)
scoreTxt:setFillColor(0)

Runtime:addEventListener("enterFrame",onEnterFrame)
