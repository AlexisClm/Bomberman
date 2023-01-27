local class = {}

local w
local h

function class.getWidth()
  return w
end

function class.setWidth(value)
  w = value
end

function class.getHeight()
  return h
end

function class.setHeight(value)
  h = value
end

local function init()
  w = love.graphics.getWidth()
  h = love.graphics.getHeight()
end

function class.load()
  init()
end

return class