--[[

LICENSE

Copyright (c) 2014-2015  Daniel Iacoviello

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

--]]



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
