Particle = {}
Particle.__index = Particle

function Particle:create(locationStart, locationEnd)
    local particle = {}
    setmetatable(particle, Particle)
    particle.locationStart = locationStart
    particle.locationEnd = locationEnd
    particle.acceleration = Vector:create(0, 0.05)
    particle.velocity = Vector:create(math.random(-200, 200) / 100,
                                      math.random(-1, 0))
    particle.lifespan = 200
    particle.decay = math.random(3, 8) / 10
    return particle
end

function Particle:applyForce(force)
    if not self:isDead() == true then self.acceleration:add(force) end
end

function Particle:update()
    if not self:isDead() == true then
        self.velocity:add(self.acceleration)
        self.locationStart:add(self.velocity)
        self.locationEnd:add(self.velocity)
        self.lifespan = self.lifespan - self.decay
    end

end

function Particle:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(128, 128, 128)
    love.graphics.line(self.locationStart.x, self.locationStart.y,
                       self.locationEnd.x, self.locationEnd.y)
    love.graphics.setColor(r, g, b, a)
end

function Particle:isDead() return self.lifespan < 0 end
