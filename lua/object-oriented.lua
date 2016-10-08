----------------------
--class Account
----------------------
Account = {balance = 0}

function Account:new (o)
	o = o or {} -- create table if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function Account:withdraw (v)
	if v > self.balance then error"insufficient funds" end
	self.balance = self.balance - v
end

function Account:deposit (v)
	self.balance = self.balance + v
end
----------------------
--SpecialAccount inherits new from Account like any other method
----------------------
SpecialAccount = Account:new()	

function SpecialAccount:withdraw (v)
	if v - self.balance >= self:getLimit() then
	error"insufficient funds"
	end
	self.balance = self.balance - v
end

function SpecialAccount:getLimit ()
	return self.limit or 0
end


--[[
function s:getLimit ()
	return self.balance * 0.10
end
--]]
--[[
After the above declaration, the call s:withdraw(200.00) runs the withdraw method
from SpecialAccount, but when withdraw calls self:getLimit, it is this last
denition that it invokes.
--]]
----------------------
--class Named
----------------------
Named = {}

function Named:getname ()
	return self.name
end
function Named:setname (n)
	self.name = n
end
-------------------------
--An implementation of Multiple Inheritance:
----------------------
-- look up for 'k' in list of tables 'plist'
local function search (k, plist)
	for i=1, #plist do
	local v = plist[i][k] -- try 'i'-th superclass
	if v then return v end
	end
end

function createClass (...)
	local c = {} -- new class
	local parents = {...}
	-- class will search for each method in the list of its parents
	setmetatable(c, {__index = function (t, k)
		return search(k, parents)
	end})
	-- prepare 'c' to be the metatable of its instances
	c.__index = c
	-- define a new constructor for this new class
	function c:new (o)
		o = o or {}
		setmetatable(o, c)
		return o
	end
	return c -- return new class
end
----------------------
--[[
To create a new class NamedAccount that is a subclass of both Account and Named,
we simply call createClass:
--]]
NamedAccount = createClass(Account, Named)
----------------------
--create new accounts
----------------------
a = Account:new{balance = 0}
b = Account:new()
s = SpecialAccount:new{limit=1000.00}
t = NamedAccount:new{name = "Paul"}
--use methods
a:deposit(100.00)
a:withdraw(10.00)
s:deposit(100.00)
s:withdraw(200.00)
--get output
print(a.balance) 
print(b.balance)
print(s.balance)
print(t:getname()) 