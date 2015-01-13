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



-- Lightning Obstical (OB_Lightning) Class Definitions
-- Yellow Non-Solid Cell that Causes Player Death

-- Code:  "LV" - Vertical Lightning
-- Code:  "LH" - Horizontal Lightning
-- Code:  "LC" - Cross Lightning


class = require("lib.middleclass")
Tile = require("Tile")
Obstical = require("Obstical")


OB_Lightning = class("OB_Lightning", Obstical)

-- OB_Lightning Default Characteristics 
-- Interactions
OB_Lightning.static.CC = true
OB_Lightning.static.SOLID = false
OB_Lightning.static.DEADLY = true
-- Color
OB_Lightning.static.R1 = 200
OB_Lightning.static.G1 = 200
OB_Lightning.static.B1 = 50
OB_Lightning.static.R2 = 255
OB_Lightning.static.G2 = 220
OB_Lightning.static.B2 = 70
-- Pre-Multiply Alphas for Speed and To Be Able to Switch them when in fastDraw Mode
OB_Lightning.static.RA1 = OB_Lightning.R1 * OB_Lightning.TILE_ALPHA / 255
OB_Lightning.static.GA1 = OB_Lightning.G1 * OB_Lightning.TILE_ALPHA / 255
OB_Lightning.static.BA1 = OB_Lightning.B1 * OB_Lightning.TILE_ALPHA / 255
OB_Lightning.static.RA2 = OB_Lightning.R2 * OB_Lightning.TILE_ALPHA / 255
OB_Lightning.static.GA2 = OB_Lightning.G2 * OB_Lightning.TILE_ALPHA / 255
OB_Lightning.static.BA2 = OB_Lightning.B2 * OB_Lightning.TILE_ALPHA / 255

OB_Lightning.static.switchTime = 0.1 -- Time to Keep Each Loop Before Switching
-- Additional Properties
OB_Lightning.static.UPDATES = true
OB_Lightning.static.VX = 0
OB_Lightning.static.VY = 0
OB_Lightning.static.HAS_GRAVITY = false



-- Initialization Function, Sets Initial Member Variables
function OB_Lightning:initialize( map, lpos, tpos, w, h )
  w = w or Tile.CELL_WIDTH
  h = h or Tile.CELL_HEIGHT

  -- Initialize
  ---------------------------map, 
  Obstical.initialize( self, map, 
  OB_Lightning.CC, OB_Lightning.SOLID, OB_Lightning.DEADLY,  -- Collision Check, Solid, Deadly
  lpos*Tile.CELL_WIDTH + ( Tile.CELL_HEIGHT - w )/2,    -- Left Position - l
  tpos*Tile.CELL_HEIGHT + ( Tile.CELL_WIDTH - h )/2,    -- Top Position - t
  w, h, -- Width, Height,
  OB_Lightning.R1, OB_Lightning.G1, OB_Lightning.B1,   -- R, G, B,
  OB_Lightning.UPDATES,         -- updates
  OB_Lightning.VX, OB_Lightning.VY,   -- x Velocity, y Velocity
  OB_Lightning.HAS_GRAVITY)    -- hasGravity

  -- true if Look 1 is Being Used, false if Look 2 is Being Used
  self.isLook1 = true
  self.ra = OB_Lightning.RA1
  self.ga = OB_Lightning.GA1
  self.ba = OB_Lightning.BA1
  -- Time Remaining before Switching Look
  self.lookTimeLeft = OB_Lightning.switchTime
end

function OB_Lightning:update( dt )
  self.lookTimeLeft = self.lookTimeLeft - dt
  if self.lookTimeLeft <= 0 then
    self:switchLook()
    self.lookTimeLeft = OB_Lightning.switchTime
  end
end

function OB_Lightning:switchLook()
  if self.isLook1 then
    self.isLook1 = false
    self.r = OB_Lightning.R2
    self.g = OB_Lightning.G2
    self.b = OB_Lightning.B2
    -- Set Premultiplied Colors Too - For Fastdraw Mode
    self.ra = OB_Lightning.RA2
    self.ga = OB_Lightning.GA2
    self.ba = OB_Lightning.BA2
  else
    self.isLook1 = true
    self.r = OB_Lightning.R1
    self.g = OB_Lightning.G1
    self.b = OB_Lightning.B1
    -- Set Premultiplied Colors Too - For Fastdraw Mode
    self.ra = OB_Lightning.RA1
    self.ga = OB_Lightning.GA1
    self.ba = OB_Lightning.BA1
  end
end


return OB_Lightning
