-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require ("luoop") -- class system

require ("father")
require ("mother")
require ("child")

-- Instantiating all objects
local oFather = Father(1) -- Giving father an id of 1
print (oFather:type()) -- Will print 'Father'
print (oFather:_getId()) -- Will print 1

local oMother = Mother(false) -- Making mother unhappy :(
print (oMother:type()) -- Will print 'Mother'
print (oMother:_getHappy()) -- Will print false

-- Child object
local oChild = Child('green') -- Making the child green
print (oChild:type()) -- Will print 'Child', type is overloaded
print (oChild:toString()) -- Will print 'I am a child'
print (oChild:_getId()) -- Will print 5
print (oChild:_getHappy()) -- The child made the mother class happy :)

-- Making a reddish unhappy child :()
oChild:_setColor('red')
oChild:_setHappy(false)
print (oChild:_getColor()) -- Will print 'Red'
print (oChild:_getHappy()) -- Will print false

