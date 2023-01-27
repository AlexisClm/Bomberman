local gameState = require("gameState")
local menu      = require("menu")
local pause     = require("pause")
local grid      = require("grid")
local box       = require("box")
local player    = require("player")
local player2   = require("player2")
local bomb      = require("bomb")
local bomb2     = require("bomb2")
local powerUp   = require("powerUp")
local exit      = require("exit")
local explosion = require("explosion")
local hud       = require("hud")
local gameWin   = require("gameWin")
local gameOver  = require("gameOver")
local sound     = require("sound")

local class = {}

local function rectRect(a, b)
  return (a.x + a.w > b.x) and (a.x < b.x + b.w) and (a.y < b.y + b.h) and (a.y + a.h > b.y)
end

local function rectCell(a, b)
  local collision = {left = false, right = false, up = false, down = false}
  if (rectRect(a, b)) then
    local colLeft  = b.x + b.w - a.x
    local colRight = a.x + a.w - b.x
    local colUp    = b.y + b.h - a.y
    local colDown  = a.y + a.h - b.y
    local colMin   = math.min(colLeft, colRight, colUp, colDown)

    if (colMin == colLeft) then
      collision.left = true
    elseif (colMin == colRight) then
      collision.right = true
    elseif (colMin == colUp) then
      collision.up = true
    elseif (colMin == colDown) then
      collision.down = true
    end
  end
  return collision
end

local function checkColPlayerCell(dt)
  local playeR = player.getHitbox()
  local line   = grid.getLine(playeR.y)
  local column = grid.getColumn(playeR.x)

  for checkLine = line-1, line+1 do
    for checkColumn = column-1, column+1 do
      if (grid.cellIsAvailable(checkLine, checkColumn)) then
        if (grid.isWall(checkLine, checkColumn)) or (grid.isBox(checkLine, checkColumn)) or (grid.isBoxState(checkLine, checkColumn)) or ((grid.isExit(checkLine, checkColumn) and (not exit.isKey()))) then
          local case = {x = grid.getX(checkColumn), y = grid.getY(checkLine), w = grid.getCellSize(), h = grid.getCellSize()}
          local collision = rectCell(playeR, case)
          if (collision.up) then
            player.setY(playeR.y + playeR.speed*dt)
            sound.getCollision():play()
          elseif (collision.down) then
            player.setY(playeR.y - playeR.speed*dt)
            sound.getCollision():play()
          elseif (collision.left) then
            player.setX(playeR.x + playeR.speed*dt)
            sound.getCollision():play()
          elseif (collision.right) then
            player.setX(playeR.x - playeR.speed*dt)
            sound.getCollision():play()
          end
        end
      end
    end
  end
end

local function checkColPlayer2Cell(dt)
  local playeR2 = player2.getHitbox()
  local line    = grid.getLine(playeR2.y)
  local column  = grid.getColumn(playeR2.x)

  for checkLine = line-1, line+1 do
    for checkColumn = column-1, column+1 do
      if (grid.cellIsAvailable(checkLine, checkColumn)) then
        if (grid.isWall(checkLine, checkColumn)) or (grid.isBox(checkLine, checkColumn)) or (grid.isBoxState(checkLine, checkColumn)) or ((grid.isExit(checkLine, checkColumn) and (not exit.isKey()))) then
          local case = {x = grid.getX(checkColumn), y = grid.getY(checkLine), w = grid.getCellSize(), h = grid.getCellSize()}
          local collision = rectCell(playeR2, case)
          if (collision.up) then
            player2.setY(playeR2.y + playeR2.speed*dt)
            sound.getCollision():play()
          elseif (collision.down) then
            player2.setY(playeR2.y - playeR2.speed*dt)
            sound.getCollision():play()
          elseif (collision.left) then
            player2.setX(playeR2.x + playeR2.speed*dt)
            sound.getCollision():play()
          elseif (collision.right) then
            player2.setX(playeR2.x - playeR2.speed*dt)
            sound.getCollision():play()
          end
        end
      end
    end
  end
end

local function checkColPlayerBombs(dt)
  local playeR = player.getHitbox()
  local line   = player.getLine()
  local column = player.getColumn()

  for bombId, bomb in ipairs(bomb.getData()) do
    local collision = rectCell(playeR, bomb)

    if (not grid.isBomb(line, column)) then
      if (collision.up) then
        player.setY(playeR.y + playeR.speed*dt)
        sound.getCollision():play()
      elseif (collision.down) then
        player.setY(playeR.y - playeR.speed*dt)
        sound.getCollision():play()
      elseif (collision.left) then
        player.setX(playeR.x + playeR.speed*dt)
        sound.getCollision():play()
      elseif (collision.right) then
        player.setX(playeR.x - playeR.speed*dt)
        sound.getCollision():play()
      end
    end
  end

  if (gameState.getState() == "gameDuo") then
    for bombId, bomb in ipairs(bomb2.getData()) do
      local collision = rectCell(playeR, bomb)

      if (not grid.isBomb(line, column)) then
        if (collision.up) then
          player.setY(playeR.y + playeR.speed*dt)
          sound.getCollision():play()
        elseif (collision.down) then
          player.setY(playeR.y - playeR.speed*dt)
          sound.getCollision():play()
        elseif (collision.left) then
          player.setX(playeR.x + playeR.speed*dt)
          sound.getCollision():play()
        elseif (collision.right) then
          player.setX(playeR.x - playeR.speed*dt)
          sound.getCollision():play()
        end
      end
    end
  end
end

local function checkColPlayer2Bombs(dt)
  local playeR2 = player2.getHitbox()
  local line    = player2.getLine()
  local column  = player2.getColumn()

  for bombId, bomb in ipairs(bomb.getData()) do
    local collision = rectCell(playeR2, bomb)

    if (not grid.isBomb(line, column)) then
      if (collision.up) then
        player2.setY(playeR2.y + playeR2.speed*dt)
        sound.getCollision():play()
      elseif (collision.down) then
        player2.setY(playeR2.y - playeR2.speed*dt)
        sound.getCollision():play()
      elseif (collision.left) then
        player2.setX(playeR2.x + playeR2.speed*dt)
        sound.getCollision():play()
      elseif (collision.right) then
        player2.setX(playeR2.x - playeR2.speed*dt)
        sound.getCollision():play()
      end
    end
  end

  for bombId, bomb in ipairs(bomb2.getData()) do
    local collision = rectCell(playeR2, bomb)

    if (not grid.isBomb(line, column)) then
      if (collision.up) then
        player2.setY(playeR2.y + playeR2.speed*dt)
        sound.getCollision():play()
      elseif (collision.down) then
        player2.setY(playeR2.y - playeR2.speed*dt)
        sound.getCollision():play()
      elseif (collision.left) then
        player2.setX(playeR2.x + playeR2.speed*dt)
        sound.getCollision():play()
      elseif (collision.right) then
        player2.setX(playeR2.x - playeR2.speed*dt)
        sound.getCollision():play()
      end
    end
  end
end

local function checkColPlayerPowerUps()
  local player = player.getHitbox()
  local line   = grid.getLine(player.y)
  local column = grid.getColumn(player.x)

  for checkLine = line-1, line+1 do
    for checkColumn = column-1, column+1 do
      local case = {x = grid.getX(checkColumn)+7, y = grid.getY(checkLine)+7, w = grid.getCellSize()-7, h = grid.getCellSize()-7}
      if (rectRect(player, case)) then
        if (grid.isBonusRange(checkLine, checkColumn)) then
          grid.setBonusRange(checkLine, checkColumn, false)
          powerUp.setBonusRange(true)
          sound.getPowerUp():play()
        elseif (grid.isBonusSpeed(checkLine, checkColumn)) then
          grid.setBonusSpeed(checkLine, checkColumn, false)
          powerUp.setBonusSpeed(true)
          powerUp.setBonusSpeedTimer(0)
          sound.getPowerUp():play()
        elseif (grid.isBonusNbBombs(checkLine, checkColumn)) then
          grid.setBonusNbBombs(checkLine, checkColumn, false)
          powerUp.setBonusNbBombs(true)
          sound.getPowerUp():play()
        elseif (grid.isBonusHp(checkLine, checkColumn)) then
          grid.setBonusHp(checkLine, checkColumn, false)
          powerUp.setBonusHp(true)
          sound.getPowerUp():play()
        end
      end
    end
  end
end

local function checkColPlayer2PowerUps()
  local player2 = player2.getHitbox()
  local line    = grid.getLine(player2.y)
  local column  = grid.getColumn(player2.x)

  for checkLine = line-1, line+1 do
    for checkColumn = column-1, column+1 do
      local case = {x = grid.getX(checkColumn)+7, y = grid.getY(checkLine)+7, w = grid.getCellSize()-7, h = grid.getCellSize()-7}
      if (rectRect(player2, case)) then
        if (grid.isBonusRange(checkLine, checkColumn)) then
          grid.setBonusRange(checkLine, checkColumn, false)
          powerUp.setBonus2Range(true)
          sound.getPowerUp():play()
        elseif (grid.isBonusSpeed(checkLine, checkColumn)) then
          grid.setBonusSpeed(checkLine, checkColumn, false)
          powerUp.setBonus2Speed(true)
          powerUp.setBonus2SpeedTimer(0)
          sound.getPowerUp():play()
        elseif (grid.isBonusNbBombs(checkLine, checkColumn)) then
          grid.setBonusNbBombs(checkLine, checkColumn, false)
          powerUp.setBonus2NbBombs(true)
          sound.getPowerUp():play()
        elseif (grid.isBonusHp(checkLine, checkColumn)) then
          grid.setBonusHp(checkLine, checkColumn, false)
          powerUp.setBonus2Hp(true)
          sound.getPowerUp():play()
        end
      end
    end
  end
end

local function checkColPlayerKey()
  local player = player.getHitbox()
  local line   = grid.getLine(player.y)
  local column = grid.getColumn(player.x)

  for checkLine = line-1, line+1 do
    for checkColumn = column-1, column+1 do
      local case = {x = grid.getX(checkColumn)+16, y = grid.getY(checkLine), w = grid.getCellSize()-28, h = grid.getCellSize()+30}
      if (rectRect(player, case)) then
        if (grid.isKey(checkLine, checkColumn)) and (not grid.isBox(checkLine, checkColumn)) then
          grid.setKey(checkLine, checkColumn, false)
          exit.setKey(true)
          sound.getKey():play()
        end
      end
    end
  end
end

local function checkColPlayerExplosions()
  local playeR = player.getHitbox2()

  for explosionId, explosion in ipairs(explosion.getData()) do
    if (rectRect(playeR, explosion)) and (player.isAlive()) then
      player.setAlive(false)
      player.setHp(player.getHp()-1)
      sound.getHit():play()
    end
  end
end

local function checkColPlayer2Explosions()
  local playeR2 = player2.getHitbox2()

  for explosionId, explosion in ipairs(explosion.getData()) do
    if (rectRect(playeR2, explosion)) and (player2.isAlive()) then
      player2.setAlive(false)
      player2.setHp(player2.getHp()-1)
      sound.getHit():play()
    end
  end
end

local function checkColExplosionsBombs()
  for explosionId, explosion in ipairs(explosion.getData()) do
    for bombId, bomB in ipairs(bomb.getData()) do
      if (rectRect(bomB, explosion)) then
        bomb.setTimer(bomb.getTimerLimit(bombId), bombId)
      end
    end
  end

  if (gameState.getState() == "gameDuo") then
    for explosionId, explosion in ipairs(explosion.getData()) do
      for bombId, bomB in ipairs(bomb2.getData()) do
        if (rectRect(bomB, explosion)) then
          bomb2.setTimer(bomb2.getTimerLimit(bombId), bombId)
        end
      end
    end
  end
end

local function checkColExplosionsPowerUps()
  for explosionId, explosioN in ipairs(explosion.getData()) do
    local line   = grid.getLine(explosioN.y)
    local column = grid.getColumn(explosioN.x)
    for checkLine = line-1, line+1 do
      for checkColumn = column-1, column+1 do
        local case = {x = grid.getX(checkColumn)+7, y = grid.getY(checkLine)+7, w = grid.getCellSize()-7, h = grid.getCellSize()-7}

        if (rectRect(case, explosioN)) then
          if (not grid.isBox(checkLine, checkColumn)) then
            if (grid.isBonusRange(checkLine, checkColumn)) then
              grid.setBonusRange(checkLine, checkColumn, false)
            elseif (grid.isBonusSpeed(checkLine, checkColumn)) then
              grid.setBonusSpeed(checkLine, checkColumn, false)
            elseif (grid.isBonusNbBombs(checkLine, checkColumn)) then
              grid.setBonusNbBombs(checkLine, checkColumn, false)
            elseif (grid.isBonusHp(checkLine, checkColumn)) then
              grid.setBonusHp(checkLine, checkColumn, false)
            end
          end
        end
      end
    end
  end
end

function class.update(dt)
  if (gameState.getState() == "gameSolo") or (gameState.getState() == "gameDuo") then
    checkColPlayerCell(dt)
    checkColPlayerBombs(dt)
    checkColPlayerPowerUps()
    checkColPlayerExplosions()
    checkColExplosionsBombs()
    checkColExplosionsPowerUps()
    if (gameState.getState() == "gameDuo") then
      checkColPlayer2Cell(dt)
      checkColPlayer2Bombs(dt)
      checkColPlayer2PowerUps()
      checkColPlayer2Explosions()
    elseif (gameState.getState() == "gameSolo") then
      checkColPlayerKey()
    end
  end
end

local function pointRect(x, y, a)
  return (x > a.x) and (x < a.x + a.w) and (y < a.y + a.h) and (y > a.y)
end

local function loadGameSolo()
  grid.load()
  box.load()
  player.load()
  bomb.load()
  powerUp.load()
  exit.load()
  explosion.load()
  hud.load()
  pause.load()
  gameWin.load()
  gameOver.load()
  
  sound.getBackground():play()
  sound.getBackground():setVolume(0.6)
  sound.getMenu():stop()
end

local function loadGameDuo()
  grid.load()
  box.load()
  player.load()
  player2.load()
  bomb.load()
  bomb2.load()
  powerUp.load()
  explosion.load()
  hud.load()
  pause.load()
  gameWin.load()
  gameOver.load()
  
  sound.getBackground():play()
  sound.getBackground():setVolume(0.6)
  sound.getMenu():stop()
end

local function checkColMenu(x, y, button)
  if (button == 1) then
    local solo = menu.getSoloHitbox()
    local duo  = menu.getDuoHitbox()
    local quit = menu.getQuitHitbox()

    if (pointRect(x, y, solo)) then
      gameState.setState("gameSolo")
      loadGameSolo()
    elseif (pointRect(x, y, duo)) then
      gameState.setState("gameDuo")
      loadGameDuo()
    elseif (pointRect(x, y, quit)) then
      love.event.quit()
    end
  end
end

local function checkColPause(x, y, button)
  if (button == 1) then
    local continue = pause.getContinueHitbox()
    local menu     = pause.getMenuHitbox()
    local quit     = pause.getQuitHitbox()

    if (pointRect(x, y, continue)) then
      if (gameState.getState() == "pauseSolo") then
        gameState.setState("gameSolo")
      elseif (gameState.getState() == "pauseDuo") then
        gameState.setState("gameDuo")
      end
      sound.getBackground():setVolume(0.6)
    elseif (pointRect(x, y, menu)) then
      gameState.setState("menu")
      sound.getMenu():play()
      sound.getBackground():stop()
    elseif (pointRect(x, y, quit)) then
      love.event.quit()
    end
  end
end

local function checkColGameWin(x, y, button)
  if (button == 1) then
    local playAgain = gameWin.getPlayAgainHitbox()
    local menu      = gameWin.getMenuHitbox()

    if (pointRect(x, y, playAgain)) then
      if (gameState.getState() == "gameWin") then
        gameState.setState("gameSolo")
        loadGameSolo()
        sound.getWin():stop()
      elseif (gameState.getState() == "playerWin") or (gameState.getState() == "player2Win") then
        gameState.setState("gameDuo")
        loadGameDuo()
        sound.getWin():stop()
      end
    elseif (pointRect(x, y, menu)) then
      gameState.setState("menu")
      sound.getMenu():play()
      sound.getWin():stop()
    end
  end
end

local function checkColGameOver(x, y, button)
  if (button == 1) then
    local retry = gameOver.getRetryHitbox()
    local menu  = gameOver.getMenuHitbox()

    if (pointRect(x, y, retry)) then
      gameState.setState("gameSolo")
      loadGameSolo()
    elseif (pointRect(x, y, menu)) then
      gameState.setState("menu")
      sound.getMenu():play()
      sound.getLose():stop()
    end
  end
end

function class.mousepressed(x, y, button)
  if (gameState.getState() == "menu") then
    checkColMenu(x, y, button)
  elseif (gameState.getState() == "pauseSolo") or (gameState.getState() == "pauseDuo") then
    checkColPause(x, y, button)
  elseif (gameState.getState() == "gameWin") or (gameState.getState() == "playerWin") or (gameState.getState() == "player2Win") then
    checkColGameWin(x, y, button)
  elseif (gameState.getState() == "gameOver") then
    checkColGameOver(x, y, button)
  end
end

return class