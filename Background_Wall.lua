-- Background_Wall Class Definition File

local class = require('lib.middleclass')
local Background = require('Background')

local w = Background.CELL_WIDTH
local h = Background.CELL_HEIGHT
local r, g, b = 128, 128, 128

local Background_Wall = class( 'Background_Wall', Background )

Background_Wall.static.w = w
Background_Wall.static.h = h

function Background_Wall:initialize( world, lpos, tpos )
  Background.initialize( self, world, true,
                         lpos*w, tpos*h, w, h,
                         r, g, b )
end

function Background_Wall.isSolid() return true end


return Background_Wall
