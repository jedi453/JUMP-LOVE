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

local world

function love.load()

  math.randomseed(os.time())
  
  love.window.setMode( Tile.CELL_WIDTH*tilesHoriz, Tile.CELL_HEIGHT*tilesVert )
  world = bump.newWorld()

  --local block = Tile.new( world, false, 100,100,32,32, 0,255,0 )
  --local block = Tile:new( world, false, 100,100,32,32, 0,255,0 )
  
  Map:new( world, "map1.txt" )

  print( "Map Loaded!" )
end

function love.draw()
  local blocks, len = world:queryRect( 0,0,fullTileWidth*tilesHoriz,fullTileHeight*tilesVert )
  for i = 1,len do
    blocks[i]:draw()
  end
  --block:draw()
end
