function titleInit(selection)
	titleOptions =
	{
		{"New Game", function() util.changeState("charSelect") end},
		--{"Options Menu", function() util.changeState("options") end},
		{"Online Rivals", function() util.changeState("netplay") end},
		{"Highscores", function() util.changeState("highscore", true) end}
	}

	menuSelectioni = selection or 1
	menuBatQuadi = 1

	menuBatTimer = 0

	mainFont = love.graphics.newFont("graphics/monofonto.ttf", 30 * scale)
	smallFont = love.graphics.newFont("graphics/monofonto.ttf", 26 * scale)
	logoFont = love.graphics.newFont("graphics/monofonto.ttf", 46 * scale)

	if not menuSong:isPlaying() then
		menuSong:play()
	end
	
	superPlayer = true
	
	if bossSong then
		bossSong:stop()
	end
end

function titleUpdate(dt)
	menuBatTimer = menuBatTimer + 8 *dt
	menuBatQuadi = math.floor(menuBatTimer % 3) + 1
end

function titleDraw()
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(gearImage, util.getHeight() * 0.01, util.getHeight() * 0.011)

	love.graphics.setFont(logoFont)

	love.graphics.setColor(255, 0, 0)
	love.graphics.print("Turtle:", util.getWidth() / 2 - logoFont:getWidth("Turtle:") / 2, love.graphics.getHeight() * 0.03)

	love.graphics.setColor(0, 255, 0)
	love.graphics.print("Invaders", util.getWidth() / 2 - logoFont:getWidth("Invaders") / 2, love.graphics.getHeight() * 0.2)

	love.graphics.setFont(mainFont)
	love.graphics.setColor(255, 255, 255)
	for k = 1, #titleOptions do
		local v = titleOptions[k][1]
		love.graphics.print(v, util.getWidth() / 2 - mainFont:getWidth(v) / 2, love.graphics.getHeight() * 0.54 + (k - 1) * 30 * scale)
	end

	love.graphics.draw(batImage, batQuads[menuBatQuadi][2], util.getWidth() / 2 - mainFont:getWidth(titleOptions[menuSelectioni][1]) / 2 - 32 * scale, (util.getHeight() * 0.54 + 12 * scale) + ((menuSelectioni - 1) * 30 * scale))
	love.graphics.draw(batImage, batQuads[menuBatQuadi][1], util.getWidth() / 2 - mainFont:getWidth(titleOptions[menuSelectioni][1]) / 2 - 32 * scale, (util.getHeight() * 0.54 + 12 * scale) + ((menuSelectioni - 1) * 30 * scale))
end

function titleKeyPressed(key)
	if key == "w" or key == "up" then
		menuSelectioni = math.max(menuSelectioni - 1, 1)
	elseif key == "s" or key == "down" then
		menuSelectioni = math.min(menuSelectioni + 1, #titleOptions)
	elseif key == "space" then
		titleOptions[menuSelectioni][2]()
	elseif key == "escape" then
		love.event.quit()
	end
end

function titleGamePadPressed(joystick, button)
	if joystick == currentGamePad then
		if button == "dpdown" then
			menuSelectioni = math.min(menuSelectioni + 1, #titleOptions)
		elseif button == "dpup" then
			menuSelectioni = math.max(menuSelectioni - 1, 1)
		elseif button == "a" then
			titleOptions[menuSelectioni][2]()
		elseif button == "b" then
			love.event.quit()
		end
	end
end

function titleMousePressed(x, y, button)
	if isTapped(util.getWidth() * 0.01, util.getHeight() * 0.011, 16 * scale, 16 * scale) then
		util.changeState("options")
	end
end

function titleTouchPressed(id, x, y, pressure)
	for i = 1, #titleOptions do
		local v = titleOptions[i][1]
		if isTapped(util.getWidth() / 2 - mainFont:getWidth(v) / 2, love.graphics.getHeight() * 0.52 + (i - 1) * 30 * scale, mainFont:getWidth(v), 26 * scale) then
			
			if menuSelectioni ~= i then
				menuSelectioni = i
			else
				titleOptions[menuSelectioni][2]()
			end

			break		
		end
	end
end