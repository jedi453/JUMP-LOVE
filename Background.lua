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



-- Background Class Definitions File

class = require('lib.middleclass')
Tile = require('Tile')

Background = class( 'Background', Tile )

function Background:initialize(...)
  Tile.initialize( self, ... )
end


-- Background Tiles Don't Need Fancy Alphas
function Background:draw()
  local camera = self.map.camera

  love.graphics.setColor( self.ra/255, self.ga/255, self.ba/255 )
  love.graphics.rectangle( "fill", self.l - camera.l,self.t - camera.t,self.w,self.h )
  love.graphics.setColor( self.r/255,self.g/255,self.b/255 )
  love.graphics.rectangle( "line", self.l - camera.l,self.t - camera.t,self.w,self.h )
end

-- Fast Draw the Background Tile -- No Outline
function Tile:fastDraw()
  local camera = self.map.camera
  -- Draw Filled Rectangle with Alpha Multiplied Each Draw
  --love.graphics.setColor(self.r/255, self.g/255, self.b/255, Tile.TILE_ALPHA/255 )
  -- Only Draw the Filled in Rectangle, without alpha Multiplied Each Draw
  love.graphics.setColor(self.ra/255, self.ga/255, self.ba/255)
  love.graphics.rectangle( "fill", self.l - camera.l, self.t - camera.t, self.w, self.h )
end


return Background
