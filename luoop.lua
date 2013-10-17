-----
-- Luoop - easy and flexible object oriented library for Lua
-- Author: Teddy Engel <engel.teddy[at]gmail.com> / @Teddy_Engel
-- Version: 1.01
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
         and sMethodName ~= '__index' then
         oClassDefinition[sMethodName] = oMethod
      end
   end

   -- Adds the superclass as a base class
   if oClassDefinition.__aParents == nil then
      oClassDefinition.__aParents = {}
   end
   oClassDefinition.__aParents[oSuperclass] = oSuperclass
end

--- MAIN CALL ---
function class(init, ...)
   local oSuperClasses = {...}
   local oClassDefinition = {}    -- a new class instance

   -- Array to store the superclasses
   oClassDefinition.__aParents = nil
   
   -- Creating all superclasses
   for oKey, oSuperClass in pairs(oSuperClasses) do _createSuperclass(oClassDefinition, oSuperClass) end
   
   oClassDefinition.__index = oClassDefinition

   -- Exposes a constructor which can be called by classname(<args>)
   local mt = {}

   mt.__call = function(class_tbl, ...)
      local oObject = {}
      setmetatable(oObject, oClassDefinition)

      -- Use this function to call the constructor on specific object you created, passing the superclass and variable parameters
      oObject._parentConstructor = function(oObject, oSuperclass, ...)
         assert(type(oSuperclass) == 'table', 'expects a valid superclass')
         assert(oObject.__aParents, '_parentConstructor expects the object to have parents')

         if oSuperclass.init then
            oSuperclass.init(oObject, ...)
         end
      end

      -- Use this function to call the destructor on specific object you created, passing the superclass and variable parameters
      oObject._parentDestructor = function (oObject, oSuperclass, ...)
         assert(type(oSuperclass) == 'table', 'expects a valid superclass')
         assert(oObject.__aParents, '_parentDestructor( expects the object to have parents')

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
   
   oClassDefinition.init = init
   -- We expose the constructor with the method new() to allow instantiating from an existing object
   oClassDefinition.new = mt.__call

   setmetatable(oClassDefinition, mt)
   return oClassDefinition
end
