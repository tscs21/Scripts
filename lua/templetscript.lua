------------------------------------------------------------------------------------------------------------

DEVICE_FAMILY = "lhc"

function _onActivation(event, arg, family)
--
-- ADD ANY START UP ROUTINES HERE
--
--    POLL:setMKeyModifier( "default", "mb5", "mb4", "lhc" ) -- allows mouse button 4 and 5 to change M states.

end

function _OnEvent(event, arg, family)
--
-- ADD EVENT FUNCTIONALITY HERE
--

end

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--
--                             NOTHING BELOW HERE NEEDS TO BE ALTERED
--
--------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
-- function PriorityHandler:new(doubleClickDelay)   doubleClickDelay = max time between clicks for resetting ability. default is 250
-- function PriorityHandler:addItem(GKey, MState, family, item, isDoubleClickResetable) - add an item to the priority queue
-- function PriorityHandler:handleEvent(event,arg,family) - delivers events to each Action/Macro in queue
-- function PriorityHandler:run(event,arg,family) - handles events and runs RunThread
-- function PriorityHandler.RunThread(mt,self) - runs all actions in order of priority.
-- function PriorityHandler:start()     - flags run to allow it to run
-- function PriorityHandler:stop()      - flags run to stop
-- function PriorityHandler:setSoftLock(lockOn)
----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- function EventKey:new(GKey, MState, family)  -- MState can be nil 1 2 or 3 (nil for all pages), family = 'kb' or 'lhc'
-- function EventKey:setWhilePressedItem(item)  - item can be a Macro only
-- function EventKey:setToggleItem(item)        - item can be a Macro only
-- function EventKey:setPressedItem(item)       - item can be a Macro or an Action
-- function EventKey:setReleasedItem(item)      - item can be a Macro or an Action
-- function EventKey:setToggleOnItem(item)      - item can be a Macro or an Action
-- function EventKey:setToggleOffItem(item)     - item can be a Macro or an Action
-- function EventKey:handleEvent(event,arg,family)  -- will process events and set flags
-- function EventKey:checkEvent(event,arg,family)   -- checks if event for key and press or release self.pressed
-- function EventKey:isPressed()                    -- returns true if key is currently pressed
-- function EventKey.runItem(item)                  -- run a single Macro or Action
-- function EventKey.stopItem(item)                 -- stops a macro, ignores Actions
-- function EventKey:runMacros()    -- run all macros associated with the EventKey (if flagged stopped, they don't run)
-- function EventKey:run(event,arg,family)      - handles events and runs macros
-- EventKey:isToggleOn()    -- returns true if toggle is on.
-----------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- function Macro:new(name, isRepeating, isInterruptable, ...)  -- ... can be an unlimited amount of Actions
-- function Macro:addAction(action)     -- add an action to the end of a Macro
-- function Macro:start()   -- flags macro so that Macro:run() will perform actions
-- function Macro:stop()    -- flags macro to stop.  It will finish running macro if not interruptable
-- function Macro:run()     -- will attempt to run a macro if flagged to by Macro:start()
-- function Macro:isRunning()  -- will return true if macro is running.  If flagged to stop, but not finished, it's true
-- function Macro:delayElapsed()    -- if delay after macro finished, has elapsed
-- function Macro:setCoolDown(coolDown) -- set coolDown before a Macro can be run again. Use with PriorityHandler
-- function Macro:setDelay(delay)   -- set a delay between reuse of a Macro or another Action. Use with PriorityHandler
-- function Macro:lock()            -- if locked, Macro will not run, even if Macro:start() is on.
-- function Macro:unlock()
-- function Macro:isLocked()
-- function Macro:reset()           -- resets coolDown and delay and kills Macro if running.
--      function Macro.RunThread(mt, self)   -- NOT TO BE USED
------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
-- function Action:new(func, delay, coolDown, varList, retList)
-- function Action:setAltInfo(cost, softLockable, castTime, gobalCoolDown)
--    - cost is for MMO mana/energy cost, softLockable is for locking a group of Actions
--    - castTime of spell, if different from delay
-- function Action:run()                    - runs an action and sets timeStamp
-- function Action:getReturnValues()        - gets values returned by run function
-- function Action:delayElapsed()            - true if delay has been achieved, or not run yet
-- function Action:coolDownElapsed()        - true if cool down has elapsed, or not run yet
-- function Action:hasRun()                 - true if action has completed function and set timeStamp
-- function Action:isRunning()              - true if run and not delayElapsed()
-- function Action.isAction(item)           - tests if item is an Action
-- function Action:lock()                   - lock Actions from running
-- function Action:unlock()                 - unlock Actions so they can run
-- function Action:isLocked()               - returns true if the Action is locked
-- function Action:reset()                  - resets cool down and delay
-- function Action:finshedCast()            - true if has run and castTime has passed.
-- function Action:GCDelapsed()             - find out if global cool down has elapsed
-------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------
-- function MoveButtons:new()
-- function MoveButtons:addMove(GKey, MState, family, gameKey)
-- function MoveButtons:isMoving()
-- function MoveButtons:run(event, arg, family)
-- function MoveButtons:timeSinceChange()
------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
-- function MultiThread:new(f)      f - function(mt,...)   mt is the controlling MultiThread
-- function MultiThread:recreate()  kill existing coroutine and recreate
-- function MultiThread:isDead()    true if coroutine is dead or nil/false
-- function MultiThread:run(...)    run coroutine with variables don't include mt
-- function MultiThread:kill()      kill coroutine
-- function MultiThread:yield()     use in function(mt,...) to yield
--------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------
-- function Poll:new(family, delay)         delay is sleep time between polls
-- function Poll:run(event, arg, family)    handles events and performs the polling as long as it's running
-- function Poll:setMKeyModifier( m1, m2, m3, family )  Allows the use of Modifiers to change M pages
-- function Poll:start()                    turn on polling
-- function Poll:stop()                     stop polling
--      function Poll:_press()                  NOT TO BE USED
--      function Poll:release()                 NOT TO BE USED
--      function Poll:setMKeyState(MKeyState)   NOT TO BE USED
------------------------------------------------------------------------------------------------------------

function OnEvent(event, arg, family)
-- POLLING INITIATED HERE
    _GetRunningTime = GetRunningTime()
    if event == "PROFILE_ACTIVATED" then
        ClearLog()
        POLL = Poll:new(POLL_FAMILY, POLL_DELAY)
        POLL:start()
        _onActivation(event, arg, family)
    else
-- POLLING ROUTINES BELOW
        POLL:run(event,arg,family)
        _OnEvent(event, arg, family)  -- Runs myOnEvent to compartmentalize
    end
end

function log(...)
    OutputLogMessage(...)
end

function Type(v)
    if type(v) == "table" then
        if v.Type ~= nil then
            return v.Type
        end
    end
    return type(v)
end

------------------------------------------------------------------------------------------------------------
-- function Poll:new(family, delay)         delay is sleep time between polls
-- function Poll:run(event, arg, family)    handles events and performs the polling as long as it's running
-- function Poll:setMKeyModifier( m1, m2, m3, family )  Allows the use of Modifiers to change M pages
-- function Poll:start()                    turn on polling
-- function Poll:stop()                     stop polling
--      function Poll:_press()                   NOT TO BE USED
--      function Poll:release()                 NOT TO BE USED
--      function Poll:setMKeyState(MKeyState)   NOT TO BE USED
------------------------------------------------------------------------------------------------------------

Poll = {}
Poll.__index = Poll
Poll.__newindex = function(table, key, value)
    for k,v in pairs(table) do
        if k == key then
            rawset(table,key,value) return
        end
    end
    error("'" .. key .. "' is not a member of Poll.", 2)
end

function Poll:new(family, delay)
    local self = {}

    self.delay = delay or 50
    if family ~= "kb" and family ~= "lhc" then
        error("Poll:new() - 'pFamily' must be 'kb' or 'lhc'", 2)
    end
    self.pFamily = family
    self.presses = 0
    self.running = false
    self.runMKeyModifier = false
    self.MKeyModifier = { nil, nil, nil }   -- "default" or Modifiers. i.e. "lshift", "ctrl"
    self.modFamily = ""
    self.Type = "Poll"

    setmetatable(self, Poll)

    return self
end

--------------------------------------------------------------------------------------------
--  Poll:setMKeyModifier( m1, m2, m3, family )
--  Sets what modifiers will change you to the associated M page of the device on family
--  "shift", "ctrl", "alt", "lshift", "lctrl", "lalt"... are all modifiers
--  "default" is the page that will be set when none of the listed modifiers are pressed
--  "" will cause a page to be ignored.
--  I.E. - Poll:setMKeyModifier( "default", "shift", "ctrl", "lhc" )
--  will set the default page to m1, shift will change you to m2, ctrl to m3 on a left hand controler
--------------------------------------------------------------------------------------------
function Poll:setMKeyModifier( m1, m2, m3, family )
    self.runMKeyModifier = true
    self.MKeyModifier[1] = m1
    self.MKeyModifier[2] = m2
    self.MKeyModifier[3] = m3
    if family ~= "kb" and family ~= "lhc" then  error("Poll:setMKeyModifier() family - needs to be 'kb' or 'lhc'",2) end
    self.modFamily = family
end

function Poll:start()
    self.running = true
    self:setMKeyState()
end

function Poll:stop()
    self.running = false
end

function Poll:_press()
    if self.running then
        self.presses = self.presses + 1
    end
end

function Poll:release()
    if self.running then
        self.presses = self.presses - 1
    end
end

function Poll:setMKeyState()
    if self.runMKeyModifier then
        local default = nil
        local i = 1
        local modMKeyState = nil

        for i = 1, 3, 1 do
            if self.MKeyModifier[i] == "default" then
                default = i
            elseif self.MKeyModifier[i] == "" then
                -- do nothing
            elseif string.sub(self.MKeyModifier[i],1,2) == "mb" then
                local iMB = tonumber(string.sub(self.MKeyModifier[i],3,3))
                if IsMouseButtonPressed(iMB) then
                    modMKeyState = i
                end
            elseif IsModifierPressed(self.MKeyModifier[i]) then
                modMKeyState = i
            end
        end
        if modMKeyState == nil then
            modMKeyState = default
        end
        if modMKeyState ~= nil then
            if self.pFamily == self.modFamily then
                SetMKeyState(modMKeyState, self.pFamily)
                return
            elseif GetMKeyState(self.modFamily) ~= modMKeyState then
                SetMKeyState(modMKeyState, self.modFamily)
            end
        end
    end
    SetMKeyState( GetMKeyState(self.pFamily), self.pFamily )
end

function Poll:run(event, arg, family)
    if self.running and self.pFamily == family then
        if event == "M_PRESSED" then
            self:_press()
        elseif event == "M_RELEASED" then
            if self.presses == 1 then
                self:setMKeyState()
                Sleep(self.delay)
            end
            self:release()
        end
    end
end

--------------------------------------------------------------------------------------------
-- function MultiThread:new(f)      f - function(mt,...)   mt is the controlling MultiThread
-- function MultiThread:recreate()  kill existing coroutine and recreate
-- function MultiThread:isDead()    true if coroutine is dead or nil/false
-- function MultiThread:run(...)    run coroutine with variables don't include mt
-- function MultiThread:kill()      kill coroutine
-- function MultiThread:yield()     use in function(mt,...) to yield
--------------------------------------------------------------------------------------------

MultiThread = {}
MultiThread.__index = MultiThread
MultiThread.__newindex = function(table, key, value)
    for k,v in pairs(table) do
        if k == key then
            rawset(table,key,value) return
        end
    end
    error("'" .. key .. "' is not a member of MultiThread.", 2)
end

function MultiThread:new(f) -- f - function(MultiThread)
	local self = {}

	if type(f) ~= "function" then
		error("A function is needed",2)
	end
    self.func = f
    self.co = false
    self.Type = "MultiThread"

	setmetatable(self, MultiThread)
	return self
end

function MultiThread:recreate()
    if not self:isDead() then
        self:kill()
    end
    self.co = coroutine.create(self.func)
end

function MultiThread:isDead()
    if not self.co then
        return true
    end
	if coroutine.status(self.co) == "dead" then
        self.co = false
		return true
	end
    return false
end

function MultiThread:run(...)
	if self:isDead() then
        self:recreate()
    end
    coroutine.resume(self.co, self, ...)
end

function MultiThread:kill()
    if self.co then
        self.co = false       -- lua automatically deallocated
    end
end

function MultiThread:yield()
	if not self:isDead() then
		coroutine.yield()
	end
end

-------------------------------------------------------------------------------------------------------
-- function Action:new(func, delay, coolDown, varList, retList)
-- function Action:setAltInfo(cost, softLockable, castTime, gobalCoolDown)
--    - cost is for MMO mana/energy cost, softLockable is for locking a group of Actions
--    - castTime of spell, if different from delay
-- function Action:run()                    - runs an action and sets timeStamp
-- function Action:getReturnValues()        - gets values returned by run function
-- function Action:delayElapsed()            - true if delay has been achieved, or not run yet
-- function Action:coolDownElapsed()        - true if cool down has elapsed, or not run yet
-- function Action:hasRun()                 - true if action has completed function and set timeStamp
-- function Action:isRunning()              - true if run and not delayElapsed()
-- function Action.isAction(item)           - tests if item is an Action
-- function Action:lock()                   - lock Actions from running
-- function Action:unlock()                 - unlock Actions so they can run
-- function Action:isLocked()               - returns true if the Action is locked
-- function Action:reset()                  - resets cool down and delay
-- function Action:finshedCast()            - true if has run and castTime has passed.
-- function Action:GCDelapsed()             - find out if global cool down has elapsed
-------------------------------------------------------------------------------------------------------
Action = {}
Action.__index = Action
Action.__newindex = function(table, key, value)
    for k,v in pairs(table) do
        if k == key then
            rawset(table,key,value) return
        end
    end
    error("'" .. key .. "' is not a member of Action.", 2)
end

function Action:new(func, delay, coolDown, varList, retList)
    local self = {}

    if type(func) ~= "function" then error("Action:new() func - requires a function",2) end
    self.func = func

    if type(delay) ~= "number" then error("Action:new()- delay - requires a number",2) end
    self.delay = delay

    if type(coolDown) ~= "number" then error("Action:new()- coolDown - requires a number",2) end
    self.coolDown = coolDown

    if varList ~= nil then
        if type(varList) ~= "table" then error("Action:new()- varList - requires a table or nil",2) end
        self.varList = varList
    else
        self.varList = {}
    end

    if retList ~= nil then
        if type(retList) ~= "table" then error("Action:new()- retList - requires a table or nil",2) end
        self.retList = retList
    else
        self.retList = {}
    end
    self.timeStamp = false
    self.Type = "Action"
    self.locked = false
    self.cost = false
    self.softLockable = false
    self.softLocked = false
    self.castTime = delay
    self.gcd = delay

    setmetatable(self, Action)
    return self
end

function Action:setAltInfo(cost, softLockable, castTime, globalCoolDown)
    if cost ~= nil then
        self.cost = cost
    end
    if softLockable ~= nil then
        self.softLockable = softLockable
    end
    if castTime ~= nil then
        self.castTime = castTime
    end
    if globalCoolDown ~= nil then
        self.gcd = globalCoolDown
    end
end

function Action:finshedCast()
    if self:hasRun() and (_GetRunningTime - self.timeStamp) >= self.castTime then
        return true
    end
    return false
end

function Action:reset()
    self.timeStamp = false
end

function Action:lock()
    self.locked = true
end

function Action:unlock()
    self.locked = false
end

function Action:isLocked()
    if self.locked or (self.softLockable and self.softLocked) then
        return true
    end
    return false
end

function Action:setSoftLock(lockOn)
    self.softLocked = lockOn
end

function Action:run()
    if not self.locked and not (self.softLockable and self.softLocked) then
        local r = { self.func(unpack(self.varList)) }
        local n = table.maxn(r)

        for i = 1, n, 1 do
            self.retList[i] = r[i] -- fill retList with returned values
        end
        self.timeStamp = _GetRunningTime
    end
end

function Action:getReturnValues()
    return unpack(self.retList)
end

function Action:delayElapsed()
    if not self.timeStamp then   -- Action has not yet run, return true
        return true
    elseif (_GetRunningTime - self.timeStamp) >= self.delay then
        return true
    end
    return false
end

function Action:GCDelapsed()
    if not self.timeStamp then   -- Action has not yet run, return true
        return true
    elseif (_GetRunningTime - self.timeStamp) >= self.gcd then
        return true
    end
    return false
end

function Action:isRunning()
    if not self.timeStamp then
        return false
    end
    if self:hasRun() and (_GetRunningTime - self.timeStamp) < self.delay then
        return true
    end
    return false
end

function Action:coolDownElapsed()
    if not self.timeStamp then  -- if no action has yet been performed, return true
        return true
    end
    if (_GetRunningTime - self.timeStamp) >= self.coolDown then
        return true
    end
    return false
end

function Action:hasRun()
    if self.timeStamp then
        if self.timeStamp > 0 then
            return true
        end
    end
    return false
end

function Action.isAction(item)
    if type(item) == "table" then
        if item.type == "Action" then
            return true
        end
    else
        return false
    end
end

------------------------------------------------------------------------------------------------------------------------
-- function Macro:new(name, isRepeating, isInterruptable, ...)  -- ... can be an unlimited amount of Actions
-- function Macro:addAction(action)     -- add an action to the end of a Macro
-- function Macro:start()   -- flags macro so that Macro:run() will perform actions
-- function Macro:stop()    -- flags macro to stop.  It will finish running macro if not interruptable
-- function Macro:run()     -- will attempt to run a macro if flagged to by Macro:start()
-- function Macro:isRunning()  -- will return true if macro is running.  If flagged to stop, but not finished, it's true
-- function Macro:delayElapsed()    -- if delay after macro finished, has elapsed
-- function Macro:setCoolDown(coolDown) -- set coolDown before a Macro can be run again. Use with PriorityHandler
-- function Macro:setDelay(delay)   -- set a delay between reuse of a Macro or another Action. Use with PriorityHandler
-- function Macro:lock()            -- if locked, Macro will not run, even if Macro:start() is on.
-- function Macro:unlock()
-- function Macro:isLocked()
-- function Macro:reset()           -- resets coolDown and delay and kills Macro if running.
--      function Macro.RunThread(mt, self)   -- NOT TO BE USED
------------------------------------------------------------------------------------------------------------------------

Macro = {}
Macro.__index = Macro
Macro.__newindex = function(table, key, value)
    for k,v in pairs(table) do
        if k == key then
            rawset(table,key,value) return
        end
    end
    error("'" .. key .. "' is not a member of Macro.", 2)
end

function Macro:new(name, isRepeating, isInterruptable, ...)  -- ... can be an unlimited amount of Actions
    local self = {}

    if type(name) ~= "string" then error("Macro:new() name - requires a macro name",2) end
    self.name = name

    if type(isRepeating) ~= "boolean" then error("Macro:new() isRepeating - requires boolean (true/false)",2) end
    self.repeating = isRepeating

    if type(isInterruptable) ~= "boolean" then error("Macro:new() isInterruptable - requires boolean (true/false)",2) end
    self.interruptable = isInterruptable

    self.action = { unpack(arg) }
    self.numActions = table.maxn(self.action) or 0
    self.running = false
    self.mt = MultiThread:new(Macro.RunThread)
    self.delay = 0
    self.coolDown = 0
    self.timeStamp = false
    self.Type = "Macro"
    self.locked = false

    setmetatable(self, Macro)
    return self
end

function Macro:reset()
    if self:isRunning() then
        self.mt:kill()
    end
    self.timeStamp = false
end

function Macro:lock()
    self.locked = true
end

function Macro:unlock()
    self.locked = false
    if not self.interruptable then  -- recreating forces it to start from the top
        self.mt:kill()
    end
end

function Macro:isLocked()
    return self.locked
end

function Macro:setCoolDown(coolDown)
    self.coolDown = coolDown
end

function Macro:setDelay(delay)
    self.delay = delay
end

function Macro:delayElapsed()
    if not self.timeStamp then   -- Action has not yet run, return true
        return true
    elseif (_GetRunningTime - self.timeStamp) >= self.delay then
        return true
    end
    return false
end

function Macro:coolDownElapsed()
    if not self.timeStamp then  -- if no action has yet been performed, return true
        return true
    end
    if (_GetRunningTime - self.timeStamp) >= self.coolDown then
        return true
    end
    return false
end

function Macro:hasRun()
    if self.timeStamp then
        return true
    end
    return false
end

function Macro:start()
    self.running = true
    if not self.interruptable then  -- recreating forces it to start from the top
        self.mt:recreate()
    end
end

function Macro:stop()
    self.running = false
end

function Macro:run()
    if not self:isLocked() and self:isRunning() then
        self.mt:run(self)
    end
end

function Macro:isRunning()
    if self.running or (not self.interruptable and not self.mt:isDead()) then
        return true
    elseif not self.interruptable and not self:delayElapsed() then
        return true
    end
    return false
end

function Macro:addAction(a)
    self.numActions = self.numActions + 1

    if Type(a) == "Action" then
        self.action[self.numActions] = a
    else
        error("Macro:addAction(a) 'a' must be an Action",2)
    end
end

function Macro.RunThread(mt, self)
    local i = 0

    if self.running then
        for i = 1, self.numActions, 1 do
            if self.action[i]:coolDownElapsed() then
                self.action[i]:run()
                while not self.action[i]:delayElapsed() do
                    mt:yield()
                end
            end
        end
        if not self.repeating then
            self:stop()
        end
        self.timeStamp = _GetRunningTime
    end
end


----------------------------------------------------------------------------------------------------------------------
-- function EventKey:new(GKey, MState, family)  -- MState can be nil 1 2 or 3 (nil for all pages), family = 'kb' or 'lhc'
-- function EventKey:setWhilePressedItem(item)  - item can be a Macro only
-- function EventKey:setToggleItem(item)        - item can be a Macro only
-- function EventKey:setPressedItem(item)       - item can be a Macro or an Action
-- function EventKey:setReleasedItem(item)      - item can be a Macro or an Action
-- function EventKey:setToggleOnItem(item)      - item can be a Macro or an Action
-- function EventKey:setToggleOffItem(item)     - item can be a Macro or an Action
-- function EventKey:handleEvent(event,arg,family)  -- will process events and set flags
-- function EventKey:checkEvent(event,arg,family)   -- checks if event for key and press or release self.pressed
-- function EventKey:isPressed()                    -- returns true if key is currently pressed
-- function EventKey.runItem(item)                  -- run a single Macro or Action
-- function EventKey.stopItem(item)                 -- stops a macro, ignores Actions
-- function EventKey:runMacros()    -- run all macros associated with the EventKey (if flagged stopped, they don't run)
-- function EventKey:run(event,arg,family)      - handles events and runs macros
-- function EventKey:getDoubleClickDelay()
-- function EventKey:clearDoubleClick()
-- EventKey:isToggleOn()    -- returns true if toggle is on.
-----------------------------------------------------------------------------------------------------------------------

EventKey = {}
EventKey.__index = EventKey
EventKey.__newindex = function(table, key, value)
    for k,v in pairs(table) do
        if k == key then
            rawset(table,key,value) return
        end
    end
    error("'" .. key .. "' is not a member of EventKey.", 2)
end

function EventKey:new(GKey, MState, family)
    local self = {}

    self.GKey = GKey
    if MState then
        if MState < 1 or MState > 3 then
            error("EventKey:new() - 'MState' must be nil for all M states, or 1 - 3 for M1, M2 or M3.", 2)
        end
        self.MState = MState
    else
        self.MState = nil
    end
    if family ~= "kb" and family ~= "lhc" then
        error("EventKey:new() - 'family' must be 'kb' or 'lhc'", 2)
    end
    self.family = family
    self.keyPressed = false

    self.whilePressedItem = false
    self.toggleItem = false
    self.pressedItem = false
    self.releasedItem = false
    self.toggleOnItem = false
    self.toggleOffItem = false

    self.pressed = false
    self.toggle = false
    self.Type = "EventKey"
    self.releasedTimeStamp = false
    self.doubleClickDelay = false
    self.isDoubleClickResetable = false

    setmetatable(self, EventKey)
    return self
end

function EventKey:clearDoubleClick()
    self.releasedTimeStamp = false
    self.doubleClickDelay = false
end

function EventKey:getDoubleClickDelay()
    if self.doubleClickDelay then
        return self.doubleClickDelay
    end
    return false
end

function EventKey:isToggleOn()
    if self.toggle then
        return true
    else
        return false
    end
end

function EventKey:setWhilePressedItem(item)
    if Type(item) == "Macro" then
        self.whilePressedItem = item
    else
        error("EventKey:setWhilePressedItem(item)  item must be a Macro",2)
    end
end

function EventKey:setToggleItem(item)
    if Type(item) == "Macro" then
        self.toggleItem = item
    else
        error("EventKey:setToggleItem(item)  item must be a Macro",2)
    end
end

function EventKey:setPressedItem(item)
    if Type(item) == "Action" or Type(item) == "Macro" then
        self.pressedItem = item
    else
        error("EventKey:setPressedItem(item)  item must be a Macro or an Action",2)
    end

    if Type(item) == "Macro" and item.repeating then
        error("EventKey:setPressedItem(item) item cannot be a repeating Macro",2)
    end
end

function EventKey:setReleasedItem(item)
    if Type(item) == "Action" or Type(item) == "Macro" then
        self.releasedItem = item
    else
        error("EventKey:setReleasedItem(item)  item must be a Macro or an Action",2)
    end

    if Type(item) == "Macro" and item.repeating then
        error("EventKey:setReleasedItem(item) item cannot be a repeating Macro",2)
    end
end

function EventKey:setToggleOnItem(item)
    if Type(item) == "Action" or Type(item) == "Macro" then
        self.toggleOnItem = item
    else
        error("EventKey:setToggleOnItem(item)  item must be a Macro or an Action",2)
    end

    if Type(item) == "Macro" and item.repeating then
        error("EventKey:setToggleOnItem(item) item cannot be a repeating Macro",2)
    end
end

function EventKey:setToggleOffItem(item)
    if Type(item) == "Action" or Type(item) == "Macro" then
        self.toggleOffItem = item
    else
        error("EventKey:setToggleOffItem(item)  item must be a Macro or an Action",2)
    end

    if Type(item) == "Macro" and item.repeating then
        error("EventKey:setToggleOffItem(item) item cannot be a repeating Macro",2)
    end
end

function EventKey:isPressed()
    return self.pressed
end

function EventKey.runItem(item)
    if Type(item) == "Macro" then
        item:start()
    elseif Type(item) == "Action" then
        item:run()
    end
end

function EventKey.stopItem(item)
    if Type(item) == "Macro" then
        item:stop()
    elseif Type(item) == "Action" then
        OutputLogMessage("EventKey.stopItem(item) item is Action, nothing to stop()\n")
    end
end

function EventKey:checkEvent(event,arg,family)
    if self.GKey == arg and self.family == family then
        if event == "G_RELEASED" then   -- Release events need to take place regardless of M state
            self.pressed = false
            self.releasedTimeStamp = _GetRunningTime
            return true
        end
        if self.MState then
            if self.MState ~= GetMKeyState(self.family) then
                return false
            end
        end
    else
        return false
    end
    if event == "G_PRESSED" then
        if self.releasedTimeStamp then
            self.doubleClickDelay = _GetRunningTime - self.releasedTimeStamp
        end
        self.pressed = true
        return true
    end
    return false
end

function EventKey:handleEvent(event,arg,family)
    if not self:checkEvent(event,arg,family) then
        return false
    end
    if event == "G_PRESSED" then
        self.toggle = not self.toggle
        if self.whilePressedItem then
            EventKey.runItem(self.whilePressedItem)
        end
        if self.toggleItem then
            if self.toggle then
                EventKey.runItem(self.toggleItem)
            else
                EventKey.stopItem(self.toggleItem)
            end
        end
        if self.pressedItem then
            EventKey.runItem(self.pressedItem)
        end
        if self.toggleOnItem then
            if self.toggle then
                EventKey.runItem(self.toggleOnItem)
            else
                EventKey.runItem(self.toggleOffItem)
            end
        end
    elseif event == "G_RELEASED" then
        if self.whilePressedItem then
            EventKey.stopItem(self.whilePressedItem)
        end
        if self.releasedItem then
            EventKey.runItem(self.releasedItem)
        end
    end

    return true
end

function EventKey:runMacros()
    if Type(self.whilePressedItem) == "Macro" then self.whilePressedItem:run() end
    if Type(self.toggleItem) == "Macro" then self.toggleItem:run() end
    if Type(self.pressedItem) == "Macro" then self.pressedItem:run() end
    if Type(self.releasedItem) == "Macro" then self.releasedItem:run() end
    if Type(self.toggleOnItem) == "Macro" then self.toggleOnItem:run() end
    if Type(self.toggleOffItem) == "Macro" then self.toggleOffItem:run() end
end

function EventKey:run(event,arg,family)
    self:handleEvent(event,arg,family)
    self:runMacros()
end

----------------------------------------------------------------------------------------------------------
-- function PriorityHandler:new(doubleClickDelay)   doubleClickDelay = max time between clicks for resetting ability. default is 250
-- function PriorityHandler:addItem(GKey, MState, family, item, isDoubleClickResetable) - add an item to the priority queue
-- function PriorityHandler:handleEvent(event,arg,family) - delivers events to each Action/Macro in queue
-- function PriorityHandler:run(event,arg,family) - handles events and runs RunThread
-- function PriorityHandler.RunThread(mt,self) - runs all actions in order of priority.
-- function PriorityHandler:start()     - flags run to allow it to run
-- function PriorityHandler:stop()      - flags run to stop
-- function PriorityHandler:setSoftLock(lockOn)
----------------------------------------------------------------------------------------------------------

PriorityHandler = {}
PriorityHandler.__index = PriorityHandler
PriorityHandler.__newindex = function(table, key, value)
    for k,v in pairs(table) do
        if k == key then
            rawset(table,key,value) return
        end
    end
    error("'" .. key .. "' is not a member of PriorityHandler.", 2)
end

function PriorityHandler:new(doubleClickDelay)
    local self = {}

    self.event = {}
    self.running = false
    self.numItems = 0
    self.mt = MultiThread:new(PriorityHandler.RunThread)
    self.Type = "PriorityHandler"
    self.resetable = false

    if doubleClickDelay ~= nil then
        self.doubleClickDelay = doubleClickDelay
    else
        self.doubleClickDelay = 250
    end
    self.softLock = false

    setmetatable(self, PriorityHandler)
    return self
end

function PriorityHandler:setSoftLock(lockOn)
    if lockOn ~= self.softLock then
        self.softLock = lockOn
        for i = 1, self.numItems, 1 do
            if Type(self.event[i].pressedItem) == "Action" then
                self.event[i].pressedItem:setSoftLock(lockOn)
                if self.event[i].pressedItem:isLocked() then
                    if self.event[i].pressedItem:isRunning() and not self.event[i].pressedItem:finshedCast() then -- if it's not finshed casting, then the GCD hasn't acted, so restart
                        self.event[i].pressedItem:reset()
                        self.mt:recreate()
                    end
                end
            end
        end
    end
end

function PriorityHandler:addItem(GKey, MState, family, item, isDoubleClickResetable)
    if Type(item) == "Macro" or Type(item) == "Action" then
        if Type(item) == "Macro" then
            if item.isInterruptable then
                error("function PriorityHandler:addItem(key, keyType, family, item) can't be interruptable Macro",2)
            end
        end
        if MState then
            if MState < 1 or MState > 3 then
                error("PriorityHandler:addItem(GKey, MState, family, item) - 'MState' must be nil for all M states, or 1 - 3 for M1, M2 or M3.", 2)
            end
        end
        if family ~= "kb" and family ~= "lhc" then
            error("PriorityHandler:addItem(GKey, MState, family, item) - 'family' must be 'kb' or 'lhc'", 2)
        end

        self.numItems = self.numItems + 1
        self.event[self.numItems] = EventKey:new(GKey, MState, family)
        self.event[self.numItems]:setPressedItem(item)
        if isDoubleClickResetable ~= nil then
            self.event[self.numItems].isDoubleClickResetable = isDoubleClickResetable
        end
    else
        error("PriorityHandler:addItem(GKey, MState, family, item) item must be a Macro or Action",2)
    end
end

function PriorityHandler:handleEvent(event,arg,family)
    local i = 1

    for i = 1, self.numItems, 1 do
        self.event[i]:checkEvent(event,arg,family)
        if self.event[i]:getDoubleClickDelay() and self.event[i].isDoubleClickResetable then
            if self.event[i]:getDoubleClickDelay() < self.doubleClickDelay then
                self.event[i].pressedItem:reset()
                self.mt:recreate()
            end
            self.event[i]:clearDoubleClick()
        end
    end
end

function PriorityHandler.RunThread(mt,self)
    local i = 0

    if self.running then
        for i = 1, self.numItems, 1 do
            if self.event[i]:isPressed() then
                if self.event[i].pressedItem:coolDownElapsed() and not self.event[i].pressedItem:isLocked() then
                    if Type(self.event[i].pressedItem) == "Macro" then
                        self.event[i].pressedItem:start()
                        self.event[i].pressedItem:run()
                        self.event[i].pressedItem:stop()
                    else
                        self.event[i].pressedItem:run()
                    end
                    local wasLocked = false     -- in case it was locked at any time during the wait, it will stop
                    while self.event[i].pressedItem:isRunning() do
                        if Type(self.event[i].pressedItem) == "Action" then
                            if self.event[i].pressedItem:isLocked() then    -- a lock has occured, remember this while waiting on GCD
                                wasLocked = true
                            end
                            if wasLocked and self.event[i].pressedItem:GCDelapsed() then
                                break
                            end
                        end
                        mt:yield()
                    end
                    return
                end
            end
        end
    end
end

function PriorityHandler:start()
    self.running = true
end

function PriorityHandler:stop()
    self.running = false
end

function PriorityHandler:run(event,arg,family)
    self:handleEvent(event,arg,family)
    if self.running then
        self.mt:run(self)
    end
end

_GetRunningTime = 0


------------------------------------------------------------------------------------------------------------
-- function MoveButtons:new()
-- function MoveButtons:addMove(GKey, MState, family, gameKey)
-- function MoveButtons:isMoving()
-- function MoveButtons:run(event, arg, family)
-- function MoveButtons:timeSinceChange()
------------------------------------------------------------------------------------------------------------

MoveButtons = {}
MoveButtons.__index = MoveButtons
MoveButtons.__newindex = function(table, key, value)
    for k,v in pairs(table) do
        if k == key then
            rawset(table,key,value) return
        end
    end
    error("'" .. key .. "' is not a member of Ability.", 2)
end

function MoveButtons:new()
    local self = {}

    self.move = {}
    self.numMoves = 0
    self.timeStamp = 0
    self.MState = 0
    self.Type = "MoveButtons"

    setmetatable(self, MoveButtons)

    return self
end

function MoveButtons:timeSinceChange()
    return _GetRunningTime - self.timeStamp
end

-- GKeys can be "UP", "DOWN", "LEFT", "RIGHT" for joystick directions or a # for normal GKey
-- gameKey is the key that will be pressed in game when the associated GKey is pressed.
-- MState can be 1-3 or nil.  nil will work on all MStates
function MoveButtons:addMove(GKey, MState, family, gameKey)
    self.numMoves = self.numMoves + 1
    self.move[self.numMoves] = {}
    self.move[self.numMoves].gameKey = gameKey
    self.move[self.numMoves].pressed = false

    if family ~= "lhc" and family ~= "kb" then
        error("MoveButtons:addMove(GKey, MState, family, gameKey) 'family' must be 'lhc' or 'kb'",2)
    end
    self.move[self.numMoves].family = family

    if MState ~= nil then
        if Type(MState) ~= "number" then
            error("MoveButtons:addMove(GKey, MState, family, gameKey) 'MState' must be a number from 1 to 3 or nil",2)
        elseif MState >= 1 and MState <= 3 then
            self.move[self.numMoves].MState = MState
        else
            error("MoveButtons:addMove(GKey, MState, family, gameKey) 'MState' must be a number from 1 to 3 or nil",2)
        end
    else
        self.move[self.numMoves].MState = 0
    end

    if Type(GKey) == "number" then
        self.move[self.numMoves].GKey = GKey
    elseif Type(GKey) == "string" then
        if GKey == "UP" then
            self.move[self.numMoves].GKey = 26
        elseif GKey == "DOWN" then
            self.move[self.numMoves].GKey = 28
        elseif GKey == "LEFT" then
            self.move[self.numMoves].GKey = 29
        elseif GKey == "RIGHT" then
            self.move[self.numMoves].GKey = 27
        else
            error("MoveButtons:addMove(GKey, MState, family, gameKey) 'GKey' must be a number or 'UP', 'DOWN', 'LEFT', 'RIGHT'",2)
        end
    else
        error("MoveButtons:addMove(GKey, MState, family, gameKey) 'GKey' must be a number or 'UP', 'DOWN', 'LEFT', 'RIGHT'",2)
    end
end

function MoveButtons:isMoving()
    local move = false

    for i=1, self.numMoves, 1 do
        if self.move[i].pressed then
            move = true
            break
        end
    end
    return move
end

function MoveButtons:run(event, arg, family)
    local wasMoving = self:isMoving()
    local _GetMKeyState = nil

    if family ~= "" then
        _GetMKeyState = GetMKeyState(family)
    else
        return
    end

    for i=1, self.numMoves, 1 do
        if self.move[i].family == family then
            if event == "G_PRESSED" then
                if arg == self.move[i].GKey and (self.move[i].MState == _GetMKeyState or self.move[i].MState == 0) then
                    self.move[i].pressed = true
                    PressKey(self.move[i].gameKey)
                end
            elseif event == "G_RELEASED" then
                if arg == self.move[i].GKey then
                    self.move[i].pressed = false
                    ReleaseKey(self.move[i].gameKey)
                end
            end
        end
    end

    if wasMoving ~= self:isMoving() then
        self.timeStamp = _GetRunningTime
    end
end