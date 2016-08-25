lem
==============

lem is a simple event manager library that allows you to register and trigger events in your game / application.

It works the same way as NodeJS's EventEmitter.

Setup
----------------

```lua
local event = require "lem" --require the library
```

Usage
----------------

Create an event manager
```lua
local myEventManager = event:new()
```

Register an event listener
```lua
myEventManager:on('start', function ()
  print("Starting game")
end)
```

Emit an event
```lua
myEventManager:emit('start')
```

You can also pass parameters in a table:
```lua
myEventManager:on('say', function (params)
  print(params.message)
end)

myEventManager:emit('say', { message = "Hi!" })
```

Chaining functions
----------------

The **event manager** object is passed through most of the methods. This allows you to chain function calls like so:
```lua
manager = event
:new()
:on('event1', function () print("event 1") end)
:on('event2', function () print("event 2") end)
```

Methods and aliases
----------------

Register an event listener
```lua
lem:on(eventname, callback)
//-> lem:addEventListener
```

Emit an event
```lua
lem:emit(eventname, params)
```

Remove an event listener
```lua
lem:remove(eventname, callback)
//-> lem:removeEventListener
```

Remove all listeners of a specific event
```lua
lem:reset(eventname)
//-> lem:removeEventListeners
```

Get total count of listeners
```lua
lem:getListenerCount(eventname)
```