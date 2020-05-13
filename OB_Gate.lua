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



-- OB_Gate.lua
-- OB_Gate Base Class for Blocks that Change Between non-Solid and Solid on Some Queue

-- Code 'GT' - GaTe

local class = require('lib.middleclass')
local Tile = require('Tile')
local Obstical = require('Obstical')

local OB_Gate = class('OB_Gate', Obstical)


-- Default Gate Attributes
OB_Gate.static.CC = true
OB_Gate.static.SOLID = false
OB_Gate.static.DEADLY = false

OB_Gate.static.WIDTH = Tile.CELL_WIDTH
OB_Gate.static.HEIGHT = Tile.CELL_HEIGHT

OB_Gate.static.R = 140
OB_Gate.static.G =  64
OB_Gate.static.B =  64

-- The Closed Gate Colors With Pre-multiplied Alphas
OB_Gate.static.RA_CLOSED = OB_Gate.R * Tile.TILE_ALPHA / 255
OB_Gate.static.GA_CLOSED = OB_Gate.G * Tile.TILE_ALPHA / 255
OB_Gate.static.BA_CLOSED = OB_Gate.B * Tile.TILE_ALPHA / 255

-- The Open Gate Colors With Pre-Multiplied Alphas
OB_Gate.static.RA_OPEN = OB_Gate.RA_CLOSED / 2
OB_Gate.static.GA_OPEN = OB_Gate.GA_CLOSED / 2
OB_Gate.static.BA_OPEN = OB_Gate.BA_CLOSED / 2

OB_Gate.static.UPDATES = true
OB_Gate.static.VX = 0
OB_Gate.static.VY = 0
OB_Gate.static.HAS_GRAVITY = false

-- Initialize the OB_Gate
function OB_Gate:initialize( map, lpos, tpos, gateOpen, width, height )
  width = width or OB_Gate.WIDTH
  height = height or OB_Gate.HEIGHT
  if gateOpen == nil then gateOpen = true end -- gateOpen is Used Later, So it Must be Changed Directly
	Obstical.initialize( self, map, OB_Gate.CC, not gateOpen, OB_Gate.DEADLY,
  									lpos*Tile.CELL_WIDTH + (Tile.CELL_WIDTH - width)/2,
                    tpos*Tile.CELL_HEIGHT + (Tile.CELL_HEIGHT - height)/2,
                    width, height,
                    OB_Gate.R, OB_Gate.G, OB_Gate.B,
                    OB_Gate.UPDATES, OB_Gate.VX, OB_Gate.VY,
                    OB_Gate.HAS_GRAVITY )
  self.gateOpen = gateOpen
  self.gateOpenOrig = gateOpen
  -- True when the Gate has Been Touched By the Player
  self.touchedByPlayer = false
end


-- Reset the Gate at the (re)start of the Level
function OB_Gate:reset()
  if self.gateOpenOrig then
    self:openGate()
  else
    self:closeGate()
  end
  -- Reset the Gate to Not Have Been Touched By Player
  self.touchedPlayer = false
end

-- Regular Draw the Gate as Opened or Closed
function OB_Gate:draw()
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


-- FastDraw the Gate as Opened or Closed 
--  No Outline + Pre-Multiplied Alphas
function OB_Gate:fastDraw()
  local camera = self.map.camera
  if self.gateOpen then
    love.graphics.setColor( OB_Gate.RA_OPEN/255, OB_Gate.GA_OPEN/255, OB_Gate.BA_OPEN/255 )
    love.graphics.rectangle( "fill", self.l - camera.l, self.t - camera.t, self.w, self.h )
  else
    love.graphics.setColor( OB_Gate.RA_CLOSED/255, OB_Gate.GA_CLOSED/255, OB_Gate.BA_CLOSED/255 )
    love.graphics.rectangle( "fill", self.l - camera.l, self.t - camera.t, self.w, self.h )
  end
end

-- Default OB_Gate Update Function, 
--  Close when a Player Passes Through
function OB_Gate:update(dt)
  local touchingPlayerNow = false
  if self.gateOpen == self.gateOpenOrig and self.map and self.map.players then
    local players = self.map.players

    for _, player in ipairs(players) do
      -- If Player is Colliding with OB_Gate
      if ( self.l < player.l + player.w and
         player.l < self.l + self.w and
         self.t < player.t + player.h and
         player.t < self.t + self.h ) then
        -- Player is Touching Gate, Handle self.touchedPlayer later
        touchingPlayerNow = true
      end
    end
  end

  if not self.touchedPlayer and touchingPlayerNow then
    self.touchedPlayer = true
  elseif self.touchedPlayer and not touchingPlayerNow then
    self:closeGate()
  end

end

-- Close the Gate
function OB_Gate:closeGate()
  self.gateOpen = false
  self.solid = true
end


-- Open the Gate
function OB_Gate:openGate()
  self.gateOpen = true
  self.solid = false
end

return OB_Gate
