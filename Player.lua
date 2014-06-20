-- Player Class Definitions

Tile = require( 'Tile' )

Player = class( 'Player', Tile )

Player.static.HEIGHT = Tile.CELL_WIDTH
Player.static.WIDTH = Tile.CELL_HEIGHT
Player.static.numPlayers = 0
Player.static.speedHoriz = 100
Player.static.jumpSpeed = 400

function Player:initialize( world, lpos, tpos, map )
  -- Only Add to Player Count if Creating a new Player
  if not self.numPlayer then
    Player.static.numPlayers = Player.static.numPlayers + 1
    self.numPlayer = Player.numPlayers
  end
  Tile.initialize( self, world, true, lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_WIDTH,
                   Player.WIDTH, Player.HEIGHT,
                   255 - ( ( self.numPlayer-1 ) * 63 ), 0, (self.numPlayer - 1) * 63,
                   true, 0, 0, true, playerCFilter )
  self.isAlive = true
  self.onGround = false
  self.hasDoubleJump = true
  self.map = map
  self.origTPos = self.t
  self.origLPos = self.l
  -- If Keys Are Held Down Already, Adjust Velocity Accordingly
  if love.keyboard.isDown( "left" ) then self.vx = - Player.speedHoriz end
  if love.keyboard.isDown( "right" ) then self.vx = self.vx + Player.speedHoriz end
end

--[[ To Redefine Later? Maybe the Default Tile:update() is Sufficient
-- Maybe Work Should be Done in Tile:update() so it Doesn't Have to be Redone
function Player:update( dt )
end
--]]


-- Move Change Velocity of Player when their Key is Pressed
function Player:keypressed( key, isRepeat )
  if self.numPlayer == 1 then
    if key == "left" then
      self.vx = self.vx - Player.speedHoriz
    elseif key == "right" then
      self.vx = self.vx + Player.speedHoriz
    elseif key == "up" and self.onGround and self.isAlive then
      self.vy = Player.static.jumpSpeed
    elseif key == "up" and self.hasDoubleJump and self.isAlive then
      self.vy = Player.static.jumpSpeed
      self.hasDoubleJump = false
    end
  elseif self.numPlayer == 2 then
    if key == "a" then
      self.vx = self.vx - Player.speedHoriz
    elseif key == "d" then
      self.vx = self.vx + Player.speedHoriz
    elseif key == "w" and self.onGround then
      self.vy = Player.static.jumpSpeed
    elseif key == "w" and self.hasDoubleJump then
      self.vy = Player.static.jumpSpeed
      self.hasDoubleJump = false
    end
  end
end


-- 
function Player:keyreleased( key )
  if self.numPlayer == 1 then
    if key == "left" then
      self.vx = self.vx + Player.speedHoriz
    elseif key == "right" then
      self.vx = self.vx - Player.speedHoriz
    end
  elseif self.numPlayer == 2 then
    if key == "a" then
      self.vx = self.vx + Player.speedHoriz
    elseif key == "d" then
      self.vx = self.vx - Player.speedHoriz
    end
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
  self.t = self.map.height - Player.HEIGHT
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
  local map = self.map
  map:nextLevel()
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
    local cols, len = self.world:check( self, new_l, new_t, self.cFilter )
    local col = cols[1]
    -- Keep Adjusting Location Until there are No More Collisions or all Have Been Checked
    while len > 0 do
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


function playerCFilter( other )
  return other.cc and other.class.name ~= 'Player'
end

return Player
