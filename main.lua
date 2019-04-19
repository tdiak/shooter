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

    maxTime = 2
    timer = 2

    zombies = {}
    bullets = {}
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
        zombie.y = zombie.y + math.sin(zombiePlayerAngle(zombie)) * zombie.speed
    end

    timer = timer - dt
    if timer <= 0 then
        spawnZombie()
        timer = maxTime
    end
end


function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.draw(sprites.player, player.x, player.y, mouseAngle(), nil, nil, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)

    for i, zombie in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, zombie.x, zombie.y, zombiePlayerAngle(zombie), nil, nil, sprites.zombie:getWidth() / 2, sprites.zombie:getHeight() / 2)
    end

    for i, b in ipairs(bullets) do

    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

function mouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) +  math.pi
end

function zombiePlayerAngle(zombie)
    return math.atan2(player.y - zombie.y, player.x - zombie.x)
end

function spawnZombie()
    zombie = {}
    zombie.x = 100
    zombie.y = 100 
    zombie.speed = 1
    zombie.dead = false

    local side = math.random(1, 4)

    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif side == 3 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 4 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end   
    table.insert(zombies, zombie)
end

function spawnBullet()
    bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 8
    table.insert( bullets, bullet)
end