Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:create(x, y)
    local vehicle = {}
    setmetatable(vehicle, Vehicle)
    vehicle.acceleration = Vector:create(0, 0)
    vehicle.velocity = Vector:create(0, 0)
    vehicle.location = Vector:create(x, y)
    vehicle.r = 5
    vehicle.vertices = {
        0, -vehicle.r * 2, -vehicle.r, vehicle.r * 2, vehicle.r, 2 * vehicle.r
    }
    vehicle.maxSpeed = 60
    vehicle.maxForce = 0.1
    vehicle.wtheta = 0
    return vehicle
end

function Vehicle:update()
    self.velocity:add(self.acceleration)
    self.velocity:limit(self.maxSpeed)
    self.location:add(self.velocity)
    self.acceleration:mul(0)
end

function Vehicle:applyForce(force) self.acceleration:add(force) end

function Vehicle:follow(flow)
    local desired = flow:lookup(self.location.x, self.location.y)
    desired:mul(self.maxSpeed)
    local steer = desired - self.velocity
    steer:limit(self.maxForce)
    self:applyForce(steer)
end

function Vehicle:borders()
    if self.location.x < 0 then self.location.x = width end
    if self.location.y < 0 then self.location.y = height end
    if self.location.x > width then self.location.x = 0 end
    if self.location.y > height then self.location.y = 0 end
end

function Vehicle:draw()
    local theta = self.velocity:heading() + math.pi / 2

    -- Сохраняем текущий цвет
    local prevColor = {love.graphics.getColor()}

    -- Устанавливаем новый цвет (красный)
    love.graphics.setColor(255, 0, 0)

    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)
    love.graphics.rotate(theta)
    love.graphics.polygon("fill", self.vertices)
    love.graphics.pop()

    -- Восстанавливаем предыдущий цвет
    love.graphics.setColor(prevColor)
end
