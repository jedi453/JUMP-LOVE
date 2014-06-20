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

local map


function love.load()

  math.randomseed(os.time())
  
  love.window.setMode( Tile.CELL_WIDTH*tilesHoriz, Tile.CELL_HEIGHT*tilesVert )
  -- world = bump.newWorld()

  --local block = Tile.new( world, false, 100,100,32,32, 0,255,0 )
  --local block = Tile:new( world, false, 100,100,32,32, 0,255,0 )
  
  map = Map:new()

  --local block = Tile:new( world, true, 620, 0, 16, 16, 255, 255, 255, true, 0, 0, true )

end


function love.draw()
  map:draw()
end


function love.update( dt )
  map:update(dt)
--[[
  local blocks, len = world:queryRect( 0,0,fullTileWidth*tilesHoriz,fullTileHeight*tilesVert )
  for i = 1, len do
    local block = blocks[i]
    if block.updates and block.class.name ~= 'Player' then
      block:update( dt )
    end
  end
  for _, player in ipairs( map.players ) do
    if player.updates then player:update( dt ) end
  end
--]]
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
