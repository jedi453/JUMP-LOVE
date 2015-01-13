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
