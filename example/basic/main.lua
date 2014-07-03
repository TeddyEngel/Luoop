-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require ("luoop")

require ("child")

-- Simple object instantiation
local oChild = Child('green') -- Making the child green

-- Calling methods
print (oChild:type()) -- Will print 'Child'
print (oChild:toString()) -- Will print 'I am a child'
print (oChild:getColor()) -- Will print 'green'

oChild:setColor('yellow') -- Assigning a new color
print (oChild:getColor()) -- Will print 'yellow'

-- Destroying child object
oChild:destroy()
oChild = nil
