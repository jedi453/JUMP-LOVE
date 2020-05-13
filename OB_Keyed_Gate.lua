--[[

LICENSE

Copyright (c) 2014-2015  Daniel Iacoviello

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

--]]

-- Gate that Opens When Key of Same Color is Collected
--  Code: K_ - Keyed (Color)
--    KG - Keyed Green
--    KB - Keyed Blue


local class = require('lib.middleclass')

local Tile = require('Tile')
local Obstical = require('Obstical')
local OB_Gate = require('OB_Gate')

local OB_Keyed_Gate = class('OB_Keyed_Gate', OB_Gate)


OB_Keyed_Gate.static.KEYHOLE_HEIGHT = OB_Gate.HEIGHT / 4
OB_Keyed_Gate.static.KEYHOLE_WIDTH = OB_Gate.WIDTH / 4
OB_Keyed_Gate.static.KEYHOLE_X_OFFSET = (OB_Gate.WIDTH - OB_Keyed_Gate.KEYHOLE_WIDTH) / 2
OB_Keyed_Gate.static.KEYHOLE_Y_OFFSET = (OB_Gate.HEIGHT - OB_Keyed_Gate.KEYHOLE_HEIGHT) / 2

OB_Keyed_Gate.static.ALPHA = Tile.TILE_ALPHA

--OB_Keyed_Gate.static.


function OB_Keyed_Gate:initialize( map, color, lpos, tpos )
  OB_Gate.initialize( self, map, lpos, tpos, false )
  self.color = color
  if color == 'green' then
    self.keyR, self.keyG, self.keyB = 0, 128, 0
  elseif color == 'blue' then
    self.keyR, self.keyG, self.keyB = 0, 0, 128
  end
end

function OB_Keyed_Gate:update(dt)
  if not self.isOpen and self.map.keys[self.color] then
    self:openGate()
  end
end


-- Draw the OB_Keyed_Gate Gate and Keyhole
function OB_Keyed_Gate:draw()
  local camera = self.map.camera
  OB_Gate.draw(self)
  love.graphics.setColor( self.keyR/255, self.keyG/255, self.keyB/255, OB_Keyed_Gate.ALPHA/255 )
  love.graphics.rectangle( "line", self.l-camera.l + OB_Keyed_Gate.KEYHOLE_X_OFFSET,
                            self.t-camera.t + OB_Keyed_Gate.KEYHOLE_Y_OFFSET,
                            OB_Keyed_Gate.KEYHOLE_WIDTH,
                            OB_Keyed_Gate.KEYHOLE_HEIGHT )
  if not self.gateOpen then
    love.graphics.rectangle( "fill", self.l-camera.l + OB_Keyed_Gate.KEYHOLE_X_OFFSET,
                              self.t-camera.t + OB_Keyed_Gate.KEYHOLE_Y_OFFSET,
                              OB_Keyed_Gate.KEYHOLE_WIDTH,
                              OB_Keyed_Gate.KEYHOLE_HEIGHT )
  end
end



-- Draw the OB_Keyed_Gate Gate and Keyhole
function OB_Keyed_Gate:fastDraw()
  local camera = self.map.camera
  OB_Gate.fastDraw(self)
  love.graphics.setColor( self.keyR/255, self.keyG/255, self.keyB/255 )
  if not self.gateOpen then
    love.graphics.rectangle( "fill", self.l-camera.l + OB_Keyed_Gate.KEYHOLE_X_OFFSET,
                              self.t-camera.t + OB_Keyed_Gate.KEYHOLE_Y_OFFSET,
                              OB_Keyed_Gate.KEYHOLE_WIDTH,
                              OB_Keyed_Gate.KEYHOLE_HEIGHT )
  end
end



-- Shouldn't Be Needed
-- function OB_Keyed_Gate:reset()
--   self:closeGate()
-- end

return OB_Keyed_Gate
