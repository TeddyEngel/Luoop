-----
-- Luoop - easy and flexible object oriented library for Lua
-- Author: Teddy Engel <engel.teddy[at]gmail.com> / @Teddy_Engel
-- Version: 1.2
--
-- This is an implementation of a object-oriented Lua module, coded entirely in Lua.
-- It is meant to be simple and flexile, since the main initial requirement was multiple inheritance and overloading + the ability
-- to call constructors / destructors with custom parameters.
--
-- MIT License (MIT)
-- Copyright (c) 2013 Teddy Engel

-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
-- the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
-- FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
-- COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
-- IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-- CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--

--- PRIVATE FUNCTIONS ---
local function _createSuperclass(oClassDefinition, oSuperclass)
   assert(type(oSuperclass) == 'table', '_createSuperclass expects a valid superclass')
   assert(oSuperclass.init, '_createSuperclass expects a superclass with a constructor defined')
   
   -- We copy all methods / variables from the superclass to the current class
   for sMethodName, oMethod in pairs(oSuperclass) do
      -- Exceptions for internally used variables
      if sMethodName ~= '__aParents'
         and sMethodName ~= '__aAllParents'
         and sMethodName ~= '__index' 
         and sMethodName ~= '__bSingleton' 
         and sMethodName ~= 'isSingleton' 
         and sMethodName ~= 'enableSingleton' 
         and sMethodName ~= 'disableSingleton' 
         and sMethodName ~= 'newSingleton' 
         and sMethodName ~= 'destroySingleton' then
         oClassDefinition[sMethodName] = oMethod
      end
   end

   if oSuperclass.__aAllParents then
      for oParentKey, oParentValue in pairs(oSuperclass.__aAllParents) do
         oClassDefinition.__aAllParents[oParentKey] = oParentValue
      end
   end
   oClassDefinition.__aAllParents[oSuperclass] = oSuperclass
   oClassDefinition.__aParents[oSuperclass] = oSuperclass
end

--- MAIN CALL ---
function class(init, ...)
   local oSuperClasses = {...}
   local oClassDefinition = {}    -- a new class instance

   -- Parameter to say if the class is a singleton or not
   oClassDefinition.__bSingleton = false
   -- Array to store the superclasses directly above this one
   oClassDefinition.__aParents = {}
   -- Array to store the full hierarchy of superclasses
   oClassDefinition.__aAllParents = {}
   
   -- Creating all superclasses
   for oKey, oSuperClass in pairs(oSuperClasses) do _createSuperclass(oClassDefinition, oSuperClass) end
   
   oClassDefinition.__index = oClassDefinition

   local function __createNewObject(...)
      local oObject = {}
      setmetatable(oObject, oClassDefinition)

      -- Use this function to know if the class has the passed class has a parent
      oObject._hasParentClass = function(oObject, oSuperclass)
         return oObject.__aAllParents[oSuperclass] ~= nil
      end

      -- Use this method to call a parent's method if implemented
      oObject._parentMethod = function(oObject, oSuperclass, sMethodName, ...)
         assert(type(oSuperclass) == 'table', 'expects a valid superclass')
         assert(oObject._hasParentClass(oObject, oSuperclass) == true, '_parentConstructor passed super class must be valid')
         assert(oSuperclass[sMethodName] ~= nil, '_parentMethod passed super class must implement the method')
         return oSuperclass[sMethodName](oObject, ...)
      end

      -- Use this function to call the constructor on specific object you created, passing the superclass and variable parameters
      oObject._parentConstructor = function(oObject, oSuperclass, ...)
         assert(type(oSuperclass) == 'table', 'expects a valid superclass')
         assert(oObject._hasParentClass(oObject, oSuperclass) == true, '_parentConstructor passed super class must be valid')

         if oSuperclass.init then
            oSuperclass.init(oObject, ...)
         end
      end

      -- Use this function to call the destructor on specific object you created, passing the superclass and variable parameters
      oObject._parentDestructor = function (oObject, oSuperclass, ...)
         assert(type(oSuperclass) == 'table', 'expects a valid superclass')
         assert(oObject._hasParentClass(oObject, oSuperclass) == true, '_parentDestructor passed super class must be valid')

         if oSuperclass.destroy then
            oSuperclass.destroy(oObject, ...)
         end
      end

      -- Then the child constructor
      if init then
         init(oObject, ...)
      end
      return oObject
   end

   -- Exposes a constructor which can be called by classname(<args>)
   local mt = {}

   mt.__call = function(class_tbl, ...)
      local oObject = nil
      if oClassDefinition.__bSingleton == false then 
         oObject = __createNewObject(...)
      end
      return oObject
   end
   
   -- Singleton handling
   local oSingleton = nil
   oClassDefinition.isSingleton = function(self)
      return oClassDefinition.__bSingleton
   end

   oClassDefinition.enableSingleton = function(self)
      self.__bSingleton = true
   end

   oClassDefinition.disableSingleton = function()
      assert(oSingleton == nil, 'disableSingleton cannot be called once a singleton has been instantiated')
      oClassDefinition.__bSingleton = false
   end

   oClassDefinition.newSingleton = function(...)
      if oClassDefinition:isSingleton() and oSingleton == nil then 
         oSingleton = __createNewObject(...)
      end
      return oSingleton
   end

   oClassDefinition.destroySingleton = function(...)
      if oSingleton ~= nil then
         if oSingleton.destroy then
            oSingleton:destroy(...)
         end
         oSingleton = nil
      end
   end

   oClassDefinition.init = init
   -- We expose the constructor with the method new() to allow instantiating from an existing object
   oClassDefinition.newInstance = mt.__call

   setmetatable(oClassDefinition, mt)
   return oClassDefinition
end
