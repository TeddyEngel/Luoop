-----------------------------------------------------------------------------------------
--
-- Father.lua
--
-----------------------------------------------------------------------------------------
require ("luoop")

--- Constructor ---
local function new(self, nId)
	-- Assigning an id
	self:_setId(nId)
end

--- Class Definition ---
Father = class(new)

--- Destructor ---
function Father:destroy()
	self:_setId(nil)
end

--- Getters / Setters ---
function Father:_getId()
	return self._nId
end

function Father:_setId(nId)
	self._nId = nId
end

-- Methods
function Father:type()
	return 'Father'
end

function Father:toString()
	return 'I am the dad'
end
