--- JumpPad Class Definitions

class = require('lib.middleclass')
Tile = require('Tile')
Background = require('Background')
Player = require('Player')

JumpPad = class('JumpPad', Background)

-- Default JumpPad Attributes
JumpPad.static.CC = true
JumpPad.static.SOLID = true
JumpPad.static.DEADLY = false

JumpPad.static.WIDTH = Tile.CELL_WIDTH
JumpPad.static.HEIGHT = Tile.CELL_HEIGHT

JumpPad.static.R = 50
JumpPad.static.G = 200
JumpPad.static.B = 50

JumpPad.static.UPDATES = false
JumpPad.static.VX = 0
JumpPad.static.VY = 0
JumpPad.static.HAS_GRAVITY = false

function JumpPad:initialize( map, lpos, tpos )
  Tile.initialize( self, map, JumpPad.CC, JumpPad.SOLID, JumpPad.DEADLY,
                    lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_HEIGHT, JumpPad.WIDTH, JumpPad.HEIGHT,
                    JumpPad.R, JumpPad.G, JumpPad.B,
                    JumpPad.UPDATES, JumpPad.VX, JumpPad.VY,
                    JumpPad.HAS_GRAVITY )
end


return JumpPad
