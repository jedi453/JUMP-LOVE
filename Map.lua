-- Map Class Definitions

local class = require('lib.middleclass')
local bump = require('bump.bump')
local Tile = require('Tile')
local Background = require('Background')
local BG_Open = require('BG_Open')
local BG_Wall = require('BG_Wall')
local Player = require('Player')


Map = class('Map')

Map.static.CELL_WIDTH = 16
Map.static.CELL_HEIGHT = 16


function Map:initialize( world, file )
  --print('Map:initialize Called')
  self.world = world
  if file then self:loadFile( file ) end
  --print('Map:initialize Finished')
end

function Map:addTile( layer, kind, xpos, ypos )
  if layer == 'BG' then
    self:addBG( kind, xpos, ypos )
  elseif layer == 'OB' then
    self:addOB( kind, xpos, ypos )
  end
end

function Map:addBG( kind, lpos, tpos )
  if kind == 'WL' then
    BG_Wall:new( self.world, lpos, tpos )
  end
end

function Map:addOB( kind, lpos, tpos )
end

function Map:addBGLine( line, tpos )
  --print( 'Map:addBGLine() Called' )
  --print( '  line = ' .. line )
  --print( string.format('  tpos = %d', tpos ) )
  local lpos = 0
  for word in string.gmatch( line, '%w+' ) do
    self:addBG( word, lpos, tpos )
    lpos = lpos + 1
  end
end

function Map:addOBLine( line, tpos )
  local lpos = 0
  for word in string.gmatch( line, '%w+' ) do
    self:addOB( word, lpos, tpos )
    lpos = lpos + 1
  end
end

function Map:addTileLine( kind, line, xpos )
  if kind == 'BG' then
    self:addBGLine( line, xpos )
  elseif kind == 'OB' then
    self:addOBLine( line, xpos )
  end
end

function Map:addPlayer( lpos, tpos )
  Player:new( self.world, lpos, tpos )
end

function Map:addPlayerLine( line )
  local lpos, tpos = string.match( line, "(%d+)%s+(%d+)" )
  Player:new( self.world, lpos, tpos )
end

function Map:loadFile( file )
  print("Map:loadFile( " .. file .. " ) Called ")

  --[[
  if not io.open( file ) then
    return
  end
  --]]
  
  local row = 0
  local isComment = false
  local isBG = false
  local isOB = false
  local isPlayer = false
  local comment = ''
  local tpos = 0

  for line in io.lines( file ) do
    if string.sub( line, 1, 1 ) == '#' then
      -- Skip Comment
    else
      -- If Mode Line is Found
      local s, e = string.find( line, ':' )
      if s then
        -- Get Mode
        local mode = string.sub( line, 1, s-1 )
        if mode == 'Comment' then
          isComment = true
          isBG = false
          isOB = false
          isPlayer = false
        elseif mode == 'Background' then
          print('Background Section Found')
          isBG = true
          isComment = false
          isOB = false
          isPlayer = false
          tpos = 0
        elseif mode == 'Obstical' then
          isOB = true
          isBG = false
          isComment = false
          tpos = 0
        end
      else
        if isComment then
          comment = comment .. line
        elseif isBG then
          self:addBGLine( line, tpos )
          tpos = tpos + 1
        elseif isOB then
          self:addOBLine( line, tpos )
          tpos = tpos + 1
        elseif isPlayer then
          self:addPlayerLine( line )
        end
      end
    end
  end
  --io.close( file )
end



return Map
