Animation = {}
Animation.__index = Animation

function Animation:create(params)
    local this = {
        texture = params.texture,
        frames = params.frames or {},
        interval = params.interval or 0.05,
        timer = 0,
        currentFrame = 1
    }

    setmetatable(this, self)
    return this
end

function Animation:getCurrentFrame() return self.frames[self.currentFrame] end

function Animation:restart()
    self.timer = 0
    self.currentFrame = 1
end

function Animation:update(dt)
    self.timer = self.timer + dt
    while self.timer > self.interval do
        self.timer = self.timer - self.interval
        self.currentFrame = (self.currentFrame + 1) % #self.frames
        if self.currentFrame == 0 then self.currentFrame = 1 end
    end
end
