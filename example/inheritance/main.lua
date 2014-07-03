-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require ("luoop")

require ("father")
require ("child")

-- Parent Object
local oFather = Father(1) -- Giving father an id of 1
print (oFather:type()) -- Will print 'Father'
print (oFather:_getId()) -- Will print 1
print (oFather:toString()) -- Will print 'I am the dad'

-- Child object, inheriting from Father
local oChild = Child('green') -- Making the child green
print (oChild:type()) -- Will print 'Child' since type is overloaded
print (oChild:toString()) -- Will print 'I am a child'
print (oChild:toParentString()) -- Will print 'I am dad', calling toString from the parent class (Father)
print (oChild:_getId()) -- Will print 5

-- Destroying child object
oChild:destroy()
oChild = nil

-- Destroying parent object
oFather:destroy()
oFather = nil