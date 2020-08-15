local state = {}

function state:init()
    self.timer = 0
    self.speed = 1
    self.state = 0

    local messages = {
        'Everybody will die at some point.',
        'There is no change without sacrifice.',
        'Every sacrifice has a reward.',
        'For those I love, I will sacrifice.',
        'Sometimes in life, you have to make a decision and make sacrifices.'
    }

    self.message = messages[math.random(1, #messages)]
end

function state:update(dt)
    if self.state == 0 then
        self.timer = self.timer + self.speed
    elseif self.state == 1 then
        self.timer = self.timer - self.speed
        if self.timer == 0 then
            self.state = 2
        end
    elseif self.state == 2 then
        game:switchState('intro')
    end

    if self.timer > 100 then
        if self.state == 0 then
            -- set non existent state
            self.state = 99
        end
    end
end

function state:draw()
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle('fill', 0, 0, 800, 600)
    love.graphics.setColor(1, 1, 1, self.timer / 100)

    game:printCenter(game.font.title, 'Sacrifice', 100)
    game:printCenter(game.font.std, self.message, 200)
    game:printCenter(game.font.std, 'Press [W] to start', 400)

    love.graphics.setColor(0.2, 0.2, 0.2, self.timer / 100)
    game:printCenter(game.font.std, 'SFX and music from DEFCON.', 545)
    game:printCenter(game.font.std, 'Brought to you by LewisTehMinerz.', 570)
end

function state:keyDown(k)
    if k == 'w' then
        self.state = 1
    end
end

return state