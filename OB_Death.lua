-- Death Obstical (OB_Death) Class Definitions
-- Black Non-solid Cell that Causes Player Death

-- CODE: "DT"

class = require("lib.middleclass")
Tile = require("Tile")
Obstical = require("Obstical")


OB_Death = class("OB_Death", Obstical)



-- Initializer
function OB_Death:initialize( map, lpos, tpos, w, h )
  w = w or Tile.CELL_WIDTH
  h = h or Tile.CELL_HEIGHT
  -----------------------map, cc,   solid, deadly
  Tile.initialize( self, map, true, false, true,
                    lpos*Tile.CELL_WIDTH - ( Tile.CELL_WIDTH - w )/2,     -- Left Position - l
                    tpos*Tile.CELL_HEIGHT - ( Tile.CELL_HEIGHT - h )/2,   -- Top Position  - t
                    w, h,       -- Width, Height
                    50, 50, 50, -- R, G, B
                    false,   0,   0, false)   -- updates, vx, vy, hasGravity
  ------------------updates, vx, vy, hasGravity
end


-- Return New Type -- OB_Death
return OB_Death
