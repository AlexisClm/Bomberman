local screen    = require("screen")
local gameState = require("gameState")
local sound     = require("sound")

local class    = {}
local images   = {}
local font     = {}
local continue = {}
local menu     = {}
local quit     = {}

function class.getContinueHitbox()
  local hitbox = {}

  hitbox.x = continue.x
  hitbox.y = continue.y
  hitbox.h = continue.h
  hitbox.w = continue.w

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

function class.getQuitHitbox()
  local hitbox = {}

  hitbox.x = quit.x
  hitbox.y = quit.y
  hitbox.h = quit.h
  hitbox.w = quit.w

  return hitbox
end

local function loadFont()
  font.small = love.graphics.newFont("Assets/Font/Bomberman.ttf", 25)
  font.big = love.graphics.newFont("Assets/Font/Bomberman.ttf", 80)
end

local function loadContinue()
  continue.w = 200
  continue.h = 50
  continue.x = (screen.getWidth()-continue.w)/2
  continue.y = (screen.getHeight())/2 - continue.h*2
end

local function loadMenu()
  menu.w = 200
  menu.h = 50
  menu.x = (screen.getWidth()-continue.w)/2
  menu.y = (screen.getHeight())/2
end

local function loadQuit()
  quit.w = 200
  quit.h = 50
  quit.x = (screen.getWidth()-quit.w)/2
  quit.y = (screen.getHeight())/2 + quit.h*2
end

function class.load()
  loadFont()
  loadContinue()
  loadMenu()
  loadQuit()
end

local function drawShade()
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle("fill", 0, 0, screen.getWidth(), screen.getHeight())
end

local function drawPause()
  love.graphics.setFont(font.big)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("PAUSE", 0, 100, screen.getWidth(), "center")
end

local function drawContinue()
  love.graphics.setFont(font.small)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", continue.x, continue.y, continue.w, continue.h)
  love.graphics.printf("Continue", continue.x, continue.y + 10, continue.w, "center")
end

local function drawMenu()
  love.graphics.setFont(font.small)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", menu.x, menu.y, menu.w, menu.h)
  love.graphics.printf("Back To Menu", menu.x, menu.y + 10, menu.w, "center")
end

local function drawQuit()
  love.graphics.setFont(font.small)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", quit.x, quit.y, quit.w, quit.h)
  love.graphics.printf("Quit", quit.x, quit.y + 10, quit.w, "center")
end

function class.draw()
  drawShade()
  drawPause()
  drawContinue()
  drawMenu()
  drawQuit()
end

function class.keypressed(key)
  if (key == "escape") then
    if (gameState.getState() == "pauseSolo") then
      gameState.setState("gameSolo")
    elseif (gameState.getState() == "pauseDuo") then
      gameState.setState("gameDuo")
    end
    sound.getBackground():setVolume(0.6)
  end
end

return class