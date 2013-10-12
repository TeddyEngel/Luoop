-----------------------------------------------------------------------------------------
--
-- Mother.lua
--
-----------------------------------------------------------------------------------------
require ("luoop") -- class system

-- Constructor
local function new(self, bHappy)
	-- Making the mom happy
	self:_setHappy(bHappy)
end

-- Class definition
Mother = class(new)

-- Destructor
function Mother:destroy(bHappy)
	self:_setHappy(bHappy)
end

-- Getters / Setters
function Mother:_getHappy()
	return self._bHappy
end

function Mother:_setHappy(bHappy)
	self._bHappy = bHappy
end

-- Other methods
function Mother:type()
	return 'Mother'
end

function Mother:toString()
	return 'I am the mom'
end


