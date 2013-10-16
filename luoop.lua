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
local function _createSuperclass(c, oSuperclass)
   assert(type(oSuperclass) == 'table', '_createSuperclass expects a valid superclass')
   assert(oSuperclass.init, '_createSuperclass expects a superclass with a constructor defined')
   
   -- We copy all methods / variables from the superclass to the current class
   for sMethodName, oMethod in pairs(oSuperclass) do
      -- Exceptions for internally used variables
      if sMethodName ~= '__parents' 
         and sMethodName ~= '__index' then
         c[sMethodName] = oMethod
      end
   end

   -- Adds the superclass as a base class
   if c.__parents == nil then
      c.__parents = {}
   end
   c.__parents[oSuperclass] = oSuperclass
end

--- MAIN CALL ---
function class(init, ...)
   local oSuperClasses = {...}
   local c = {}    -- a new class instance

   -- Array to store the superclasses
   c.__parents = nil
   
   -- Creating all superclasses
   for oKey, oSuperClass in pairs(oSuperClasses) do _createSuperclass(c, oSuperClass) end
   
   c.__index = c

   -- Exposes a constructor which can be called by classname(<args>)
   local mt = {}

   mt.__call = function(class_tbl, ...)
      local obj = {}
      setmetatable(obj,c)

      -- Use this function to call the constructor on specific object you created, passing the superclass and variable parameters
      function obj:_parentConstructor(oSuperclass, ...)
         assert(type(oSuperclass) == 'table', 'expects a valid superclass')
         assert(obj.__parents, 'callConstructor expects the obj to have parents')

         if oSuperclass.init then
            oSuperclass.init(obj, ...)
         end
      end

      -- Use this function to call the destructor on specific object you created, passing the superclass and variable parameters
      function obj:_parentDestructor(oSuperclass, ...)
         assert(type(oSuperclass) == 'table', 'expects a valid superclass')
         assert(obj.__parents, 'callDestructor expects the obj to have parents')

         if oSuperclass.destroy then
            oSuperclass.destroy(obj, ...)
         end
      end

      -- Then the child constructor
      if init then
         init(obj, ...)
      end 
      
      return obj
   end
   
   c.init = init
   -- We expose the constructor with the method new() to allow instantiating from an existing object
   c.new = mt.__call

   setmetatable(c, mt)
   return c
end
