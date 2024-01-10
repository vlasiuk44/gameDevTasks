Vector = {}
Vector.__index = Vector

function Vector:create(x, y)
    local vector = {}
    setmetatable(vector, Vector)
    vector.x = x
    vector.y = y
    return vector
end

function Vector:random(minx, maxx, miny, maxy)
    x = love.math.random(minx, maxx)
    y = love.math.random(miny, maxy)
    return Vector:create(x, y)
end

function Vector:__tostring()
    return "Vector(x = " .. self.x .. ", y = " .. self.y .. ")"
end

function Vector:__add(other) -- сумма векторов
    return Vector:create(self.x + other.x, self.y + other.y)
end

function Vector:__sub(other) -- разность векторов
    return Vector:create(self.x - other.x, self.y - other.y)
end

function Vector:__mul(value) -- умножение вектора
    return Vector:create(self.x * value, self.y * value)
end

function Vector:__div(value) -- деление вектора
    return Vector:create(self.x / value, self.y / value)
end

function Vector:mag() -- длина вектора
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:norm() -- нормализация вектра(уменьшение длинны до 1 с сохранением направления)
    m = self:mag()
    if m > 0 then return self / m end
end

function Vector:limit(max)
    if self:mag() > max then
        norm = self:norm()
        return norm * max
    end
    return self
end

function Vector:add(other)
    self.x = self.x + other.x
    self.y = self.y + other.y
end

function Vector:sub(other)
    self.x = self.x - other.x
    self.y = self.y - other.y
end

function Vector:mul(value)
    self.x = self.x * value
    self.y = self.y * value
end

function Vector:div(value)
    self.x = self.x / value
    self.y = self.y / value
end
