a = {}
b = {__mode = "k"}
setmetatable(a, b) -- now 'a' has weak keys
key = {} -- creates first key
a[key] = 1
key = {} -- creates second key
a[key] = 2
collectgarbage() -- forces a garbage collection cycle
for k, v in pairs(a) do print(v) end

--[[
	In this example, the second assignment key={} overwrites the rst key. When
	the collector runs, there is no other reference to the rst key, so it is collected
	and the corresponding entry in the table is removed. The second key, however,
	is still anchored in variable key, so it is not collected.
]]





