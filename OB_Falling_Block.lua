-- Falling Block Obstical ( OB_Falling_Block ) 

-- MAP CODE: "FB"


class = require('lib.middleclass')
Tile = require('Tile')
Obstical = require('Obstical')

OB_Falling_Block = class('OB_Falling_Block', Obstical)



-- OB_Falling_Block Default Characteristics
-- Interaction
OB_Falling_Block.static.CC = true
OB_Falling_Block.static.SOLID = true
OB_Falling_Block.static.DEADLY = false
-- Size
OB_Falling_Block.static.WIDTH = Tile.CELL_WIDTH
OB_Falling_Block.static.HEIGHT = Tile.CELL_HEIGHT
-- Color
OB_Falling_Block.static.R = 0
OB_Falling_Block.static.G = 0
OB_Falling_Block.static.B = 200
-- Additional Properties
OB_Falling_Block.static.UPDATES = true
OB_Falling_Block.static.VX = 0
OB_Falling_Block.static.VY0 = 0
OB_Falling_Block.static.HAS_GRAVITY = false
OB_Falling_Block.static.GRAVITY = Tile.GRAVITY
OB_Falling_Block.static.TERMINAL_VY = Tile.TERMINAL_VY
-- Time to Wait After Stepped on Before Falling ( in Seconds )
OB_Falling_Block.static.FALL_WAIT = 0.5
OB_Falling_Block.static.STEPPED_ON0 = false

--- Only Activate self.steppedOn if Colliding with a Player that's Alive
OB_Falling_Block.static.STEPPED_ON_C_FILTER = function( other )
  return other.isPlayer and other.isAlive
end

function OB_Falling_Block:initialize( map, lpos, tpos )
  
  Tile.initialize( self, map, 
                    OB_Falling_Block.CC, OB_Falling_Block.SOLID, OB_Falling_Block.DEADLY, -- Collision Check, Solid, Deadly,
                    lpos*Tile.CELL_WIDTH - ( Tile.CELL_WIDTH - OB_Falling_Block.WIDTH )/2,
                    tpos*Tile.CELL_HEIGHT - ( Tile.CELL_HEIGHT - OB_Falling_Block.HEIGHT )/2,
                    OB_Falling_Block.WIDTH, OB_Falling_Block.HEIGHT, -- Width, Height
                    OB_Falling_Block.R, OB_Falling_Block.G, OB_Falling_Block.B,   -- Color
                    OB_Falling_Block.UPDATES, OB_Falling_Block.VX, OB_Falling_Block.VY0, OB_Falling_Block.HAS_GRAVITY ) -- Movement
  self.steppedOn = OB_Falling_Block.STEPPED_ON0 -- True When a Player Has Stepped on the Block
  self.timeTillFall = OB_Falling_Block.FALL_WAIT
  -- Initial Conditions Used for reset()
  self.startL = lpos*Tile.CELL_WIDTH - ( Tile.CELL_WIDTH - OB_Falling_Block.WIDTH )/2
  self.startT = tpos*Tile.CELL_HEIGHT - ( Tile.CELL_HEIGHT - OB_Falling_Block.HEIGHT )/2
end


-- Calculate and Limit the Change in Position Based on Gravity
function OB_Falling_Block:calcGravity( dt )
  self.vy = self.vy - OB_Falling_Block.GRAVITY*dt
  self.vy = math.max( self.vy, -OB_Falling_Block.TERMINAL_VY )
end


-- Update the OB_Falling_Block
-- Figure out when it Should Start Falling and How Far to Go
function OB_Falling_Block:update( dt )

  -- Fall When Appropriate
  if self.steppedOn then
    self.timeTillFall = self.timeTillFall - dt
  else
    --- Example Debug
    --self.map.comment = 'Not Stepped On' -- TODO REMOVE DEBUG
  end
  if self.timeTillFall <= 0 then
    self.hasGravity = true
    -- Prevent timeTillFall becoming too low
    self.steppedOn = false
  end

  -- On Collision with the Player, Activate Gravity
  -- Check for Player Block Above
  if not self.steppedOn then
    -- Check for Player Above self
    local cols, len = self.map.world:check( self, self.l, self.t-1, OB_Falling_Block.STEPPED_ON_C_FILTER )
    if len ~= 0 then
      for i = 1,len do
        local ny
        col = cols[i]
        _, _, _, ny = col:getTouch()
        if ny > 0 then
          self.steppedOn = true
        end
      end
    end
  end
  
  if self.hasGravity then
    self:calcGravity( dt )
    self:move( self.l, self.t - (self.vy*dt) )
  end
end

-- Move the Block 
function OB_Falling_Block:move( new_l, new_t )
  local cFilter = function(other) return other.solid end

  local cols, len = self.map.world:check( self, new_l, new_t, cFilter )
  local visited = {}
  while len > 0 do
    if not visited[col] then
      for i = 1, len do
        local col = cols[i]
        visited[col] = true
        local tl, tt, nx, ny = col:getTouch()
        new_t = tt or new_t
        new_t = math.max( new_t, 0 )
        new_t = math.min( new_t, self.map.height+Tile.CELL_HEIGHT ) -- Let OB_Falling_Block Fall out of Map, but not too far
        -- Reset Vertical Velocity if On Block
        if ny < 0 then
          self.vy = 0
        end
      end
      cols, len = self.map.world:check( self, new_l, new_t, cFilter )
    end
  end
  self.world:move( self, self.l, new_t )
  new_t = math.max( new_t, 0 )
  new_t = math.min( new_t, self.map.height+Tile.CELL_HEIGHT ) -- Let OB_Falling_Block Fall out of Map, but not too far
  self.t = new_t or self.t
end


-- Reset Block when Player Dies
function OB_Falling_Block:reset()
  -- Move Back
  self.l = self.startL
  self.t = self.startT
  self.map.world:move( self, self.l, self.t )
  -- Reset Velocities
  self.vx = OB_Falling_Block.VX
  self.vy = OB_Falling_Block.VY0
  -- Not Falling Stuff
  self.steppedOn = false -- OB_Falling_Block.STEPPED_ON0
  self.timeTillFall = OB_Falling_Block.FALL_WAIT
  self.hasGravity = OB_Falling_Block.HAS_GRAVITY
end

return OB_Falling_Block
