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


-- OB_Gate_Key Class Definitions
-- Code: _K - (Color) Key
--       GK - Green Key
--       BK - Blue Key

local class = require('lib.middleclass')
local Tile = require('Tile')
local Obstical = require('Obstical')

local OB_Gate_Key = class('OB_Gate_Key', Obstical)

-- Properties
OB_Gate_Key.static.CC = true
OB_Gate_Key.static.SOLID = false
OB_Gate_Key.static.DEADLY = false

-- Default Color
OB_Gate_Key.static.DEFAULT_R = 128
OB_Gate_Key.static.DEFAULT_G = 128
OB_Gate_Key.static.DEFAULT_B = 128
OB_Gate_Key.static.ALPHA = Tile.ALPHA

-- Location, Location, Location
OB_Gate_Key.static.WIDTH = (1/2) * Tile.CELL_WIDTH
OB_Gate_Key.static.HEIGHT = (1/2) * Tile.CELL_HEIGHT
OB_Gate_Key.static.lOffset = ( Tile.CELL_WIDTH - OB_Gate_Key.WIDTH ) / 2
OB_Gate_Key.static.tOffset = ( Tile.CELL_HEIGHT - OB_Gate_Key.HEIGHT ) / 2

--Updates
OB_Gate_Key.static.UPDATES = true
OB_Gate_Key.static.VX = 0
OB_Gate_Key.static.VY = 0
OB_Gate_Key.static.HAS_GRAVITY = false



function OB_Gate_Key:initialize( map, color, lpos, tpos )
  Obstical.initialize( self, map,
                        OB_Gate_Key.CC, OB_Gate_Key.SOLID, OB_Gate_Key.DEADLY,
                        lpos*Tile.CELL_WIDTH + OB_Gate_Key.lOffset, tpos*Tile.CELL_HEIGHT + OB_Gate_Key.tOffset,
                        OB_Gate_Key.WIDTH, OB_Gate_Key.HEIGHT,
                        OB_Gate_Key.DEFAULT_R, OB_Gate_Key.DEFAULT_G, OB_Gate_Key.DEFAULT_B,
                        OB_Gate_Key.UPDATES, OB_Gate_Key.VX, OB_Gate_Key.VY, OB_Gate_Key.HAS_GRAVITY )
  self.remaining = true
  self.isKey = true
  self.color = color
  if color == 'green' then
    self.r, self.g, self.b = 0, 128, 0
  elseif color == 'blue' then
    self.r, self.g, self.b = 0, 0, 128
  end
end


-- Called When the Player Collects the Key
function OB_Gate_Key:collect()
  if not self.map.keys[self.color] then
    -- TODO - REPLACE PLACEHOLDER
    self.map:playMedia('jump_collect')
    self.map.keys[self.color] = true
    return true
  else
    return false
  end
end
    

-- Normal Draw - Outline + Inside ( if Present )
function OB_Gate_Key:draw()
  local camera = self.map.camera
  love.graphics.setColor( self.r, self.g, self.b, OB_Gate_Key.ALPHA )
  love.graphics.rectangle( 'line', self.l-camera.l, self.t-camera.t, self.w, self.h )
  if self.remaining then
    love.graphics.setColor( self.r, self.g, self.b )
    love.graphics.rectangle( 'fill', self.l-camera.l, self.t-camera.t, self.w, self.h )
  end
end

-- Fast Draw - Outline + Inside ( if Present )
function OB_Gate_Key:fastDraw()
  local camera = self.map.camera
  if self.remaining then
    love.graphics.setColor( self.r, self.g, self.b, OB_Gate_Key.ALPHA )
    love.graphics.rectangle( 'fill', self.l-camera.l, self.t-camera.t, self.w, self.h )
  else
    love.graphics.setColor( self.r, self.g, self.b, OB_Gate_Key.ALPHA/2 )
    love.graphics.rectangle( 'fill', self.l-camera.l, self.t-camera.t, self.w, self.h )
  end
end

function OB_Gate_Key:update(dt)
  self.remaining = not self.map.keys[self.color]
end

return OB_Gate_Key
