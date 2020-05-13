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




--- Game Class Definitions

--- The Game Class Holds the State and State Specific Variables
---- Such as:
----- Map - For State when Playing
----- Menu - For State when in Menu


local class = require('lib.middleclass')
local Map = require('Map')
local Menu = require('Menu')
local Player = require('Player')


local Game = class('Game')


-- A Super Secret Amazingly Securely Encrypted File that No Human's Eyes are Worthy to See the Contents of
Game.static.SAVE_FILE = "Shhhh...secret"


function Game:initialize( state, ... )
  self.state = state or 'menu'
  -- Load Maximum Level Attained
  self:load()
  self.isMenu = false
  self.isMap  = false
  if state == 'menu' then
    self.menu = Menu(self, ...)
    self.isMenu = true
  elseif state == 'map' then
    self.map = Map(self, ...)
    self.isMap = true
  end
  self.debugString = ''
end


-- Set the Current Game State
function Game:setState( state, ... )
  if self.state ~= state then
    self.state = state
    if state == 'menu' then 
      self.isMenu = true 
      self.isMap = false
      self.map = nil
      self.menu = Menu(self, ...)
    elseif state == 'map' then 
      self.isMap = true
      self.isMenu = false
      self.menu = nil
      self.map = Map(self, ...)
    end
  end
end


-- Update the Current Game
function Game:update( dt )
  if self.isMenu then
    self.menu:update( dt )
  elseif self.isMap then
    self.map:update( dt )
  end
  -- Debug FPS
  --game.debugString = love.timer.getFPS()
end


-- Draw the Current Game
function Game:draw()
  if self.isMenu then
    self.menu:draw()
  elseif self.isMap then
    self.map:draw()
  end
  love.graphics.setColor( 255/255, 128/255, 0/255 )
  love.graphics.print( self.debugString, 0, 0, 0, 3 )
end

-- Load a Map/Level
function Game:loadLevel( levelNum )
  self:setState( 'map', levelNum )
end


-- Pass Key Presses Appropriately, Based On State
function Game:keypressed( key, isRepeat )
  -- 
  if key == 'escape' then
    if self.isMenu then
      love.event.quit()
    elseif self.isMap then
      self:setState( 'menu', self.map.levelNum )
    end
  else
    if self.isMenu then
      self.menu:keypressed( key, isRepeat )
    elseif self.isMap then
      if key == 'escape' then
        love.event.quit()
        return
      end
      self.map:keypressed( key, isRepeat )
    end
  end
end


-- Pass Key Releases Appropriately, Based On State
function Game:keyreleased( key )
  if self.isMenu then
    self.menu:keyreleased( key )
  elseif self.isMap then
    self.map:keyreleased( key )
  end
end


function Game:gamepadpressed(joystick, button)
  local id = joystick:getID()
  if id <= Player.maxPlayers and id > 0 then
    if button == 'dpleft' then self:keypressed( Player.leftKeys[id] )
    elseif button == 'dpright' then self:keypressed( Player.rightKeys[id] )
    elseif button == 'y' then self:keypressed( Player.jumpKeys[id] )
    elseif button == 'back' then self:keypressed( 'escape' )
    end
  end
end


function Game:gamepadreleased(joystick, button)
  local id = joystick:getID()
  if id <= Player.maxPlayers and id > 0 then
    if button == 'dpleft' then self:keyreleased( Player.leftKeys[id] )
    elseif button == 'dpright' then self:keyreleased( Player.rightKeys[id] )
    elseif button == 'y' then self:keyreleased( Player.jumpKeys[id] )
    end
  end
end



-- Load Maximum Level Number for Maximum Level Attained 
function Game:load()
  self.maxLevelReached = love.filesystem.read( Game.SAVE_FILE ) 
  self.maxLevelReached = tonumber( self.maxLevelReached ) or 1
  if self.maxLevelReached > #Map.MAP_FILES then self.maxLevelReached = #Map.MAP_FILES end
end

-- Save the Maximum Progress (Level Number) Made By the Player
function Game:save( levelNum )
  self:load()
  if levelNum > self.maxLevelReached then
    love.filesystem.write( Game.SAVE_FILE, levelNum )
  end
  self.maxLevelReached = levelNum
end

return Game
