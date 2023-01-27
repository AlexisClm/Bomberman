local screen    = require("screen")
local gameState = require("gameState")

local class    = {}
local data     = {}
local images   = {}
local offset   = {}
local cellList = {}
local nb       = {}

local cell

function class.cellIsAvailable(line, column)
  return (line >= 1) and (line <= nb.lines) and (column >= 1) and (column <= nb.columns)
end

function class.getX(column)
  return offset.x + (column-1) * cell
end

function class.getY(line)
  return offset.y + (line-1) * cell
end

function class.getLine(y)
  return math.floor((y - offset.y)/cell) + 1
end

function class.getColumn(x)
  return math.floor((x - offset.x)/cell) + 1
end

function class.getNbLines()
  return nb.lines
end

function class.getNbColumns()
  return nb.columns
end

function class.getOffsetX()
  return offset.x
end

function class.getOffsetY()
  return offset.y
end

function class.getCellSize()
  return cell
end

function class.isWall(line, column)
  return data[line][column].wall
end

function class.isSpawn(line, column)
  return data[line][column].spawn
end

function class.setBox(line, column, value)
  data[line][column].box = value
end

function class.isBox(line, column)
  return data[line][column].box
end

function class.setBoxState(line, column, value)
  data[line][column].boxState = value
end

function class.isBoxState(line, column)
  return data[line][column].boxState
end

function class.setBonusRange(line, column, value)
  data[line][column].bonusRange = value
end

function class.isBonusRange(line, column)
  return data[line][column].bonusRange
end

function class.setBonusSpeed(line, column, value)
  data[line][column].bonusSpeed = value
end

function class.isBonusSpeed(line, column)
  return data[line][column].bonusSpeed
end

function class.setBonusNbBombs(line, column, value)
  data[line][column].bonusNbBombs = value
end

function class.isBonusNbBombs(line, column)
  return data[line][column].bonusNbBombs
end

function class.setBonusHp(line, column, value)
  data[line][column].bonusHp = value
end

function class.isBonusHp(line, column)
  return data[line][column].bonusHp
end

function class.setKey(line, column, value)
  data[line][column].key = value
end

function class.isKey(line, column)
  return data[line][column].key
end

function class.setExit(line, column, value)
  data[line][column].exit = value
end

function class.isExit(line, column)
  return data[line][column].exit
end

function class.setBomb(line, column, value)
  data[line][column].bomb = value
end

function class.isBomb(line, column)
  return data[line][column].bomb
end

local function initImages()
  images.wall        = love.graphics.newImage("Assets/Images/Wall.png")
  images.ground      = love.graphics.newImage("Assets/Images/Ground.png")
  images.groundShade = love.graphics.newImage("Assets/Images/GroundShade.png")
end

local function initSettings()
  nb.lines   = 11
  nb.columns = 13
  cell       = 64
  offset.x   = 20
  offset.y   = (screen.getHeight() - nb.lines * cell)/2
end

local function initGrid()
  cellList = {}

  for line = 1, nb.lines do
    data[line] = {}
    for column = 1, nb.columns do
      data[line][column] = {isWalkable = true, wall = false, box = false, boxState = false, spawn = false, exit = false, bonusRange = false, bonusSpeed = false, bonusNbBombs = false, bonusHp = false, key = false, bomb = false}
    end
  end

--  Case sortie
  if (gameState.getState() == "gameSolo") then
    data[6][nb.columns-1].exit = true
  end
end

local function initWalls()
  for line = 1, nb.lines do
    for column = 1, nb.columns do
      local cellData = data[line][column]
      if (line == 1) or (line == nb.lines) or (column == 1) or (column == nb.columns) then
        cellData.wall = true
      end
    end
  end
  for line = 3, nb.lines-2, 2 do
    for column = 3, nb.columns-2, 2 do
      local cellData = data[line][column]
      cellData.wall = true
    end
  end
end

local function initSafeZone()
  data[2][2].spawn = true
  data[2][3].spawn = true
  data[3][2].spawn = true

  if (gameState.getState() == "gameDuo") then
    data[10][12].spawn = true
    data[9][12].spawn  = true
    data[10][11].spawn = true
  end
end

function class.load()
  initImages()
  initSettings()
  initGrid()
  initWalls()
  initSafeZone()
end

local function drawGrid()
  for line = 1, nb.lines do
    for column = 1, nb.columns do
      local x        = class.getX(column)
      local y        = class.getY(line)
      local cellData = data[line][column]

      if (cellData.wall) then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.wall, x, y)
      elseif (cellData.isWalkable) then
        if (data[line-1][column].wall) or (data[line-1][column].box) or (data[line-1][column].exit) then
          love.graphics.setColor(1, 1, 1)
          love.graphics.draw(images.groundShade, x, y)
        else
          love.graphics.setColor(1, 1, 1)
          love.graphics.draw(images.ground, x, y)
        end
      end
    end
  end
end

function class.draw()
  drawGrid()
end

return class