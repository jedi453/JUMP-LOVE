-- Background Class Definitions File

class = require('lib.middleclass')
bump = require('bump.bump')
Tile = require('Tile')

Obstical = class( 'Obstical', Tile )
function Obstical:initialize(...) -- map, cc, solid, deadly, l,t,w,h, r,g,b, updates, vx, vy, hasGravity, cFilter)
  Tile.initialize( self, ... )
  --Tile.initialize( self, map, cc, solid, deadly, l,t,w,h, r,g,b, updates, vx, vy, hasGravity, cFilter )
end

return Obstical
