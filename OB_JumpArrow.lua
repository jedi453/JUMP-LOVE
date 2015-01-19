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



-- JumpArrow Class Definitions

class = require('lib.middleclass')
Tile = require('Tile')
Obstical = require('Obstical')

JumpArrow = class('JumpArrow', Obstical)

-- Collision Check Stuff
JumpArrow.static.CC = true
JumpArrow.static.SOLID = false
JumpArrow.static.DEADLY = false

-- Positional Stuff
JumpArrow.static.WIDTH = (1/2) * Tile.CELL_WIDTH
JumpArrow.static.HEIGHT = (3/4) * Tile.CELL_HEIGHT
JumpArrow.static.lOffset = ( Tile.CELL_WIDTH - JumpArrow.WIDTH ) / 4
JumpArrow.static.tOffset = ( Tile.CELL_HEIGHT - JumpArrow.HEIGHT ) / 2
-- The Coordinates of the Rectangle
-- JumpArrow.static.rectCoords = { l = Tile.CELL_WIDTH / 3,
--                                 t = ( Tile.CELL_HEIGHT - JumpArrow.HEIGHT )/2,
--                                 w = Tile.CELL_WIDTH / 3,
--                                 h = JumpArrow.HEIGHT / 4,
--                               }
-- The Coordinates of the Triangle
JumpArrow.static.triCoords = {
                              { l = JumpArrow.WIDTH / 2, t = 0 },
                              { l = 0, t = JumpArrow.HEIGHT },
                              { l = JumpArrow.WIDTH, t = JumpArrow.HEIGHT },
                             }

-- Color
JumpArrow.static.R = 200
JumpArrow.static.G = 200
JumpArrow.static.B = 75
JumpArrow.static.ALPHA = 100 ---Tile.TILE_ALPHA

-- Updates/Velocity
JumpArrow.static.UPDATES = true
JumpArrow.static.VX = 0
JumpArrow.static.VY = 0
JumpArrow.static.HAS_GRAVITY = false

-- Respawn Time
JumpArrow.static.RESPAWN_TIME = 5

function JumpArrow:initialize( map, lpos, tpos )
  Obstical.initialize( self, map,
                          JumpArrow.CC, JumpArrow.SOLID, JumpArrow.DEADLY,
                          lpos*Tile.CELL_WIDTH + JumpArrow.lOffset, tpos*Tile.CELL_HEIGHT + JumpArrow.tOffset,
                          JumpArrow.WIDTH, JumpArrow.HEIGHT,
                          JumpArrow.R, JumpArrow.G, JumpArrow.B,
                          JumpArrow.UPDATES, JumpArrow.VX, JumpArrow.VY, JumpArrow.HAS_GRAVITY )
  -- Is the Arrow Still there
  self.remaining = true
  self.respawnTime = JumpArrow.RESPAWN_TIME
  self.isJumpArrow = true
end

function JumpArrow:collect()
  if self.remaining then
    self.map:playMedia('jump_collect')
    self.remaining = false
    self.respawnTime = JumpArrow.RESPAWN_TIME
    return true
  else
    return false
  end
  --[[
  -- Make Sure player is Actually a Player
  if player.class.name ~= 'Player' then return end

  -- Remove the JumpArrow and Award Player DoubleJump Only if they Do Not Already Have One
  if not player.hasDoubleJump and self.remaining then
    player.hasDoubleJump = true
    self.remaining = false
    self.respawnTime = JumpArrow.RESPAWN_TIME
  end
  ]]
end

-- Draw an Empty Arrow if not Remaining, Draw a Full one Otherwise
function JumpArrow:draw()
  local camera = self.map.camera
  local l = self.l - camera.l
  local t = self.t - camera.t

  -- Draw Outline
  love.graphics.setColor( JumpArrow.R, JumpArrow.G, JumpArrow.B, JumpArrow.ALPHA )
  --love.graphics.rectangle( "line", self.l-camera.l, self.t-camera.t, self.w, self.h )
  love.graphics.polygon( "line", l + JumpArrow.triCoords[1].l, t + JumpArrow.triCoords[1].t,
                                  l + JumpArrow.triCoords[2].l, t + JumpArrow.triCoords[2].t,
                                  l + JumpArrow.triCoords[3].l, t + JumpArrow.triCoords[3].t )

  -- Draw Inside, If Applicable
  if self.remaining then
    love.graphics.setColor( JumpArrow.R, JumpArrow.G, JumpArrow.B )
    --love.graphics.rectangle( "fill", self.l-camera.l, self.t-camera.t, self.w, self.h )
    love.graphics.polygon( "fill", l + JumpArrow.triCoords[1].l, t + JumpArrow.triCoords[1].t,
                                    l + JumpArrow.triCoords[2].l, t + JumpArrow.triCoords[2].t,
                                    l + JumpArrow.triCoords[3].l, t + JumpArrow.triCoords[3].t )
  end
end

-- FastDraw an Empty Arrow if not Remaining, Draw a Full one Otherwise
function JumpArrow:fastDraw()
  local camera = self.map.camera
  local l = self.l - camera.l
  local t = self.t - camera.t

  -- Draw Inside, If Applicable
  if self.remaining then
    love.graphics.setColor( JumpArrow.R, JumpArrow.G, JumpArrow.B )
    --love.graphics.rectangle( "fill", self.l-camera.l, self.t-camera.t, self.w, self.h )
    love.graphics.polygon( "fill", l + JumpArrow.triCoords[1].l, t + JumpArrow.triCoords[1].t,
                                    l + JumpArrow.triCoords[2].l, t + JumpArrow.triCoords[2].t,
                                    l + JumpArrow.triCoords[3].l, t + JumpArrow.triCoords[3].t )
  else
    -- Draw Light Version
    love.graphics.setColor( JumpArrow.R, JumpArrow.G, JumpArrow.B, JumpArrow.ALPHA )
    --love.graphics.rectangle( "fill", self.l-camera.l, self.t-camera.t, self.w, self.h )
    love.graphics.polygon( "fill", l + JumpArrow.triCoords[1].l, t + JumpArrow.triCoords[1].t,
                                    l + JumpArrow.triCoords[2].l, t + JumpArrow.triCoords[2].t,
                                    l + JumpArrow.triCoords[3].l, t + JumpArrow.triCoords[3].t )
  end
end


-- Make the JumpArrow Respawn After Timer Runs Out
function JumpArrow:update(dt)
  if not self.remaining then
    self.respawnTime = self.respawnTime - dt
    if self.respawnTime < 0 then
      self.remaining = true
      self.respawnTime = JumpArrow.RESPAWN_TIME
    end
  end
end

-- Make the JumpArrow Respawn when the Player Dies
function JumpArrow:reset()
  self.remaining = true
  self.respawnTime = JumpArrow.RESPAWN_TIME
end

return JumpArrow
