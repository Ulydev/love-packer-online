function highscoreInit(menu)
	highscoreFromMenu = menu

	mainFont = love.graphics.newFont("graphics/monofonto.ttf", 24 * scale)
	logoFont = love.graphics.newFont("graphics/monofonto.ttf", 36 * scale)

	highi = nil
	if not highscoreFromMenu then
		for x = 1, #highscores do
			if score > highscores[x][3] then
				highi = x
				break
			end
		end

		if not highi then
			util.changeState("title", 1)
		else
			for i = #highscores, highi + 1, -1 do
				highscores[i] = {highscores[i - 1][1], highscores[i - 1][2], highscores[i - 1][3]}
			end

			highscores[highi] = {"????", difficulties[difficultyi], score}
	
			if mobileMode then
				love.keyboard.setTextInput(true)
			end
		end
	end

	inputFade = 0
	inputName = ""

	colorFadeTime = 1
end

function highscoreUpdate(dt)
	if highi then
		inputFade = math.min(inputFade + dt / 0.3, 1)

		colorFadeTime = math.min(colorFadeTime + 2.5 * dt, 1)
	end
end

function highscoreDraw()
	if mobileMode then
		if not highi then
			love.graphics.draw(backImage, util.getHeight() * 0.01, util.getHeight() * 0.011)
		else
			love.graphics.draw(keyboardImage, util.getHeight() * 0.01, util.getHeight() * 0.011)
		end
	end

	love.graphics.setFont(logoFont)

	love.graphics.setColor(65, 168, 95)
	love.graphics.print("High Scores", (util.getWidth() / 2 - logoFont:getWidth("High Scores") / 2) - 1.5 * scale, love.graphics.getHeight() * 0.1 - 1.5 * scale)

	love.graphics.setColor(255, 255, 255)
	love.graphics.print("High Scores", util.getWidth() / 2 - logoFont:getWidth("High Scores") / 2, love.graphics.getHeight() * 0.1)

	love.graphics.setFont(mainFont)

	for k = 1, #highscores do
		local highString = k .. ". " .. highscores[k][1] .. "    " .. highscores[k][2] .. "    " .. highscores[k][3]

		local color = {44, 130, 201}
		if k > 1 then
			color = {255, 73, 56}
		end

		love.graphics.setColor(unpack(color))
		love.graphics.print(highString, (util.getWidth() / 2 - mainFont:getWidth(highString) / 2) - 1.5 * scale, ((love.graphics.getHeight() * 0.4) - 1.5 * scale) + (k - 1) * 32 * scale)

		love.graphics.setColor(255, 255, 255)
		love.graphics.print(highString, util.getWidth() / 2 - mainFont:getWidth(highString) / 2,  (love.graphics.getHeight() * 0.4) + (k - 1) * 32 * scale)
	end

	if highi then
		love.graphics.setColor(0, 0, 0, 180 * inputFade)

		love.graphics.rectangle("fill", 0, 0, util.getWidth(), util.getHeight())

		love.graphics.setColor(255, 255, 255, 255 * inputFade)

		for x = 1, 8 do
			love.graphics.rectangle("fill", util.getWidth() / 2 - 92 * scale + (x - 1) * 23 * scale, (util.getHeight() * 0.37), 20 * scale, 2 * scale)
		end

		if #inputName == 0 then
			love.graphics.setColor(180, 180, 180, 255 * inputFade)

			love.graphics.print("Enter your name", util.getWidth() / 2 - mainFont:getWidth("Enter your name") / 2 - 2 * scale, util.getHeight() * 0.26)
		else
			for x = 1, #inputName do
				if x == #inputName then
					love.graphics.setColor(util.colorFade(colorFadeTime, 1, {255, 0, 0, 255 * inputFade}, {255, 255, 255, 255 * inputFade}))
				else
					love.graphics.setColor(255, 255, 255, 255 * inputFade)
				end

				love.graphics.print(inputName:sub(x, x), ((util.getWidth() / 2 - 92 * scale) + 10 * scale) - mainFont:getWidth(inputName:sub(x, x)) / 2 + (x - 1) * 23 * scale, util.getHeight() * 0.26)
			end
		end

		love.graphics.setColor(255, 255, 255, 255)
	end
end

function highscoreTextInput(text)
	if not highi then
		return
	end
		
	if #inputName < 8 then
		if colorFadeTime == 1 then
			colorFadeTime = 0
				
			keyboardSound:play()

			inputName = inputName .. text
		end
	end
end

function highscoreTouchPressed(x, y, button)
	if isTapped(util.getWidth() * 0.01, util.getHeight() * 0.011, 16 * scale, 16 * scale) then
		if not highi then
			util.changeState("title", 3)
		else
			if not love.keyboard.hasTextInput() then
				love.keyboard.setTextInput(true)
			end
		end
	end
end

function highscoreGamePadPressed(joystick, button)
	if joystick == currentGamePad then
		if not highi then
			if button == "b" then
				if highscoreFromMenu then
					util.changeState("title", 3)
				end
			end
		end
	end
end

function highscoreKeyPressed(key)
	if highi then
		if key == "backspace" then
			inputName = inputName:sub(1, -2)
		elseif key == "return" then
			if #inputName > 0 then
				highscores[highi][1] = inputName

				love.keyboard.setTextInput(false)
				
				saveSettings()

				util.changeState("title", 1)
			end
		end
		return
	end

	if key == "escape" then
		if highscoreFromMenu then
			util.changeState("title", 3)
		end
	end
end