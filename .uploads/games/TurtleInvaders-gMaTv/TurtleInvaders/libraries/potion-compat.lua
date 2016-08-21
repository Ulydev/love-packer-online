--[[
	FOR NINTENDO 3DS ONLY

	You may use this for -Love Potion- only!

	TurtleP
--]]

if not love.graphics.scale then
	function love.graphics.scale(scalarX, scalarY)
		--do nothing
	end
end

if not love.graphics.setDefaultFilter then
	function love.graphics.setDefaultFilter(min, max) 
		--do nothing
	end
end

if not love.audio.setVolume then
	function love.audio.setVolume(volume)
		--do nothing
	end
end

if not love.math then
	love.math = {}

	function love.math.setRandomSeed(...)
		math.randomseed(...)
	end

	function love.math.random(...)
		return math.random(...)
	end
end