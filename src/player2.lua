local grid      = require("grid")
local animation = require("animation")
local bomb2     = require("bomb2")
local gameState = require("gameState")
local sound     = require("sound")

local class = {}
local data  = {}

function class.getHitbox()
  local hitbox = {}

  hitbox.x     = data.x + 5
  hitbox.y     = data.y + 40
  hitbox.h     = data.h - 40
  hitbox.w     = data.w - 10
  hitbox.speed = data.speed

  return hitbox
end

function class.getHitbox2()
  local hitbox = {}

  hitbox.x = data.x + 8
  hitbox.y = data.y + 14
  hitbox.h = data.h - 16
  hitbox.w = data.w - 20

  return hitbox
end

function class.getPlayer()
  local player = {}

  player.x     = data.x
  player.y     = data.y
  player.h     = data.h
  player.w     = data.w
  player.speed = data.speed

  return player
end

function class.getLine()
  return data.line
end

function class.getColumn()
  return data.column
end

function class.setX(value)
  data.x = value-5
end

function class.setY(value)
  data.y = value-40
end

function class.setSpeed(value)
  data.speed = value
end

function class.getSpeed()
  return data.speed
end

function class.setHp(value)
  data.hp = value
end

function class.getHp()
  return data.hp
end

function class.setAlive(value)
  data.alive = value
end

function class.isAlive()
  return data.alive
end

local function initPlayer()
  data.sprite = love.graphics.newImage("Assets/Images/Player2.png")
  data.w      = 40
  data.h      = 62
  data.x      = grid.getX(12)+10
  data.y      = grid.getY(10)-20
  data.speed  = 150
  data.hp     = 1
  data.alive  = true
  data.state  = true

  data.timerAlive    = 0
  data.timerAliveMax = 2.5
  data.timerState    = 0
  data.timerStateMax = 0.1

  data.animations = {}
  data.animations.down  = animation.new(data.sprite, 4, 5, 0, 0, data.w, data.h)
  data.animations.up    = animation.new(data.sprite, 4, 5, 0, 62, data.w, data.h)
  data.animations.left  = animation.new(data.sprite, 4, 5, 0, 124, data.w, data.h)
  data.animations.right = animation.new(data.sprite, 4, 5, 0, 186, data.w, data.h)

  data.currentAnimation = data.animations.down
end

function class.load()
  initPlayer()
end

local function movePlayer(dt)
  local hitbox = class.getHitbox()

  data.line      = grid.getLine(hitbox.y-hitbox.h + grid.getOffsetY())
  data.column    = grid.getColumn(hitbox.x-hitbox.w/4 + grid.getOffsetX())
  data.isWalking = false

  if (love.keyboard.isDown("up")) then
    data.y = data.y - data.speed * dt
    data.currentAnimation = data.animations.up
    data.isWalking = true
  end

  if (love.keyboard.isDown("down")) then
    data.y = data.y + data.speed * dt
    data.currentAnimation = data.animations.down
    data.isWalking = true
  end

  if (love.keyboard.isDown("left")) then
    data.x = data.x - data.speed * dt
    data.currentAnimation = data.animations.left
    data.isWalking = true
  end

  if (love.keyboard.isDown("right")) then
    data.x = data.x + data.speed * dt
    data.currentAnimation = data.animations.right
    data.isWalking = true
  end

  if (data.isWalking) then
    animation.update(data.currentAnimation, dt)
  else
    data.currentAnimation.currentFrame = 1
  end
end

local function respawn(dt)
  if (not data.alive) then
    data.timerAlive = data.timerAlive + dt
    if (not data.state) then
      data.timerState = data.timerState + dt
      if (data.timerState > data.timerStateMax) then
        data.state = true
        data.timerState = 0
      end
    elseif (data.state) then
      data.timerState = data.timerState + dt
      if (data.timerState > data.timerStateMax) then
        data.state = false
        data.timerState = 0
      end
    end
    if (data.timerAlive > data.timerAliveMax) then
      data.alive = true
      data.timerAlive = 0
    end
  end
end

local function checkLose()
  if (data.hp == 0) then
    gameState.setState("playerWin")
    sound.getWin():play()
    sound.getBackground():stop()
  end
end

function class.update(dt)
  movePlayer(dt)
  respawn(dt)
  checkLose()
end

function class.draw()
  if (data.alive) or (data.state) then
    love.graphics.setColor(1, 1, 1)
    animation.draw(data.currentAnimation, data.x, data.y, 0, 0)
  end
end

function class.keypressed(key)
  if (key == "return") and (bomb2.getNbBombs() < bomb2.getNbBombsMax()) and (not grid.isBomb(data.line, data.column)) and (data.alive) then
    bomb2.initBomb(data.line, data.column)
    grid.setBomb(data.line, data.column, true)
    sound.getBomb():play()
  end
end

return class