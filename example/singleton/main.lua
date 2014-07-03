-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require ("luoop")

require ("bird")

-- Creating a singleton bird
local oBird = Bird.newSingleton() -- Getting a singleton object
local oSameBird = Bird.newSingleton() -- Getting the same singleton object

Bird.destroySingleton() -- Reseting the singleton for class bird (so that the next newSingleton yields a new instance)
oSameBird = nil
oBird = nil

-- Creating a new singleton bird
local oNewBird = Bird.newSingleton() -- Not the same object as above
oNewBird:destroySingleton() -- Reseting the singleton for object from class bird (both notations work)
oNewBird = nil
