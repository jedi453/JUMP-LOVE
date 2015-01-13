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



-- Touch_Button Class Definitions
--- A Persistant, non-moving Button that Responds to an Android Touch Event

local class = require('lib.middleclass')

local Player = require('Player')
local Tile = require('Tile')


local Touch_Button = class('Touch_Button')

-- Static Constants
Touch_Button.static.C_FILTER = function( other ) return other.isTouchButton end

-- Minimum Time Since Last Press to Perform Jump ( So that the Double Jump isn't Automatically Consumed whenever the Button is Pressed Once )
Touch_Button.static.MIN_WAIT_TIME_JUMP = 0.5

-- Color, Alpha
Touch_Button.static.R = 200
Touch_Button.static.G = 100
Touch_Button.static.B = 100
Touch_Button.static.ALPHA = 80
Touch_Button.static.TEXT_R = 200
Touch_Button.static.TEXT_G = 200
Touch_Button.static.TEXT_B = 200

-- Initialization Function / Constructor
function Touch_Button:initialize( map, l,t,w,h, kind, numPlayer )
  self.map = map
  self.l = l
  self.t = t
  self.w = w
  self.h = h
  self.touchID = -1
  self.numPlayer = numPlayer or 1
  self.isTouchButton = true
  self.kind = kind      -- The Kind of Movement 'left', 'right' or 'jump'
  self.timeSincePressed = 0
  if kind == 'left' then self.isLeft = true end
  if kind == 'right' then self.isRight = true end
  if kind == 'jump' then self.isJump = true end

  -- Register Touch_Button With Bump so Touches can be Checked
  map.world:add(self, l,t,w,h)
end

-- Called when this Button is Touched
function Touch_Button:touched( id, l, t, pressure )
  self.touchID = id
  local player = self.map.players[ self.numPlayer ]
  -- Don't Update if numPlayer isn't a Valid Player
  if not player then 
    return
  else
    -- Send Appropriate Keypress to Appropriate Player
    if self.isLeft then
      player.vx = player.vx - Player.speedHoriz
    elseif self.isRight then
      player.vx = player.vx + Player.speedHoriz
    elseif self.isJump and self.timeSincePressed > Touch_Button.MIN_WAIT_TIME_JUMP then 
      -- Only Jump if there's Been Enough time Since Last Press
      if self.inCannon then
        player:shootCannon()
      else
        self.map.players[ self.numPlayer ]:jump()
      end
    end
  end
end

-- Called when this Button is Released
function Touch_Button:released( id, l, t, pressure )
  self.touchID = -1
  -- Don't Update if numPlayer isn't a Valid Player
  if not self.map.players[ self.numPlayer ] then 
    return
  else
    -- Send Appropriate Keypress to Appropriate Player
    if self.isLeft then
      self.map.players[ self.numPlayer ].vx = self.map.players[ self.numPlayer ].vx + Player.speedHoriz
    elseif self.isRight then
      self.map.players[ self.numPlayer ].vx = self.map.players[ self.numPlayer ].vx - Player.speedHoriz
    end
  end
end



-- Update self.timeSincePressed
function Touch_Button:update(dt)
  self.timeSincePressed = self.timeSincePressed + dt
end


-- Draw the Touch_Button
function Touch_Button:draw()
  love.graphics.setColor( Touch_Button.R, Touch_Button.G, Touch_Button.B, Touch_Button.ALPHA )
  love.graphics.rectangle( 'fill', self.l,self.t,self.w,self.h )
  love.graphics.setColor( Touch_Button.R, Touch_Button.G, Touch_Button.B )
  love.graphics.rectangle( 'line', self.l,self.t,self.w,self.h )
  love.graphics.setColor( Touch_Button.TEXT_R, Touch_Button.TEXT_G, Touch_Button.TEXT_B )
  love.graphics.print( self.kind, self.l, self.t, 0, Tile.SCALE, Tile.SCALE )
end

return Touch_Button
