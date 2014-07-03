-----------------------------------------------------------------------------------------
--
-- Bird.lua
--
-----------------------------------------------------------------------------------------
require ("luoop")

--- Constructor ---
local function new(self)
end

--- Class Definition ---
Bird = class(new)
Bird:enableSingleton()

--- Destructor ---
function Bird:destroy()
end

--- Getters / Setters ---

-- Other methods
function Bird:type()
    return 'Bird'
end

function Bird:toString()
    return 'I am the singleton bird'
end
