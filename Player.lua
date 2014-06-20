-- Player Class Definitions

Tile = require( 'Tile' )

Player = class( 'Player', Tile )

Player.static.HEIGHT = Tile.CELL_WIDTH
Player.static.WIDTH = Tile.CELL_HEIGHT
Player.static.numPlayers = 0
Player.static.speedHoriz = 50

function Player:initialize( world, lpos, tpos )
  Tile.initialize( self, world, true, lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_WIDTH,
                   Player.WIDTH, Player.HEIGHT,
                   200, 0, 0,
                   true, 0, 0, true )
  self.isAlive = true
  Player.static.numPlayers = Player.static.numPlayers + 1
  self.numPlayer = Player.numPlayers
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

return Player
