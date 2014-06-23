local class = require('lib.middleclass')
local bump = require('bump.bump')

-- Tile Class Definitions

-- Tile Holds and Manipulates a Rectangle Game Object

Tile = class('Tile')

Tile.static.TILE_ALPHA = 128
Tile.static.CELL_WIDTH = 16
Tile.static.CELL_HEIGHT = 16
Tile.static.GRAVITY = 500  -- pixels/second^2
Tile.static.TERMINAL_VY = 350

-- cc = collision check, l = left, t = top, w = width, h = height, cFilter = Collision Filter Function
function Tile:initialize( world, cc, solid, deadly, l,t,w,h, r,g,b, updates, vx, vy, hasGravity, cFilter )
  -- Initialize Members to Given Values
  self.world = world
  self.cc = cc
  self.solid = solid
  self.deadly = deadly
  self.l, self.t, self.w, self.h = l, t, w, h
  self.r, self.g, self.b = r, g, b
  self.updates = updates or false
  self.vx = vx or 0
  self.vy = vy or 0
  self.hasGravity = hasGravity or false
  self.cFilter = cFilter or function( other ) return other.cc and other.solid end

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
  local tl, tt, nx, ny, sl, st
  if self.cc and self.solid then
    local visited = {}
    local dl, dt = new_l - self.l, new_t - self.t
    local cols, len = self.world:check( self, new_l, new_t, self.cFilter )
    local col = cols[1]
    while len > 0 do
      tl, tt, nx, ny, sl, st = col:getSlide()

      if visited[col.other] then return end -- Thanks to Kikito - Prevent Infinite Loops
      visited[col.other] = true

      cols, len = self.world:check( self, sl, st, self.cFilter )
      col = cols[1]
      if self.hasGravity and ny > 0 then -- TODO CHECK THIS
        self.vy = 0
      end
    end
    self.l, self.t = sl or new_l, st or new_t
    self.world:move( self, self.l, self.t )
  else
    self.l, self.t  = new_l, new_t
  end
end

-- Default Collision Handling Function for Tiles
function Tile:handleCollision( tl, tt, nx, ny, sl, st, other )
end

function Tile:calcGravity(dt)
  if self.hasGravity then
    self.vy = self.vy - ( Tile.GRAVITY * dt )
    if self.vy < -Tile.TERMINAL_VY then
      self.vy = -Tile.TERMINAL_VY
    end
  end
end

function Tile:update(dt)
  if self.hasGravity then
    self:calcGravity( dt )
  end
  if self.updates and self.vx ~= 0 or self.vy ~= 0 then
    self:move( self.l + (self.vx*dt), self.t - (self.vy*dt) )
  end
end

return Tile
