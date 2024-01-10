require('vector')
require('particle')
require('particlesystem')
require('repeller')
require('rectangle')

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    rectangles = {}

    ps = ParticleSystem:create(Particle)

    rectangles[1] = Rectangle:create(Vector:create(200, 100), 100, 25)
    rectangles[2] = Rectangle:create(Vector:create(350, 150), 50, 75)
    rectangles[3] = Rectangle:create(Vector:create(450, 300), 75, 100)
    rectangles[4] = Rectangle:create(Vector:create(500, 75), 50, 125)
    rectangles[5] = Rectangle:create(Vector:create(600, 150), 150, 50)
end

function love.update() ps:update(repeller) end

function love.draw()
    ps:draw()
    for v, r in pairs(rectangles) do r:draw() end
end

function love.mousepressed(x, y, button, istouch, presses)
    for k, r in pairs(rectangles) do
        if r:onClick(ps, x, y) then table.remove(rectangles, k) end
    end
end
