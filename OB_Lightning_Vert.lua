-- Lightning Obstical Vertical (OB_Lightning_Vert) Class Definitions
-- Yellow Half-Width Non-Solid Cell that Causes Player Death

-- Code:  "LV" - Lightning Vertical


class = require("lib.middleclass")
Tile = require("Tile")
Obstical = require("Obstical")
OB_Lightning = require("OB_Lightning")

OB_Lightning_Vert = class("OB_Lightning_Vert", OB_Lightning)


-- OB_Lightning_Vert Characteristics 
-- Dimensions:
OB_Lightning_Vert.static.WIDTH = Tile.CELL_WIDTH / 2
OB_Lightning_Vert.static.HEIGHT = Tile.CELL_HEIGHT

-- Initialization Function, Sets Initial Member Variables
function OB_Lightning_Vert:initialize( map, lpos, tpos )
  OB_Lightning.initialize( self, map, lpos, tpos,
                          OB_Lightning_Vert.WIDTH, OB_Lightning_Vert.HEIGHT )
end

return OB_Lightning_Vert
