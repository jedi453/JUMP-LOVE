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


-- JUMP Menu
--  Allows Player to Switch Between Maps with Player 1 Left/Right Movement
--  and Select a Map with the Player 1 Jump Button

-- Simple Idea for Menu System:
  -- Shows each Map/Level Full-Screen (Except Possibly for Touchscreen Buttons) One at a Time 
  -- Maps can be switched between with Right/Left
  -- Currently Viewed Map Can Be Selected with Jump Button
  -- Doesn't Call the Map's update() function

local class = require('lib.middleclass')
local bump = require('bump.bump')

-- Base Tile Type
local Tile = require('Tile')

--[[
-- Base Background Tile Type
local Background = require('Background')
-- Base Obstical Tile Type
local Obstical = require('Obstical')
--]]

-- Background Tile Types
local BG_Open = require('BG_Open')
local BG_Wall = require('BG_Wall')
local BG_JumpPad = require('BG_JumpPad')

-- Obstical Tile Types
-- Platforms
local OB_Platform = require('OB_Platform')
local OB_Platform_Stop = require('OB_Platform_Stop')
--
local OB_JumpArrow = require('OB_JumpArrow')
local OB_Death = require('OB_Death')
-- Lightning
local OB_Lightning_Vert = require('OB_Lightning_Vert')
local OB_Lightning_Horiz = require('OB_Lightning_Horiz')
local OB_Lightning_Cross = require('OB_Lightning_Cross')
-- Falling Block
local OB_Falling_Block = require('OB_Falling_Block')
-- Gate that Closes After Player Goes Through it
local OB_Gate = require('OB_Gate')
local OB_Cannon = require('OB_Cannon')
local OB_Lightning_Gate = require('OB_Lightning_Gate')

-- Player Tile Type
local Player = require('Player')

-- Camera Class
local Camera = require('Camera')

-- Android Touch Buttons
local Touch_Button = require('Touch_Button')

Map = require('Map')



-- Create the Menu Class, Derived From Map Class
Menu = class('Menu', Map)


-- Static Members
Menu.static.MENU_TEXT_XPOS_FACTOR = 0.45
Menu.static.MENU_TEXT_YPOS_FACTOR = 0.8

function Menu:initialize( game, levelNum )
  -- TODO - Initialize Most Recent Level Instead of Level 1
  levelNum = levelNum or 1
  self.game = game
  Map.initialize(self, game, levelNum)
  -- This Just Gets rid of the Bump World in Hopes that it will Be Garbage Collected
  --  TODO - Find a Better way to do this that Still Allows Code Reuse from Map.lua
  --   NOTE: Might not Even Work
  self.world = nil
  collectgarbage( "collect" )
end




-- Override Inherited update() from Map
function Menu:update(dt)
end


-- Override Inherited draw() from Map, Can still Use Map.draw(self,...) if Needed
function Menu:draw()
  Map.draw(self)
  love.graphics.setColor( 255, 128, 128 )
  love.graphics.print( "MENU\n",
                       self.width * Menu.MENU_TEXT_XPOS_FACTOR,
                       self.height * Menu.MENU_TEXT_YPOS_FACTOR,
                       0,
                       2)
  love.graphics.print( "Press Left/Right to Go Back/Forward a Level",
                        self.width * (Menu.MENU_TEXT_XPOS_FACTOR - 0.15 ),
                        self.height * Menu.MENU_TEXT_YPOS_FACTOR + 2*(Tile.CELL_HEIGHT+1) )
  love.graphics.print( "Press Jump to Select The Level",
                        self.width * (Menu.MENU_TEXT_XPOS_FACTOR - 0.09 ),
                        self.height * Menu.MENU_TEXT_YPOS_FACTOR + 3*(Tile.CELL_HEIGHT+1) )
end


-- Select the Current Level and Start it
function Menu:selectLevel()
  self.game:loadLevel( self.levelNum )
end


-- Go to the Next Level in the Menu
-- Don't Allow "Beating" the Game by Just Advancing through all the Levels in the Menu
function Menu:nextLevel()
  -- Only Go to The Next Level if it Exists...
  if self.levelNum < #Map.MAP_FILES then
    Map.nextLevel(self)
  end
end

-- Maps can be switched between with Player 1 Right/Left Keys/Buttons
-- Currently Viewed Map Can Be Selected with Jump Button
function Menu:keypressed(key, isrepeat)
  if key == Player.leftKeys[1] then
    self:prevLevel()
  elseif key == Player.rightKeys[1] then
    self:nextLevel()
  elseif key == Player.jumpKeys[1] then
    self:selectLevel()
  end
end

return Menu
