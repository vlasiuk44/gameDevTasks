love.keyboard.keysPressed = {}
love.keyboard.keysReleased = {}

push = require 'push'

require 'Map'
require 'Player'
require 'enemy'

virtualWidth = 432
virtualHeight = 243

windowWidth = 1280
windowHeight = 720

math.randomseed(os.time())

map = Map:create()

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight,
                     {fullscreen = false, resizable = true})
end

function love.resize(w, h) push:resize(w, h) end

function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

function love.keypressed(key)
    if key == 'escape' then love.event.quit() end

    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key) love.keyboard.keysReleased[key] = true end

function love.update(dt)
    map:update(dt)

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end

function love.draw()
    push:apply('start')

    love.graphics.clear(108, 140, 255, 255)

    love.graphics.translate(math.floor(-map.camX), math.floor(-map.camY))
    map:render()

    push:apply('end')
end
