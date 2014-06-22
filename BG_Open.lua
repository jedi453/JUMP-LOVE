local class = require('lib.middleclass')
local Background = require('Background')

local BG_Open = class( 'BG_Open', Background )

local w = Background.CELL_WIDTH
local h = Background.CELL_HEIGHT
local r, g, b = 0, 0, 0

function BG_Open:initialize( world, lpos, hpos )
  Background.initialize( self, world, false, false, false,
                          lpos*w, hpos*h, w, h,
                          r, g, b )
end


function BG_Open.draw() end


function BG_Open.isSolid() return false end


return BG_Open
