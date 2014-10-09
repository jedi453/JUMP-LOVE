local class = require('lib.middleclass')
local bump = require('bump.bump')

-- Tile Class Definitions

-- Tile Holds and Manipulates a Rectangle Game Object

Tile = class('Tile')

-- Maximum Number of Tiles to Display at Once in Each Direction
Tile.static.MAX_VERT = math.floor(30)

-- Android Only -- Size of the Displayed Section of Tiles in the Map
Tile.static.ANDROID_VIEW_SCALE = 0.8

-- Base Cell Size Before Scaling
Tile.static.CELL_WIDTH = 16
Tile.static.CELL_HEIGHT = 16

Tile.static.TILE_ALPHA = 128
if love.system.getOS() == 'Android' then
  --Tile.static.SCALE = math.floor( (love.graphics.getHeight() * Tile.ANDROID_VIEW_SCALE / ( Tile.MAX_VERT * Tile.CELL_HEIGHT )) )
  Tile.static.SCALE = math.floor( (love.graphics.getHeight() * Tile.ANDROID_VIEW_SCALE)/(Tile.MAX_VERT) ) / Tile.CELL_HEIGHT
  --Tile.static.MAX_HORIZ = math.floor(love.graphics.getWidth() * Tile.ANDROID_VIEW_SCALE / ( Tile.SCALE * Tile.CELL_WIDTH ))
  --Tile.static.MAX_HORIZ = math.floor((love.graphics.getWidth()*Tile.ANDROID_VIEW_SCALE)/(Tile.CELL_WIDTH*Tile.SCALE) )
  Tile.static.MAX_HORIZ = 40
else
  Tile.static.SCALE = 1
  Tile.static.SCALE = math.floor( love.graphics.getHeight() / Tile.MAX_VERT) / Tile.CELL_HEIGHT
  Tile.static.MAX_HORIZ = 40
end
-- Scale the Base Cell Size
-- Calculate Cell Width/Height and Round to Nearest Integer
Tile.static.CELL_WIDTH = math.floor(Tile.SCALE * Tile.CELL_WIDTH + 0.5)
Tile.static.CELL_HEIGHT = math.floor(Tile.SCALE * Tile.CELL_HEIGHT + 0.5)
Tile.static.GRAVITY = 500 * Tile.SCALE  -- pixels/second^2
Tile.static.TERMINAL_VY = Tile.SCALE * 350
Tile.static.FLOAT_TOL = 0.0001


-- cc = collision check, l = left, t = top, w = width, h = height, cFilter = Collision Filter Function
function Tile:initialize( map, cc, solid, deadly, l,t,w,h, r,g,b, updates, vx, vy, hasGravity, cFilter )
  -- Initialize Members to Given Values
  self.map = map
  self.world = map.world
  self.cc = cc
  self.solid = solid
  self.deadly = deadly
  self.l, self.t, self.w, self.h = l, t, w, h
  self.r, self.g, self.b = r, g, b
  --print("updates = " .. tostring(updates))
  self.updates = updates or false
  self.vx = vx or 0
  self.vy = vy or 0
  self.hasGravity = hasGravity or false
  self.cFilter = cFilter or function( other ) return other.solid end -- other.cc not Needed, as Only Items w/ cc are Checked

  -- Register Tile with bump if Collisions Should be Checked
  if cc then
    --print( "map.world.add( " .. tostring(map) .. ", " .. tostring(self) .. ", " .. tostring(l) .. ", " .. tostring(t) .. ", " .. tostring(w) .. ", " .. tostring(h) .. " )")
    map.world:add(self, l,t,w,h)
  end
end

-- Don't Draw Outlines/Alpha on GCW0 Version
if love.graphics.getHeight() < 300 then
  function Tile:draw()
    local camera = self.map.camera
    -- Only Draw the Filled in Rectangle, without alpha
    love.graphics.setColor(self.r, self.g, self.b, Tile.static.TILE_ALPHA )
    love.graphics.rectangle( "fill", self.l - camera.l, self.t - camera.t, self.w, self.h )
  end
else
  -- Draw the Tile
  function Tile:draw()
    local camera = self.map.camera

    -- Only Draw the Tile if it's within the Camera's Viewport
    love.graphics.setColor( self.r, self.g, self.b, Tile.static.TILE_ALPHA )
    love.graphics.rectangle( "fill", self.l - camera.l,self.t - camera.t,self.w,self.h )
    love.graphics.setColor( self.r,self.g,self.b )
    love.graphics.rectangle( "line", self.l - camera.l,self.t - camera.t,self.w,self.h )
  end
end

-- Move the Tile, Check for Collisions, Register Change w/ Bump
function Tile:move( new_l, new_t )
  local tl, tt, nx, ny, sl, st
  if self.cc then
    local visited = {}
    local dl, dt = new_l - self.l, new_t - self.t
    local cols, len = self.world:check( self, new_l, new_t, self.cFilter )
    local col = cols[1]
    while len > 0 do
      tl, tt, nx, ny, sl, st = col:getSlide()

      if visited[col.other] then return end -- Thanks to Kikito - Prevent Infinite Loops
      visited[col.other] = true

      -- Handle Collision in Way Specific to Subclass
      self:handleCollision( new_l, new_t, tl, tt, nx, ny, sl, st, col.other )

      --[[ -- Old Collision Handling
      cols, len = self.world:check( self, sl, st, self.cFilter )
      col = cols[1]
      if self.hasGravity and ny > 0 then -- TODO CHECK THIS
        self.vy = 0
      end
      --]]
    end
    --self.l, self.t = sl or new_l, st or new_t
    if ( self.l < 0 ) then self.l = 0 end
    if ( self.t < 0 ) then self.t = 0 end
    self.world:move( self, self.l, self.t )
  else
    self.l, self.t  = new_l, new_t
  end
end

-- Default Collision Handling Function for Tiles
function Tile:handleCollision( new_l, new_t, tl, tt, nx, ny, sl, st, other )
      cols, len = self.world:check( self, sl, st, self.cFilter )
      col = cols[1]
      if self.hasGravity and ny < 0 then -- TODO CHECK THIS
        self.vy = 0
      end
      self.l, self.t = sl or new_l, st or new_t
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
  if self.updates and math.abs(self.vx) > Tile.FLOAT_TOL or math.abs(self.vy) > Tile.FLOAT_TOL then
    self:move( self.l + (self.vx * dt), self.t - (self.vy * dt) )
  end
end

return Tile
