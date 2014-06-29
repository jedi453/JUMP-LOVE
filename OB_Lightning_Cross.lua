-- Lightning Obstical Cross (OB_Lightning_Cross) Class Definitions
-- Yellow Non-Solid Cell that Causes Player Death

-- Code:  "LX" - Cross Lightning


class = require("lib.middleclass")
Tile = require("Tile")
Obstical = require("Obstical")
OB_Lightning = require("OB_Lightning")

OB_Lightning_Cross = class("OB_Lightning_Cross", OB_Lightning)


-- OB_Lightning_Cross Characteristics 
-- Dimensions:
OB_Lightning_Cross.static.WIDTH = Tile.CELL_WIDTH
OB_Lightning_Cross.static.HEIGHT = Tile.CELL_HEIGHT

-- Initialization Function, Sets Initial Member Variables
function OB_Lightning_Cross:initialize( map, lpos, tpos )
  OB_Lightning.initialize( self, map, lpos, tpos,
                          OB_Lightning_Cross.WIDTH, OB_Lightning_Cross.HEIGHT )
end

return OB_Lightning_Cross
