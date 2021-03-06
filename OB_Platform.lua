--[[

LICENSE

Copyright (c) 2014-2015  Daniel Iacoviello

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

--]]



-- Moving Platform ( OB_Platform ) Class Definitions
-- Yellow Solid Block that Moves and Can Carry Player Along with it
-- MAP CODE:  PL - Moving Platform ( Starts Left )
--            PR - Moving Platform ( Starts Right )
-- Note:  Platforms of the Same type in a Row Will be Strung Together to form one Contiguous Platform


-- TODO: BUGS
--[[
  -- Fixed - Different Types of Platforms Next to Each other seem to Break
--]]
class = require("lib.middleclass")
Tile = require("Tile")
Obstical = require("Obstical")
Player = require("Player")

OB_Platform = class("OB_Platform", Obstical)

OB_Platform.static.xSpeed = 100 * Tile.SCALE

-- Collision Filter to Redirect Movement
function OB_Platform.static.cFilter( other )
  -- If it's a Player Only Collide if it's Alive
  if other.isPlayer then return other.isAlive end
  -- If it's not a Player, Make Sure it's Solid or it Bounces Platforms
  return other.solid or other.bouncesPlatforms
end

function OB_Platform:initialize( map, lpos, tpos, direction, platformWidth )
  direction = direction or 1
  platformWidth = platformWidth or 1
  --                        map,  cc,  solid, deadly,
  Obstical.initialize( self, map, true, true, false,
                        (lpos-platformWidth)*Tile.CELL_WIDTH, tpos*Tile.CELL_HEIGHT, platformWidth*Tile.CELL_WIDTH, Tile.CELL_HEIGHT,
                        200, 200, 0,
                        true, direction*OB_Platform.xSpeed, 0, false )
  self.lpos = lpos
  self.tpos = tpos
  self.platformWidth = platformWidth or 1
  self.startL = self.l
  self.startVX = self.vx
end

-- Override Move Function
function OB_Platform:move( new_l, new_t )
  local tl, tt, nx, ny
  local visited = {}
  local cols, len = self.world:check( self, new_l, new_t, OB_Platform.cFilter )
  local col = cols[1]
  while len > 0 do
    tl, tt, nx, ny = col:getTouch()

    if visited[col.other] then return end -- Thanks to Kikito - Prevent Infinite Loops
    visited[col.other] = true


    if nx > 0 then
      self.vx = OB_Platform.xSpeed
    elseif nx < 0 then
      self.vx = -OB_Platform.xSpeed
    end
  end
  self.l, self.t = tl or new_l, tt or new_t
  if ( self.l < 0 ) then 
    self.l = 0
    self.vx = OB_Platform.xSpeed
  end
  if ( self.l + self.w ) > self.map.width then
    self.l = self.map.width - self.w
    self.vx = -OB_Platform.xSpeed
  end
  self.world:move( self, self.l, self.t )
end

-- Reset Platform, Called when Player Dies
function OB_Platform:reset()
  self.l = self.startL
  self.vx = self.startVX
  self.map.world:move( self, self.l, self.t )
end

return OB_Platform
