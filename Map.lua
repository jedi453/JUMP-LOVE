-- Map Class Definitions

local class = require('lib.middleclass')
local bump = require('bump.bump')
local Tile = require('Tile')
local Background = require('Background')
local BG_Open = require('BG_Open')
local BG_Wall = require('BG_Wall')
local BG_JumpPad = require('BG_JumpPad')
local OB_Platform = require('OB_Platform')
local OB_JumpArrow = require('OB_JumpArrow')
local Player = require('Player')

-- See Map:initialize to register new Background/Obstical Types

Map = class('Map')

Map.static.CELL_WIDTH = 16
Map.static.CELL_HEIGHT = 16
Map.static.MAP_FILES = { 'map1.txt', 'map2.txt' }

-- Add Sound Effects Here
Map.static.SOUNDS = { jump = "sfx/player_jump.ogg", kill = "sfx/player_die.ogg", jump_collect = "sfx/player_collect_jumpArrow.ogg" }
Map.static.media = {}

-- Default Text Location
Map.static.COMMENT_L_DEFAULT = 1
Map.static.COMMENT_T_DEFAULT = 1

function Map:initialize( levelNum )
  self.world = bump.newWorld()

  -- BG Constructors Holder -- Register BG Types Here
  self.BG_Kinds = {
    -------------------------------------- map, rest
    WL = function(...) return BG_Wall:new(self, ...); end,
    JP = function(...) return BG_JumpPad:new(self, ...); end,
  }

  -- OB Constructors Holder -- Register OB Types Here
  self.OB_Kinds = {
    PL = function(...) args = {...}; return OB_Platform:new(self, args[1], args[2], -1, self.platformWidth); end,
    PR = function(...) args = {...}; return OB_Platform:new(self, args[1], args[2],  1, self.platformWidth); end,
    JA = function(...) return OB_JumpArrow(self, ...); end,
  }

  -- Initialize Normal Variable
  self.height = 0
  self.width = 0
  self.players = {}
  self.numPlayers = 0
  self.levelNum = levenNum or 1
  self.numBGTiles = 0   -- Number of Background Tiles
  self.BGTiles = {}     -- List of the Background Tiles
  self.numOBTiles = 0   -- Number of Obstical Tiles
  self.OBTiles = {}   -- List of the Obstical Tiles
  self.comment = ""   -- The Comment for the Map, Displayed on the Screen
  self.commentL = Map.COMMENT_L_DEFAULT -- The l Position of the Comment
  self.commentT = Map.COMMENT_T_DEFAULT -- The t Position of the Comment
  self.platformWidth = 0 -- Used to Maintain State while Adding Platforms of width Greater than 1

  -- Load Map File if Any, if None, Quit
  local file = Map.MAP_FILES[self.levelNum]
  if file then
    Map.loadFile( self, file )
  else
    love.event.quit()
  end
end

-- Open All Needed Sound Media Files
function Map.static.openMedia()
  for k, v in pairs( Map.SOUNDS ) do
    Map.static.media[k] = love.audio.newSource(v)
  end
end

-- Play Sound Media by Name
function Map:playMedia( name )
  local sound = Map.media[name]
  if sound then
    love.audio.play( sound )
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
  self.comment = ""
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
  if type(self.BG_Kinds[kind]) == 'function' then
    self.numBGTiles = self.numBGTiles + 1
    self.BGTiles[ self.numBGTiles ] = self.BG_Kinds[kind]( lpos, tpos )
  end
  --[[ -- Old Code
  if kind == 'WL' then
    self.numBGTiles = self.numBGTiles + 1
    self.BGTiles[ self.numBGTiles ] = 
  end
  ]]
end

function Map:addOB( kind, lpos, tpos, last )
  --last = last or '00'
  -- Handle Multiple Width Platforms
  if kind == 'PL' or kind == 'PR' then
    self.platformWidth = self.platformWidth + 1
  end
  if ( last == 'PL' or last == 'PR' ) and kind ~= last then
    self.numOBTiles = self.numOBTiles + 1
    self.OBTiles[ self.numOBTiles ] = self.OB_Kinds[last]( lpos, tpos )
    -- Handle Opposing Platform Types Next to Each Other
    if kind == 'PL' or kind == 'PR' then
      self.platformWidth = 1
    else
      self.platformWidth = 0
    end
  end
  
  -- Handle Non-Platforms
  if kind ~= 'PL' and kind ~= 'PR' and type( self.OB_Kinds[kind] ) == 'function' then
    self.numOBTiles = self.numOBTiles + 1
    self.OBTiles[ self.numOBTiles ] = self.OB_Kinds[kind]( lpos, tpos )
  end
end

-- Add a Line of Background Elements and Return Maximum lpos
function Map:addBGLine( line, tpos )
  local lpos = 0
  for kind in string.gmatch( line, '%w+' ) do
    self:addBG( kind, lpos, tpos )
    lpos = lpos + 1
  end
  return lpos
end

-- Add a Line of Obstical Elements and Return Maximum lpos
function Map:addOBLine( line, tpos )
  local lpos = 0
  local last --= '00' -- Last Obstical Loaded
  for obsticalName in string.gmatch( line, '%w+' ) do
    self:addOB( obsticalName, lpos, tpos, last )
    lpos = lpos + 1
    last = obsticalName
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

function Map:addCommentLine( line )
  self.comment = self.comment .. line .. string.format("\n")
end

function Map:addPlayer( lpos, tpos )
  return Player:new( self, lpos, tpos )
end

function Map:addPlayerLine( line )
  local lpos, tpos = string.match( line, "(%d+)%s+(%d+)" )
  return Player:new( self, lpos, tpos, self )
end

function Map:loadFile( file )
  
  local row = 0
  local isComment = false
  local isCommentLocation = false
  local isBG = false
  local isOB = false
  local isPlayer = false
  local tpos = 0
  local maxTPos = 0
  
  Player.static.numPlayers = 0

  for line in love.filesystem.lines( file ) do
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
          isCommentLocation = true
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
        self.platformWidth = 0 -- Reset Platform Width Holder
        if isComment then
          if isCommentLocation then
            local i = 1
            for pos in string.gmatch( line, "%d+" ) do
              -- Set Position for Comments if Given, Otherwise, use Default
              if i == 1 then self.commentL = tonumber(pos) or Map.COMMENT_L_DEFAULT
              elseif i == 2 then self.commentT = tonumber(pos) or Map.COMMENT_T_DEFAULT
              end
              i = i + 1
            end
            -- If No Position Was Given, Assume that line is a Comment, forward it to addCommentLine()
            if i < 2 then self:addCommentLine( line ) end
            isCommentLocation = false
          else
            self:addCommentLine( line )
          end
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

  -- Draw Comments
  love.graphics.setColor( 255, 255, 255 )
  love.graphics.print( self.comment, self.commentL*Tile.CELL_WIDTH, self.commentT*Tile.CELL_HEIGHT )
  --print( self.comment ) 
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
