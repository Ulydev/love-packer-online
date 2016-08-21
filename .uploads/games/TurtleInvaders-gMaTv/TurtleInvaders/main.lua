_EMULATEHOMEBREW = (love.system.getOS() ~= "3ds")

util = require 'libraries.util'
class = require 'libraries.middleclass'

require 'libraries.physics'
require 'libraries.character'
require 'libraries.functions'

require 'libraries.potion-compat'
require 'libraries.keyboard'

require 'classes.star'
require 'classes.timer'
require 'classes.bat'
require 'classes.barrier'
require 'classes.bullet'
require 'classes.player'
require 'classes.explosion'
require 'classes.display'
require 'classes.powerup'
require 'classes.megacannon'
require 'classes.fizzle'
require 'classes.megabat'
require 'classes.achievement'
require 'classes.raccoon'
require 'classes.phoenix'
require 'classes.pausemenu'

require 'states.intro'
require 'states.title'
require 'states.game'
require 'states.options'
require 'states.charselect'
require 'states.credits'
require 'states.highscore'

require 'netplay.netplay'

io.stdout:setvbuf("no")

--[[
	A note worth reading:

	This game was originally made for PC/Mac/Linux/Android devices. This is the Nintendo 3DS homebrew port. You know what I have to work with here?
	Right now it's Love Potion 1.0.8 which can only use up to two fonts and we haven't got audio streaming. This is a big deal since the original
	version used a shitton of audio and fonts. I've got to hotswap fonts and music as needed so it's a pain but worth it!

	If you enjoy this, please private message me on GBATemp.net (TurtleP)! You can find my website at:

	http://TurtleP.github.io/
--]]

love.math.setRandomSeed( os.time() )

--Make sure random stuff works
love.math.random()
love.math.random()

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	introImage = love.graphics.newImage("graphics/intro/intro.png")
	potionImage = love.graphics.newImage("graphics/intro/potionlogo.png")

	batImage = love.graphics.newImage("graphics/game/bat.png")
	batQuads = {}
	for x = 1, 3 do
		batQuads[x] = {}
		for y = 1, 2 do
			batQuads[x][y] = love.graphics.newQuad((x - 1) * 30, (y - 1) * 14, 30, 14, batImage:getWidth(), batImage:getHeight())
		end
	end

	explosionImage = love.graphics.newImage("graphics/game/explosion.png")
	explosionQuads = {}
	for k = 1, 7 do
		explosionQuads[k] = love.graphics.newQuad((k - 1) * 18, 0, 16, 16, explosionImage:getWidth(), explosionImage:getHeight())
	end

	healthImage = love.graphics.newImage("graphics/game/health.png")
	healthQuads = {}
	for x = 1, 2 do
		healthQuads[x] = {}
		for y = 1, 2 do
			healthQuads[x][y] = love.graphics.newQuad((x - 1) * 8, (y - 1) * 8, 8, 8, healthImage:getWidth(), healthImage:getHeight())
		end
	end
	
	powerupImage = love.graphics.newImage("graphics/game/powerups.png")
	powerupQuads = {}
	for k = 1, 10 do
		powerupQuads[k] = love.graphics.newQuad((k - 1) * 19, 0, 18, 14, powerupImage:getWidth(), powerupImage:getHeight())
	end

	megaCannonBaseImage = love.graphics.newImage("graphics/game/boombase.png")
	megaCannonBaseQuads = {}
	local boomBaseLimit = {6, 2}
	for y = 1, 2 do
		for x = 1, boomBaseLimit[y] do
			table.insert(megaCannonBaseQuads, love.graphics.newQuad((x - 1) * 80, (y - 1) * 80, 80, 80, megaCannonBaseImage:getWidth(), megaCannonBaseImage:getHeight()))
		end
	end

	megaCannonBoomImage = love.graphics.newImage("graphics/game/boom.png")
	megaCannonBoomQuads = {}
	local boomLimit = {6, 6, 3}
	for y = 1, 3 do
		for x = 1, boomLimit[y] do
			table.insert(megaCannonBoomQuads, love.graphics.newQuad((x - 1) * 80, (y - 1) * 80, 80, 80, megaCannonBoomImage:getWidth(), megaCannonBoomImage:getHeight()))
		end
	end

	megaCannonBeamImage = love.graphics.newImage("graphics/game/beam.png")
	megaCannonBeamQuads = {}
	for k = 1, 5 do
		megaCannonBeamQuads[k] = love.graphics.newQuad((k - 1) * 22, 0, 22, 22, megaCannonBeamImage:getWidth(), megaCannonBeamImage:getHeight())
	end

	bossImage = love.graphics.newImage("graphics/game/boss.png")
	bossQuads = {}
	for i = 1, 3 do
		bossQuads[i] = love.graphics.newQuad((i - 1) * 60, 0, 59, 30, bossImage:getWidth(), bossImage:getHeight())
	end

	achievementImage = love.graphics.newImage("graphics/etc/achievements.png")
	achievementQuads = {}
	for k = 1, 10 do
		achievementQuads[k] = love.graphics.newQuad((k - 1) * 30, 0, 30, 30, achievementImage:getWidth(), achievementImage:getHeight())
	end

	raccoonImage = love.graphics.newImage("graphics/game/risky.png")
	raccoonQuads = {}
	for k = 1, 2 do
		raccoonQuads[k] = love.graphics.newQuad((k - 1) * 45, 0, 44, 52, raccoonImage:getWidth(), raccoonImage:getHeight())
	end

	phoenixImage = love.graphics.newImage("graphics/game/phoenix.png")
	phoenixQuads = {}
	for k = 1, 4 do
		phoenixQuads[k] = love.graphics.newQuad((k - 1) * 64, 0, 64, 50, phoenixImage:getWidth(), phoenixImage:getHeight())
	end

	fireImage = love.graphics.newImage("graphics/game/fireballs.png")
	fireQuads = {}
	for k = 1, 2 do
		fireQuads[k] = love.graphics.newQuad((k - 1) * 15, 0, 13, 15, fireImage:getWidth(), fireImage:getHeight())
	end

	shieldShards = {}
	for k = 1, 9 do
		shieldShards[k] = love.graphics.newImage("graphics/game/shield/" .. k .. ".png")
	end

	keyboardImage = love.graphics.newImage("graphics/mobile/keyboard.png");keyboardImage:setFilter("linear", "linear")
	backImage = love.graphics.newImage("graphics/mobile/back.png");backImage:setFilter("linear", "linear")
	gearImage = love.graphics.newImage("graphics/mobile/options.png");gearImage:setFilter("linear", "linear")
	
	waveAdvanceSound = love.audio.newSource("audio/wave.ogg", "static")
	gameOverSound = love.audio.newSource("audio/gameover.ogg", "static")

	bulletSound = love.audio.newSource("audio/bullet.ogg", "static")
	laserSound = love.audio.newSource("audio/laser.ogg", "static")

	explodeSound = love.audio.newSource("audio/explode.ogg", "static")

	pauseSound = love.audio.newSource("audio/pause.ogg", "static")

	addLifeSound = love.audio.newSource("audio/oneup.ogg", "static")

	fizzleSound = love.audio.newSource("audio/evaporate.ogg", "static")
	megaCannonSound = love.audio.newSource("audio/megacannon.ogg", "static")

	keyboardSound = love.audio.newSource("audio/drip.ogg", "static")
	keyboardOpenSound = love.audio.newSource("audio/open.ogg", "static")
	keyboardCloseSound = love.audio.newSource("audio/close.ogg", "static")
	
	shieldSound = love.audio.newSource("audio/shield.ogg")

	toggleSound = love.audio.newSource("audio/tick.ogg")
	blipSound = love.audio.newSource("audio/blip.ogg")
	
	hurtSound = {}
	for k = 1, 3 do
		hurtSound[k] = love.audio.newSource("audio/hurt" .. k .. ".ogg", "static")
	end

	loadCharacters()

	difficulties = 
	{
		"Normal",
		"Hard",
		"Insane"
	}

	difficultyi = 1

	gameModes =
	{
		"Arcade",
		"Endless"
	}

	menuSong = love.audio.newSource("audio/menu.ogg", "stream")
	menuSong:setLooping(true)

	bossSong = love.audio.newSource("audio/boss.ogg", "stream")
	bossSong:setLooping(true)

	gameModei = 1
	
	versionString = "2.0"

	loadSettings()

	batSaveTimer = 0
	batSaveQuadi = 1

	mobileMode = ((love.system.getOS() == "Android") or (love.system.getOS() == "iOS"))

	if not mobileMode then
		love.window.setMode(400, 240)
	else
		love.window.setFullscreen(true, "desktop")
	end

	local width, height = love.graphics.getDimensions()

	--iOS and its 'highDPI' are a bitch
	if love.system.getOS() == "iOS" then
		width, height = love.window.toPixels(love.graphics.getWidth()), love.window.toPixels(love.graphics.getHeight())
	end

	scale = math.floor( math.max( (width / 400), (height / 240) ) )

	starFields = {}

	for fieldCount = 1, 3 do
		starFields[fieldCount] = {}
		for starCount = 1, math.floor(100 / fieldCount) do
			table.insert(starFields[fieldCount], star:new(love.math.random(width), love.math.random(height), fieldCount))
		end
	end

	love.graphics.setLineWidth(love.graphics.getLineWidth() * scale)

	--love.audio.setVolume(0)

	tapTimer = 0
	tapIsHeld = false

	accelerometerJoystick = nil

	util.changeState("intro")
end

function love.update(dt)
	util.updateState(dt)

	for k, v in pairs(achievements) do
		v:update(dt)
	end

	if state ~= "intro" and not paused then
		for fieldCount = 1, #starFields do
			local v = starFields[fieldCount]

			for k, s in pairs(v) do
				s:update(dt)
			end
		end
	end

	if isSaving then
		batSaveTimer = batSaveTimer + 12 * dt
		batSaveQuadi = math.floor(batSaveTimer % 3) + 1

		if batSaveTimer > 12 then
			isSaving = false
			batSaveTimer = 0
		end
	end

	if mobileMode then
		if tapIsHeld then
			tapTimer = tapTimer + dt
		end
	end
end

function love.draw()
	if state ~= "intro" then
		for fieldCount = 1, #starFields do
			local v = starFields[fieldCount]

			for k, s in pairs(v) do
				s:draw()
			end
		end
	end

	util.renderState()

	if isSaving then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(batImage, batQuads[batSaveQuadi][1], love.graphics.getWidth() * .92, love.graphics.getHeight() * .92)
		love.graphics.draw(batImage, batQuads[batSaveQuadi][2], love.graphics.getWidth() * .92, love.graphics.getHeight() * .92)
	end
end

function love.keypressed(key)
	util.keyPressedState(key)
end

function love.keyreleased(key)
	util.keyReleasedState(key)
end

function love.mousepressed(x, y, button)
	util.mousePressedState(x, y, button)
end

function love.textinput(text)
	util.textInput(text)
end

function love.joystickadded(joystick)
	if mobileMode then
		if joystick:getName():find("Accelerometer") then
			accelerometerJoystick = joystick
		else
			if joystick:isGamepad() then
				currentGamePad = joystick
				accelerometerJoystick = nil
			end
		end
	else
		local id, instance = joystick:getID()

		if id == 1 then
			currentGamePad = joystick
		end
	end
end

function love.gamepadpressed(joystick, button)
	if mobileMode then
		if joystick == currentGamePad then
			if button == "dpup" then
				love.keypressed("up")
			elseif button == "dpright" then
				love.keypressed("right")
			elseif button == "dpdown" then
				love.keypressed("down")
			elseif button == "left" then
				love.keypressed("left")
			elseif button == "a" then
				love.keypressed("space")
			elseif button == "b" then
				if state == "game" then
					love.keypressed("lshift")
				else
					love.keypressed("escape")
				end
			elseif button == "start" then
				love.keypressed("escape")
			end
		end
	else
		util.gamePadPressed(joystick, button)
	end
end

function love.gamepadreleased(joystick, button)
	if mobileMode then
		if state ~= game then
			return
		end

		if joystick == currentGamePad then
			if button == "dpright" then
				love.keypressed("right")
			elseif button == "left" then
				love.keypressed("left")
			end
		end
	else
		util.gamePadReleased(joystick, button)
	end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	tapIsHeld = true

	util.touchPressed(id, x, y, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	if tapTimer > 1 then
		love.keypressed("escape")
	end
	tapTimer = 0
	tapIsHeld = false
end

function loadSettings()
	defaultSettings()
		
	local saveData = love.filesystem.read("save.txt")

	if saveData then
		if not saveData then
			return
		end

		local keys = saveData:split(";")

		for x = 1, #keys do
			local keyPairs = keys[x]:split(":")

			local index, value = keyPairs[1], keyPairs[2]

			if index == "music" then
				musicEnabled = util.toBoolean(value)
				optionsSetSound(true)
			elseif index == "sound" then
				soundEnabled = util.toBoolean(value)
				optionsSetSound(false)
			elseif index == "achievement" then
				achievements[tonumber(value)]:unlock()
			elseif index == "highscore" then
				local split = value:split("~")

				highscores[tonumber(split[1])] = {split[2], split[3], tonumber(split[4])}
			end
		end
	end
end

function saveSettings()
	isSaving = true

	local string = ""

	for k = 1, #achievements do
		if achievements[k].unlocked then
			string = string .. "achievement:" .. k .. ";"
		end
	end

	string = string .. "music:" .. tostring(musicEnabled) .. ";" .. "sound:" .. tostring(soundEnabled) .. ";"

	for k = 1, #highscores do
		string = string .. "highscore:" .. k .. "~" .. highscores[k][1] .. "~" .. highscores[k][2] .. "~" .. highscores[k][3] .. ";"
	end

	love.filesystem.write("save.txt", string)
end

function defaultSettings(remove)
	controls =
	{
		left = "a",
		right = "d",
		shoot = "space",
		ability = "lshift"
	}

	highscores = {}
	for k = 1, 4 do
		highscores[k] = {"????", "Unknown", 0}
	end
	
	--SET UP ACHIEVEMENTS
	local achievementNames =
	{
		"Megalovania Bat",
		"Risky Raccoon",
		"Phoenix Fizzler",
		"Easy as Pie",
		"Average Gamer",
		"Dedicated Player",
		"Combo Madness",
		"Super Player",
		"Cease Fire",
		"Double Ping"
	}
	
	achievements = {}
	for k = 1, 10 do
		table.insert(achievements, achievement:new(k, achievementNames[k]))
	end
	
	musicEnabled = true
	soundEnabled = true

	if remove then
		explodeSound:play()

		love.filesystem.remove("save.txt")
	end
end

local oldDraw = love.graphics.draw
function love.graphics.draw(...)
	local vararg = {...}

	if type(vararg[2]) == "number" then
		oldDraw(vararg[1], vararg[2], vararg[3], vararg[4], scale, scale)
	else
		oldDraw(vararg[1], vararg[2], vararg[3], vararg[4], vararg[5], scale, scale)
	end
end

function isTapped(x, y, width, height)
	return aabb(x, y, width, height, love.mouse.getX(), love.mouse.getY(), 8, 8)
end