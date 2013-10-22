-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require ("luoop")

require ("father")
require ("mother")
require ("child")
require ("bird")

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

-- Making a yellow child
oChild:_setColor('yellow')
print (oChild:_getColor()) -- Will print 'yellow'

-- Creating a singleton bird
local oBird = Bird.newSingleton() -- Getting a singleton
local oSameBird = Bird.newSingleton() -- Getting the same singleton

Bird.destroySingleton() -- Reseting the singleton (so that the next newSingleton yields a new instance)
oSameBird = nil
oBird = nil