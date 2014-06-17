local class = require('lib.middleclass')
local Background = require('Background')

local Background_Open = class( 'Background_Open', Background )

local w = Background.CELL_WIDTH
local h = Background.CELL_HEIGHT
local r, g, b = 0, 0, 0

function Background_Open:initialize( world, lpos, hpos )
  Background.initialize( self, world, false, 
                          lpos*w, hpos*h, w, h,
                          r, g, b )
end


function Background_Open.draw() end


function Background_Open.isSolid() return false end


return Background_Open
