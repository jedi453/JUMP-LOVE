fullTileWidth = 16
fullTileHeight = 16
tilesVert = 30
tilesHoriz = 40

bump = require('bump.bump')
bump_debug = require('bump.bump_debug')
Tile = require('Tile')
BG_Open = require('BG_Open')
BG_Wall = require('BG_Wall')
Map = require('Map')
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
