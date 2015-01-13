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



-- BG_Wall Class Definition File
--
--  Code: 

local class = require('lib.middleclass')
local Background = require('Background')

local w = Background.CELL_WIDTH
local h = Background.CELL_HEIGHT
local r, g, b = 128, 128, 128

local BG_Wall = class( 'Wall', Background )

BG_Wall.static.w = w
BG_Wall.static.h = h


function BG_Wall:initialize( map, lpos, tpos )
  --                           map, cc, solid, deadly,
  Background.initialize( self, map, true, true, false,
                         lpos*Background.CELL_WIDTH, tpos*Background.CELL_HEIGHT, w, h,
                         r, g, b,
  --                  updates, vx, vy, hasGravity
                         false, 0, 0, false )
end

function BG_Wall.isSolid() return true end

return BG_Wall
