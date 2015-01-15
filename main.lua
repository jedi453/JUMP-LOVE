
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


function love.load()
  love.window.setMode( Tile.CELL_WIDTH*tilesHoriz, Tile.CELL_HEIGHT*tilesVert )

  -- Load Sounds
  Map.openMedia()

  -- Create Map Instance
  --map = Map:new()
  game = Game( 'menu' )

  -- Create New Font at Reasonable Size
  scaledFont = love.graphics.newFont( 12*Tile.SCALE )
  love.graphics.setFont( scaledFont )

end


function love.draw()
  game:draw()
end


function love.update( dt )
  game:update(dt)
end

-- Pass Key Presses to Map
function love.keypressed( key, isrepeat )
  if game then
    game:keypressed( key, isrepeat )
  end
end

-- Pass Key Releases to Map
function love.keyreleased( key )
  if game then
    game:keyreleased( key )
  end
end


-- Android Specific Stuff
function love.touchpressed( id, l, t, pressure )
  if pressure > 0 then
    local items, len = game.map.world:queryPoint( l*love.graphics.getWidth(), t*love.graphics.getHeight(), Touch_Button.C_FILTER )
    if len < 1 then
      game.map.touchButtonsByID[id] = nil
      return
    else
      local item = items[1]
      game.map.touchButtonsByID[id] = item
      -- Only Support One Touch_Button in the Same Location For Now
      item:touched( id, l, t, pressure )
    end
  end
end


-- Android Specific Stuff
function love.touchreleased( id, l, t, pressure )
  local items, len = game.map.world:queryPoint( l*love.graphics.getWidth(), t*love.graphics.getHeight(), Touch_Button.C_FILTER )
  -- Only Support One Touch_Button in the Same Location
  if len < 1 then 
    game.map.touchButtonsByID[id] = nil
    return 
  elseif game.map.touchButtonsByID[id] then  -- TODO IMPROVE EFFICIENCY
    local item = items[1]
    item:released( id, l, t, pressure )
    game.map.touchButtonsByID[id] = nil
  end
end


-- Android Specific Stuff
function love.touchmoved( id, l, t, pressure )
  local items, len = game.map.world:queryPoint( l*love.graphics.getWidth(), t*love.graphics.getHeight(), Touch_Button.C_FILTER )

  -- Only Support One Touch_Button in the Same Location
  -- TODO Improve Efficiency
  
  if len > 0 then -- TODO Improve Efficiency
    local item = items[1]

    -- Only Press the Button the Previous Button if the Current One isn't the Same
    if game.map.touchButtonsByID[id] then
      if game.map.touchButtonsByID[id].touchID ~= item.touchID then
        game.map.touchButtonsByID[id]:released( id, l, t, pressure )
        game.map.touchButtonsByID[id] = item
        item:touched( id, l, t, pressure )
      end
    else
      -- No Previous Button Pressed, Press this One
      game.map.touchButtonsByID[id] = item
      item:touched( id, l, t, pressure )
    end
  elseif game.map.touchButtonsByID[id] then
    -- Moved Off Active Touch_Button, Release it and Remove it from touchButtonsByID
    game.map.touchButtonsByID[id]:released( id, l, t, pressure )
    game.map.touchButtonsByID[id] = nil
  end
end
