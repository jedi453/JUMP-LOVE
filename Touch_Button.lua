-- Touch_Button Class Definitions
--- A Persistant, non-moving Button that Responds to an Android Touch Event

local class = require('lib.middleclass')

local Player = require('Player')



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
  -- Don't Update if numPlayer isn't a Valid Player
  if not self.map.players[ self.numPlayer ] then 
    return
  else
    -- Send Appropriate Keypress to Appropriate Player
    if self.isLeft then
      self.map.players[ self.numPlayer ].vx = self.map.players[ self.numPlayer ].vx - Player.speedHoriz
    elseif self.isRight then
      self.map.players[ self.numPlayer ].vx = self.map.players[ self.numPlayer ].vx + Player.speedHoriz
    elseif self.isJump and self.timeSincePressed > Touch_Button.MIN_WAIT_TIME_JUMP then 
      -- Only Jump if there's Been Enough time Since Last Press
      self.map.players[ self.numPlayer ]:jump()
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
end

return Touch_Button
