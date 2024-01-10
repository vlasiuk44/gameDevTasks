Wave = {}
Wave.__index = Wave

function Wave.new(amplitude, frequency, direction)
    local self = setmetatable({}, Wave)
    self.amplitude = amplitude
    self.frequency = frequency
    self.angle = 0
    self.vel = 0.005
    self.direction = direction
    return self
end

function Wave:update() self.angle = self.angle + self.vel * self.direction end

function Wave:draw()
    for x = 0, width, 8 do
        local y = self.amplitude *
                      math.sin((self.angle + x / 240) * self.frequency)
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("line", x, y + height / 2, 10)
        love.graphics.setColor((width / 2) / x, 0, x / (width / 2), 0.5)
        love.graphics.circle("fill", x, y + height / 2, 10)
    end
end

return Wave
