-- luoop.lua

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

--- PROTECTED FUNCTIONS ---

-- Use this function to call the constructor on specific object you created, passing the superclass and variable parameters
function callConstructor(obj, oSuperclass, ...)
   assert(type(oSuperclass) == 'table', 'expects a valid superclass')
   assert(obj.__parents, 'initSuperclassRem expects the obj to have parents')

   if oSuperclass.init then
      oSuperclass.init(obj, ...)
   end
end

-- Use this function to call the destructor on specific object you created, passing the superclass and variable parameters
function callDestructor(obj, oSuperclass, ...)
   assert(type(oSuperclass) == 'table', 'expects a valid superclass')
   assert(obj.__parents, 'initSuperclassRem expects the obj to have parents')

   if oSuperclass.destroy then
      oSuperclass.destroy(obj, ...)
   end
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
