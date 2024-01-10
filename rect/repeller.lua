Repeller = {}
Repeller.__index = Repeller

function Repeller:create(x, y)
    local repeller = {}
    setmetatable(repeller, Repeller)
    repeller.location = Vector:create(x, y)
    repeller.r = 50
    repeller.strength = 15
    return repeller
end

function Repeller:repel(particle)
    local dir = self.location - particle.locationStart
    local d = dir:mag()
    if d <= self.r then d = 1 end
    local dir = dir:norm()
    local force = -1 * self.strength / (d * d)
    dir:mul(force)
    return dir
end
