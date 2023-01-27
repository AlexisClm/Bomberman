local grid      = require("grid")
local box       = require("box")
local animation = require("animation")

local class = {}
local data  = {}

function class.getData()
  return data
end

local function initExplosion(line, column, dir)
  local explosion = {}

  if (dir == "middle") then
    explosion.sprite = love.graphics.newImage("Assets/Images/Explosion/Middle.png")
  elseif (dir == "left") then
    explosion.sprite = love.graphics.newImage("Assets/Images/Explosion/Left.png")
  elseif (dir == "right") then
    explosion.sprite = love.graphics.newImage("Assets/Images/Explosion/Right.png")
  elseif (dir == "up") then
    explosion.sprite = love.graphics.newImage("Assets/Images/Explosion/Up.png")
  elseif (dir == "down") then
    explosion.sprite = love.graphics.newImage("Assets/Images/Explosion/Down.png")
  elseif (dir == "leftMax") then
    explosion.sprite = love.graphics.newImage("Assets/Images/Explosion/LeftMax.png")
  elseif (dir == "rightMax") then
    explosion.sprite = love.graphics.newImage("Assets/Images/Explosion/RightMax.png")
  elseif (dir == "upMax") then
    explosion.sprite = love.graphics.newImage("Assets/Images/Explosion/UpMax.png")
  elseif (dir == "downMax") then
    explosion.sprite = love.graphics.newImage("Assets/Images/Explosion/DownMax.png")
  end


  explosion.w          = 64
  explosion.h          = 64
  explosion.line       = line
  explosion.column     = column
  explosion.x          = grid.getX(explosion.column)
  explosion.y          = grid.getY(explosion.line)
  explosion.timer      = 0
  explosion.timerLimit = 0.5

  explosion.animation = animation.new(explosion.sprite, 4, 8, 0, 0, explosion.w, explosion.h, false)

  table.insert(data, explosion)
end

function class.setExplosion(line, column, range)
  local checkColumn = column - 1
  local checkLine   = line - 1
  local count       = 1

  initExplosion(line, column, "middle")

  while (grid.cellIsAvailable(line, checkColumn)) and (count <= range) and (not grid.isWall(line, checkColumn)) do
    if (grid.isBox(line, checkColumn)) or (grid.isBoxState(line, checkColumn)) then
      grid.setBoxState(line, checkColumn, true)
      grid.setBox(line, checkColumn, false)
      box.initBoxesAnim()
    elseif (count == range) then
      initExplosion(line, checkColumn, "leftMax")
    else
      initExplosion(line, checkColumn, "left")
      checkColumn = checkColumn - 1
    end
    count = count + 1
  end

  checkColumn = column + 1
  count = 1

  while (grid.cellIsAvailable(line, checkColumn)) and (count <= range) and (not grid.isWall(line, checkColumn)) and (not grid.isExit(line, checkColumn)) do
    if (grid.isBox(line, checkColumn)) or (grid.isBoxState(line, checkColumn)) then
      grid.setBoxState(line, checkColumn, true)
      grid.setBox(line, checkColumn, false)
      box.initBoxesAnim()
    elseif (count == range) then
      initExplosion(line, checkColumn, "rightMax")
    else
      initExplosion(line, checkColumn, "right")
      checkColumn = checkColumn + 1
    end
    count = count + 1
  end

  count = 1

  while (grid.cellIsAvailable(checkLine, column)) and (count <= range) and (not grid.isWall(checkLine, column)) and (not grid.isExit(checkLine, column)) do
    if (grid.isBox(checkLine, column)) or (grid.isBoxState(checkLine, column)) then
      grid.setBoxState(checkLine, column, true)
      grid.setBox(checkLine, column, false)
      box.initBoxesAnim()
    elseif (count == range) then
      initExplosion(checkLine, column, "upMax")
    else
      initExplosion(checkLine, column, "up")
      checkLine = checkLine - 1
    end
    count = count + 1
  end

  checkLine = line + 1
  count = 1

  while (grid.cellIsAvailable(checkLine, column)) and (count <= range) and (not grid.isWall(checkLine, column)) and (not grid.isExit(checkLine, column)) do
    if (grid.isBox(checkLine, column)) or (grid.isBoxState(checkLine, column)) then
      grid.setBoxState(checkLine, column, true)
      grid.setBox(checkLine, column, false)
      box.initBoxesAnim()
    elseif (count == range) then
      initExplosion(checkLine, column, "downMax")
    else
      initExplosion(checkLine, column, "down")
      checkLine = checkLine + 1
    end
    count = count + 1
  end
end

function class.load()
  data = {}
end

local function updateExplosion(dt)
  for explosionId, explosion in ipairs(data) do
    explosion.timer = explosion.timer + dt
    if (explosion.timer > explosion.timerLimit) then
      table.remove(data, explosionId)
    end
    animation.update(explosion.animation, dt)
  end
end

function class.update(dt)
  updateExplosion(dt)
end

local function drawExplosion()
  for explosionId, explosion in ipairs(data) do
    love.graphics.setColor(1, 1, 1)
    animation.draw(explosion.animation, explosion.x, explosion.y, 0, 0)
  end
end

function class.draw()
  drawExplosion()
end

return class