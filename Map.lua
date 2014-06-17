-- Map Class Definitions

local class = require('lib.middleclass')

local Map = class('Map')

function Map:initialize( file )
  self.background = {}
  self.obsticals = {}
  if file then
    self:load( file )
  else
  end
end
