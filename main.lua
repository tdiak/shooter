function love.load()
    sprites = {}
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    sprites.background = love.graphics.newImage('sprites/background.png')

    player = {}
    player.x = love.graphics.getWidth() / 2 
    player.y = love.graphics.getHeight() / 2
end


function love.update(dt)
    if love.keyboard.isDown('s') and player.y < love.graphics.getHeight() - 40 then
        player.y = player.y + 2
    elseif love.keyboard.isDown('w') and player.y > 0 then
        player.y = player.y - 2
    elseif love.keyboard.isDown('a') and player.x > 0 then
        player.x = player.x - 2
    elseif love.keyboard.isDown('d') and player.x < love.graphics.getWidth() - 30 then
        player.x = player.x +  2
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.draw(sprites.player, player.x, player.y)
end