-- BG_Wall Class Definition File

local class = require('lib.middleclass')
local Background = require('Background')

local w = Background.CELL_WIDTH
local h = Background.CELL_HEIGHT
local r, g, b = 128, 128, 128

local BG_Wall = class( 'BG_Wall', Background )

BG_Wall.static.w = w
BG_Wall.static.h = h

function BG_Wall:initialize( world, lpos, tpos )
  --                           world, cc, solid, deadly,
  Background.initialize( self, world, true, true, false,
                         lpos*w, tpos*h, w, h,
                         r, g, b )
end

function BG_Wall.isSolid() return true end


return BG_Wall
