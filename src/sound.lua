local class = {}
local data  = {}

function class.getMenu()
  return data.menu
end

function class.getBackground()
  return data.background
end

function class.getCollision()
  return data.collision
end

function class.getBomb()
  data.bombClone = data.bomb:clone()
  return data.bombClone
end

function class.getExplosion()
  data.explosionClone = data.explosion:clone()
  return data.explosionClone
end

function class.getHit()
  return data.hit
end

function class.getPowerUp()
  return data.powerUp
end

function class.getKey()
  return data.key
end

function class.getWin()
  return data.win
end

function class.getLose()
  return data.lose
end

local function initMenu()
  data.menu = love.audio.newSource("Assets/Sounds/Menu.mp3", "static")
  data.menu:setVolume(0.5)
end

local function initBackground()
  data.background = love.audio.newSource("Assets/Sounds/Background.mp3", "static")
end

local function initCollision()
  data.collision = love.audio.newSource("Assets/Sounds/Collision.wav", "static")
  data.collision:setVolume(0.2)
end

local function initBomb()
  data.bomb = love.audio.newSource("Assets/Sounds/Bomb.mp3", "static")
  data.bomb:setVolume(1)
end

local function initExplosion()
  data.explosion = love.audio.newSource("Assets/Sounds/Explosion.mp3", "static")
  data.explosion:setVolume(0.5)
end

local function initHit()
  data.hit = love.audio.newSource("Assets/Sounds/Hit.wav", "static")
  data.hit:setVolume(1)
end

local function initPowerUp()
  data.powerUp = love.audio.newSource("Assets/Sounds/PowerUp.wav", "static")
  data.powerUp:setVolume(1)
end

local function initKey()
  data.key = love.audio.newSource("Assets/Sounds/Key.wav", "static")
  data.key:setVolume(1)
end

local function initWin()
  data.win = love.audio.newSource("Assets/Sounds/Win.mp3", "static")
  data.win:setVolume(0.4)
end

local function initLose()
  data.lose = love.audio.newSource("Assets/Sounds/Lose.mp3", "static")
  data.lose:setVolume(0.8)
end

function class.load()
  initMenu()
  initBackground()
  initCollision()
  initBomb()
  initExplosion()
  initHit()
  initPowerUp()
  initKey()
  initWin()
  initLose()
end

return class