require 'Util'
Map = {}
Map.__index = Map

TILE_BRICK = 1
TILE_ENEMY = 6
TILE_EMPTY = 29
TILE_QUESTION = 25
TILE_QUESTION_DARK = 27
PIPE_TOP_LEFT = 265
PIPE_TOP_RIGHT = 266
PIPE_BOTTOM_LEFT = 298
PIPE_BOTTOM_RIGHT = 299
CLOUD_TOP_LEFT = 661
CLOUD_TOP_MIDDLE = 662
CLOUD_TOP_RIGHT = 663
CLOUD_BOTTOM_LEFT = 694
CLOUD_BOTTOM_MIDDLE = 695
CLOUD_BOTTOM_RIGHT = 696
BUSH_LEFT = 309
BUSH_MIDDLE = 310
BUSH_RIGHT = 311

local scrollSpeed = 124

function Map:create()

    local this = {
        spritesheet = love.graphics.newImage('graphics/tiles.png'),
        tileWidth = 16,
        tileHeight = 16,
        mapWidth = 1000,
        mapHeight = 28,
        tiles = {},
        gravity = 40,

        camX = 0,
        camY = -3
    }
    this.enemySpeed = 50
    this.enemies = {}

    this.player = Player:create(this)
    this.tileSprites = generateQuads(this.spritesheet, 16, 16)
    this.mapWidthPixels = this.mapWidth * this.tileWidth
    this.mapHeightPixels = this.mapHeight * this.tileHeight
    this.spriteBatch = love.graphics.newSpriteBatch(this.spritesheet,
                                                    this.mapWidth *
                                                        this.mapHeight)
    setmetatable(this, self)

    for y = 1, this.mapHeight do
        for x = 1, this.mapWidth do this:setTile(x, y, TILE_EMPTY) end
    end

    local x = 1
    while x < this.mapWidth do

        if x < this.mapWidth - 3 then
            if math.random(20) == 1 then
                local cloudStart = math.random(this.mapHeight / 2 - 6)

                this:setTile(x, cloudStart, CLOUD_TOP_LEFT)
                this:setTile(x, cloudStart + 1, CLOUD_BOTTOM_LEFT)
                this:setTile(x + 1, cloudStart, CLOUD_TOP_MIDDLE)
                this:setTile(x + 1, cloudStart + 1, CLOUD_BOTTOM_MIDDLE)
                this:setTile(x + 2, cloudStart, CLOUD_TOP_RIGHT)
                this:setTile(x + 2, cloudStart + 1, CLOUD_BOTTOM_RIGHT)
            end
        end

        if math.random(20) == 1 then
            this:setTile(x, this.mapHeight / 2 - 2, PIPE_TOP_LEFT)
            this:setTile(x, this.mapHeight / 2 - 1, PIPE_BOTTOM_LEFT)

            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end

            x = x + 1
            this:setTile(x, this.mapHeight / 2 - 2, PIPE_TOP_RIGHT)
            this:setTile(x, this.mapHeight / 2 - 1, PIPE_BOTTOM_RIGHT)

            local enemy = {
                x = (x + 1) * this.tileWidth,
                y = (this.mapHeight / 2 - 2) * this.tileHeight,
                width = this.tileWidth,
                height = this.tileHeight,
                direction = 1
            }
            table.insert(this.enemies, enemy)

            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end

            x = x + 1

        elseif math.random(10) == 1 and x < this.mapWidth - 3 then
            local bushLevel = this.mapHeight / 2 - 1

            this:setTile(x, bushLevel, BUSH_LEFT)
            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end
            x = x + 1

            this:setTile(x, bushLevel, BUSH_MIDDLE)
            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end
            x = x + 1

            this:setTile(x, bushLevel, BUSH_RIGHT)
            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end
            x = x + 1

        elseif math.random(10) ~= 1 then
            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end

            if math.random(15) == 1 then
                this:setTile(x, this.mapHeight / 2 - 4, TILE_QUESTION)
            end

            x = x + 1
        else
            x = x + 2
        end
    end
    this:refreshSpriteBatch()

    return this
end

function Map:collides(tile)
    local collidables = {
        TILE_BRICK, TILE_QUESTION, TILE_QUESTION_DARK, PIPE_TOP_LEFT,
        PIPE_BOTTOM_LEFT, PIPE_TOP_RIGHT, PIPE_BOTTOM_RIGHT, TILE_ENEMY
    }

    for _, v in ipairs(collidables) do if tile == v then return true end end

    return false
end

function Map:refreshSpriteBatch()
    self.spriteBatch = love.graphics.newSpriteBatch(self.spritesheet,
                                                    self.mapWidth *
                                                        self.mapHeight)
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            self.spriteBatch:add(self.tileSprites[self:getTile(x, y)],
                                 (x - 1) * self.tileWidth,
                                 (y - 1) * self.tileHeight)
        end
    end
end

function Map:update(dt)
    self.player:update(dt)
    self.camX = math.max(0, math.min(self.player.x - virtualWidth / 2, math.min(
                                         self.mapWidthPixels - virtualWidth,
                                         self.player.x)))

    for _, enemy in ipairs(self.enemies) do
        enemy.x = enemy.x + self.enemySpeed * enemy.direction * dt

        if self:checkCollision(self.player, enemy) then

            if self.player.dy > 0 then
                table.remove(self.enemies, _)

            else

                love.event.quit()
            end
        end

        local tileLeft = math.floor(enemy.x / self.tileWidth) + 1
        local tileRight = math.floor((enemy.x + enemy.width) / self.tileWidth) +
                              1

        if self:collides(self:getTile(tileLeft,
                                      math.floor(enemy.y / self.tileHeight) + 1)) or
            self:collides(
                self:getTile(tileRight,
                             math.floor(enemy.y / self.tileHeight) + 1)) then
            enemy.direction = -enemy.direction
        end

        if enemy.x < 0 or enemy.x + enemy.width > self.mapWidthPixels then
            enemy.direction = -enemy.direction
        end
    end

    if self.player.y > self.mapHeightPixels then love.event.quit() end
end

function Map:checkCollision(a, b)
    return
        a.x < b.x + b.width and a.x + a.width > b.x and a.y < b.y + b.height and
            a.y + a.height > b.y
end

function Map:tileAt(x, y)
    return self:getTile(math.floor(x / self.tileWidth) + 1,
                        math.floor(y / self.tileHeight) + 1)
end

function Map:getTile(x, y) return self.tiles[(y - 1) * self.mapWidth + x] end

function Map:setTile(x, y, tile) self.tiles[(y - 1) * self.mapWidth + x] = tile end

function Map:render()
    love.graphics.draw(self.spriteBatch)
    self.player:render()

    local prevColor = {love.graphics.getColor()}

    love.graphics.setColor(255, 0, 0)
    local enemy = self:getEnemy()
    for _, enemy in ipairs(self.enemies) do
        love.graphics.rectangle('fill', enemy.x, enemy.y, enemy.width,
                                enemy.height)

    end
    love.graphics.setColor(prevColor)

end

function Map:getEnemy()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if self:getTile(x, y) == TILE_ENEMY then
                return {
                    x = (x - 1) * self.tileWidth,
                    y = (y - 1) * self.tileHeight,
                    width = self.tileWidth,
                    height = self.tileHeight
                }
            end
        end
    end
    return nil
end
