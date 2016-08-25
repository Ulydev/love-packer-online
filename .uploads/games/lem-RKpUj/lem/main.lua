io.stdout:setvbuf'no' 

love.window.setTitle("Press Space to emit event, Escape to remove event")

event = require "lem" --require the library

local function sayMessage (params)
  print(params.author.." says: "..params.message)
end

manager = event
:new() --create new event manager
:on('say', sayMessage) --register event

function love.keypressed(key)
  
  if key == "space" then
    manager:emit('say', { --emit event
      author = "System",
      message = "I've just been asked to say something!"
    })
  elseif key == "escape" and manager:getListenerCount('say') > 0 then
    manager:remove('say', sayMessage)
    print("I won't listen to events anymore.")
  end
  
end