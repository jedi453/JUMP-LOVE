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
JumpArrow.static.lOffset = ( Tile.CELL_WIDTH - JumpArrow.WIDTH ) / 2
JumpArrow.static.tOffset = ( Tile.CELL_HEIGHT - JumpArrow.HEIGHT ) / 2

-- Color
JumpArrow.static.R = 200
JumpArrow.static.G = 200
JumpArrow.static.B = 75
JumpArrow.static.ALPHA = 90---Tile.TILE_ALPHA

-- Updates/Velocity
JumpArrow.static.UPDATES = true
JumpArrow.static.VX = 0
JumpArrow.static.VY = 0
JumpArrow.static.HAS_GRAVITY = false

-- Respawn Time
JumpArrow.static.RESPAWN_TIME = 7

function JumpArrow:initialize( map, lpos, tpos )
  Background.initialize( self, map,
                          JumpArrow.CC, JumpArrow.SOLID, JumpArrow.DEADLY,
                          lpos*Tile.CELL_WIDTH + JumpArrow.lOffset, tpos*Tile.CELL_HEIGHT + JumpArrow.tOffset,
                          JumpArrow.WIDTH, JumpArrow.HEIGHT,
                          JumpArrow.R, JumpArrow.G, JumpArrow.B,
                          JumpArrow.UPDATES, JumpArrow.VX, JumpArrow.VY, JumpArrow.HAS_GRAVITY )
  -- Is the Arrow Still there
  self.remaining = true
  self.respawnTime = JumpArrow.RESPAWN_TIME
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

  -- Draw Inside, If Applicable
  if self.remaining then
    love.graphics.setColor( JumpArrow.R, JumpArrow.G, JumpArrow.B )
    love.graphics.rectangle( "fill", self.l-camera.l, self.t-camera.t, self.w, self.h )
  end

  -- Draw Outline
  love.graphics.setColor( JumpArrow.R, JumpArrow.G, JumpArrow.B, JumpArrow.ALPHA )
  love.graphics.rectangle( "line", self.l-camera.l, self.t-camera.t, self.w, self.h )
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
