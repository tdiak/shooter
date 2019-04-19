function love.load()
    sprites = {}
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    sprites.background = love.graphics.newImage('sprites/background.png')

    player = {}
    player.x = love.graphics.getWidth() / 2 
    player.y = love.graphics.getHeight() / 2
    player.speed = 3

    zombies = {}
end


function love.update(dt)
    if love.keyboard.isDown('s') and player.y < love.graphics.getHeight() - 40 then
        player.y = player.y + player.speed
    elseif love.keyboard.isDown('w') and player.y > 0 then
        player.y = player.y - player.speed
    elseif love.keyboard.isDown('a') and player.x > 0 then
        player.x = player.x - player.speed
    elseif love.keyboard.isDown('d') and player.x < love.graphics.getWidth() - 30 then
        player.x = player.x +  player.speed
    end

    for i, zombie in ipairs(zombies) do
        zombie.x = zombie.x + math.cos(zombiePlayerAngle(zombie)) * zombie.speed
    end
end


function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.draw(sprites.player, player.x, player.y, mouseAngle(), nil, nil, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)

    for i, z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(zombie), nil, nil, sprites.zombie:getWidth() / 2, sprites.zombie:getHeight() / 2)
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

function mouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) +  math.pi
end

function zombiePlayerAngle(zombie)
    return math.atan2(zombie.y - player.y, zombie.x - player.x)
end

function spawnZombie()
    zombie = {}
    zombie.x = 0
    zombie.y = 0 
    zombie.speed = 1
    table.insert(zombies, zombie)
end
