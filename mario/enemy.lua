Enemy = {}
Enemy.__index = Enemy

local WALKING_SPEED = 140

function Enemy:create(map)
    local this = {
        x = 0,
        y = 0,
        width = 16,
        height = 32,

        xOffset = 8,
        yOffset = 16,

        map = map,
        texture = love.graphics.newImage('graphics/mario1.png'),
        currentFrame = nil,
        animation = nil,
        state = 'idle',
        direction = 'right',
        dx = 0,
        dy = 0
    }

    this.y = map.tileHeight * ((map.mapHeight - 2) / 2) - this.height
    this.x = map.tileWidth * 10 * 2

    setmetatable(this, self)
    return this
end

function Enemy:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Enemy:checkLeftCollision()
    if self.dx < 0 then
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(
                self.map:tileAt(self.x - 1, self.y + self.height - 1)) then
            self.dx = 0
            local xmod = (self.x - 1) % self.map.tileWidth
            local offset = self.map.tileWidth - xmod
            self.x = math.floor(self.x - 1 + offset)
        end
    end
end

function Enemy:checkRightCollision()
    if self.dx > 0 then
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(
                self.map:tileAt(self.x + self.width, self.y + self.height - 1)) then
            self.dx = 0
            self.x = math.floor(self.x - (self.x % self.map.tileWidth))
        end
    end
end

function Enemy:render()
    local scaleX

    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end

    love.graphics.draw(self.texture[0], math.floor(self.x),
                       math.floor(self.y + self.yOffset), 0, scaleX, 1,
                       self.xOffset, self.yOffset)
end
