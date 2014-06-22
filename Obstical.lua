-- Background Class Definitions File

class = require('lib.middleclass')
bump = require('bump.bump')
Tile = require('Tile')

Obstical = class( 'Obstical', Tile )
function Obstical:initialize( world, cc, solid, deadly, l,t,w,h, r,g,b )
  Tile.initialize( self, world, cc, solid, deadly, l,t,w,h, r,g,b )
end

return Obstical
