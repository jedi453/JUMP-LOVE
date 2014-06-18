local class = require('lib.middleclass')
local bump = require('bump.bump')

-- Tile Class Definitions

-- Tile Holds and Manipulates a Rectangle Game Object

Tile = class('Tile')

Tile.static.TILE_ALPHA = 128
Tile.static.CELL_WIDTH = 16
Tile.static.CELL_HEIGHT = 16
Tile.static.GRAVITY = 500  -- pixels/second^2

-- cc = collision check, l = left, t = top, w = width, h = height
function Tile:initialize( world, cc, l,t,w,h, r,g,b )
  -- Initialize Members to Given Values
  self.world = world
  self.cc = cc
  self.l, self.t, self.w, self.h = l, t, w, h
  self.r, self.g, self.b = r, g, b
  
  -- Register Tile with bump if Collisions Should be Checked
  if cc then
    world:add(self, l,t,w,h)
  end
end


-- Draw the Tile
function Tile:draw()
  love.graphics.setColor( self.r, self.g, self.b, Tile.static.TILE_ALPHA )
  love.graphics.rectangle( "fill", self.l,self.t,self.w,self.h )
  love.graphics.setColor( self.r,self.g,self.b )
  love.graphics.rectangle( "line", self.l,self.t,self.w,self.h )
end


-- Move the Tile, Check for Collisions, Register Change w/ Bump
function Tile:move( new_l, new_t )
  if self.cc then
    local cols, len = world:check( self )
    while len > 0 do
      tl, tt, nx, ny, sl, st = cols[1].getSlide()
      cols, len = world:check( self, sl, st )
    end
    self.l, self.t = new_l, new_t
    self.world:move( self, new_l, new_t )
  else
    self.l, self.t  = new_l, new_t
  end
end

function Tile:applyGravity(dt)
end

return Tile
