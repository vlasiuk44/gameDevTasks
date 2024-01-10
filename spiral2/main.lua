require("vector")
require("vehicle")
require("flow")

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    vehicle = Vehicle:create(width / 2, height / 2)
    map = FlowMap:create(30)
    map:spiral()
end

function love.update(dt)
    local x, y = love.mouse.getPosition()
    vehicle:follow(map)
    vehicle:borders()
    vehicle:update()

end

function love.draw()
    map:draw()
    vehicle:draw()

end
