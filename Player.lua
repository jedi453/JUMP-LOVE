-- Player Class Definitions

Tile = require( 'Tile' )

Player = class( 'Player', Tile )

Player.static.HEIGHT = Tile.CELL_WIDTH
Player.static.WIDTH = Tile.CELL_HEIGHT
Player.static.numPlayers = 0
Player.static.speedHoriz = 100
Player.static.jumpSpeed = 400

function Player:initialize( world, lpos, tpos )
  Tile.initialize( self, world, true, lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_WIDTH,
                   Player.WIDTH, Player.HEIGHT,
                   200, 0, 0,
                   true, 0, 0, true, playerCFilter )
  self.isAlive = true
  Player.static.numPlayers = Player.static.numPlayers + 1
  self.numPlayer = Player.numPlayers
  self.onGround = false
  self.hasDoubleJump = true
end

--[[ To Redefine Later? Maybe the Default Tile:update() is Sufficient
-- Maybe Work Should be Done in Tile:update() so it Doesn't Have to be Redone
function Player:update( dt )
end
--]]

function Player:keypressed( key, isRepeat )
  if self.numPlayer == 1 then
    if key == "left" then
      self.vx = self.vx - Player.speedHoriz
    elseif key == "right" then
      self.vx = self.vx + Player.speedHoriz
    elseif key == "up" and self.onGround then
      self.vy = Player.static.jumpSpeed
    elseif key == "up" and self.hasDoubleJump then
      self.vy = Player.static.jumpSpeed
      self.hasDoubleJump = false
    end
  end
end

function Player:keyreleased( key )
  if self.numPlayer == 1 then
    if key == "left" then
      self.vx = self.vx + Player.speedHoriz
    elseif key == "right" then
      self.vx = self.vx - Player.speedHoriz
    end
  end
end


function Player:checkOnGround( ny )
  if ny < 0 then
    self.onGround = true
    self.hasDoubleJump = true
  end
end


function Player:move( new_l, new_t )
  local tl, tt, nx, ny, sl, st
  self.onGround = false
  if self.cc then
    local visited = {}
    local dl, dt = new_l - self.l, new_t - self.t
    local cols, len = self.world:check( self, new_l, new_t, self.cFilter )
    local col = cols[1]
    while len > 0 do
      tl, tt, nx, ny, sl, st = col:getSlide()
      
      self:checkOnGround( ny )

      if visited[col.other] then return end -- Thanks to Kikito - Prevent Infinite Loops
      visited[col.other] = true

      cols, len = self.world:check( self, sl, st, self.cFilter )
      col = cols[1]
      if self.hasGravity and ny > 0 then --------- TODO: CHECK THIS
        self.vy = 0
      end
    end
    self.l, self.t = sl or new_l, st or new_t
    self.world:move( self, self.l, self.t )
  else
    self.l, self.t  = new_l, new_t
  end
end


function playerCFilter( other )
  return other.cc and other.class.name ~= 'Player'
end

return Player
