-- Map Class Definitions

-- The Map Class Acts as a Container for All the Background Objects,
--    Obstical Objects, Camera Object, and Player Objects
-- It Also Holds the Bump.lua World Object as Well as anything That Would
--  Otherwise be Global, in Order to Avoid Global Variables

local class = require('lib.middleclass')
local bump = require('bump.bump')

-- Base Tile Type
local Tile = require('Tile')

--[[
-- Base Background Tile Type
local Background = require('Background')
-- Base Obstical Tile Type
local Obstical = require('Obstical')
--]]

-- Background Tile Types
local BG_Open = require('BG_Open')
local BG_Wall = require('BG_Wall')
local BG_JumpPad = require('BG_JumpPad')

-- Obstical Tile Types
-- Platforms
local OB_Platform = require('OB_Platform')
local OB_Platform_Stop = require('OB_Platform_Stop')
--
local OB_JumpArrow = require('OB_JumpArrow')
local OB_Death = require('OB_Death')
-- Lightning
local OB_Lightning_Vert = require('OB_Lightning_Vert')
local OB_Lightning_Horiz = require('OB_Lightning_Horiz')
local OB_Lightning_Cross = require('OB_Lightning_Cross')
-- Falling Block
local OB_Falling_Block = require('OB_Falling_Block')


-- Player Tile Type
local Player = require('Player')

-- Camera Class
local Camera = require('Camera')

-- Android Touch Buttons
local Touch_Button = require('Touch_Button')

-- See Map:initialize to register new Background/Obstical Types


-- Create the Map Class
Map = class('Map')


-- Set Map Class Static Members

--Map.static.CELL_WIDTH = Tile.CELL_WIDTH   -- TODO CHECK, Was 16
--Map.static.CELL_HEIGHT = Tile.CELL_HEIGHT -- TODO CHECK, Was 16
--Map.static.MAP_FILES = { 'map-mike.txt', } 
--Map.static.MAP_FILES = { 'map1.txt', 'map2.txt', 'map3.txt' }
--Map.static.MAP_FILES = { 'map3.txt', }
Map.static.MAP_FILES = { 'map1-1.txt', 'map1-2.txt', 'map1-3.txt', 'map1-4.txt', 'map1-5.txt', 'map3.txt', }


-- Add Sound Effects Here
Map.static.SOUNDS = { jump = "sfx/player_jump.ogg", kill = "sfx/player_die.ogg", jump_collect = "sfx/player_collect_jumpArrow.ogg" }
Map.static.media = {}

-- Default Text Location
Map.static.COMMENT_L_DEFAULT = 1
Map.static.COMMENT_T_DEFAULT = 1

-- Android Specific Stuff
Map.static.IS_ANDROID = ( love.system.getOS() == 'Android' )
--Map.static.LEVEL_SCREEN_HEIGHT_RATIO = 0.8
--Map.static.LEVEL_SCREEN_WIDTH_RATIO = 0.8

-- Android Stuff
Map.static.TOUCH_BUTTON_MOVE_L_OFFSET = 0.05 * love.graphics.getWidth()  -- Distance From Left Edge of Screen For First Move Touch_Button
Map.static.TOUCH_BUTTON_MOVE_T_OFFSET = 0   -- Distance from Top of Viewport to First Touch_Button
Map.static.TOUCH_BUTTON_MOVE_WIDTH = 0.15 * love.graphics.getWidth()    -- Width of Move Touch_Buttons
-- Height of Move Touch_Buttons
Map.static.TOUCH_BUTTON_MOVE_HEIGHT = love.graphics.getHeight()
                                  - ( love.graphics.getHeight()*( 1 - Tile.ANDROID_VIEW_SCALE ) - Map.TOUCH_BUTTON_MOVE_T_OFFSET )
Map.static.TOUCH_BUTTON_JUMP_L_OFFSET = 0.05 * love.graphics.getWidth() -- Distance from Right of Viewport to Jump Touch_Button
Map.static.TOUCH_BUTTON_JUMP_T_OFFSET = 0  -- Distance from Top of Screen to Jump Touch_Button
-- Width of Jump Touch_Button
Map.static.TOUCH_BUTTON_JUMP_WIDTH = love.graphics.getWidth()
                                      - (love.graphics.getWidth()*( 1 - Tile.ANDROID_VIEW_SCALE ) - Map.TOUCH_BUTTON_JUMP_L_OFFSET )
Map.static.TOUCH_BUTTON_JUMP_HEIGHT = love.graphics.getHeight()  -- Height of Jump Touch_Button

-- Initializer For Map Function, Loads Current Level From File and Sets Everything Up
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
    -- Platform starting Left
    PL = function(...) args = {...}; return OB_Platform:new(self, args[1], args[2], -1, self.platformWidth); end,
    -- Platform starting Right
    PR = function(...) args = {...}; return OB_Platform:new(self, args[1], args[2],  1, self.platformWidth); end,
    -- Platform Stopper
    PS = function(...) return OB_Platform_Stop(self, ...) end,
    -- double Jump Arrow
    JA = function(...) return OB_JumpArrow(self, ...); end,
    -- DeaTh
    DT = function(...) return OB_Death(self, ...); end,
    -- Lightning Cross
    LC = function(...) return OB_Lightning_Cross(self, ...) end,
    -- Lightning Vertical
    LV = function(...) return OB_Lightning_Vert(self, ...) end,
    -- Lightning Horizontal
    LH = function(...) return OB_Lightning_Horiz(self, ...) end,
    -- Falling Block
    FB = function(...) return OB_Falling_Block(self, ...) end,
  }

  -- Initialize Normal Variable
  self.height = 0
  self.width = 0
  self.players = {} -- Array of Players
  self.players_vx = {} -- Array of Players' Initial x Velocities, Used to Reset Initial Velocity
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
  self.touchButtons = {} -- Touch_Button Array
  self.touchButtonsByID = {} -- Hash Table

  -- Load Map File if Any, if None, Quit
  local file = Map.MAP_FILES[self.levelNum]
  if file then
    Map.loadFile( self, file )
  else
    love.event.quit()
  end

  -- Add Touch_Buttons if On Android
  if Map.IS_ANDROID then
    self.touchButtons[1] = Touch_Button( self, Map.TOUCH_BUTTON_MOVE_L_OFFSET, self.height + Map.TOUCH_BUTTON_MOVE_T_OFFSET,
                                          Map.TOUCH_BUTTON_MOVE_WIDTH, Map.TOUCH_BUTTON_MOVE_HEIGHT,
                                          'left', 1 )
    self.touchButtons[2] = Touch_Button( self, Map.TOUCH_BUTTON_MOVE_L_OFFSET+Map.TOUCH_BUTTON_MOVE_WIDTH, self.height + Map.TOUCH_BUTTON_MOVE_T_OFFSET,
                                          Map.TOUCH_BUTTON_MOVE_WIDTH, Map.TOUCH_BUTTON_MOVE_HEIGHT,
                                          'right', 1 )
    self.touchButtons[3] = Touch_Button( self, self.width + Map.TOUCH_BUTTON_JUMP_L_OFFSET, Map.TOUCH_BUTTON_JUMP_T_OFFSET,
                                          Map.TOUCH_BUTTON_JUMP_WIDTH, Map.TOUCH_BUTTON_JUMP_HEIGHT,
                                          'jump', 1 )
  end

  -- Add Camera
  self.camera = Camera(self)
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
  self.numPlayers = 0
  self.levelNum = self.levelNum + 1
  self.numBGTiles = 0
  self.BGTiles = {}
  self.numOBTiles = 0
  self.OBTiles = {}
  self.comment = ""

  -- Get Previous players' x Velocities ( Restored Later ), then Reset players, 
  for i = 1, #self.players do
    self.players_vx[i] = self.players[i].vx
  end
  self.players = {}
  local file = Map.MAP_FILES[self.levelNum]
  if file then
    Map.loadFile( self, file )
  else
    love.event.quit()
  end

  -- Restore Players' Initial x Velocities
  for i = 1, #self.players do
    local old_vx = self.players_vx[i]
    if old_vx then
      self.players[i].vx = old_vx
    end
  end
  
  -- Android Specific Stuff, Register Touch_Buttons in New World
  for i = 1, #self.touchButtons do
    local button = self.touchButtons[i]
    self.world:add( button, button.l,button.t,button.w,button.h )
  end

  -- Garbage Collect, Try to Reduce Memory Leakage
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
    --- TODO ERROR with Adjacent Platforms of Differing Types
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
          self.platformWidth = 0 -- Reset Platform Width Holder
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
  -- Get Android Screen Touches
  -- Update Touch Buttons
  if Map.IS_ANDROID then
    for i = 1, #self.touchButtons do
      self.touchButtons[i]:update(dt)
    end
    --self.comment = "Player.vx = " .. self.players[1].vx -- TODO REMOVE DEBUG
  end

  -- Iterate over all Non-Player Tiles and Update them
  -- Iterate over BG Tiles
  for i = 1, self.numBGTiles do
    local BGTile = self.BGTiles[i]
    if BGTile.updates then
      BGTile:update(dt)
    end
  end
  -- Iterate over OB Tiles
  for i = 1, self.numOBTiles do
    local OBTile = self.OBTiles[i]
    if OBTile.updates then
      OBTile:update(dt)
    end
  end
  -- Iterate over all Players and Update them
  for i = 1, self.numPlayers do
    -- Avoid Crashing When Switching to Level with Fewer Players
    if self.players[i] then
      self.players[i]:update( dt )
    end
  end

  -- Update Camera
  if self.players[Camera.FOLLOW_PLAYER_NUM] then
    self.camera:update( dt )
  end
end


-- Map Draw Function
function Map:draw()
  local camera = self.camera

  -- Draw Background Tiles
  for i = 1, self.numBGTiles do
    local BGTile = self.BGTiles[i]
    -- Only Draw the Tile if it's within the Camera's Viewport
    if BGTile.l + BGTile.w>= camera.l and BGTile.l <= camera.l + camera.width 
      and BGTile.t + BGTile.h >= camera.t and BGTile.t <= camera.t + camera.height then
      BGTile:draw()
    end
  end

  -- Draw Obstical Tiles
  for i = 1, self.numOBTiles do
    local OBTile = self.OBTiles[i]
    if OBTile.l + OBTile.w >= camera.l and OBTile.l <= camera.l + camera.width 
      and OBTile.t + OBTile.h >= camera.t and OBTile.t <= camera.t + camera.height then
      OBTile:draw()
    end
  end

  -- Draw Comments
  love.graphics.setColor( 255, 255, 255 )
  love.graphics.print( self.comment, self.commentL*Tile.CELL_WIDTH, self.commentT*Tile.CELL_HEIGHT, 0, Tile.SCALE )

  -- Draw Players
  for i = 1, self.numPlayers do
    local player = self.players[i]
    if player.l + player.w >= camera.l and player.l <= camera.l + camera.width 
      and player.t + player.h >= camera.t and player.t <= camera.t + camera.height then
    player:draw()
    end
  end

  -- Draw Touch Buttons
  if Map.IS_ANDROID then
    for i = 1, #self.touchButtons do
      self.touchButtons[i]:draw()
    end
  end
end


-- Reset Function to Map, Pass to Objects in Map
function Map:reset()
  -- Reset Players
  for i = 1, self.numPlayers do
    local player = self.players[i]
    if player.reset then
      player:reset()
    end
  end

  -- Reset Obsticals
  for i = 1, self.numOBTiles do
    local obstical = self.OBTiles[i]
    if obstical.reset then
      obstical:reset()
    end
  end

  -- Reset Backgrounds
  for i = 1, self.numBGTiles do
    local background = self.BGTiles[i]
    if background.reset then
      background:reset()
    end
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
