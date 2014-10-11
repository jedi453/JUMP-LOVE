-- OB_Gate.lua
-- OB_Gate Base Class for Blocks that Change Between non-Solid and Solid on Some Queue

-- Code 'GT' - GaTe

class = require('lib.middleclass')
Tile = require('Tile')
Obstical = require('Obstical')

OB_Gate = class('OB_Gate', Obstical)


-- Default Gate Attributes
OB_Gate.static.CC = true
OB_Gate.static.SOLID = false
OB_Gate.static.DEADLY = false

OB_Gate.static.WIDTH = Tile.CELL_WIDTH
OB_Gate.static.HEIGHT = Tile.CELL_HEIGHT

OB_Gate.static.R = 128
OB_Gate.static.G =  50
OB_Gate.static.B =  50

OB_Gate.static.UPDATES = true
OB_Gate.static.VX = 0
OB_Gate.static.VY = 0
OB_Gate.static.HAS_GRAVITY = false

-- Initialize the OB_Gate
function OB_Gate:initialize( map, lpos, tpos, gateOpen )
  if gateOpen == nil then self.gateOpen = true end
	Obstical.initialize( self, map, OB_Gate.CC, not self.gateOpen, OB_Gate.DEADLY,
  									lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_HEIGHT, OB_Gate.WIDTH, OB_Gate.HEIGHT,
                    OB_Gate.R, OB_Gate.G, OB_Gate.B,
                    OB_Gate.UPDATES, OB_Gate.VX, OB_Gate.VY,
                    OB_Gate.HAS_GRAVITY )
  self.gateOpenOrig = self.gateOpen
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

-- Draw the Gate as Opened or Closed
function OB_Gate:draw()
  local camera = self.map.camera
  if self.gateOpen then
    love.graphics.setColor( self.r, self.g, self.b, Tile.static.TILE_ALPHA )
    love.graphics.rectangle( "line", self.l - camera.l, self.t - camera.t, self.w, self.h )
  else
    love.graphics.setColor( self.r, self.g, self.b )
    love.graphics.rectangle( "line", self.l - camera.l, self.t - camera.t, self.w, self.h )
    love.graphics.setColor( self.r, self.g, self.b, Tile.static.TILE_ALPHA )
    love.graphics.rectangle( "fill", self.l - camera.l, self.t - camera.t, self.w, self.h )
  end
end



-- Default OB_Gate Update Function, 
--  Close when a Player Passes Through
function OB_Gate:update(dt)
  local touchingPlayerNow = false
  if self.map and self.map.players then
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
