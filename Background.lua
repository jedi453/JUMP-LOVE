-- Background Class Definitions File

class = require('lib.middleclass')
bump = require('bump.bump')
Tile = require('Tile')

Background = class( 'Background', Tile )

--[[
Background.static.CELL_WIDTH = 16
Background.static.CELL_HEIGHT = 16
--]]

--[[ Background Tile Types
--
--    '00' - Empty, Black, No Collisions
--    'WL' - Wall, Gray/Silver, Prohibits Movement
--    'JP' - Jump Platform, Green, Causes Superjump when Stepped on by Player
--    
--]]

-- cc - Colision Check
--[[
function Background:initialize( world, cc, kind, lpos, tpos )
  local ret -- Return Value
  if kind == '00' then
    ret = Tile:initialize( world, false, -- world, check_collisions
                                  lpos*Background.CELL_WIDTH, tpos*Background.CELL_HEIGHT, -- l, t
                                  Background.CELL_WIDTH, Background.CELL_HEIGHT, -- w, h
                                  0, 0, 0 ) -- r, g, b
    ret.solid = false
    ret.
  elseif kind == 'WL' then
    ret = Tile:initialize( world, true, -- world, check_collisions
                                  lpos*Background.CELL_WIDTH, tpos*Background.CELL_HEIGHT, -- l, t
                                  Background.CELL_WIDTH, Background.CELL_HEIGHT, -- w, h
                                  128, 128, 128 ) -- r, g, b
    ret.solid = true
  elseif kind == 'JP' then
    ret = Tile:initialize( world, true, -- world, check_collisions
                                  lpos*Background.CELL_WIDTH, tpos*Background.CELL_HEIGHT, -- l, t
                                  Background.CELL_WIDTH, Background.CELL_HEIGHT, -- w, h
                                  0, 200, 50 ) -- r, g, b
    ret.solid = true
  end
  ret.kind = kind
  return ret
end
--]]

function Background:initialize( world, cc, l,t,w,h, r,g,b )
  Tile.initialize(self, world, cc, l,t,w,h, r,g,b )
end


return Background
