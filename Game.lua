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
--local Menu = require('Menu')


local Game = class('Game')


function Game:initialize( state, ... )
  self.state = state or 'menu'
  self.isMenu = false
  self.isMap  = false
  if state == 'menu' then
    self.menu = Menu(...)
    self.isMenu = true
  elseif state == 'map' then
    self.map = Map(...)
    self.isMap = true
  end
end


-- Set the Current Game State
function Game:setState( state, ... )
  if self.state ~= state then
    self.state = state
    if state == 'menu' then 
      self.isMenu = true 
      self.isMap = false
      self.map = nil
      self.menu = Menu(...)
    elseif state == 'map' then 
      self.isMap = true
      self.isMenu = false
      self.menu = nil
      self.map = Map(...)
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
end


-- Draw the Current Game
function Game:draw()
  if self.isMenu then
    self.menu:draw()
  elseif self.isMap then
    self.map:draw()
  end
end

-- Load a Map/Level
function Game:loadLevel( levelNum )
  self.setState( 'map', levelNum )
end


-- Pass Key Presses Appropriately, Based On State
function Game:keypressed( key, isRepeat )
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


-- Pass Key Releases Appropriately, Based On State
function Game:keyreleased( key )
  if self.isMenu then
    self.menu:keyreleased( key )
  elseif self.isMap then
    self.map:keyreleased( key )
  end
end

return Game
