FlowMap = {}
FlowMap.__index = FlowMap

function FlowMap:create(n)
    local flow = {}
    setmetatable(flow, FlowMap)
    flow.field = {}
    love.math.setRandomSeed(10000)
    flow.n = n
    flow.width = width / flow.n
    flow.height = height / flow.n
    return flow
end


function FlowMap:init()
    local xoff = math.random(1, 100) / 100
    local yoff = math.random(1, 100) / 100
    for y=1, self.n do
        self.field[y] = {}
        for x=1, self.n do
            local theta = math.map(love.math.noise(xoff, yoff), 0, 1, 0, math.pi*2)
            self.field[y][x] = Vector:create(math.cos(theta), math.sin(theta))
            yoff = yoff + 0.1
        end
        xoff = xoff + 0.1
    end
end

function FlowMap:spiral()
    local xoff = width / 2
    local yoff = height / 2
    local deg = 45
    for y=1, self.n do
        self.field[y] = {}
        for x=1, self.n do
            local xc = self.width * (x - 1) + self.width / 2
            local yc = self.width * (y - 1) + self.height / 2
            local vec = Vector:create(xc - xoff, yc - yoff)
            vec:norm()
            local theta = math.map(love.math.noise(xoff, yoff), 10, 1, 0, math.pi*2)
            self.field[y][x] = Vector:create(vec.x * math.cos(deg+theta) - vec.y*math.sin(deg+theta),
                                            vec.y * math.cos(deg+theta) + vec.x*math.sin(deg+theta))

            yoff = yoff + 0.1
        end
        xoff = xoff + 0.1
    end
end

function FlowMap:draw()  
    for y=1, self.n do
        for x=1, self.n do
            love.graphics.push()
            local xc = self.width * (x - 1) + self.width / 2
            local yc = self.width * (y - 1) + self.height / 2
            love.graphics.translate(xc, yc)
            local v = self.field[y][x]
            love.graphics.rotate(v:heading())
            local len = v:mag() * 100
            love.graphics.line(0, 0, len, 0)
            love.graphics.circle("fill", 0, 0, 5)
            love.graphics.pop()
        end
    end
end

function FlowMap:lookup(x, y)
    local col = math.floor(math.map(x, 0, width, 1, self.n)+0.5)
    local row = math.floor(math.map(y, 0, height, 1, self.n)+0.5)
    return self.field[col][row]:copy()
end