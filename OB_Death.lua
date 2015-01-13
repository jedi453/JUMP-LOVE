--[[

LICENSE

Copyright (c) 2014-2015  Daniel Iacoviello

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

--]]



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
