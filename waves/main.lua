local Wave = require "Wave"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    wave1 = Wave.new(40, 10, 1)
    wave2 = Wave.new(20, 4, -1)
end

function love.update()
    wave1:update()
    wave2:update()
end

function love.draw()
    wave1:draw()
    wave2:draw()
end
