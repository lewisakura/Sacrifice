require 'game'

function love.load()
    math.randomseed(os.time())

    game.currentMusic = game.music[math.random(1, #game.music)]
    love.audio.play(game.currentMusic)

    game:switchState('title')
end

function love.draw()
    love.graphics.setFont(game.font.std)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(love.timer.getFPS()) .. 'FPS', 0, 0)

    game.state:draw()
end

function love.update(dt)
    if game.state.update then
        game.state:update(dt)
    end

    if not game.currentMusic:isPlaying() then
        game.currentMusic = game.music[math.random(1, #game.music)]
        love.audio.play(game.currentMusic)
    end
end

function love.keypressed(k, sc, r)
    if game.state.keyDown then
        game.state:keyDown(k, sc, r)
    end
end

function love.keyreleased(k, sc)
    if game.state.keyUp then
        game.state:keyUp(k, sc)
    end
end