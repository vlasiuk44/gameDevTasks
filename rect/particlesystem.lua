ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:create(cls)
    local system = {}
    setmetatable(system, ParticleSystem)
    system.cls = cls or Particle
    system.particles = {}
    system.index = 0
    return system
end

function ParticleSystem:addParticle(locationStart, locationEnd) 
    self.particles[self.index] = self.cls:create(locationStart, locationEnd)
    self.index = self.index + 1
end

function ParticleSystem:applyReppeler()
    for k, v in pairs(self.particles) do
        local force = repeller:repel(v)
        v:applyForce(force)
    end

end

function ParticleSystem:update(repeller)
    for k,v in pairs(self.particles) do
        v:update()
    end
    self:applyReppeler(repeller)
end

function ParticleSystem:applyForce(force)
    for k, v in pairs(self.particles) do
        v:applyForce(force)
    end
end

function ParticleSystem:draw()
    for k, v in pairs(self.particles) do
        v:draw()
    end
end