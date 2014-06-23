-- Moving Platform ( Platform ) Class Definitions
class = require("lib.middleclass")
Tile = require("Tile")
Obstical = require("Obstical")
Player = require("Player")

Platform = class("Platform", Obstical)

Platform.static.xSpeed = 150

function Platform:initialize( world, lpos, tpos, direction, width )
  direction = direction or 1
  width = width or 1
  --                        world,  cc,  solid, deadly,
  Obstical.initialize( self, world, true, true, false,
                        lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_HEIGHT, width*Tile.CELL_WIDTH, Tile.CELL_HEIGHT,
                        200, 200, 0,
                        true, direction*Platform.xSpeed, 0, false )
  self.lpos = lpos
  self.tpos = tpos
  self.width = width or 1
end

function Platform:move( new_l, new_t )
  local tl, tt, nx, ny, sl, st
  local blocks, len = self.world
end

function Platform.static.cFilter( other )
  return other.solid
end

return Platform
