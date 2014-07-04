fullTileWidth = 16
fullTileHeight = 16
tilesVert = 30
tilesHoriz = 40

bump = require('bump.bump')
bump_debug = require('bump.bump_debug')
Tile = require('Tile')
Map = require('Map')
if Map.IS_ANDROID then Touch_Button = require('Touch_Button') end
--media = require('lib.media')


local map


function love.load()
  love.window.setMode( Tile.CELL_WIDTH*tilesHoriz, Tile.CELL_HEIGHT*tilesVert )

  -- Load Sounds
  Map.openMedia()

  -- Create Map Instance
  map = Map:new()
end


function love.draw()
  map:draw()
end


function love.update( dt )
  map:update(dt)
end

-- Pass Key Presses to Map
function love.keypressed( key, isrepeat )
  if key == "escape" then
    love.event.quit()
    return 
  end
  if map then
    map:keypressed( key, isrepeat )
  end
end

-- Pass Key Releases to Map
function love.keyreleased( key )
  if map then
    map:keyreleased( key )
  end
end


-- Android Specific Stuff
function love.touchpressed( id, l, t, pressure )
  if pressure > 0 then
    local items, len = map.world:queryPoint( l*love.graphics.getWidth(), t*love.graphics.getHeight(), Touch_Button.C_FILTER )
    for i = 1, len do
      items[i]:touched()
    end
  end
end


-- Android Specific Stuff
function love.touchreleased( id, l, t, pressure )
  if pressure > 0 then
    local items, len = map.world:queryPoint( l*love.graphics.getWidth(), t*love.graphics.getHeight(), Touch_Button.C_FILTER )
    for i = 1, len do
      items[i]:released()
    end
  end
end
