Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle:create(location, width, height)
    local rectangle = {}
    setmetatable(rectangle, Rectangle)

    rectangle.location = location

    rectangle.width = width
    rectangle.height = height

    repeller = Repeller:create(width / 2 + 100, height / 2 + 150)
    return rectangle
end

function Rectangle:draw()
    love.graphics.rectangle('line', self.location.x, self.location.y,
                            self.width, self.height)
end

function Rectangle:onClick(ps, x, y)
    if x >= self.location.x and x <= self.location.x + self.width and y >=
        self.location.y and y <= self.location.y + self.height then
        local topLeft = self.location:copy()
        local topRight = Vector:create(self.location.x + self.width,
                                       self.location.y)
        local bottomLeft = Vector:create(self.location.x,
                                         self.location.y + self.height)
        local bottomRight = Vector:create(self.location.x + self.width,
                                          self.location.y + self.height)

        ps:addParticle(topLeft:copy(), topRight:copy())
        ps:addParticle(topRight:copy(), bottomRight:copy())
        ps:addParticle(bottomRight:copy(), bottomLeft:copy())
        ps:addParticle(bottomLeft:copy(), topLeft:copy())
        return true
    end
    return false
end
