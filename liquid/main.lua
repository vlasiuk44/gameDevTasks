-- main.lua
require "vector"
require "mover"
require "liquid"

movers = {}

function love.load()
    love.window.setTitle("Acceleration")
    width, height = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.setBackgroundColor(128 / 255, 128 / 255, 128 / 255)

    table.insert(movers,
                 Mover:create(Vector:create(width / 3, height / 4),
                              Vector:create(0, 0), 100, 30, 2))
    table.insert(movers,
                 Mover:create(Vector:create(2 * width / 3, height / 4),
                              Vector:create(0, 0), 40, 40, 2))

    water = Liquid:create(0, height / 2, 800, 300, 0.05)
    gravity = Vector:create(0, 0.1)
end

function love.update(dt)
    for _, mover in ipairs(movers) do
        mover:applyForce(gravity)

        local friction = (mover.velocity * -1):norm()
        if friction then
            friction:mul(0.03)
            mover:applyForce(friction)
        end

        if water:isInside(mover) then
            local pixel_to_reality_coef = 10000000
            local V = mover.width * mover.height *
                          (water.y + water.h - mover.location.y) /
                          pixel_to_reality_coef
            local Fa = 9.81 * V + 1.0
            local mag = mover.velocity:mag()
            local drag = water.c * mag * mag * Fa
            local dragVec = (mover.velocity * -1):norm()
            dragVec:mul(drag)
            mover:applyForce(dragVec)
        end

        mover:checkBoundaries()
        mover:update()
    end
end

function love.draw()
    for _, mover in ipairs(movers) do mover:draw() end
    water:draw()
end
