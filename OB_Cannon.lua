-- OB_Cannon Class Definitions
--  Base Class for Cannons that Grab, then Shoot Player
-- CODE: CN


-- Require
class = require('lib.middleclass')
Tile = require('Tile')
Obstical = require('Obstical')


OB_Cannon = class('OB_Cannon', Obstical)


OB_Cannon.static.TURN_SOUND = "cannon_turn"

-- Default Cannon Attributes
OB_Cannon.static.CC = true
OB_Cannon.static.SOLID = false
OB_Cannon.static.DEADLY = false

OB_Cannon.static.WIDTH = Tile.CELL_WIDTH
OB_Cannon.static.HEIGHT = Tile.CELL_HEIGHT
OB_Cannon.static.ARROW_WIDTH = OB_Cannon.WIDTH / 4
OB_Cannon.static.ARROW_HEIGHT = OB_Cannon.HEIGHT / 4

OB_Cannon.static.R = 200
OB_Cannon.static.G = 150
OB_Cannon.static.B = 0
-- The Alpha of the Outside Border of the Cannon
--OB_Cannon.static.OUTLINE_ALPHA = 255
-- The Alpha of the Background of the Cannon ( The Rectangle )
--OB_Cannon.static.BG_ALPHA = 128
-- The Alpha of the Rectangle Indicating Direction
OB_Cannon.static.DIRECTION_ALPHA = 255

OB_Cannon.static.UPDATES = true
OB_Cannon.static.VX = 0
OB_Cannon.static.VY = 0
OB_Cannon.static.HAS_GRAVITY = false

-- Default Countdown until Turning
OB_Cannon.static.TURN_TIME = 0.5

-- Constructor for OB_Cannon
function OB_Cannon:initialize( map, lpos, tpos, turnTime )
  Obstical.initialize( self, map, OB_Cannon.CC, OB_Cannon.SOLID, OB_Cannon.DEADLY,
                    lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_HEIGHT, OB_Cannon.WIDTH, OB_Cannon.HEIGHT,
                    OB_Cannon.R, OB_Cannon.G, OB_Cannon.B,
                    OB_Cannon.UPDATES, OB_Cannon.VX, OB_Cannon.VY,
                    OB_Cannon.HAS_GRAVITY )
  -- The Direction of the Cannon x Component, -1 for Left, 1 for Right, 0 for Middle
  self.directionX = 0
  -- The Direction of the Cannon x Component, -1 for Up, 1 for Down, 0 for Middle
  self.directionY = 0
  self.isCannon = true
  self.running = false
  self.turnTime = turnTime or OB_Cannon.TURN_TIME
  self.timeSinceTurn = 0
  self.playerList = {}
end

-- Cannon - Regular Draw Function
function OB_Cannon:draw()
  -- Draw Outline/Background
  Tile.draw(self)
  -- Draw Direction "Arrow" in Appropriate Spot ( I Hope... )
  local camera = self.map.camera
  love.graphics.setColor( self.r, self.g, self.b, OB_Cannon.DIRECTION_ALPHA )
  love.graphics.rectangle( "fill", self.l-camera.l + 0.375*(1+self.directionX)*self.w,
                                   self.t-camera.t + 0.375*(1+self.directionY)*self.h,
                                   OB_Cannon.ARROW_WIDTH, OB_Cannon.ARROW_HEIGHT )
  --[[ -- Older Easier to Understand Version
  love.graphics.rectangle("fill", self.l-camera.l + ((1/2)-(1/8))*self.w + ((1/2)-(1/8))*self.w*self.directionX,
                                  self.t-camera.t + 0.375*self.h + 0.375*self.h*self.directionY,
                                  self.w, self.h )
  --]]
  self.turnSound = OB_Cannon.TURN_SOUND
end


-- Cannon - FastDraw Function
function OB_Cannon:fastDraw()
  -- Draw Outline/Background
  Tile.fastDraw(self)
  -- Draw Direction "Arrow" in Appropriate Spot ( I Hope... )
  local camera = self.map.camera
  love.graphics.setColor( self.r, self.g, self.b, OB_Cannon.DIRECTION_ALPHA )
  love.graphics.rectangle( "fill", self.l-camera.l + 0.375*(1+self.directionX)*self.w,
                                   self.t-camera.t + 0.375*(1+self.directionY)*self.h,
                                   OB_Cannon.ARROW_WIDTH, OB_Cannon.ARROW_HEIGHT )
  --[[ -- Older Easier to Understand Version
  love.graphics.rectangle("fill", self.l-camera.l + ((1/2)-(1/8))*self.w + ((1/2)-(1/8))*self.w*self.directionX,
                                  self.t-camera.t + 0.375*self.h + 0.375*self.h*self.directionY,
                                  self.w, self.h )
  --]]
  self.turnSound = OB_Cannon.TURN_SOUND
end




-- Update the Cannon to Change Direction
function OB_Cannon:update(dt)
  if self.running then
    self.timeSinceTurn = self.timeSinceTurn + dt
    if self.timeSinceTurn > self.turnTime then
      self:turn()
      self.timeSinceTurn = 0
    end
  end
end


-- Start the Cannon
function OB_Cannon:start()
  -- If there's No-one in the Cannon
  if next(self.playerList) == nil then
    self.directionX = 1
    self.directionY = 0
    self.timeSinceTurn = 0
  end
  self.running = true
  -- Play Turn Sound
  self.map:playMedia( self.turnSound )
end


-- Stop the Cannon
function OB_Cannon:stop()
  self.directionX = 0
  self.directionY = 0
  self.running = false
end

-- Add a Player to the Cannon
function OB_Cannon:addPlayer( player )
  self:start()
  self.playerList[player] = true
end

function OB_Cannon:removePlayer( player )
  self.playerList[player] = nil
  if not next( self.playerList ) then
    self:stop()
  end
end

-- Turn the Cannon
function OB_Cannon:turn()
  if self.directionX > 0 then
    -- Pointing Right, Now Point Down
    self.directionX = 0
    self.directionY = 1
  elseif self.directionX < 0 then
    -- Pointing Left, Now Point Up
    self.directionX = 0
    self.directionY = -1
  elseif self.directionY > 0 then
    -- Pointing Down, Now Point Left
    self.directionX = -1
    self.directionY = 0
  else
    -- Pointing Up or Nowhere, Now Point Right
    self.directionX = 1
    self.directionY = 0
  end
  -- Play Turning Sound
  self.map:playMedia( self.turnSound )
end

return OB_Cannon
