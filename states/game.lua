
local state = {}

function state:init()
    self.secondTimer = 0

    self.timer = 0
    self.state = 0
    self.speed = 1

    self.population = {}
    self.food = 20
    self.water = 20
    self.housing = 20
    self.sacrifices = 0
    self.suffering = 0

    self.cooldown = 0
    self.day = 1
    self.simSpeed = 1

    self.townName = game:genTownName()
    self.news = { 'The town of ' .. self.townName .. ' has been created.', '', '', '', '', '', '', '', '', '' }

    for i = 1, 100, 1 do
        table.insert(self.population, game:genHumanName())
    end
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
        game:switchState('fin')
    end

    if self.timer > 100 then
        if self.state == 0 then
            -- set non existent state
            self.state = 99
        end
    end

    self.secondTimer = self.secondTimer + dt
    if self.secondTimer >= (1 / self.simSpeed) then
        self:secondUpdate()
        self.secondTimer = 0
    end
end

function state:addNews(news)
    table.remove(self.news)
    table.insert(self.news, 1, news)
end

function state:born()
    local name = game:genHumanName()
    table.insert(self.population, name)
    self:modSuffering(-1)
    state:addNews(name .. ' has been born.')
end

function state:kill(reason)
    local name = table.remove(self.population, math.random(1, #self.population))
    self:modSuffering(1)
    state:addNews(name .. ' has died due to ' .. reason .. '.')
end

function state:modSuffering(modifier)
    self.suffering = self.suffering + modifier
    if math.random(1, 50) == 1 then
        love.audio.play(game.sfx.suffering[math.random(1, #game.sfx.suffering)])
    end
end

function state:secondUpdate()
    if #self.population <= 0 then return end -- skip loop if there's no one alive

    self.cooldown = 0
    self.day = self.day + 1

    if #self.population >= 2 and math.random(1, 100) == 1 then
        self:born()
        self:modSuffering(-1)
    end

    if math.random(1, 100) == 1 then
        local name = game:genHumanName()
        table.insert(self.population, name)
        self:addNews(name .. ' has entered the town.')
    end

    if math.random(1, 100) == 1 then
        local name = table.remove(self.population, math.random(1, #self.population))
        self:addNews(name .. ' has left the town.')
    end

    if math.random(1, 100) <= (self.suffering / 4) then
        local reason = math.random(1, 5)
        if reason == 1 then
            self:kill('violence')
            self:modSuffering(2)
        elseif reason == 2 then
            self:kill('execution')
        elseif reason == 3 then
            self:kill('lack of warmth')
            self:modSuffering(1)
        elseif reason == 4 then
            self:kill('illness')
        elseif reason == 5 then
            self:kill('harsh weather')
            self:modSuffering(1)
        end
    end

    if math.random(1, 500) <= ((self.suffering / 8) + 1) then
        self:kill('a sacrifice')
        self.sacrifices = self.sacrifices + 1
        love.audio.play(game.sfx.sacrifice[math.random(1, #game.sfx.sacrifice)])
    end

    if math.random(1, 10000) == 1 then
        self:kill('a lightning strike')
        love.audio.play(game.sfx.thunder[1])
    end

    for i = 1, #self.population, 1 do
        if math.random(1, 500) == 1 then
            if self.food == 0 then
                self:modSuffering(1)
                if math.random(1, 5) == 1 then
                    self:kill('starvation')
                end
            else
                self.food = self.food - 1
            end
        end
        if math.random(1, 500) == 1 then
            if self.water == 0 then
                self:modSuffering(1)
                if math.random(1, 5) == 1 then
                    self:kill('thirst')
                end
            else
                self.water = self.water - 1
            end
        end
        if math.random(1, 500) == 1 then
            if self.housing == 0 then
                self:modSuffering(1)
                if math.random(1, 5) == 1 then
                    self:kill('lack of housing')
                end
            else
                self.housing = self.housing - 1
            end
        end
    end

    if #self.population <= 0 then
        game.finalDays = self.day
        self.state = 1
    end
end

function state:draw()
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle('fill', 0, 0, 800, 600)
    love.graphics.setColor(1, 1, 1, self.timer / 100)

    game:print(game.font.std, 'Population: ' .. #self.population, 5, 0)
    game:printCenter(game.font.std, 'Day ' .. self.day, 0)
    game:printCenter(game.font.std, self.townName, 25)
    game:printRight(game.font.std, 'Sacrifices: ' .. self.sacrifices, 0)
    game:printRight(game.font.std, 'Suffering: ' .. self.suffering, 25)
    game:printRight(game.font.std, 'Food: ' .. self.food, 50)
    game:printRight(game.font.std, 'Water: ' .. self.water, 75)
    game:printRight(game.font.std, 'Housing: ' .. self.housing, 100)
    game:print(game.font.std, '[S] Force Sacrifice (+1)\n[L] Create Life (-1)\n[F] Give Food (-0.5)\n[W] Give Water (-0.5)\n[H] Give Housing (-2)', 5, 25)
    game:printCenter(game.font.std, 'Speed: ' .. self.simSpeed .. 'x', 570)
    game:print(game.font.std, '[,] Slow Down', 5, 570)
    game:printRight(game.font.std, 'Speed Up [.]', 570)

    for i = 10, 1, -1 do
        local y = 500 - (25 * (i - 1))
        local color = ((13 - i - 1) * 0.1)
        love.graphics.setColor(color, color, color, self.timer / 100)
        game:printCenter(game.font.std, self.news[i], y)
    end
end

function state:keyDown(k)
    if k == '.' then
        if self.simSpeed == 10 then return end
        self.simSpeed = self.simSpeed + 0.25
    end

    if k == ',' then
        if self.simSpeed == 0 then return end
        self.simSpeed = self.simSpeed - 0.25
    end

    if self.cooldown == 1 then return end

    if k == 's' then
        if #self.population > 1 then
            self.sacrifices = self.sacrifices + 1
            self:kill('a forced sacrifice')
            self:modSuffering(1)
            self.cooldown = 1
        end
    elseif k == 'l' then
        if self.sacrifices < 1 then return end
        self.sacrifices = self.sacrifices - 1
        self:born()
        self.cooldown = 1
    elseif k == 'f' then
        if self.sacrifices < 0.5 then return end
        self.sacrifices = self.sacrifices - 0.5
        self.food = self.food + 1
        self.cooldown = 1
    elseif k == 'w' then
        if self.sacrifices < 0.5 then return end
        self.sacrifices = self.sacrifices - 0.5
        self.water = self.water + 1
        self.cooldown = 1
    elseif k == 'h' then
        if self.sacrifices < 2 then return end
        self.sacrifices = self.sacrifices - 2
        self.housing = self.housing + 1
        self.cooldown = 1
    end
end

return state