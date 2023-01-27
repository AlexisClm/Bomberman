local screen = require("screen")
local sound  = require("sound")

local class = {}
local solo  = {}
local duo   = {}
local quit  = {}

local font
local backgroundImg

function class.getSoloHitbox()
  local hitbox = {}

  hitbox.x = solo.x
  hitbox.y = solo.y
  hitbox.h = solo.h
  hitbox.w = solo.w

  return hitbox
end

function class.getDuoHitbox()
  local hitbox = {}

  hitbox.x = duo.x
  hitbox.y = duo.y
  hitbox.h = duo.h
  hitbox.w = duo.w

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

local function loadImages()
  backgroundImg = love.graphics.newImage("Assets/Images/BackgroundMenu.jpg")
end

local function loadFont()
  font = love.graphics.newFont("Assets/Font/Bomberman.ttf", 25)
end

local function loadSolo()
  solo.w = 200
  solo.h = 50
  solo.x = (screen.getWidth()-solo.w)/2
  solo.y = (screen.getHeight())/2 - 75 
end

local function loadDuo()
  duo.w = 200
  duo.h = 50
  duo.x = (screen.getWidth()-duo.w)/2
  duo.y = (screen.getHeight())/2 +50
end

local function loadQuit()
  quit.w = 200
  quit.h = 50
  quit.x = (screen.getWidth()-quit.w)/2
  quit.y = (screen.getHeight())/2 + 175
end

function class.load()
  loadImages()
  loadFont()
  loadSolo()
  loadDuo()
  loadQuit()
  sound.getMenu():play()
end

local function drawBackground()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(backgroundImg)
end

local function drawSolo()
  love.graphics.setFont(font)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", solo.x, solo.y, solo.w, solo.h)
  love.graphics.printf("Solo", solo.x, solo.y + 10, solo.w, "center")
end

local function drawDuo()
  love.graphics.setFont(font)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", duo.x, duo.y, duo.w, duo.h)
  love.graphics.printf("Duo", duo.x, duo.y + 10, duo.w, "center")
end

local function drawQuit()
  love.graphics.setFont(font)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", quit.x, quit.y, quit.w, quit.h)
  love.graphics.printf("Quit", quit.x, quit.y + 10, quit.w, "center")
end

function class.draw()
  drawBackground()
  drawSolo()
  drawDuo()
  drawQuit()
end

function class.keypressed(key)
  if (key == "escape") then
    love.event.quit()
  end
end

return class