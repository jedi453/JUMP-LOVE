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

--[==[
-- Attempt to Create Canvases to Speed up Drawing, Doesn't Work on GCW0
function BG_Wall.load()
  BG_Wall.static.canvas = love.graphics.newCanvas(w, h)
  love.graphics.setCanvas(BG_Wall.static.canvas)
    BG_Wall.canvas:clear(0, 0, 0)
    love.graphics.setColor( r, g, b, Tile.static.TILE_ALPHA )
    love.graphics.rectangle( "fill", 0, 0, w, h )
    love.graphics.setColor( r, g, b )
    love.graphics.rectangle( "line", 0, 0, w, h )
  love.graphics.setCanvas()
end
--]==]


--[=[
-- Attempt to Support Canvases to Speed Up Drawing, Doesn't Work on GCW0
function BG_Wall:draw()
  local camera = self.map.camera
  love.graphics.setColor( 255, 255, 255 )
  love.graphics.setBlendMode('premultiplied')
  love.graphics.draw( BG_Wall.canvas, self.l - camera.l, self.t - camera.t )
  love.graphics.setBlendMode('alpha')
end
--]=]

return BG_Wall
