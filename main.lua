fullTileWidth = 16
fullTileHeight = 16
tilesVert = 30
tilesHoriz = 40

bump = require('bump.bump')
bump_debug = require('bump.bump_debug')
Tile = require('Tile')
BG_Open = require('BG_Open')
BG_Wall = require('BG_Wall')

local world

function love.load()

  math.randomseed(os.time())
  
  love.window.setMode( Tile.CELL_WIDTH*tilesHoriz, Tile.CELL_HEIGHT*tilesVert )
  world = bump.newWorld()

  --local block = Tile.new( world, false, 100,100,32,32, 0,255,0 )
  --local block = Tile:new( world, false, 100,100,32,32, 0,255,0 )

  local blocks = {}

  for lpos = 1,40 do
    for tpos = 1,30 do
      if ( math.random(0,1) > 0.5 ) then
        local block = BG_Open:new( world, lpos-1, tpos-1 )
      else
        local block = BG_Wall:new( world, lpos-1, tpos-1 )
      end
    end
  end
end

function love.draw()
  local blocks, len = world:queryRect( 0,0,800,600 )
  for i = 1,len do
    blocks[i]:draw()
  end
  --block:draw()
end
