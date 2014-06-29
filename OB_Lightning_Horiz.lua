-- Lightning Obstical Horizontal (OB_Lightning_Horiz) Class Definitions
-- Yellow Non-Solid Cell that Causes Player Death

-- Map Code:  "LH" - Lightning - Horizontal


class = require("lib.middleclass")
Tile = require("Tile")
Obstical = require("Obstical")
OB_Lightning = require("OB_Lightning")

OB_Lightning_Horiz = class("OB_Lightning_Horiz", OB_Lightning)


-- OB_Lightning_Horiz Characteristics 
-- Dimensions:
OB_Lightning_Horiz.static.WIDTH = Tile.CELL_WIDTH
OB_Lightning_Horiz.static.HEIGHT = Tile.CELL_HEIGHT / 2

-- Initialization Function, Sets Initial Member Variables
function OB_Lightning_Horiz:initialize( map, lpos, tpos )
  OB_Lightning.initialize( self, map, lpos, tpos,
                          OB_Lightning_Horiz.WIDTH, OB_Lightning_Horiz.HEIGHT )
end

return OB_Lightning_Horiz
