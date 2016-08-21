function optionsInit()
	optionTabs = {"General", "Controls"}

	optionsX = love.graphics.getWidth() / 2 - 180 * scale
	optionsY = love.graphics.getHeight() / 2 - 105 * scale
	optionsWidth = 360
	optionsHeight = 210
	
	mainFont = love.graphics.newFont("graphics/monofonto.ttf", 24 * scale)
	logoFont = love.graphics.newFont("graphics/monofonto.ttf", 16 * scale)

	optionsSelection = 1
	optionsTab = 1

	optionsSelections =
	{
		{"Difficulty:", function() optionsChangeDifficulty(1) end},
		{"Game Mode:", function() optionsChangeMode(1) end},
		{"", function() end},
		{"Sound Effects:", function() optionsToggleSound(false) end},
		{"Music:", function() optionsToggleSound(true) end},
		{"", function() end},
		{"Delete data", function() defaultSettings(true) end},
		{"View credits", function() util.changeState("credits") end}
	}

	optionsDelay = 0.1
end

function optionsUpdate(dt)
	optionsDelay = math.max(optionsDelay - dt, 0)
end

function optionsDraw()
	if mobileMode then
		love.graphics.draw(backImage, util.getHeight() * 0.01, util.getHeight() * 0.011)
	end

	love.graphics.setFont(mainFont)

	--GENERAL
	love.graphics.setColor(127, 127, 127)
	if optionsTab == 1 then
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.print("General", optionsX, optionsY + 2 * scale)	

	--CONTROLS
	if not mobileMode then
		love.graphics.setColor(127, 127, 127)
		if optionsTab == 2 then
			love.graphics.setColor(255, 255, 255)
		end
		love.graphics.print("Controls", optionsX + 98 * scale, optionsY + 2 * scale)
	end	

	--ACHIEVEMENTS
	local achievementTextX, tabIndex = optionsX + 210 * scale, 3
	if mobileMode then
		achievementTextX, tabIndex = optionsX + 98 * scale, 2
	end

	love.graphics.setColor(127, 127, 127)
	if optionsTab == tabIndex then
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.print("Achievements", achievementTextX, optionsY + 2 * scale)

	love.graphics.setFont(logoFont)

	--GENERAL
	if optionsTab == 1 then

		love.graphics.setColor(255, 255, 255)
		love.graphics.print("v" .. versionString, (optionsX + optionsWidth * scale) - logoFont:getWidth("v" .. versionString), (optionsY + optionsHeight * scale) - logoFont:getHeight())

		love.graphics.setColor(127, 127, 127)
		if optionsSelection == 1 then
			love.graphics.setColor(255, 255, 255)
		end
		love.graphics.print("Difficulty: " .. difficulties[difficultyi], optionsX + 16 * scale, optionsY + 32 * scale)

		love.graphics.setColor(127, 127, 127)
		if optionsSelection == 2 then
			love.graphics.setColor(255, 255, 255)
		end
		love.graphics.print("Game Mode: " .. gameModes[gameModei], optionsX + 16 * scale, optionsY + 54 * scale)

		love.graphics.setColor(127, 127, 127)
		if optionsSelection == 4 then
			love.graphics.setColor(255, 255, 255)
		end

		local soundString = "Enabled"
		if not soundEnabled then
			soundString = "Disabled"
		end
		love.graphics.print("Sound Effects: " .. soundString, optionsX + 16 * scale, optionsY + 98 * scale)
		
		love.graphics.setColor(127, 127, 127)
		if optionsSelection == 5 then
			love.graphics.setColor(255, 255, 255)
		end

		local musicString = "Enabled"
		if not musicEnabled then
			musicString = "Disabled"
		end
		love.graphics.print("Music: " .. musicString, optionsX + 16 * scale, optionsY + 120 * scale)

		love.graphics.setColor(127, 127, 127)
		if optionsSelection == 7 then
			love.graphics.setColor(255, 255, 255)
		end
		love.graphics.print("Delete Data", optionsX + 16 * scale, optionsY + 164 * scale)

		love.graphics.setColor(127, 127, 127)
		if optionsSelection == 8 then
			love.graphics.setColor(255, 255, 255)
		end
		love.graphics.print("View Credits", optionsX + 16 * scale, optionsY + 186 * scale)
	end

	if not mobileMode and optionsTab == 2 then
		love.graphics.setColor(127, 127, 127)
		if optionsSelection == 1 then
			love.graphics.setColor(255, 255, 255)
		end
		love.graphics.print("Move Left: " .. controls["left"]:gsub("^%l", string.upper), optionsX + 16, optionsY + 32 * scale)

		love.graphics.setColor(127, 127, 127)
		if optionsSelection == 2 then
			love.graphics.setColor(255, 255, 255)
		end
		love.graphics.print("Move Right: " .. controls["right"]:gsub("^%l", string.upper), optionsX + 16, optionsY + 54 * scale)

		love.graphics.setColor(127, 127, 127)
		if optionsSelection == 3 then
			love.graphics.setColor(255, 255, 255)
		end
		love.graphics.print("Shoot: " .. controls["shoot"]:gsub("^%l", string.upper), optionsX + 16, optionsY + 76 * scale)
		
		love.graphics.setColor(127, 127, 127)
		if optionsSelection == 4 then
			love.graphics.setColor(255, 255, 255)
		end
		love.graphics.print("Use Ability: " .. controls["ability"]:gsub("^%l", string.upper), optionsX + 16, optionsY + 98 * scale)
	end

	if optionsTab == tabIndex then
		for k = 1, #achievements do
			love.graphics.setColor(127, 127, 127)
			if achievements[k].unlocked then
				love.graphics.setColor(255, 255, 255)
			end
			love.graphics.draw(achievementImage, achievementQuads[k], optionsX + math.mod((k - 1), 2) * 180 * scale, (((optionsY + 32 * scale) + 16 * scale) - 15 * scale) + math.floor((k - 1) /  2) * 36 * scale)
			love.graphics.print(achievements[k].title, optionsX + 40 * scale + math.mod((k - 1), 2) * 180 * scale, (((optionsY + 32 * scale) + 16 * scale) - logoFont:getHeight() / 2) + math.floor((k - 1) /  2) * 36 * scale)
		end
	end
end

function optionsTouchPressed(id, x, y, pressure)
	for k = 1, #optionsSelections do
		local v = optionsSelections[k][1]

		if v ~= "" then
			if isTapped(optionsX + 16 * scale, optionsY + (32 + (k - 1) * 22) * scale, logoFont:getWidth(v), 16 * scale) then
				
				if optionsSelection ~= k then
					optionsSelection = k
				else
					optionsSelections[optionsSelection][2]()
				end

				break
			end
		end
	end

	if isTapped(optionsX, optionsY + 6 * scale, mainFont:getWidth("General"), 20 * scale) then
		optionsTab = 1
	elseif isTapped(optionsX + 98 * scale, optionsY + 6 * scale, mainFont:getWidth("Achievements"), 20 * scale) then
		optionsTab = 2
	end

	if optionsDelay > 0 then
		return
	end

	if isTapped(util.getWidth() * 0.01, util.getHeight() * 0.011, 16 * scale, 16 * scale) then
		util.changeState("title")
	end
end

function optionsKeyPressed(key)
	if optionsInput then
		local controlSelected = "left"
		if optionsSelection == 2 then
			controlSelected = "right"
		elseif optionsSelection == 3 then
			controlSelected = "shoot"
		elseif optionsSelection == 4 then
			controlSelected = "ability"
		end

		controls[controlSelected] = key
		optionsInput = false
		
		return
	end

	if key == "s" or key == "down" then
		optionsChangeItem(1)
	elseif key == "w" or key == "up" then
		optionsChangeItem(-1)
	elseif key == "d" or key == "right" then
		if optionsSelection == 1 then
			optionsChangeDifficulty(1)
		elseif optionsSelection == 2 then
			optionsChangeMode(1)
		end
	elseif key == "a" or key == "left" then
		if optionsSelection == 1 then
			optionsChangeDifficulty(-1)
		elseif optionsSelection == 2 then
			optionsChangeMode(-1)
		end
	elseif key == "space" then
		if optionsTab == 1 then
			if optionsSelection == 7 then
				defaultSettings(true)
			elseif optionsSelection == 8 then
				util.changeState("credits")
			end
		elseif optionsTab == 2 then
			if optionsSelection > 0 or optionsSelection < 5 then
				optionsInput = true
			end
		end
	elseif key == "escape" then
		saveSettings()
		
		util.changeState("title")
	elseif key == "tab" then
		optionsChangeTab()
	end
end

function optionsGamePadPressed(joystick, button)
	if joystick == currentGamePad then

		if optionsInput then
			local controlSelected = "left"
			if optionsSelection == 2 then
				controlSelected = "right"
			elseif optionsSelection == 3 then
				controlSelected = "shoot"
			elseif optionsSelection == 4 then
				controlSelected = "ability"
			end

			controls[controlSelected] = button
			optionsInput = false
			
			return
		end

		if button == "dpdown" then
			optionsChangeItem(1)
		elseif button == "dpup" then
			optionsChangeItem(-1)
		elseif button == "dpright" then
			if optionsSelection == 1 then
				optionsChangeDifficulty(1)
			elseif optionsSelection == 2 then
				optionsChangeMode(1)
			end
		elseif button == "dpleft" then
			if optionsSelection == 1 then
				optionsChangeDifficulty(-1)
			elseif optionsSelection == 2 then
				optionsChangeMode(-1)
			end
		elseif button == "a" then
			if optionsTab == 1 then
				if optionsSelection == 7 then
					defaultSettings(true)
				elseif optionsSelection == 8 then
					util.changeState("credits")
				end
			elseif optionsTab == 2 then
				if optionsSelection > 0 or optionsSelection < 5 then
					optionsInput = true
				end
			end
		elseif button == "b" then
			saveSettings()

			util.changeState("title")
		elseif button == "rightshoulder" or button == "leftshoulder" then
			optionsChangeTab()
		end
	end
end

function optionsChangeTab()
	optionsTab = optionsTab + 1

	local max = 3
	if mobileMode then
		max = 2
	end

	if optionsTab > max then
		optionsTab = 1
	end

	optionsSelection = 1
end

function optionsChangeItem(i)
	local max = #optionsSelections
	if optionsTab == 2 then
		max = 4
	end

	if (optionsSelection + i == 3) or (optionsSelection + i == 6)  then
		optionsSelection = optionsSelection + i
	end

	optionsSelection = util.clamp(optionsSelection + i, 1, max)
end

function optionsChangeDifficulty(i)
	difficultyi = difficultyi + i
	if difficultyi < 1 then
		difficultyi = #difficulties
	elseif difficultyi > #difficulties then
		difficultyi = 1
	end
end

function optionsChangeMode(i)
	gameModei = gameModei + i
	if gameModei < 1 then
		gameModei = #gameModes
	elseif gameModei > #gameModes then
		gameModei = 1
	end
end

function optionsToggleSound(bgm)
	for k, v in pairs(_G) do
		if type(v) == "userdata" then
			if v.getType then
				if not bgm then
					if v:getType() == "static" then
						if v:getVolume() == 0 then
							v:setVolume(1)
							soundEnabled = true
						else
							v:setVolume(0)
							soundEnabled = false
						end
					end
				else
					if v:getType() == "stream" then
						if v:getVolume() == 0 then
							v:setVolume(1)
							musicEnabled = true
						else
							v:setVolume(0)
							musicEnabled = false
						end
					end
				end
			end
		end
	end
end

function optionsSetSound(bgm)
	for k, v in pairs(_G) do
		if type(v) == "userdata" then
			if v.getType then
				if not bgm then
					if v:getType() == "static" then
						if not soundEnabled then
							v:setVolume(0)
						else
							v:setVolume(1)
						end
					end
				else
					if v:getType() == "stream" then
						if not musicEnabled then
							v:setVolume(0)
						else
							v:setVolume(1)
						end
					end
				end
			end
		end
	end
end