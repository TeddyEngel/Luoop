-----------------------------------------------------------------------------------------
--
-- Child.lua
--
-----------------------------------------------------------------------------------------
require ("luoop")
require ("father") -- parent class

--- Constructor ---
local function new(self, sColor)
	-- Always call the parent constructor first
	self:_parentConstructor(Father, 5) -- Passing an argument to the father constructor

	-- Assigning a color
	self:_setColor(sColor)
end

--- Class Definition ---
Child = class(new, Father)

--- Destructor ---
function Child:destroy()
	self:_setColor(nil)

	-- Always call the destructors last
	self:_parentDestructor(Father)
end

--- Getters / Setters ---
function Child:_getColor()
	return self._sColor
end

function Child:_setColor(sColor)
	self._sColor = sColor
end

function Child:type()
	return 'Child'
end

function Child:toString()
	return 'I am a child'
end

function Child:toParentString()
	return self:_parentMethod(Father, 'toString')
end
