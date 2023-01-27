local screen    = require("screen")
local menu      = require("menu")
local pause     = require("pause")
local grid      = require("grid")
local box       = require("box")
local player    = require("player")
local player2   = require("player2")
local bomb      = require("bomb")
local bomb2     = require("bomb2")
local explosion = require("explosion")
local hud       = require("hud")
local collision = require("collision")
local powerUp   = require("powerUp")
local exit      = require("exit")
local animation = require("animation")
local gameState = require("gameState")
local gameWin   = require("gameWin")
local gameOver  = require("gameOver")
local sound     = require("sound")

function love.load()
  gameState.setState("menu")
  screen.load()
  sound.load()
  menu.load()
end

function love.update(dt)
  if (gameState.getState() == "gameSolo") or (gameState.getState() == "gameDuo") then
    box.update(dt)
    player.update(dt)
    bomb.update(dt)
    explosion.update(dt)
    powerUp.update(dt)
    collision.update(dt)
    if (gameState.getState() == "gameSolo") then
      exit.update(dt)
    elseif (gameState.getState() == "gameDuo") then
      player2.update(dt)
      bomb2.update(dt)    
    end
  end
end

function love.draw()
  if (gameState.getState() == "menu") then
    menu.draw()
  elseif (gameState.getState() == "gameSolo") or (gameState.getState() == "pauseSolo") then
    grid.draw()
    bomb.draw()
    powerUp.draw()
    box.draw()
    exit.draw()
    player.draw()
    explosion.draw()
    hud.draw()
  elseif (gameState.getState() == "gameDuo") or (gameState.getState() == "pauseDuo") then
    grid.draw()
    bomb.draw()
    bomb2.draw()
    powerUp.draw()
    box.draw()
    player.draw()
    player2.draw()
    explosion.draw()
    hud.draw()
  elseif (gameState.getState() == "gameWin") or (gameState.getState() == "playerWin") or (gameState.getState() == "player2Win") then
    gameWin.draw()
  elseif (gameState.getState() == "gameOver") then
    gameOver.draw()
  end
  if (gameState.getState() == "pauseSolo") or (gameState.getState() == "pauseDuo") then
    pause.draw()
  end
end

function love.keypressed(key)
  if (gameState.getState() == "menu") then
    menu.keypressed(key)
  elseif (gameState.getState() == "gameSolo") then
    player.keypressed(key)
  elseif (gameState.getState() == "gameDuo") then
    player.keypressed(key)
    player2.keypressed(key)
  elseif (gameState.getState() == "pauseSolo") or (gameState.getState() == "pauseDuo") then
    pause.keypressed(key)
  elseif (gameState.getState() == "gameWin") or (gameState.getState() == "playerWin") or (gameState.getState() == "player2Win") then
    gameWin.keypressed(key)
  elseif (gameState.getState() == "gameOver") then
    gameOver.keypressed(key)
  end
end

function love.mousepressed(x, y, button)
  if (gameState.getState() ~= "gameSolo") and (gameState.getState() ~= "gameDuo") then
    collision.mousepressed(x, y, button)
  end
end
