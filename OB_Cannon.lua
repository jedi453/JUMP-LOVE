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



-- OB_Cannon Class Definitions
--  Base Class for Cannons that Grab, then Shoot Player
-- CODE: CN


-- Require
class = require('lib.middleclass')
Tile = require('Tile')
Obstical = require('Obstical')


OB_Cannon = class('OB_Cannon', Obstical)


OB_Cannon.static.TURN_SOUND = "cannon_turn"

-- Default Cannon Attributes
OB_Cannon.static.CC = true
OB_Cannon.static.SOLID = false
OB_Cannon.static.DEADLY = false

OB_Cannon.static.WIDTH = Tile.CELL_WIDTH
OB_Cannon.static.HEIGHT = Tile.CELL_HEIGHT
OB_Cannon.static.ARROW_WIDTH = OB_Cannon.WIDTH / 4
OB_Cannon.static.ARROW_HEIGHT = OB_Cannon.HEIGHT / 4

OB_Cannon.static.R = 200
OB_Cannon.static.G = 150
OB_Cannon.static.B = 0
-- The Alpha of the Outside Border of the Cannon
--OB_Cannon.static.OUTLINE_ALPHA = 255
-- The Alpha of the Background of the Cannon ( The Rectangle )
--OB_Cannon.static.BG_ALPHA = 128
-- The Alpha of the Rectangle Indicating Direction
OB_Cannon.static.DIRECTION_ALPHA = 255

OB_Cannon.static.UPDATES = true
OB_Cannon.static.VX = 0
OB_Cannon.static.VY = 0
OB_Cannon.static.HAS_GRAVITY = false

-- Default Countdown until Turning
OB_Cannon.static.TURN_TIME = 0.5

-- Constructor for OB_Cannon
function OB_Cannon:initialize( map, lpos, tpos, turnTime )
  Obstical.initialize( self, map, OB_Cannon.CC, OB_Cannon.SOLID, OB_Cannon.DEADLY,
                    lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_HEIGHT, OB_Cannon.WIDTH, OB_Cannon.HEIGHT,
                    OB_Cannon.R, OB_Cannon.G, OB_Cannon.B,
                    OB_Cannon.UPDATES, OB_Cannon.VX, OB_Cannon.VY,
                    OB_Cannon.HAS_GRAVITY )
  -- The Direction of the Cannon x Component, -1 for Left, 1 for Right, 0 for Middle
  self.directionX = 0
  -- The Direction of the Cannon y Component, -1 for Up, 1 for Down, 0 for Middle
  self.directionY = 0
  self.isCannon = true
  self.running = false
  self.turnTime = turnTime or OB_Cannon.TURN_TIME
  self.timeSinceTurn = 0
  self.playerList = {}
  self.turnSound = OB_Cannon.TURN_SOUND
end

-- Reset Cannon
function OB_Cannon:reset()
  self.playerList = {}
  self.directionX = 0
  self.directionY = 0
  self.running = false
end

-- Cannon - Regular Draw Function
function OB_Cannon:draw()
  -- Draw Outline/Background
  Tile.draw(self)
  -- Draw Direction "Arrow" in Appropriate Spot
  local camera = self.map.camera
  love.graphics.setColor( self.r/255, self.g/255, self.b/255, OB_Cannon.DIRECTION_ALPHA/255 )
  love.graphics.rectangle( "fill", self.l-camera.l + 0.375*(1+self.directionX)*self.w,
                                   self.t-camera.t + 0.375*(1+self.directionY)*self.h,
                                   OB_Cannon.ARROW_WIDTH, OB_Cannon.ARROW_HEIGHT )
  --[[ -- Older Easier to Understand Version
  love.graphics.rectangle("fill", self.l-camera.l + ((1/2)-(1/8))*self.w + ((1/2)-(1/8))*self.w*self.directionX,
                                  self.t-camera.t + 0.375*self.h + 0.375*self.h*self.directionY,
                                  self.w, self.h )
  --]]
end


-- Cannon - FastDraw Function
function OB_Cannon:fastDraw()
  -- Draw Outline/Background
  Tile.fastDraw(self)
  -- Draw Direction "Arrow" in Appropriate Spot
  local camera = self.map.camera
  love.graphics.setColor( self.r/255, self.g/255, self.b/255, OB_Cannon.DIRECTION_ALPHA/255 )
  love.graphics.rectangle( "fill", self.l-camera.l + 0.375*(1+self.directionX)*self.w,
                                   self.t-camera.t + 0.375*(1+self.directionY)*self.h,
                                   OB_Cannon.ARROW_WIDTH, OB_Cannon.ARROW_HEIGHT )
end




-- Update the Cannon to Change Direction
function OB_Cannon:update(dt)
  if self.running then
    self.timeSinceTurn = self.timeSinceTurn + dt
    if self.timeSinceTurn > self.turnTime then
      self:turn()
      self.timeSinceTurn = 0
    end
  end
end


-- Start the Cannon
function OB_Cannon:start()
  -- If there's No-one in the Cannon
  if next(self.playerList) == nil then
    self.directionX = 1
    self.directionY = 0
    self.timeSinceTurn = 0
  end
  self.running = true
  -- Play Turn Sound
  self.map:playMedia( self.turnSound )
end


-- Stop the Cannon
function OB_Cannon:stop()
  self.directionX = 0
  self.directionY = 0
  self.running = false
end

-- Add a Player to the Cannon
function OB_Cannon:addPlayer( player )
  self:start()
  self.playerList[player] = true
end

function OB_Cannon:removePlayer( player )
  self.playerList[player] = nil
  if not next( self.playerList ) then
    self:stop()
  end
end

-- Turn the Cannon
function OB_Cannon:turn()
  if self.directionX > 0 then
    -- Pointing Right, Now Point Down
    self.directionX = 0
    self.directionY = 1
  elseif self.directionX < 0 then
    -- Pointing Left, Now Point Up
    self.directionX = 0
    self.directionY = -1
  elseif self.directionY > 0 then
    -- Pointing Down, Now Point Left
    self.directionX = -1
    self.directionY = 0
  else
    -- Pointing Up or Nowhere, Now Point Right
    self.directionX = 1
    self.directionY = 0
  end
  -- Play Turning Sound
  self.map:playMedia( self.turnSound )
end

return OB_Cannon
