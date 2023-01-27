local screen    = require("screen")
local gameState = require("gameState")
local sound     = require("sound")

local class     = {}
local images    = {}
local font      = {}
local playAgain = {}
local menu      = {}

function class.getPlayAgainHitbox()
  local hitbox = {}

  hitbox.x = playAgain.x
  hitbox.y = playAgain.y
  hitbox.h = playAgain.h
  hitbox.w = playAgain.w

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
  images.backgroundPlayer  = love.graphics.newImage("Assets/Images/BackgroundWinWhite.jpg")
  images.backgroundPlayer2 = love.graphics.newImage("Assets/Images/BackgroundWinBlack.jpg")
end

local function loadFont()
  font.small = love.graphics.newFont("Assets/Font/Bomberman.ttf", 25)
  font.big   = love.graphics.newFont("Assets/Font/Bomberman.ttf", 80)
end

local function loadPlayAgain()
  playAgain.w = 200
  playAgain.h = 50
  playAgain.x = (screen.getWidth())/2 - playAgain.w*1.3
  playAgain.y = screen.getHeight()-60
end

local function loadQuit()
  menu.w = 200
  menu.h = 50
  menu.x = (screen.getWidth())/2 + menu.w*0.3
  menu.y = screen.getHeight()-60
end

function class.load()
  loadImages()
  loadFont()
  loadPlayAgain()
  loadQuit()
end

local function drawBackground()
  if (gameState.getState() == "gameWin") or (gameState.getState() == "playerWin") then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.backgroundPlayer)
  elseif (gameState.getState() == "player2Win") then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.backgroundPlayer2)
  end
end

local function drawYouWin()
  love.graphics.setFont(font.big)
  love.graphics.setColor(0, 0, 0)

  if (gameState.getState() == "gameWin") then
    love.graphics.printf("YOU WIN", 0, 10, screen.getWidth(), "center")
  elseif (gameState.getState() == "playerWin") then
    love.graphics.printf("WHITE BOMBER WINS", 125, 10, screen.getWidth(), "center")
  elseif (gameState.getState() == "player2Win") then
    love.graphics.printf("BLACK BOMBER WINS", 125, 10, screen.getWidth(), "center")
  end
end

local function drawPlayAgain()
  love.graphics.setFont(font.small)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", playAgain.x, playAgain.y, playAgain.w, playAgain.h)
  love.graphics.printf("Play Again", playAgain.x, playAgain.y + 10, playAgain.w, "center")
end

local function drawMenu()
  love.graphics.setFont(font.small)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", menu.x, menu.y, menu.w, menu.h)
  love.graphics.printf("Back To Menu", menu.x, menu.y + 10, menu.w, "center")
end

function class.draw()
  drawBackground()
  drawYouWin()
  drawPlayAgain()
  drawMenu()
end

function class.keypressed(key)
  if (key == "escape") then
    gameState.setState("menu")
    sound.getWin():stop()
    sound.getMenu():play()
  end
end

return class