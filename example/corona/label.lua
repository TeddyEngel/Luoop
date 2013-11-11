-----------------------------------------------------------------------------------------
--
-- Label.lua
-- Example of a corona label class, to display a text label.
-- The label class inherits from controls and call the control:render() method in render()
--
-----------------------------------------------------------------------------------------
require("control") -- parent class

--- Constructor ---
local function new(self, nX, nY, nWidth, nHeight, oReferencePoint, sText, nFontSize, oFont)
    self:_parentConstructor(Control, nX, nY, nWidth, nHeight, oReferencePoint)
    
    -- Default Listeners
    self:_setText(sText)

    -- Font
    if oFont == nil then oFont = native.systemFont end
    self:_setFont(oFont)

    -- Font size
    if nFontSize == nil then nFontSize = 12 end
    self:_setFontSize(nFontSize)

    if oReferencePoint == nil then
        self:_setReferencePoint(display.CenterReferencePoint)
    end
end

Label = class(new, Control)

--- Destructor ---
function Label:destroy()
    local oDisplayObject = self:_getDisplayObject()
    if oDisplayObject then display.remove(oDisplayObject) end
    self:_setDisplayObject(nil)
    self:_setReferencePoint(nil)
    self:_setText(nil)
    self:_setFont(nil)

    self:_parentDestructor(Control)
end

--- Overloaded Methods ---
function Label:type()
    return 'Label'
end

--- Getters / Setters ---
function Label:_getText()
    return self._sText
end

function Label:_setText(sText)
    self._sText = sText
end

function Label:getText()
    local oDisplayObject = self:_getDisplayObject()

    assert(oDisplayObject ~= nil, 'expects a created display object')
    return oDisplayObject.text
end

function Label:setText(sText)
    local oDisplayObject = self:_getDisplayObject()

    assert(oDisplayObject ~= nil, 'expects a created display object')
    self:_setText(sText)
    oDisplayObject.text = sText
end

function Label:_getFontSize()
    return self._nFontSize
end

function Label:_setFontSize(nFontSize)
    self._nFontSize = nFontSize
end

function Label:getFontSize()
    return self:_getFontSize()
end

function Label:setFontSize(nFontSize)
    self:_setFontSize(nFontSize)
end

function Label:_getFont()
    return self._oFont
end

function Label:_setFont(oFont)
    self._oFont = oFont
end

--- Methods ---
function Label:render()
    self:_parentMethod(Control, 'render')

    local oDisplayObject = nil
    local sText = self:_getText()
    local nX = self:getX()
    local nY = self:getY()
    local nWidth = self:getWidth()
    local nHeight = self:getHeight()
    local oReferencePoint = self:getReferencePoint()
    local oFont = self:_getFont()
    local nFontSize = self:getFontSize()
    
    if nWidth ~= nil then
        oDisplayObject = display.newText(sText, 0, 0, nWidth, nHeight, oFont, nFontSize )   
    else
        oDisplayObject = display.newText(sText, 0, 0, oFont, nFontSize )
    end
    -- Handling placement / text
    if oReferencePoint then
        oDisplayObject:setReferencePoint(oReferencePoint)
    end
    oDisplayObject.x = nX
    oDisplayObject.y = nY
    self:_setDisplayObject(oDisplayObject)
end
