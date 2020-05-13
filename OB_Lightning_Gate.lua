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



-- Lightning Gate
--  Able to Be Passed through Safely Once, then Becomes Deadly
--  CODE: LG


local class = require('lib.middleclass')
local Tile = require('Tile')
local Obstical = require('Obstical')
local OB_Gate = require('OB_Gate')
local OB_Lightning = require('OB_Lightning')

local OB_Lightning_Gate = class('OB_Lightning_Gate', OB_Gate)

OB_Lightning_Gate.static.SWITCH_TIME = 0.1
OB_Lightning_Gate.static.UPDATES = true
OB_Lightning_Gate.static.R1 = 200
OB_Lightning_Gate.static.G1 = 200
OB_Lightning_Gate.static.B1 = 50
OB_Lightning_Gate.static.R2 = 255
OB_Lightning_Gate.static.G2 = 220
OB_Lightning_Gate.static.B2 = 70
-- Pre-multiply Alphas for FastDraw Mode
OB_Lightning_Gate.static.RA1 = OB_Lightning_Gate.R1 * OB_Lightning_Gate.TILE_ALPHA / 255
OB_Lightning_Gate.static.GA1 = OB_Lightning_Gate.G1 * OB_Lightning_Gate.TILE_ALPHA / 255
OB_Lightning_Gate.static.BA1 = OB_Lightning_Gate.B1 * OB_Lightning_Gate.TILE_ALPHA / 255
OB_Lightning_Gate.static.RA2 = OB_Lightning_Gate.R2 * OB_Lightning_Gate.TILE_ALPHA / 255
OB_Lightning_Gate.static.GA2 = OB_Lightning_Gate.G2 * OB_Lightning_Gate.TILE_ALPHA / 255
OB_Lightning_Gate.static.BA2 = OB_Lightning_Gate.B2 * OB_Lightning_Gate.TILE_ALPHA / 255


function OB_Lightning_Gate:initialize( map, lpos, tpos, gateOpen, width, height)
  -- Default to Open, but Accept false as a Value
  if gateOpen == nil then gateOpen = true end
  OB_Gate.initialize( self, map, lpos, tpos, gateOpen, width, height )
  self.solid = false -- Override Setting from OB_Gate.initialize
  self.deadly = not self.gateOpen
  self.isLook1 = true
  self.ra = OB_Lightning_Gate.RA1
  self.ga = OB_Lightning_Gate.GA1
  self.ba = OB_Lightning_Gate.BA1
  self.lookTimeLeft = OB_Lightning_Gate.SWITCH_TIME
end


-- "Close" the Gate - Make it Deadly
function OB_Lightning_Gate:closeGate()
  self.gateOpen = false
  self.deadly = true
end


-- "Open" the Gate - Make it Safe
function OB_Lightning_Gate:openGate()
  self.gateOpen = true
  self.deadly = false
end


-- OB_Lightning_Gate Update Function, 
--  Close when a Player Passes Through
--  Switch Between Looks Every OB_Lightning_Gate.SWITCH_TIME seconds
function OB_Lightning_Gate:update(dt)
  -- Gate Update
  OB_Gate.update(self, dt)
  -- Lightning Update
  if not self.gateOpen then
    OB_Lightning.update(self, dt)
  end
  --[[
    self.lookTimeLeft = self.lookTimeLeft - dt
    if self.lookTimeLeft <= 0 then
      self:switchLook()
      self.lookTimeLeft = OB_Lightning.switchTime
    end
  --]]
end



function OB_Lightning_Gate:draw()
  if self.gateOpen then
    return OB_Gate.draw(self)
  else
    return OB_Lightning.draw(self)
  end
end

function OB_Lightning_Gate:fastDraw()
  if self.gateOpen then
    return OB_Gate.fastDraw(self)
  else
    return OB_Lightning.fastDraw(self)
  end
end


--[[
-- -- Inherited From OB_Gate Should Be Good? -- TODO CHECK
-- Draw the Lightning Gate as Opened or Closed
function OB_Lightning_Gate:draw()
  local camera = self.map.camera
  if self.gateOpen then
    love.graphics.setColor( self.r/255, self.g/255, self.b/255, Tile.static.TILE_ALPHA/255 )
    love.graphics.rectangle( "line", self.l - camera.l, self.t - camera.t, self.w, self.h )
  else
    love.graphics.setColor( self.r/255, self.g/255, self.b/255 )
    love.graphics.rectangle( "line", self.l - camera.l, self.t - camera.t, self.w, self.h )
    love.graphics.setColor( self.r/255, self.g/255, self.b/255, Tile.static.TILE_ALPHA/255 )
    love.graphics.rectangle( "fill", self.l - camera.l, self.t - camera.t, self.w, self.h )
  end
end
--]]


-- Switch Look when Closed
function OB_Lightning_Gate:switchLook()
  if self.isLook1 then
    self.isLook1 = false
    self.r = OB_Lightning_Gate.R2
    self.g = OB_Lightning_Gate.G2
    self.b = OB_Lightning_Gate.B2
    -- Switch Premultiplied Alpha Colors as Well
    self.ra = OB_Lightning_Gate.RA2
    self.ga = OB_Lightning_Gate.GA2
    self.ba = OB_Lightning_Gate.BA2
  else
    self.isLook1 = true
    self.r = OB_Lightning_Gate.R1
    self.g = OB_Lightning_Gate.G1
    self.b = OB_Lightning_Gate.B1
    -- Switch Premultiplied Alpha Colors as Well
    self.ra = OB_Lightning_Gate.RA1
    self.ga = OB_Lightning_Gate.GA1
    self.ba = OB_Lightning_Gate.BA1
  end
end


-- Reset Gate
function OB_Lightning_Gate:reset()
  OB_Gate.reset(self)
  self.r = OB_Gate.R
  self.g = OB_Gate.G
  self.b = OB_Gate.B
end

return OB_Lightning_Gate
