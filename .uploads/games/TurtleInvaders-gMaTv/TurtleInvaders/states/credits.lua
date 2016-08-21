function creditsInit()
	local text = 
	{
		"A game by TurtleP",
		"",
		"",
		":: Graphics ::",
		"Jael Clark - Hatninja",
		"HugoBDesigner",
		"Chase6897",
		"",
		"",
		":: Audio ::",
		"Kyle Prior",
		"Saint Happyfaces",
		"",
		"",
		":: Testers ::",
		"ihaveamac",
		"Melon Bread",
		"",
		"",
		"Find more games at my site:",
		"http://TurtleP.github.io/"
	}

	creditsText = {}
	for k = 1, #text do
		creditsCreateText(text[k])
	end

	logoFont = love.graphics.newFont("graphics/monofonto.ttf", 46 * scale)
	mainFont = love.graphics.newFont("graphics/monofonto.ttf", 16 * scale)

	creditsY = 240
end

function creditsUpdate(dt)
	for k, v in pairs(creditsText) do
		v[2] = v[2] - 25 * dt
	end
end

function creditsDraw()
	love.graphics.setColor(255, 255, 255)

	love.graphics.setFont(logoFont)

	love.graphics.setColor(255, 0, 0)
	love.graphics.print("Turtle:", util.getWidth() / 2 - logoFont:getWidth("Turtle:") / 2, love.graphics.getHeight() * 0.03)

	love.graphics.setColor(0, 255, 0)
	love.graphics.print("Invaders", util.getWidth() / 2 - logoFont:getWidth("Invaders") / 2, love.graphics.getHeight() * 0.17)

	love.graphics.setColor(255, 255, 255)

	love.graphics.setFont(mainFont)

	for k = 1, #creditsText do
		love.graphics.setScissor(0, 100 * scale, love.graphics.getWidth(), 200 * scale)

		love.graphics.print(creditsText[k][1], util.getWidth() / 2 - mainFont:getWidth(creditsText[k][1]) / 2, creditsText[k][2] * scale)
		
		love.graphics.setScissor()
	end
end

function creditsKeyPressed(key)
	util.changeState("options")
end

function creditsMousePressed(x, y, button)
	util.changeState("options")
end

function creditsGamePadPressed(joystick, button)
	util.changeState("options")
end

function creditsCreateText(text)
	table.insert(creditsText, {text, love.graphics.getHeight() / scale + (#creditsText - 1) * 16, "bottom"})
end