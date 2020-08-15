game = {}

game.state = nil
game.states = {
    title = require 'states/title',
    intro = require 'states/intro',
    game = require 'states/game',
    fin = require 'states/fin'
}
game.currentMusic = nil

game.finalDays = 0

game.names = {
    human = {
        first = {}, last = {}
    },
    town = {
        pre = {}, start = {}, ending = {}
    }
}

for line in love.filesystem.lines('assets/namegen/human/first.txt') do
    table.insert(game.names.human.first, line)
end

for line in love.filesystem.lines('assets/namegen/human/last.txt') do
    table.insert(game.names.human.last, line)
end

for line in love.filesystem.lines('assets/namegen/town/pre.txt') do
    table.insert(game.names.town.pre, line)
end

for line in love.filesystem.lines('assets/namegen/town/start.txt') do
    table.insert(game.names.town.start, line)
end

for line in love.filesystem.lines('assets/namegen/town/ending.txt') do
    table.insert(game.names.town.ending, line)
end

function game:genHumanName()
    return self.names.human.first[math.random(1, #self.names.human.first)] .. ' ' .. self.names.human.last[math.random(1, #self.names.human.last)]
end

function game:genTownName()
    return self.names.town.pre[math.random(1, #self.names.town.pre)] .. ' ' .. self.names.town.start[math.random(1, #self.names.town.start)] .. self.names.town.ending[math.random(1, #self.names.town.ending)]
end

game.font = {
    std = love.graphics.newFont("assets/font/rct2-latin-extended.ttf", 30),
    title = love.graphics.newFont("assets/font/rct2-latin-extended.ttf", 96)
}

game.music = {
    love.audio.newSource("assets/music/1.ogg", "stream"),
    love.audio.newSource("assets/music/2.ogg", "stream"),
    love.audio.newSource("assets/music/3.ogg", "stream"),
    love.audio.newSource("assets/music/4.ogg", "stream")
}

game.sfx = {
    ambience = {
        love.audio.newSource("assets/sfx/lords_prayer.ogg", "stream")
    },
    suffering = {
        love.audio.newSource("assets/sfx/mancough_verb.ogg", "stream"),
        love.audio.newSource("assets/sfx/womancough_verb.ogg", "stream"),
        love.audio.newSource("assets/sfx/womancry_verb.ogg", "stream"),
        love.audio.newSource("assets/sfx/womancry2_verb.ogg", "stream")
    },
    sacrifice = {
        love.audio.newSource("assets/sfx/souls.ogg", "stream"),
        love.audio.newSource("assets/sfx/souls2.ogg", "stream"),
        love.audio.newSource("assets/sfx/souls3.ogg", "stream"),
        love.audio.newSource("assets/sfx/souls4.ogg", "stream"),
        love.audio.newSource("assets/sfx/souls5.ogg", "stream"),
        love.audio.newSource("assets/sfx/souls6.ogg", "stream"),
        love.audio.newSource("assets/sfx/souls7.ogg", "stream")
    },
    thunder = {
        love.audio.newSource("assets/sfx/thunder.ogg", "stream")
    }
}

for _, v in pairs(game.music) do
    v:setVolume(0.3)
end

for _, v in pairs(game.sfx) do
    for _, sfx in pairs(v) do
        sfx:setVolume(0.3)
    end
end

for _, v in pairs(game.font) do
    v:setFilter('nearest', 'nearest', 1)
end

function game:switchState(name)
    if not game.states[name] then
        error('no such state '..name)
    end

    game.state = game.states[name]
    if game.state.init then
        game.state:init()
    end
end

function game:print(font, message, w, y)
    love.graphics.setFont(font)
    love.graphics.print(message, w, y)
end

function game:printCenter(font, message, y)
    self:print(font, message, (800 / 2) - (font:getWidth(message) / 2), y)
end

function game:printRight(font, message, y)
    self:print(font, message, (800) - (font:getWidth(message)) - 5, y)
end