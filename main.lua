
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



fullTileWidth = 16
fullTileHeight = 16
tilesVert = 30
tilesHoriz = 40

bump = require('bump.bump')
--bump_debug = require('bump.bump_debug')
Tile = require('Tile')
Game = require('Game')
Map = require('Map')
BG_Wall = require('BG_Wall')
if Map.IS_ANDROID then Touch_Button = require('Touch_Button') end
--media = require('lib.media')

game = {}

local map
local BASE_FONT_SIZE = 14

local lastTouchList = {}


function love.load()
  love.window.setMode( Tile.CELL_WIDTH*tilesHoriz, Tile.CELL_HEIGHT*tilesVert )

  -- Load Sounds
  Map.openMedia()

  -- Create Map Instance
  --map = Map:new()
  game = Game( 'menu' )

  -- Create New Font at Reasonable Size
  scaledFont = love.graphics.newFont( BASE_FONT_SIZE*Tile.SCALE )
  love.graphics.setFont( scaledFont )

end


function love.draw()
  game:draw()
end


function love.update( dt )
  local touches = love.touch.getTouches()
  local newTouchList = {}

  -- Get Current Touches
  for i, id in ipairs(touches) do
    local l, t = love.touch.getPosition(id)
    newTouchList[id] = {l = l, t = t}
  end

  -- Register New Touches
  for id, v in pairs(newTouchList) do
    if not lastTouchList[id] then
      touchpressed(id, v.l, v.t)
    end
  end

  -- Remove Old Presses
  for id, v in pairs(lastTouchList) do
    if not newTouchList[id] then
      touchreleased(id, v.l, v.t)
    end
  end

  -- Do Normal Update
  game:update(dt)

  -- Update lastTouchList to Current One for Next Frame
  lastTouchList = newTouchList
end

-- Pass Key Presses to Game
function love.keypressed( key, isrepeat )
  if game then
    game:keypressed( key, isrepeat )
  end
end

-- Pass Key Releases to Game
function love.keyreleased( key )
  if game then
    game:keyreleased( key )
  end
end


-- Pass Gamepad Pressed Events to Game
function love.gamepadpressed( joystick, key )
  if game then
    game:gamepadpressed( joystick, key )
  end
end

-- Pass Gamepad Released Events to Game
function love.gamepadreleased( joystick, key )
  if game then
    game:gamepadreleased( joystick, key )
  end
end



-- Android Specific Stuff
function touchpressed( id, l, t )
  local map
  if game.isMap then map = game.map else map = game.menu end
  local items, len = map.world:queryPoint( l, t, Touch_Button.C_FILTER )
  if len < 1 then
    map.touchButtonsByID[id] = nil
    return
  else
    local item = items[1]
    map.touchButtonsByID[id] = item
    -- Only Support One Touch_Button in the Same Location For Now
    item:touched( id, l, t )
  end
end


-- Android Specific Stuff
function touchreleased( id, l, t )
  local map
  if game.isMap then map = game.map else map = game.menu end
  local items, len = map.world:queryPoint( l, t, Touch_Button.C_FILTER )
  -- Only Support One Touch_Button in the Same Location
  if len < 1 then 
    map.touchButtonsByID[id] = nil
    return 
  elseif map.touchButtonsByID[id] then  -- TODO IMPROVE EFFICIENCY
    local item = items[1]
    item:released( id, l, t )
    map.touchButtonsByID[id] = nil
  end
end


-- Android Specific Stuff
function touchmoved( id, l, t )
  local map
  if game.isMap then map = game.map else map = game.menu end
  local items, len = map.world:queryPoint( l, t, Touch_Button.C_FILTER )

  -- Only Support One Touch_Button in the Same Location
  -- TODO Improve Efficiency
  
  if len > 0 then -- TODO Improve Efficiency
    local item = items[1]

    -- Only Press the Button the Previous Button if the Current One isn't the Same
    if map.touchButtonsByID[id] then
      if map.touchButtonsByID[id].touchID ~= item.touchID then
        map.touchButtonsByID[id]:released( id, l, t )
        map.touchButtonsByID[id] = item
        item:touched( id, l, t )
      end
    else
      -- No Previous Button Pressed, Press this One
      map.touchButtonsByID[id] = item
      item:touched( id, l, t )
    end
  elseif map.touchButtonsByID[id] then
    -- Moved Off Active Touch_Button, Release it and Remove it from touchButtonsByID
    map.touchButtonsByID[id]:released( id, l, t )
    map.touchButtonsByID[id] = nil
  end
end
