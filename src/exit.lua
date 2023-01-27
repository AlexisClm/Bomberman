local grid      = require("grid")
local powerUp   = require("powerUp")
local animation = require("animation")

local class = {}
local key   = {}
local exit  = {}

function class.setKey(value)
  key.state = value
end

function class.isKey()
  return key.state
end

local function initKey()
  key.sprite = love.graphics.newImage("Assets/Images/KeyAnim.png")
  key.state  = false
  key.w      = 28
  key.h      = 64

  key.animation = animation.new(key.sprite, 6, 10, 0, 0, key.w, key.h)

  local random = table.remove(powerUp.getBoxList(), love.math.random(#powerUp.getBoxList()))
  grid.setKey(random.line, random.column, true)
end

local function initExit()
  exit.sprite = love.graphics.newImage("Assets/Images/ExitAnim.png")
  exit.w      = 64
  exit.h      = 64

  exit.animation = animation.new(exit.sprite, 4, 2, 0, 0, exit.w, exit.h)
end

function class.load()
  initKey()
  initExit()
end

local function updateExitAnim(dt)
  if (key.state) then
    if (exit.animation.currentFrame < 4) then
      animation.update(exit.animation, dt)
    else
      exit.animation.currentFrame = 4
    end
  end
end

function class.update(dt)
  updateExitAnim(dt)
  animation.update(key.animation, dt)
end

local function drawExit()
  for line = 2, grid.getNbLines()-1 do
    for column = 2, grid.getNbColumns()-1 do
      local x = grid.getX(column)
      local y = grid.getY(line)
      if (not grid.isBox(line, column)) then
        if (grid.isKey(line, column)) then
          love.graphics.setColor(1, 1, 1)
          animation.draw(key.animation, x+32, y+10, key.w, key.h)
        elseif (grid.isExit(line, column)) then
          love.graphics.setColor(1, 1, 1)
          animation.draw(exit.animation, x, y, 0, 0)
        end
      end
    end
  end
end

function class.draw()
  drawExit()
end

return class