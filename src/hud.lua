local screen    = require("screen")
local bomb      = require("bomb")
local bomb2     = require("bomb2")
local player    = require("player")
local player2   = require("player2")
local powerUp   = require("powerUp")
local exit      = require("exit")
local gameState = require("gameState")

local class  = {}
local images = {}
local hp     = {}
local nbBomb = {}
local range  = {}
local speed  = {}

local font
local hudX
local keyY

local function initImages()
  images.life   = love.graphics.newImage("Assets/Images/LifeWhite.png")
  images.life2  = love.graphics.newImage("Assets/Images/LifeBlack.png")
  images.nbBomb = love.graphics.newImage("Assets/Images/NbBomb.png")
  images.range  = love.graphics.newImage("Assets/Images/Range.png")
  images.speed  = love.graphics.newImage("Assets/Images/Speed.png")
  images.key    = love.graphics.newImage("Assets/Images/Key.png")
  images.exit   = love.graphics.newImage("Assets/Images/Exit.png")
end

local function initSettings()
  if (gameState.getState() == "gameSolo") then 
    hp.y = 100
  elseif (gameState.getState() == "gameDuo") then
    hp.y = 20
  end
  
  font = love.graphics.newFont("Assets/Font/Bomberman.ttf", 40)

  hudX     = screen.getWidth()-172
  nbBomb.y = hp.y + 100
  range.y  = nbBomb.y + 100
  speed.y  = range.y + 100
  keyY     = speed.y + 200

  hp.y2     = screen.getHeight()/2 + 20
  nbBomb.y2 = hp.y2 + 100
  range.y2  = nbBomb.y2 + 100
  speed.y2  = range.y2 + 100
end

function class.load()
  initImages()
  initSettings()
end

local function drawHp()
  love.graphics.draw(images.life, hudX+30, hp.y)
  love.graphics.setFont(font)
  love.graphics.print("X "..player.getHp(), hudX+90, hp.y+10)
end

local function drawNbBomb()
  love.graphics.draw(images.nbBomb, hudX+30, nbBomb.y)
  love.graphics.print("X "..bomb.getNbBombsMax(), hudX+90, nbBomb.y)
end

local function drawRange()
  love.graphics.draw(images.range, hudX+30, range.y)
  love.graphics.print("X "..bomb.getRange(), hudX+90, range.y-5)
end

local function drawSpeed()
  love.graphics.draw(images.speed, hudX+30, speed.y)
  love.graphics.print("X "..powerUp.getNbSpeed(), hudX+90, speed.y-5)
end

local function drawMissions()
  if (not exit.isKey()) then
    love.graphics.print("FIND THE", hudX+12, keyY-75)
    love.graphics.draw(images.key, hudX+75, keyY)
  else
    love.graphics.print("GO TO", hudX+35, keyY-100)
    love.graphics.print("THE", hudX+55, keyY-50)
    love.graphics.draw(images.exit, hudX+55, keyY+20)
  end
end

local function drawHp2()
  love.graphics.line(hudX, screen.getHeight()/2, screen.getWidth(), screen.getHeight()/2)
  love.graphics.draw(images.life2, hudX+30, hp.y2)
  love.graphics.print("X "..player2.getHp(), hudX+90, hp.y2+10)
end

local function drawNbBomb2()
  love.graphics.draw(images.nbBomb, hudX+30, nbBomb.y2)
  love.graphics.print("X "..bomb2.getNbBombsMax(), hudX+90, nbBomb.y2)
end

local function drawRange2()
  love.graphics.draw(images.range, hudX+30, range.y2)
  love.graphics.print("X "..bomb2.getRange(), hudX+90, range.y2-5)
end

local function drawSpeed2()
  love.graphics.draw(images.speed, hudX+30, speed.y2)
  love.graphics.print("X "..powerUp.getNbSpeed2(), hudX+90, speed.y2-5)
end

function class.draw()
  drawHp()
  drawNbBomb()
  drawRange()
  drawSpeed()

  if (gameState.getState() == "gameSolo") or (gameState.getState() == "pauseSolo") then
    drawMissions()
  elseif (gameState.getState() == "gameDuo") or (gameState.getState() == "pauseDuo") then
    drawHp2()
    drawNbBomb2()
    drawRange2()
    drawSpeed2()
  end
end

return class