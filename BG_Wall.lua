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
