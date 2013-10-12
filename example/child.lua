-----------------------------------------------------------------------------------------
--
-- Child.lua
--
-----------------------------------------------------------------------------------------
require ("luoop") -- class system
require ("father") -- parent class
require ("mother") -- parent class

-- Constructor
local function new(self, sColor)
	-- Always call the parent constructor first
	callConstructor(self, Father, 5)
	callConstructor(self, Mother, true)

	-- Assigning a color
	self:_setColor(sColor)
end

-- Class definition
Child = class(new, Father, Mother)

-- Destructor
function Child:destroy()
	self:_setColor(nil)

	-- Always call the destructors last
	callDestructor(self, Mother, false)
	callDestructor(self, Father)
end

-- Getters / Setters
function Child:_getColor()
	return self._sColor
end

function Child:_setColor(sColor)
	self._sColor = sColor
end

-- Overloaded methods
function Child:type()
	return 'Child'
end

function Child:toString()
	return 'I am a child'
end

