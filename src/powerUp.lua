local grid      = require("grid")
local player    = require("player")
local player2   = require("player2")
local bomb      = require("bomb")
local bomb2     = require("bomb2")
local animation = require("animation")
local gameState = require("gameState")

local class   = {}
local images  = {}
local bonus   = {}
local bonus2  = {}
local random  = {}
local boxList = {}

function class.getBoxList()
  return boxList
end

function class.setBonusRange(value)
  bonus.range = value
end

function class.setBonusSpeed(value)
  bonus.speed = value
end

function class.setBonusNbBombs(value)
  bonus.nbBombs = value
end

function class.setBonusHp(value)
  bonus.hp = value
end

function class.setBonusSpeedTimer(value)
  bonus.speedTimer = value
end

function class.setBonus2Range(value)
  bonus2.range = value
end

function class.setBonus2Speed(value)
  bonus2.speed = value
end

function class.setBonus2NbBombs(value)
  bonus2.nbBombs = value
end

function class.setBonus2Hp(value)
  bonus2.hp = value
end

function class.setBonus2SpeedTimer(value)
  bonus2.speedTimer = value
end

function class.getNbSpeed()
  return bonus.nbSpeed
end

function class.getNbSpeed2()
  return bonus2.nbSpeed
end

local function initImages()
  images.bonusRange   = love.graphics.newImage("Assets/Images/PowerUp/BonusRange.png")
  images.bonusSpeed   = love.graphics.newImage("Assets/Images/PowerUp/BonusSpeed.png")
  images.bonusNbBombs = love.graphics.newImage("Assets/Images/PowerUp/BonusNbBombs.png")
  images.bonusHp      = love.graphics.newImage("Assets/Images/PowerUp/BonusHp.png")
end

local function initSettings()
  boxList = {}

  bonus.range   = false
  bonus.nbBombs = false
  bonus.hp      = false
  bonus.speed   = false
  bonus.nbSpeed = 1

  bonus2.range   = false
  bonus2.nbBombs = false
  bonus2.hp      = false
  bonus2.speed   = false
  bonus2.nbSpeed = 1

  random.bonusRange = love.math.random(3, 4)
  random.bonusHp    = love.math.random(2, 3)

  if (gameState.getState() == "gameSolo") then
    random.bonusSpeed   = love.math.random(2, 3)
    random.bonusNbBombs = love.math.random(2, 3)
  elseif (gameState.getState() == "gameDuo") then
    random.bonusSpeed   = love.math.random(3, 4)
    random.bonusNbBombs = love.math.random(3, 4)
  end
end

local function initPowerUps()
  for line = 2, grid.getNbLines()-1 do
    for column = 2, grid.getNbColumns()-1 do
      if (grid.isBox(line, column)) then
        table.insert(boxList, {line = line, column = column})
      end
    end
  end

  for i = 1, random.bonusRange do
    local random = table.remove(boxList, love.math.random(#boxList))
    grid.setBonusRange(random.line, random.column, true)
  end

  for i = 1, random.bonusSpeed do
    local random = table.remove(boxList, love.math.random(#boxList))
    grid.setBonusSpeed(random.line, random.column, true)
  end

  for i = 1, random.bonusNbBombs do
    local random = table.remove(boxList, love.math.random(#boxList))
    grid.setBonusNbBombs(random.line, random.column, true)
  end

  for i = 1, random.bonusHp do
    local random = table.remove(boxList, love.math.random(#boxList))
    grid.setBonusHp(random.line, random.column, true)
  end
end

function class.load()
  initImages()
  initSettings()
  initPowerUps()
end

local function setPlayerBonus(dt)
  if (bonus.speed) then
    player.setSpeed(player.getSpeed()*1.25)
    bonus.nbSpeed = bonus.nbSpeed + 1
    bonus.speed = false
  elseif (bonus.range) then
    bomb.setRange(bomb.getRange()+1)
    bonus.range = false
  elseif (bonus.nbBombs) then
    bomb.setNbBombs(bomb.getNbBombsMax()+1)
    bonus.nbBombs = false
  elseif (bonus.hp) then
    player.setHp(player.getHp()+1)
    bonus.hp = false
  end
end

local function setPlayer2Bonus(dt)
  if (bonus2.speed) then
    player2.setSpeed(player2.getSpeed()*1.25)
    bonus2.nbSpeed = bonus.nbSpeed + 1
    bonus2.speed = false
  elseif (bonus2.range) then
    bomb2.setRange(bomb2.getRange()+1)
    bonus2.range = false
  elseif (bonus2.nbBombs) then
    bomb2.setNbBombs(bomb2.getNbBombsMax()+1)
    bonus2.nbBombs = false
  elseif (bonus2.hp) then
    player2.setHp(player2.getHp()+1)
    bonus2.hp = false
  end
end

function class.update(dt)
  setPlayerBonus(dt)
  if (gameState.getState() == "gameDuo") then
    setPlayer2Bonus(dt)
  end
end

local function drawPowerups()
  for line = 2, grid.getNbLines()-1 do
    for column = 2, grid.getNbColumns()-1 do
      local x = grid.getX(column)+7
      local y = grid.getY(line)+7
      if (grid.isBonusRange(line, column)) then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.bonusRange, x, y)
      elseif (grid.isBonusSpeed(line, column)) then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.bonusSpeed, x, y)
      elseif (grid.isBonusNbBombs(line, column)) then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.bonusNbBombs, x, y)
      elseif (grid.isBonusHp(line, column)) then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.bonusHp, x, y)
      end
    end
  end
end

function class.draw()
  drawPowerups()
end

return class