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
