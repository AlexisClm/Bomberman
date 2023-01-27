local grid      = require("grid")
local explosion = require("explosion")
local animation = require("animation")
local sound     = require("sound")

local class = {}
local data  = {}

local nbBombs
local actualRange

function class.getData()
  return data
end

function class.setNbBombs(value)
  nbBombs = value
end

function class.getNbBombsMax()
  return nbBombs
end

function class.getNbBombs()
  return #data
end

function class.setRange(value)
  actualRange = value
end

function class.getRange()
  return actualRange
end

function class.setTimer(value, id)
  data[id].timer = value
end

function class.getTimerLimit(id)
  return data[id].timerLimit
end

function class.initBomb(line, column)
  local bomb = {}

  bomb.sprite     = love.graphics.newImage("Assets/Images/Bomb.png")
  bomb.w          = grid.getCellSize()
  bomb.h          = grid.getCellSize()
  bomb.line       = line
  bomb.column     = column
  bomb.x          = grid.getX(bomb.column)
  bomb.y          = grid.getY(bomb.line)
  bomb.range      = actualRange
  bomb.timer      = 0
  bomb.timerLimit = 2

  bomb.animation = animation.new(bomb.sprite, 3, 4.5, 0, 0, 42, 42, true)

  table.insert(data, bomb)
end

local function initSettings()
  data = {}
  nbBombs     = 1
  actualRange = 1
end

function class.load()
  initSettings()
end

local function updateBombs(dt)
  for bombId, bomb in ipairs(data) do
    bomb.timer = bomb.timer + dt
    if (bomb.timer > bomb.timerLimit) then
      table.remove(data, bombId)
      grid.setBomb(bomb.line, bomb.column, false)
      explosion.setExplosion(bomb.line, bomb.column, bomb.range)
      sound.getExplosion():play()
    end
    animation.update(bomb.animation, dt)
  end
end

function class.update(dt)
  updateBombs(dt)
end

local function drawBombs()
  for bombId, bomb in ipairs(data) do
    love.graphics.setColor(1, 1, 1)
    animation.draw(bomb.animation, bomb.x, bomb.y, -grid.getCellSize()+42, -grid.getCellSize()+42)
  end
end

function class.draw()
  drawBombs()
end

return class