-----------------------------------------------------------------------------------------
--
-- Child.lua
--
-----------------------------------------------------------------------------------------
require ("luoop")

--- Constructor ---
local function new(self, sColor)
	-- Assigning a color
	self:_setColor(sColor)
end

--- Class Definition ---
Child = class(new)

--- Destructor ---
function Child:destroy()
	self:_setColor(nil)
end

--- Getters / Setters ---

-- Privates
function Child:_getColor()
	return self._sColor
end

function Child:_setColor(sColor)
	self._sColor = sColor
end

-- Public
function Child:getColor()
	return self:_getColor()
end

function Child:setColor(sColor)
	self:_setColor(sColor)
end

function Child:type()
	return 'Child'
end

function Child:toString()
	return 'I am a child'
end