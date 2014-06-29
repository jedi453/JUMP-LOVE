-- Moving Platform ( Platform ) Class Definitions
-- Yellow Solid Block that Moves and Can Carry Player Along with it
-- CODE:  PL - Moving Platform ( Starts Left )
--        PR - Moving Platform ( Starts Right )
-- Note:  Platforms of the Same type in a Row Will be Strung Together to form one Contiguous Platform


-- TODO: BUGS
--[[
  -- Different Types of Platforms Next to Each other seem to Break
--]]
class = require("lib.middleclass")
Tile = require("Tile")
Obstical = require("Obstical")
Player = require("Player")

Platform = class("Platform", Obstical)

Platform.static.xSpeed = 100

function Platform.static.cFilter( other )
  return other.solid
end

function Platform:initialize( map, lpos, tpos, direction, platformWidth )
  --print("Platform.initialize( " .. tostring(self) .. ", " .. tostring(map) .. ", " .. tostring(lpos) .. ", " .. tostring(tpos) .. ", " .. tostring(direction) .. ", " .. tostring(platformWidth) .. ")")
  direction = direction or 1
  platformWidth = platformWidth or 1
  --                        map,  cc,  solid, deadly,
  Obstical.initialize( self, map, true, true, false,
                        lpos*Tile.CELL_WIDTH, tpos*Tile.CELL_HEIGHT, platformWidth*Tile.CELL_WIDTH, Tile.CELL_HEIGHT,
                        200, 200, 0,
                        true, direction*Platform.xSpeed, 0, false )
  self.lpos = lpos
  self.tpos = tpos
  self.platformWidth = platformWidth or 1
end

-- Override Move Function
function Platform:move( new_l, new_t )
  local tl, tt, nx, ny
  local visited = {}
  local cols, len = self.world:check( self, new_l, new_t, self.cFilter )
  local col = cols[1]
  while len > 0 do
    tl, tt, nx, ny = col:getTouch()

    if visited[col.other] then return end -- Thanks to Kikito - Prevent Infinite Loops
    visited[col.other] = true


    if nx > 0 then
      self.vx = Platform.xSpeed
    elseif nx < 0 then
      self.vx = -Platform.xSpeed
    end
  end
  self.l, self.t = tl or new_l, tt or new_t
  if ( self.l < 0 ) then 
    self.l = 0
    self.vx = Platform.xSpeed
  end
  if ( self.l + self.w ) > self.map.width then
    self.l = self.map.width - self.w
    self.vx = -Platform.xSpeed
  end
  self.world:move( self, self.l, self.t )
end

return Platform
