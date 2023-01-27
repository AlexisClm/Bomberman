local grid      = require("grid")
local animation = require("animation")

local class     = {}
local boxes     = {}
local boxesAnim = {}
local box       = {}

local nbBoxes

function class.initBoxesAnim()
  local boxAnim = {}

  boxAnim.sprite = love.graphics.newImage("Assets/Images/BoxAnim.png")

  boxAnim.timer            = 0
  boxAnim.timerLimit       = 0.5
  boxAnim.removeTimer      = 0
  boxAnim.removeTimerLimit = 0.45

  boxAnim.animation = animation.new(boxAnim.sprite, 5, 10, 0, 0, box.w, box.h)

  table.insert(boxesAnim, boxAnim)
end

local function initBoxes()
  boxes = {}
  
  box.img = love.graphics.newImage("Assets/Images/Box.png")
  box.w   = grid.getCellSize()
  box.h   = grid.getCellSize()
  
  nbBoxes = 55
end

local function createBoxes()
  for line = 2, grid.getNbLines()-1 do
    for column = 2, grid.getNbColumns()-1 do
      if (not grid.isWall(line, column)) and (not grid.isSpawn(line, column)) and (not grid.isExit(line, column)) then
        table.insert(boxes, {line = line, column = column})
      end
    end
  end

  for i = 1, nbBoxes do
    local random = table.remove(boxes, love.math.random(#boxes))
    grid.setBox(random.line, random.column, true)
  end
end

function class.load()
  initBoxes()
  createBoxes()
end

local function updateBoxesAnim(dt)
  for boxAnimId, boxAnim in ipairs(boxesAnim) do
    boxAnim.timer = boxAnim.timer + dt
    boxAnim.removeTimer = boxAnim.removeTimer + dt
    if (boxAnim.timer > boxAnim.timerLimit) then
      table.remove(boxesAnim, boxAnimId)
    end
    animation.update(boxAnim.animation, dt)
  end
end

local function removeBoxesAnim()
  for line = 1, grid.getNbLines() do
    for column = 1, grid.getNbColumns() do
      local x = grid.getX(column)
      local y = grid.getY(line)
      if (grid.isBoxState(line, column)) then
        for boxAnimId, boxAnim in ipairs(boxesAnim) do
          if (boxAnim.removeTimer > boxAnim.removeTimerLimit) then
            grid.setBoxState(line, column, false)
          end
        end
      end
    end
  end
end

function class.update(dt)
  updateBoxesAnim(dt)
  removeBoxesAnim()
end

local function drawBoxes()
  for line = 1, grid.getNbLines() do
    for column = 1, grid.getNbColumns() do
      local x = grid.getX(column)
      local y = grid.getY(line)
      if (grid.isBox(line, column)) then
        love.graphics.draw(box.img, x, y)
      elseif (grid.isBoxState(line, column)) then
        for boxAnimId, boxAnim in ipairs(boxesAnim) do
          animation.draw(boxAnim.animation, x, y, 0, 0)
        end
      end
    end
  end
end

function class.draw()
  drawBoxes()
end

return class