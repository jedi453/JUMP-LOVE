-- Player Class Definitions

-- CODE: In map file, "Player:" Header then the T, L Coordinates of Each Player ( 0 Based )

Tile = require( 'Tile' )
Player = class( 'Player', Tile )

Player.static.HEIGHT = Tile.CELL_WIDTH
Player.static.WIDTH = Tile.CELL_HEIGHT
Player.static.numPlayers = 0
Player.static.speedHoriz = 150 * Tile.SCALE
Player.static.jumpSpeed = 300 * Tile.SCALE
Player.static.CANNON_SPEED = Player.jumpSpeed
Player.static.superJumpSpeed = 2 * Player.jumpSpeed
Player.static.leftKeys = { "left", "a" }
Player.static.rightKeys = { "right", "d" }
-- Attempt to Change Jump Key to Space On the GCW0
if love.graphics.getHeight() < 300 then
  Player.static.jumpKeys = { " ", "w" }
else
  Player.static.jumpKeys = { "up", "w" }
end
Player.static.maxPlayers = 2
-- Offset to Prevent Player Getting Stuck when Exactly Positioned on Block
Player.static.OFFSET = Tile.FLOAT_TOL 

function Player:initialize( map, lpos, tpos )
  -- Only Add to Player Count if Creating a new Player
  if not self.numPlayer then
    Player.static.numPlayers = Player.static.numPlayers + 1
    self.numPlayer = Player.numPlayers
  end
  if Player.numPlayers > Player.maxPlayers then
    error("Maximum of " .. tostring(Player.maxPlayers) .. " Players Supported...")
  end
  Tile.initialize( self, map, true, true, false, 
                   lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_WIDTH, -- left, top - Adjusted to Prevent Getting Stuck
                   Player.WIDTH, Player.HEIGHT,  -- width, height - Adjusted to Prevent Getting Stuck
                   255 - ( ( self.numPlayer-1 ) * 63 ), 0, (self.numPlayer - 1) * 63,
                   true, 0, 0, true )
  self.isAlive = true
  self.onGround = false
  self.hasDoubleJump = true
  self.map = map
  self.origTPos = self.t
  self.origLPos = self.l
  --self.cFilter = Player.cFilter
  -- If Keys Are Held Down Already, Adjust Velocity Accordingly
  self.vxRiding = 0
  self.vyRiding = 0
  --self:adjustInitialVelocity() -- OLD - NOW HANDLED BY MAP!
  self.isPlayer = true

  -- True if the Player is in a Cannon
  self.inCannon = false
  -- Holds a Reference to the Cannon the Player is in
  self.cannon = nil
  self.flying = false
  self.vxFlying = 0
  self.vyFlying = 0
end

-- Make Sure the Player Can Jump then Jump
-- Or Shoot the Cannon if the Player is in a Cannon
function Player:jump()
  if self.inCannon then
    self:shootCannon()
	elseif self.isAlive and not self.flying then
    if self.onGround then
      self.vy = Player.jumpSpeed
      self.map:playMedia("jump")
      self.onGround = false
    elseif self.hasDoubleJump then
      self.vy = Player.jumpSpeed
      self.map:playMedia("jump")
      self.hasDoubleJump = false
    end
  end
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
    -- Will Shoot Cannon Instead if in One
  	self:jump()
  end
end


-- Enter a Cannon
function Player:enterCannon( cannon )
  if cannon then
    self.inCannon = true
    self.cannon = cannon
    self.flying = false
    cannon:addPlayer( self )
  end
end


-- Shoot the Player Out of the Cannon into the Wild Blue Yonder!
function Player:shootCannon()
  if self.cannon then
    local cannon = self.cannon
    local newL = cannon.l + (cannon.w*cannon.directionX)
    local newT = cannon.t + (cannon.h*cannon.directionY)
    -- Make sure the Player can Enter the Block
    -- Player is Flying ( Not Affected By Gravity )
    self.flying = true
    self.vxFlying = cannon.directionX * Player.CANNON_SPEED
    -- Player is no Longer in a Cannon
    self.inCannon = false
    self.cannon:removePlayer( self )
    self.cannon = nil
    -- Do this Last as Normally Collision isn't Checked the Same way -- TODO CHECK THIS!
    self:move( newL, newT )
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
    self.vy = 0 --- TODO CHECK THIS
    return true
  end
  return false
end

function Player:kill()
  self.isAlive = false
  self.t = math.min( self.map.height - Player.HEIGHT, self.t )
  self.vy = Player.jumpSpeed / 2
  self:move( self.l, self.t )
  self.map:playMedia("kill")
end


function Player:respawn()
  self.l = self.origLPos
  self.t = self.origTPos 
  self.world:move( self, self.l,self.t,self.w,self.h )
  self.isAlive = true
  self.vy = 0
  self.map:reset()
  self.flying = false
  self.inCannon = false
end


function Player:beatMap()
  self.map:nextLevel()
end

-- Move Player to New Location Checking for Collisions if Applicable
----- TODO FIX When Player is Perfectly Lined Up with the Block Below, it Can't Move
function Player:move( new_l, new_t )
  local tl, tt, nx, ny, sl, st
  -- Assume Not On Ground Until Proven Otherwise
  self.onGround = false

  if self.isAlive and not self.inCannon then
  
    -- Check for Solid Obstical Collisions, Handle them
    local cols, len = self.map.world:check( self, new_l, new_t, Player.cFilterSolid )
    if len == 0 then
      self.l, self.t = new_l, new_t -- Move to New Position
      self.world:move( self, self.l,self.t, self.w,self.h )  -- Let bump Know About the Move
    else
      -- Stop the Player From Flying Further
      self.flying = false
      -- Keep Adjusting Location Until there are No More Collisions or all Have Been Checked
      while len > 0 do
        local visited = {}
        local col = cols[1]
        -- Get Adjusted/Corrected Location and Collsion Normals
        tl, tt, nx, ny, sl, st = col:getSlide()
        -- Check if Player is On the Ground and Reset isOnGround and hasDoubleJump if Needed
        self:checkOnGround( ny )

        -- Thanks to Kikito - Prevent Infinite Loops
        if visited[col.other] then break end
        visited[col.other] = true
        
        -- Move the Player Until they Just Touch the Obstical
        self.l, self.t = tl, tt
        self.map.world:move( self, tl,tt,self.w,self.h )

        -- Recalculate Collisions
        cols, len = self.map.world:check( self, sl, st, Player.cFilterSolid )
        if len == 0 then
          -- Move with Slide
          --if st > self.t then self.map.comment = 'st = ' .. tostring(st) end -- TODO REMOVE DEBUG
          self.l, self.t = sl, st
          self.map.world:move( self, sl,st, self.w,self.h )
        end

        -- Set Vertical Velocity to 0 if On or Below a Solid Object
        if self.hasGravity and math.abs(ny) > Tile.FLOAT_TOL then 
          self.vy = 0
        end
      end
    end

    -- Make Sure the Player Doesn't Move out of the Map
    if self.l < 0 then
      self.l = 0
      self.map.world:move( self, self.l,self.t, self.w,self.h )
      self.flying = false
    end
    if self.t < 0 then 
      self.t = 0
      self.vy = 0
      self.map.world:move( self, self.l,self.t, self.w,self.h )
      self.flying = false
    end
    -- Kill the Player If Below the Bottom of the Map
    if self.t > self.map.height then
      self:kill()
      return
    end
  else
    -- Player isn't Alive, so Don't Obey Normal Collision Checking Rules
    self.t = new_t
    if self.t > self.map.height then
      self:respawn()
    end
  end
  
end



-- Draw the Player when Applicable
function Player:draw()
  if self.isAlive and not self.inCannon then
    Tile.draw(self)
  end
end


-- Check for Deadly Collisions
function Player:checkDeadly()
    local cols, len = self.map.world:check( self, self.l, self.t, Player.cFilterDeadly )
    if len > 0 then self:kill() end
end

-- Check if Win Condition is Met ( Player Passed Right Edge of Map
function Player:checkWin()
  -- Check Win Condition
  if self.isAlive and self.l > self.map.width then
    self:beatMap()
  end
end

-- Change this To Handle Being on Objects that Have Velocity
function Player:update( dt )
  -- Only Update the Player if they're not in a Cannon
  if not self.inCannon then
    self.vxRiding, self.vyRiding = 0, 0
    if not self.flying and not self.inCannon then
      self:calcGravity( dt )
    end

    -- Only Check for Special Tiles if the Player is Alive
    if self.isAlive and not self.inCannon then
      --local new_l, new_t = self.l + (self.vx*dt), self.t - (self.vy*dt)
      -- Check For Moving Platforms/Conveyor Belts, Move Accordingly
      self:adjustVelocityByRiding()

      -- Check for JumpPad, Adjust Velocity Accordingly
      self:adjustVelocityByJumpPad()

      -- Check for JumpArrow, Collect if Needed
      self:checkJumpArrow()

      -- Check for Cannon, Enter if Touching
      self:checkCannon()
    end

    -- Avoid Getting Stuck When On the Ground, Lined Up with the Cell Below
    if self.onGround then
      -- Player is On the Ground, Only Move Left/Right
      self:move( self.l + ( (self.vx + self.vxRiding) * dt ), self.t )
      -- Check if the Player is On the Ground
      local cols, len = self.map.world:check( self, self.l, self.t - (self.vy+self.vyRiding)*dt, Player.cFilter )
      -- Loop Through Collisions, Breaking if/when a Collision Says the Player is On the Ground
      for i = 1, len do
        local tl, tt, nx, ny = cols[i]:getTouch()
        if self:checkOnGround(ny) then break end
      end
    else
      -- Player is Not On the Ground, Move Normally
      self:move( self.l + ( (self.vx + self.vxRiding) * dt), 
                self.t - ( (self.vy + self.vyRiding) * dt) )
    end

    -- Check for Deadly Obstical
    if self.isAlive then
      self:checkDeadly()
    end

    -- Check for Win Condition
    self:checkWin()
  end
end


-- OLD -- Now Handled By Map!
--[[
-- Set Initial Velocity at Start of Level to Correspond With Current Keys
function Player:adjustInitialVelocity()
  if love.keyboard.isDown( Player.leftKeys[ self.numPlayer ] ) then
    self.vx = -Player.speedHoriz
  elseif love.keyboard.isDown( Player.rightKeys[ self.numPlayer ] ) then
    self.vx = Player.speedHoriz
  end
end
--]]


-- Check for a Moving Platform Below the Player and Increase Base Velocity to Match
function Player:adjustVelocityByRiding()
  local ridingFilter = function( other ) return other.class.name == 'OB_Platform'; end
  local cols, len = self.map.world:check( self, self.l, self.t+1, ridingFilter )
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

-- Check for a JumpPad Below the Player and Cause Superjump if Detected
function Player:adjustVelocityByJumpPad()
  local jumpPadFilter = function( other ) return other.class.name == 'JumpPad'; end
  local cols, len = self.map.world:check( self, self.l, self.t+1, jumpPadFilter )
  local visited = {}
  if len > 0 then
    self.onGround = false
    self.hasDoubleJump = true
    self.vy = Player.superJumpSpeed 
    self.map:playMedia("jump")
  end
end

-- Check for a Double Jump Arrow Under the Player, and Try to Collect it if Applicable
function Player:checkJumpArrow()
  if not self.hasDoubleJump then
    local jumpArrowFilter = function( other ) return other.class.name == 'JumpArrow'; end
    local cols, len = self.map.world:check( self, self.l, self.t, jumpArrowFilter )
    local visited = {}
    for i = 1, len do
      local col = cols[i]
      self.hasDoubleJump = col.other:collect()

      -- Stop Checking After Finding a Full JumpArrow
      if self.hasDoubleJump then return end
    end
  end
end


-- Check for a Cannon Touching the Player and Enter it if There
function Player:checkCannon()
	local cannonFilter = function( other ) return other.isCannon; end
  local cols, len = self.map.world:check( self, self.l, self.t, cannonFilter )
  -- Enter Cannon if Touching
  if len > 0 then
    self:enterCannon( cols[1].other )
  end
end

--[[ -- Old Overly Generic Collision Checking
-- Only Handle Collisions with these Objects
function Player.static.cFilter( other )
  return other.cc and ( other.solid or other.deadly ) and other.class.name ~= 'Player'
end
--]]

-- Movement Collision Checking
function Player.static.cFilterSolid(other)
  return other.solid and not other.isPlayer
end

-- Deadly Stuff Collision Checking
function Player.static.cFilterDeadly(other)
  return other.deadly
end

return Player
