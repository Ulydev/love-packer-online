local _KEYNAMES =
{
	"a", "b", "select", "start",
	"dright", "dleft", "dup", "ddown",
	"rbutton", "lbutton", "x", "y",
	"lzbutton", "rzbutton", "cstickright", 
	"cstickleft", "cstickup", "cstickdown",
	"cpadright", "cpadleft", "cpadup", "cpaddown"
}

BUTTONCONFIG =
{
	["a"] = "z",
	["b"] = "x",
	["y"] = "c",
	["x"] = "v",
	["start"] = "return",
	["select"] = "rshift",
	["up"] = "w",
	["left"] = "a",
	["right"] = "d",
	["down"] = "s",
	["rbutton"] = "kp0",
	["lbutton"] = "rctrl",
	["cpadright"] = "right",
	["cpadleft"] = "left",
	["cpadup"] = "up",
	["cpaddown"] = "down",
	["cstickleft"] = "",
	["cstickright"] ="",
	["cstickup"] = "",
	["cstickdown"] = ""
}

function love.graphics.setDepth(depthValue)
	assert(depthValue and type(depthValue) == "number", "Number expected: got " .. type(depthValue))
end

function love.graphics.set3D(enable3D)
	assert(enable3D and type(enable3D) == "boolean", "Boolean expected: got " .. type(depthValue))
end

function love.system.getWifiStrength()
	return 3
end

local olddraw = love.graphics.draw
function love.graphics.draw(...)
	local args = {...}

	local image = args[1]
	local quad
	local x, y, r = 0, 0, 0
	local scalex, scaley

	if type(args[2]) == "userdata" then
		quad = args[2]
		x = args[3] or 0
		y = args[4] or 0
		scalex, scaley = args[5], args[6]
	else
		x, y = args[2] or 0, args[3] or 0
		r = args[4] or 0
	end
	
	if love.graphics.getScreen() == "bottom" then
		x = x + 40
		y = y + 240
	end

	if not quad then
		if r then
			olddraw(image, x + image:getWidth() / 2, y + image:getHeight() / 2, r, 1, 1, image:getWidth() / 2, image:getHeight() / 2)
		else
			olddraw(image, x, y)
		end
	else
		olddraw(image, quad, x, y, 0, 1, 1)
	end
end

local olddofile = dofile
function dofile(...)
	return love.filesystem.load(...)()
end

local oldRectangle = love.graphics.rectangle
function love.graphics.rectangle(mode, x, y, width, height)
	local x = x or 0
	local y = y or 0
	if love.graphics.getScreen() == "bottom" then
		x = x + 40
		y = y + 240
	end
	oldRectangle(mode, x, y, width, height)
end

local oldCircle = love.graphics.circle
function love.graphics.circle(mode, x, y, r, segments)
	local x = x or 0
	local y = y or 0
	if love.graphics.getScreen() == "bottom" then
		x = x + 40
		y = y + 240
	end
	oldCircle(mode, x, y, r, segments)
end

local oldPrint = love.graphics.print
function love.graphics.print(text, x, y, r, scalex, scaley, sx, sy)
	local x = x or 0
	local y = y or 0
	if love.graphics.getScreen() == "bottom" then
		x = x + 40
		y = y + 240
	end
	oldPrint(text, x, y, r, scalex, scaley, sx, sy)
end
	
local oldKey = love.keypressed
function love.keypressed(key)
	for k, v in pairs(BUTTONCONFIG) do
		if key == v then
			oldKey(k)
			break
		end
	end
end

local oldKey = love.keyreleased
function love.keyreleased(key)
	for k, v in pairs(BUTTONCONFIG) do
		if key == v then
			oldKey(k)
			break
		end
	end
		
	if key == "1" or key == "2" then
		love.system.setModel(tonumber(key))
	end
end

function math.clamp(low, n, high) 
	return math.min(math.max(low, n), high) 
end

local oldMousePressed = love.mousepressed	
function love.mousepressed(x, y, button)
	x, y = math.clamp(0, x - 40, 320), math.clamp(0, y - 240, 240)

	if oldMousePressed then
		oldMousePressed(x, y, 1)
	end
end

local oldMouseReleased = love.mousereleased
function love.mousereleased(x, y, button)
	x, y = math.clamp(0, x - 40, 320), math.clamp(0, y - 240, 240)

	if oldMouseReleased then
		oldMouseReleased(x, y, 1)
	end
end

_SCREEN = "top"

models = {"3DS", "3DSXL"}
function love.system.getModel()
	return models[scale]
end

function love.system.setModel(s)
	scale = s
		
	util.setScalar(s, s)

	if love.system.getModel() ~= "PC" then
		love.window.setMode(400 * scale, 480 * scale, {vsync = true})
	else
		love.window.setMode(400 * scale, 240 * scale, {vsync = true})
	end

	love.window.setTitle(love.filesystem.getIdentity() .. " :: " .. love.system.getModel())
end

love.system.setModel(1)

function love.graphics.setScreen(screen)
	assert(type(screen) == "string", "String expected, got " .. type(screen))
	_SCREEN = screen

	love.graphics.setColor(32, 32, 32)

	love.graphics.rectangle("fill", 0, 240, 40, 240)
	love.graphics.rectangle("fill", 360, 240, 40, 240)

	love.graphics.setColor(255, 255, 255)

	if screen == "top" then
		love.graphics.setScissor(0, -(mapScrollY or 0 * scale), 400 * scale, 240 * scale)
	elseif screen == "bottom" then
		love.graphics.setScissor(40 * scale, (240 * scale) - (mapScrollY or 0 * scale), 320 * scale, 240 * scale)
	end
end

function love.graphics.getWidth()
	if love.graphics.getScreen() == "bottom" then
		return 320
	end
	return 400
end

function love.graphics.getHeight()
	return 240
end

function love.graphics.getScreen()
	return _SCREEN
end

local oldclear = love.graphics.clear
function love.graphics.clear(r, g, b, a)
	love.graphics.setScissor()

	oldclear(r, g, b, a)
end