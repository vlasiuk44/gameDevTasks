Mover = {}

function Mover:create(location, velocity, width, height, weight)
    local mover = {
        location = location,
        velocity = velocity,
        acceleration = Vector:create(0, 0),
        width = width or 10,
        height = height or 10,
        weight = weight or 1
    }
    setmetatable(mover, self)
    self.__index = self
    return mover
end

function Mover:draw()
    love.graphics.rectangle("fill", self.location.x, self.location.y, self.width, self.height)
end

function Mover:applyForce(force)
    self.acceleration:add(force * self.weight)
end

function Mover:update()
    self.velocity:add(self.acceleration)
    self.location:add(self.velocity)
    self.acceleration:mul(0)
    self:checkBoundaries()
end

function Mover:checkBoundaries()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    if self.location.x > width - self.width or self.location.x < 0 then
        self.velocity.x = -1 * self.velocity.x
        self.location.x = math.max(0, math.min(self.location.x, width - self.width))
    end

    if self.location.y > height - self.height or self.location.y < 0 then
        self.velocity.y = -1 * self.velocity.y
        self.location.y = math.max(0, math.min(self.location.y, height - self.height))
    end
end
