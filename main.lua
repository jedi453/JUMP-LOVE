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
  --map.comment = 'Touch Pressed ID: ' .. tostring(id) -- TODO REMOVE DEBUG
  if pressure > 0 then
    local items, len = map.world:queryPoint( l*love.graphics.getWidth(), t*love.graphics.getHeight(), Touch_Button.C_FILTER )
    if len < 1 then
      map.touchButtonsByID[id] = nil
      return
    else
      local item = items[1]
      map.touchButtonsByID[id] = item
      -- Only Support One Touch_Button in the Same Location For Now
      item:touched( id, l, t, pressure )
    end
  end
end


-- Android Specific Stuff
function love.touchreleased( id, l, t, pressure )
  --map.comment = 'Touch Released ID: ' .. tostring(id) -- TODO REMOVE DEBUG
  local items, len = map.world:queryPoint( l*love.graphics.getWidth(), t*love.graphics.getHeight(), Touch_Button.C_FILTER )
  -- Only Support One Touch_Button in the Same Location
  if len < 1 then 
    map.touchButtonsByID[id] = nil
    return 
  elseif map.touchButtonsByID[id] then  -- TODO IMPROVE EFFICIENCY
    local item = items[1]
    item:released( id, l, t, pressure )
    map.touchButtonsByID[id] = nil
    --[[
    if map.touchButtonsByID[i].touchID == item.touchID and item.touchID >= 0 then 
      item:released( id, l, t, pressure ) 
    end
    --]]
  end
  --[[
  for i = 1, len do
    items[i]:released( id, l, t, pressure )
  end
  --]]
end


-- Android Specific Stuff
function love.touchmoved( id, l, t, pressure )
  --map.comment = 'Touch Moved ID: ' .. tostring(id)  -- TODO REMOVE DEBUG
  local items, len = map.world:queryPoint( l*love.graphics.getWidth(), t*love.graphics.getHeight(), Touch_Button.C_FILTER )

  -- Only Support One Touch_Button in the Same Location
  -- TODO Improve Efficiency
  
  if len > 0 then -- TODO Improve Efficiency
    local item = items[1]
    --map.comment = map.comment .. ',  ' .. tostring(map.touchButtonsByID[id])
    --map.touchButtonsByID[id]:released( id, l, t, pressure ) -- DONE ABOVE

    -- Only Press the Button the Previous Button if the Current One isn't the Same
    if map.touchButtonsByID[id] and map.touchButtonsByID[id].touchID ~= item.touchID then
      map.touchButtonsByID[id]:released( id, l, t, pressure )
      map.touchButtonsByID[id] = item
      item:touched( id, l, t, pressure )
    end
    --[[
    if item.touchID ~= map.touchButtonsByID[id].touchID and item.touchID >= 0 and map.touchButtonsByID[id].touchID >= 0 then 
      map.touchButtonsByID[id]:released( id, l, t, pressure )
      item:touched( id, l, t, pressure )
      map.touchButtonsByID[id] = item
    end
    --]]
  end
end
