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
Map.static.MAP_FILES = { 'map1.txt', 'map2.txt' }


function Map:initialize( levelNum )
  self.world = bump.newWorld()
  self.height = 0
  self.width = 0
  self.players = {}
  self.numPlayers = 0
  self.levelNum = levenNum or 1
  self.numBGTiles = 0
  self.BGTiles = {}
  self.numOBTiles = 0
  self.OBTiles = {}
  local file = Map.MAP_FILES[self.levelNum]
  if file then
    Map.loadFile( self, file )
  else
    love.event.quit()
  end
end

function Map:nextLevel()
  self.world = bump.newWorld()
  self.width, self.height = 0, 0
  self.players = {}
  self.numPlayers = 0
  self.levelNum = self.levelNum + 1
  self.numBGTiles = 0
  self.BGTiles = {}
  self.numOBTiles = 0
  self.OBTiles = {}
  local file = Map.MAP_FILES[self.levelNum]
  if file then
    Map.loadFile( self, file )
  else
    love.event.quit()
  end
  collectgarbage("collect")
end

--[[
function Map:clear()
  local blocks, len = self.world:queryRect( 0, 0, self.width, self.height )
  for _, block in ipairs(blocks) do
    self.world:remove( block )
  end
end
--]]


function Map:addTile( layer, kind, xpos, ypos )
  if layer == 'BG' then
    self:addBG( kind, xpos, ypos )
  elseif layer == 'OB' then
    self:addOB( kind, xpos, ypos )
  end
end

function Map:addBG( kind, lpos, tpos )
  if kind == 'WL' then
    self.numBGTiles = self.numBGTiles + 1
    self.BGTiles[ self.numBGTiles ] = BG_Wall:new( self.world, lpos, tpos )
  end
end

function Map:addOB( kind, lpos, tpos )
end

-- Add a Line of Background Elements and Return Maximum lpos
function Map:addBGLine( line, tpos )
  local lpos = 0
  for word in string.gmatch( line, '%w+' ) do
    self:addBG( word, lpos, tpos )
    lpos = lpos + 1
  end
  return lpos
end

-- Add a Line of Obstical Elements and Return Maximum lpos
function Map:addOBLine( line, tpos )
  local lpos = 0
  for word in string.gmatch( line, '%w+' ) do
    self:addOB( word, lpos, tpos )
    lpos = lpos + 1
  end
  return lpos
end

function Map:addTileLine( kind, line, xpos )
  if kind == 'BG' then
    self:addBGLine( line, xpos )
  elseif kind == 'OB' then
    self:addOBLine( line, xpos )
  end
end

function Map:addPlayer( lpos, tpos )
  return Player:new( self.world, lpos, tpos, self )
end

function Map:addPlayerLine( line )
  local lpos, tpos = string.match( line, "(%d+)%s+(%d+)" )
  return Player:new( self.world, lpos, tpos, self )
end

function Map:loadFile( file )
  
  local row = 0
  local isComment = false
  local isBG = false
  local isOB = false
  local isPlayer = false
  local comment = ''
  local tpos = 0
  local maxTPos = 0
  
  Player.static.numPlayers = 0

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
          isBG = true
          isComment = false
          isOB = false
          isPlayer = false
          tpos = 0
        elseif mode == 'Obstical' then
          isOB = true
          isBG = false
          isComment = false
          isPlayer = false
          tpos = 0
        elseif mode == 'Player' then
          isOB = false
          isBG = false
          isComment = false
          isPlayer = true
        end
      else
        if isComment then
          comment = comment .. line
        elseif isBG then
          maxTPos = math.max( self:addBGLine( line, tpos ), maxTPos )
          tpos = tpos + 1
          self.height = self.height + Tile.CELL_HEIGHT
        elseif isOB then
          maxTPos = math.max( self:addOBLine( line, tpos ), maxTPos )
          tpos = tpos + 1
        elseif isPlayer then
          self.numPlayers = self.numPlayers + 1
          self.players[self.numPlayers] = self:addPlayerLine( line )
          --isPlayer = false -- 1 Player Mode
        end
      end
    end
  end
  self.width = Tile.CELL_WIDTH * maxTPos
end


-- Map Update Function
function Map:update( dt )
  -- Iterate over all Non-Player Tiles and Update them
  local blocks, len = self.world:queryRect( 0, 0, self.width, self.height )
  for i = 1, len do
    local block = blocks[i]
    if block.class.name ~= 'Player' and block.update then
      block:update( dt )
    end
  end
  -- Iterate over all Players and Update them
  for i = 1, self.numPlayers do
    -- Avoid Crashing When Switching to Level with Fewer Players
    if self.players[i] then
      self.players[i]:update( dt )
    end
  end
end


-- Map Draw Function
function Map:draw()
  -- Draw Background Tiles
  for i = 1, self.numBGTiles do
    self.BGTiles[i]:draw()
  end

  -- Draw Obstical Tiles
  for i = 1, self.numOBTiles do
    self.OBTiles[i]:draw()
  end

  -- Draw Players
  for i = 1, self.numPlayers do
    self.players[i]:draw()
  end
end


-- Pass Key Presses to Players
function Map:keypressed( key, isRepeat )
  for _, player in ipairs(self.players) do
    player:keypressed( key, isRepeat )
  end
end

-- Pass Key Releases to Players
function Map:keyreleased( key )
  for _, player in ipairs(self.players) do
    player:keyreleased( key )
  end
end


-- Return Our Fresh, Shiny, New Class
return Map
