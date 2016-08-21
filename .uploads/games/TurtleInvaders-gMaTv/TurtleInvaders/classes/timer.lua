timer = class("timer")

function timer:init(time, callback)
	self.time = 0
	self.maxTime = time

	self.callback = callback

	self.maxTimer = self.maxTime
end

function timer:update(dt)
	if self.time < self.maxTime then
		self.time = self.time + dt
	else
		self.time = self.time - self.maxTimer
		self.callback(self)
	end
end

function timer:setTimeLimit(timeLimit)
	self.maxTimer = timeLimit
	self.maxTime = self.maxTimer
end