-- Camera Class Definitions
--  Used to Scroll Maps Larger than Tile.MAX_HORIZ by Tile.MAX_VERT

class = require('lib.middleclass')
Tile = require('Tile')

Camera = class( 'Camera' )


-- Static Members
-- The Size of the Camera
Camera.static.WIDTH = Tile.CELL_WIDTH * Tile.MAX_HORIZ
Camera.static.HEIGHT = Tile.CELL_WIDTH * Tile.MAX_VERT
-- The Number of the Player to Follow
Camera.static.FOLLOW_PLAYER_NUM = 1


-- Initialization Function
function Camera:initialize( map ) -- Map, Top Position, Left Postion
  self.map = map
  self.width = Camera.WIDTH
  self.height = Camera.HEIGHT

  -- Center the Camera Horizontally with the Player, Respecting any Edges
  self.l = self.map.players[Camera.FOLLOW_PLAYER_NUM].l - ( Camera.WIDTH / 2 )
  self.l = math.max( 0, self.l )
  self.l = math.min( self.map.width - Camera.WIDTH, self.l )

  -- Center the Camera Vertically with the Player, Respecting any Edges
  self.t = self.map.players[Camera.FOLLOW_PLAYER_NUM].t - ( Camera.HEIGHT / 2 )
  self.t = math.max( 0, self.t )
  self.t = math.min( self.map.height - Camera.HEIGHT, self.t )
end



-- Update the Camera to Center on the Player, then Move it to be Lined Up with the Edges of the Map
function Camera:update(dt)
  -- Set the L Position, then Line Up with the Edge of the Map if Over it
  self.l = self.map.players[Camera.FOLLOW_PLAYER_NUM].l - ( Camera.WIDTH / 2 )
  self.l = math.max( 0, self.l )
  self.l = math.min( self.map.width - Camera.WIDTH, self.l )

  self.t = self.map.players[Camera.FOLLOW_PLAYER_NUM].t - ( Camera.HEIGHT / 2 )
  self.t = math.max( 0, self.t )
  self.t = math.min( self.map.height - Camera.HEIGHT, self.t )
end


return Camera
