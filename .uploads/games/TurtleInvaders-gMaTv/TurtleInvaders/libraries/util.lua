local util = {}

--[[
	util.lua

	Useful Tool in Love

	TurtleP

	v2.0
--]]

local scale = {1, 1}

function util.changeScale(scalar)
	scale = scalar

	love.window.setMode(love.graphics.getWidth() * scalar, love.graphics.getHeight() * scalar)
end

function util.clearFonts()
	mainFont = nil
	logoFont = nil
	pauseFont = nil
	hudFont = nil
	warningFont = nil
	chooseFont = nil
	abilityFont = nil

	collectgarbage()
	
	collectgarbage()
end

function util.round(num, idp) --Not by me
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function util.toBoolean(stringCompare)
	return tostring(stringCompare) == "true"
end

function util.setScalar(xScale, yScale)
	scale = {xScale, yScale}
end

function util.changeState(toState, ...)
	local arg = {...} or {}

	if _G[toState .. "Init"] then
		state = toState
		
		util.clearFonts()
		
		_G[toState .. "Init"](unpack(arg))
	end

end

function util.lerp(a, b, t) 
	return (1 - t) * a + t * b 
end

function util.updateState(dt)
	dt = math.min(1/60, dt)
	
	if _G[state .. "Update"] then
		_G[state .. "Update"](dt)
	end
end

function util.renderState()
	if _G[state .. "Draw"] then
		_G[state .. "Draw"]()
	end
end

function util.keyPressedState(key)
	if _G[state .. "KeyPressed"] then
		_G[state .. "KeyPressed"](key)
	end
end

function util.keyReleasedState(key)
	if _G[state .. "KeyReleased"] then
		_G[state .. "KeyReleased"](key)
	end
end

function util.mousePressedState(x, y, button)
	if _G[state .. "MousePressed"] then
		_G[state .. "MousePressed"](x, y, button)
	end
end

function util.mouseReleasedState(x, y, button)
	if _G[state .. "MouseReleased"] then
		_G[state .. "MouseReleased"](x, y, button)
	end
end

function util.textInput(text)
	if _G[state .. "TextInput"] then
		_G[state .. "TextInput"](text)
	end
end

function util.mouseMovedState(x, y, dx, dy)
	if _G[state .. "MouseMoved"] then
		_G[state .. "MouseMoved"](x, y, dx, dy)
	end
end

function util.gamePadPressed(joystick, button)
	if _G[state .. "GamePadPressed"] then
		_G[state .. "GamePadPressed"](joystick, button)
	end
end

function util.gamePadReleased(joystick, button)
	if _G[state .. "GamePadReleased"] then
		_G[state .. "GamePadReleased"](joystick, button)
	end
end

function util.touchPressed(id, x, y, pressure)
	if _G[state .. "TouchPressed"] then
		_G[state .. "TouchPressed"](id, x, y, pressure)
	end
end

function util.touchReleased(id, x, y, pressure)
	if _G[state .. "TouchReleased"] then
		_G[state .. "TouchReleased"](id, x, y, pressure)
	end
end

function util.dist(x1,y1, x2,y2) 
	return ((x2-x1)^2+(y2-y1)^2)^0.5 
end

function util.clamp(val, min, max)
	return math.max(min, math.min(val, max))
end

function util.colorFade(currenttime, maxtime, c1, c2) --Color function
	local tp = currenttime/maxtime
	local ret = {} --return color

	for i = 1, #c1 do
		ret[i] = c1[i]+(c2[i]-c1[i])*tp
		ret[i] = math.max(ret[i], 0)
		ret[i] = math.min(ret[i], 255)
	end

	return ret
end

function util.getWidth()
	return love.graphics.getWidth()
end

function util.getHeight()
	return love.graphics.getHeight()
end

Color =
{
	["red"] = {225, 73, 56},
	["green"] = {65, 168, 95},
	["blue"] = {44, 130, 201},
	["yellow"] = {250, 197, 28},
	["orange"] = {243, 121, 52},
	["purple"] = {147, 101, 184},
	["darkPurple"] = {85, 57, 130},
	["black"] = {0, 0, 0},
	["white"] = {255, 255, 255}
}

return util
