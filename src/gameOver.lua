local screen    = require("screen")
local gameState = require("gameState")

local class  = {}
local font   = {}
local retry  = {}
local menu   = {}

local backgroundImg

function class.getRetryHitbox()
  local hitbox = {}

  hitbox.x = retry.x
  hitbox.y = retry.y
  hitbox.h = retry.h
  hitbox.w = retry.w

  return hitbox
end

function class.getMenuHitbox()
  local hitbox = {}

  hitbox.x = menu.x
  hitbox.y = menu.y
  hitbox.h = menu.h
  hitbox.w = menu.w

  return hitbox
end

local function loadImages()
  backgroundImg = love.graphics.newImage("Assets/Images/BackgroundLose.jpg")
end

local function loadFont()
  font.small  = love.graphics.newFont("Assets/Font/Bomberman.ttf", 25)
  font.medium = love.graphics.newFont("Assets/Font/Bomberman.ttf", 50)
  font.big    = love.graphics.newFont("Assets/Font/Bomberman.ttf", 80)
end

local function loadRetry()
  retry.w = 200
  retry.h = 50
  retry.x = (screen.getWidth()-retry.w)/2
  retry.y = screen.getHeight()-190
end

local function loadQuit()
  menu.w = 200
  menu.h = 50
  menu.x = (screen.getWidth()-menu.w)/2
  menu.y = screen.getHeight()-130
end

function class.load()
  loadImages()
  loadFont()
  loadRetry()
  loadQuit()
end

local function drawBackground()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(backgroundImg)
end

local function drawYouLose()
  love.graphics.setFont(font.big)
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("YOU LOSE", 0, 10, screen.getWidth(), "center")
  love.graphics.setFont(font.medium)
  love.graphics.printf("L2p noob", 30, 575, 220, "center", math.rad(-15))
end

local function drawRetry()
  love.graphics.setFont(font.small)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", retry.x, retry.y, retry.w, retry.h)
  love.graphics.printf("Retry", retry.x, retry.y + 10, retry.w, "center")
end

local function drawMenu()
  love.graphics.setFont(font.small)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", menu.x, menu.y, menu.w, menu.h)
  love.graphics.printf("Back To Menu", menu.x, menu.y + 10, menu.w, "center")
end

function class.draw()
  drawBackground()
  drawYouLose()
  drawRetry()
  drawMenu()
end

function class.keypressed(key)
  if (key == "escape") then
    gameState.setState("menu")
  end
end

return class