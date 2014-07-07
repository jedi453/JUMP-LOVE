-- Platform Stop Obstical (OB_Platform_Stop) Class Definitions
-- 
-- Map Code: PS

class = require('lib.middleclass')
Tile = require('Tile')
Obstical = require('Obstical')

OB_Platform_Stop = class('OB_Platform_Stop', Obstical)


-- OB_Platform_Stop Basic Properties
-- Interactions
OB_Platform_Stop.static.CC = true
OB_Platform_Stop.static.SOLID = false
OB_Platform_Stop.static.DEADLY = false
OB_Platform_Stop.static.BOUNCES_PLATFORMS = true
-- Size
OB_Platform_Stop.static.WIDTH = Tile.CELL_WIDTH / 2
OB_Platform_Stop.static.HEIGHT = Tile.CELL_HEIGHT / 2 
-- Color
OB_Platform_Stop.static.R = 100
OB_Platform_Stop.static.G = 100
OB_Platform_Stop.static.B = 100
-- Additional Properties
OB_Platform_Stop.static.UPDATES = false
OB_Platform_Stop.static.VX = 0
OB_Platform_Stop.static.VY = 0
OB_Platform_Stop.static.HAS_GRAVITY = false


-- Initialization Function for New OB_Platform_Stop
function OB_Platform_Stop:initialize( map, lpos, tpos )
  Tile.initialize( self, map, 
                    OB_Platform_Stop.CC, OB_Platform_Stop.SOLID, OB_Platform_Stop.DEADLY, -- Player Interaction Stuff
                    lpos*Tile.CELL_WIDTH + ( Tile.CELL_WIDTH - OB_Platform_Stop.WIDTH )/2, -- Left Position
                    tpos*Tile.CELL_HEIGHT + ( Tile.CELL_HEIGHT - OB_Platform_Stop.HEIGHT )/2, -- Top Position
                    OB_Platform_Stop.WIDTH, OB_Platform_Stop.HEIGHT, -- Width, Height
                    OB_Platform_Stop.R, OB_Platform_Stop.G, OB_Platform_Stop.B,   -- Red, Green, Blue
                    OB_Platform_Stop.UPDATES, -- updates
                    OB_Platform_Stop.VX, OB_Platform_Stop.VY,   -- X Velocity, Y Velocity
                    OB_Platform_Stop.HAS_GRAVITY )    -- Has Velocity
  self.bouncesPlatforms = OB_Platform_Stop.BOUNCES_PLATFORMS
end

function OB_Platform_Stop:draw()
  local camera = self.map.camera

  love.graphics.setColor( self.r, self.g, self.b )
  love.graphics.rectangle( "line", self.l-camera.l, self.t-camera.t, self.w, self.h )
end

return OB_Platform_Stop
