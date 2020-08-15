local state = {}

function state:init()
    love.audio.play(game.sfx.ambience[1]) -- lords_prayer

    self.timer = 0
    self.speed = 1
    self.timerForTheTimer = 0
    self.state = 0
end

function state:update(dt)
    if self.state == 0 then
        self.timer = self.timer + self.speed
    elseif self.state == 1 then
        self.timer = self.timer - self.speed
        if self.timer == 0 then
            self.state = 3
        end
    elseif self.state == 3 then
        game:switchState('game')
    end

    if self.timer > 100 then
        if self.state == 0 then
            self.state = 2
        end
    end

    if self.state == 2 then
        self.timerForTheTimer = self.timerForTheTimer + 1
        if self.timerForTheTimer == 200 then
            self.state = 1
        end
    end
end

function state:draw()
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle('fill', 0, 0, 800, 600)
    love.graphics.setColor(1, 1, 1, self.timer / 100)

    game:printCenter(game.font.std, 'Nothing great was ever accomplished', 250)
    game:printCenter(game.font.std, 'without making sacrifices.', 275)
end

return state