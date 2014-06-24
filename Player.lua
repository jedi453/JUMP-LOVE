-- Player Class Definitions

Tile = require( 'Tile' )
Player = class( 'Player', Tile )

Player.static.HEIGHT = Tile.CELL_WIDTH
Player.static.WIDTH = Tile.CELL_HEIGHT
Player.static.numPlayers = 0
Player.static.speedHoriz = 150
Player.static.jumpSpeed = 300
Player.static.leftKeys = { "left", "a" }
Player.static.rightKeys = { "right", "d" }
Player.static.jumpKeys = { "up", "w" }
Player.static.maxPlayers = 2

function Player:initialize( map, lpos, tpos )
  -- Only Add to Player Count if Creating a new Player
  if not self.numPlayer then
    Player.static.numPlayers = Player.static.numPlayers + 1
    self.numPlayer = Player.numPlayers
  end
  if Player.numPlayers > Player.maxPlayers then
    error("Maximum of " .. tostring(Player.maxPlayers) .. " Players Supported...")
  end
  Tile.initialize( self, map, true, true, false, lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_WIDTH,
                   Player.WIDTH, Player.HEIGHT,
                   255 - ( ( self.numPlayer-1 ) * 63 ), 0, (self.numPlayer - 1) * 63,
                   true, 0, 0, true, Player.cFilter )
  self.isAlive = true
  self.onGround = false
  self.hasDoubleJump = true
  self.map = map
  self.origTPos = self.t
  self.origLPos = self.l
  self.cFilter = Player.cFilter
  -- If Keys Are Held Down Already, Adjust Velocity Accordingly
  self.vxRiding = 0
  self.vyRiding = 0
  self:adjustInitialVelocity()
end

--[[ To Redefine Later? Maybe the Default Tile:update() is Sufficient
-- Maybe Work Should be Done in Tile:update() so it Doesn't Have to be Redone
function Player:update( dt )
end
--]]

function Player:jump()
  self.vy = Player.jumpSpeed
  self.map:playMedia("jump")
end

-- Move Change Velocity of Player when their Key is Pressed
function Player:keypressed( key, isRepeat )
  -- Player Number Independant Keypress Reactions
  if key == Player.leftKeys[self.numPlayer] then
    self.vx = self.vx - Player.speedHoriz
  elseif key == Player.rightKeys[self.numPlayer] then
    self.vx = self.vx + Player.speedHoriz
  elseif key == Player.jumpKeys[self.numPlayer] then
    -- Checking Done in Jump Function
    if self.isAlive then
      if self.onGround then
        self:jump()
      elseif self.hasDoubleJump then
        self.hasDoubleJump = false
        self:jump()
      end
    end
  end
end

-- 
function Player:keyreleased( key )
  -- Player Number Independant Key Release Reactions
  if key == Player.leftKeys[self.numPlayer] then
    self.vx = self.vx + Player.speedHoriz
  elseif key == Player.rightKeys[self.numPlayer] then
    self.vx = self.vx - Player.speedHoriz
  end
end


--[[ Check if the Player is On the Ground, and Reset hasDoubleJump,
--    onGround
--]]
function Player:checkOnGround( ny )
  if ny < 0 then
    self.onGround = true
    self.hasDoubleJump = true
  end
end

function Player:kill()
  self.isAlive = false
  self.t = math.min( self.map.height - Player.HEIGHT, self.t )
  self.vy = Player.jumpSpeed / 2
  self:move( self.l, self.t )
end


function Player:respawn()
  self.l = self.origLPos
  self.t = self.origTPos 
  self.world:move( self, self.l, self.t )
  self.isAlive = true
  self.vy = 0
end


function Player:beatMap()
  self.map:nextLevel()
end

-- Move Player to New Location Checking for Collisions if Applicable
function Player:move( new_l, new_t )
  local tl, tt, nx, ny, sl, st
  -- Assume Not On Ground Until Proven Otherwise
  self.onGround = false
  if self.cc and self.isAlive then
    -- Obey Normal Collision Checking Rules
    
    local visited = {}
    -- dl, dt -- Delta_Left, Delta_Top -- Change in Position
    local dl, dt = new_l - self.l, new_t - self.t
    -- Get Collisions for New Location

    --[[
    -- Make Sure we didn't start with a Collsion
    local cols, len = self.world:check( self )
    assert( len == 0 )
    ]]

    local cols, len = self.world:check( self, new_l, new_t, self.cFilter )
    local col = cols[1]
    -- Keep Adjusting Location Until there are No More Collisions or all Have Been Checked
    while len > 0 do
      -- If Touching a Deadly Object, Kill the Player
      if col.other.deadly then
        self:kill()
        return
      end
      -- Get Adjusted/Corrected Location and Collsion Normals
      tl, tt, nx, ny, sl, st = col:getSlide()
      --[[ Check if the Player is On the Ground, and Reset hasDoubleJump,
      --    onGround and vy if they are
      --]]
      self:checkOnGround( ny )

      -- Thanks to Kikito - Prevent Infinite Loops
      if visited[col.other] then return end
      visited[col.other] = true

      -- Recalculate Collisions
      cols, len = self.world:check( self, sl, st, self.cFilter )
      col = cols[1]

      -- Set Vertical Velocity to 0 if on a Solid Object
      if self.hasGravity and ny ~= 0 then --------- TODO: CHECK THIS
        self.vy = 0
      end
    end
    self.l, self.t = sl or new_l, st or new_t
    self.l = math.max( self.l, 0 )
    --if self.l < 0 then self.l = 0 end
    if self.t < 0 then 
      self.t = 0
      self.vy = 0
    end
    if self.t > self.map.height then
      self:kill()
    end
    self.world:move( self, self.l, self.t )
  else
    -- Don't Obey Normal Collision Checking Rules
    if self.isAlive then
      self.l, self.t  = new_l, new_t
    else
      self.t = new_t
      if self.t > self.map.height then
        self:respawn()
      end
    end
  end

  -- Check Win Condition
  if self.isAlive and self.l > self.map.width then
    self:beatMap()
  end
end

-- Change this To Handle Being on Objects that Have Velocity
function Player:update( dt )
  self.vxRiding, self.vyRiding = 0, 0
  self:calcGravity( dt )
  --local new_l, new_t = self.l + (self.vx*dt), self.t - (self.vy*dt)
  self:adjustVelocityByRiding()
  self:move( self.l + ( (self.vx + self.vxRiding) * dt), 
              self.t - ( (self.vy + self.vyRiding) * dt) )
end

function Player:adjustInitialVelocity()
  if love.keyboard.isDown( Player.leftKeys[ self.numPlayer ] ) then
    self.vx = -Player.speedHoriz
  elseif love.keyboard.isDown( Player.rightKeys[ self.numPlayer ] ) then
    self.vx = Player.speedHoriz
  end
end

function Player:adjustVelocityByRiding()
  local cols, len = self.map.world:check( self, self.l, self.t+1, Player.cFilter )
  local visited = {}
  while len > 0 do
    local col = cols[1]
    if visited[col.other] then break end -- Don't Infinitely Loop, and Prevent Adjusting Velocity Twice
    visited[col.other] = true
    if math.abs( col.other.vx ) > Tile.FLOAT_TOL then
      self.vxRiding = self.vxRiding + col.other.vx
    end
    if math.abs( col.other.vy ) > Tile.FLOAT_TOL then
      self.vyRiding = self.vyRiding + col.other.vy
    end
  end
end

-- Only Handle Collisions with these Objects
function Player.static.cFilter( other )
  return other.cc and ( other.solid or other.deadly ) and other.class.name ~= 'Player'
end


return Player
