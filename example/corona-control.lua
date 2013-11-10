-----------------------------------------------------------------------------------------
--
-- Control.lua
--
-----------------------------------------------------------------------------------------
require ("luoop") -- class system

--- Constructor ---
local function new(self, nX, nY, nWidth, nHeight, oReferencePoint)
    -- public members
    self._nX = nX
    self._nY = nY
    self._nWidth = nWidth
    self._nHeight = nHeight
    self._oReferencePoint = oReferencePoint

    -- private members
    self._sFamily = sFamily
    self._sId = sId
    self._oDisplayObject = nil
end

-- A class
Control = class(new)

--- Destructor ---
function Control:destroy()
    self._nX = nil
    self._nY = nil
    self._nWidth = nil
    self._nHeight = nil
    self._oReferencePoint = nil
    self._oDisplayObject = nil
end

function Control:type()
    return 'Control'
end

-- Getters / setters
function Control:_getX()
    return self._nX
end

function Control:getX()
    return self:_getX()
end

function Control:setX(nX)
    self._nX = nX

    -- Updating display object if needed
    local oDisplayObject = self:_getDisplayObject()

    if oDisplayObject ~= nil then oDisplayObject.x = nX end
end

function Control:_getY()
    return self._nY
end

function Control:getY()
    return self:_getY()
end

function Control:setY(nY)
    self._nY = nY

    -- Updating display object if needed
    local oDisplayObject = self:_getDisplayObject()

    if oDisplayObject ~= nil then oDisplayObject.y = nY end
end

function Control:_getWidth()
    return self._nWidth
end

function Control:getWidth()
    return self:_getWidth()
end

function Control:setWidth(nWidth)
    self._nWidth = nWidth

    -- Updating display object if needed
    local oDisplayObject = self:_getDisplayObject()

    if oDisplayObject ~= nil then oDisplayObject.width = nWidth end
end

function Control:_getHeight()
    return self._nHeight
end

function Control:getHeight()
    return self:_getHeight()
end

function Control:setHeight(nHeight)
    self._nHeight = nHeight

    -- Updating display object if needed
    local oDisplayObject = self:_getDisplayObject()

    if oDisplayObject ~= nil then oDisplayObject.height = nHeight end
end

function Control:getContentWidth()
    local nContentWidth = 0
    local oDisplayObject = self:_getDisplayObject()

    if oDisplayObject ~= nil then nContentWidth = oDisplayObject.contentWidth end
    return nContentWidth
end

function Control:getContentHeight()
    local nContentHeight = 0
    local oDisplayObject = self:_getDisplayObject()

    if oDisplayObject ~= nil then nContentHeight = oDisplayObject.contentHeight end
    return nContentHeight
end

function Control:_getReferencePoint()
    return self._oReferencePoint
end

function Control:getReferencePoint()
    return self:_getReferencePoint()
end

function Control:_setReferencePoint(oReferencePoint)
    self._oReferencePoint = oReferencePoint
end

function Control:setReferencePoint(oReferencePoint)
    self:_setReferencePoint(oReferencePoint)

    -- Updating display object if needed
    local oDisplayObject = self:_getDisplayObject()

    if oDisplayObject ~= nil then oDisplayObject:setReferencePoint(oReferencePoint) end
end

function Control:_getDisplayObject()
    return self._oDisplayObject
end

function Control:_setDisplayObject(oDisplayObject)
    self._oDisplayObject = oDisplayObject
end

--- Methods ---
function Control:refresh()
    -- Some controls require a specific routine to call when content is updated
end

function Control:render()
    -- Called when actually rendering by creating the display object and showing on screen
end

function Control:addOnTouchEvent(fctOnTouch)
    local oDisplayObject = self:_getDisplayObject()
    return oDisplayObject:addEventListener( "touch", fctOnTouch)
end

function Control:removeOnTouchEvent(fctOnTouch)
    local oDisplayObject = self:_getDisplayObject()
    return oDisplayObject:removeEventListener( "touch", fctOnTouch)
end

function Control:addOnTapEvent(fctOnTap)
    local oDisplayObject = self:_getDisplayObject()
    return oDisplayObject:addEventListener( "tap", fctOnTap)
end

function Control:removeOnTapEvent(fctOnTap)
    local oDisplayObject = self:_getDisplayObject()
    return oDisplayObject:removeEventListener( "tap", fctOnTap)
end