pausemenu = class("pausemenu")

function pausemenu:init()
	self.options = 
	{
		{"Continue", 
			function() 
				paused = false 
			end
		},
		{"Exit to Title", 
			function()
				paused = false
				
				util.changeState("title") 
			end
		},
		{"Quit Game",
			function()
				love.event.quit()
			end
		},
	}

	self.selection = 1
end

function pausemenu:draw()
	local x, y, w, h = 128, 71, 144, 98

	love.graphics.setFont(pauseFont)

	love.graphics.print("Game Paused", love.graphics.getWidth() / 2 - pauseFont:getWidth("Game Paused") / 2, love.graphics.getHeight() * 0.3)

	for k = 1, #self.options do
		local v = self.options[k]
		if self.selection == k then
			love.graphics.setColor(255, 255, 255)
		else
			love.graphics.setColor(128, 128, 128)
		end

		love.graphics.print(v[1], love.graphics.getWidth() / 2 - pauseFont:getWidth(v[1]) / 2, love.graphics.getHeight() * 0.4 + (k - 1) * 22 * scale)
	end

	love.graphics.setColor(255, 255, 255)
end

function pausemenu:keyPressed(key)
	if key == "s" or key == "down" then
		self.selection = math.min(self.selection + 1, #self.options)
	elseif key == "w" or key == "up" then
		self.selection = math.max(self.selection - 1, 1)
	elseif key == "space" then
		self.options[self.selection][2]()
	end
end

function pausemenu:touchPressed(x, y)
	for k = 1, #self.options do
		local v = self.options[k]

		if isTapped(love.graphics.getWidth() / 2 - pauseFont:getWidth(v[1]) / 2, love.graphics.getHeight() * 0.4 + (k - 1) * 22 * scale, pauseFont:getWidth(v[1]), 20 * scale) then
			
			if self.selection ~= k then
				self.selection = k
			else
				v[2]()
			end
			
			break
		end
	end
end