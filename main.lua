gameStates = {}
gameStates.menu = 1
gameStates.play = 2
gameStates.over = 3


function love.load()
    sprites = {}
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    sprites.background = love.graphics.newImage('sprites/background.png')

    myFont = love.graphics.newFont(40)

    player = {}
    player.x = love.graphics.getWidth() / 2 
    player.y = love.graphics.getHeight() / 2
    player.speed = 3
    player.score = 0

    maxTime = 2
    timer = 2

    zombies = {}
    bullets = {}

    gameState = gameStates.menu
end


function love.update(dt)

    if gameState == gameStates.play then
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

            if distanceBetween(player.x, player.y, zombie.x, zombie.y) < 20 then
                gameState = gameStates.over
                zombies = {}
            end
         end

        for i, bullet in ipairs(bullets) do
            bullet.x = bullet.x + math.cos(bullet.direction) * bullet.speed
            bullet.y = bullet.y + math.sin(bullet.direction) * bullet.speed
        end

        for i, zombie in ipairs(zombies) do
            for i, bullet in ipairs(bullets) do
                if distanceBetween(zombie.x, zombie.y, bullet.x, bullet.y) < 20 then
                    zombie.dead = true
                    bullet.dead = true
                    player.score = player.score + 1
                end
            end
        end

        for i=#zombies, 1, -1 do
            local z = zombies[i]
            if z.dead then
                table.remove(zombies, i)
            end
        end

        for i=#bullets, 1, -1 do
            local b = bullets[i]
            if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() or b.dead then
                table.remove(bullets, i)
            end
        end

        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            timer = maxTime
            maxTime = maxTime * 0.9
        end
    end
end


function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    
    if gameState == gameStates.play then
        love.graphics.setFont(myFont)
        love.graphics.print(string.format("Score: %d", player.score), 10, 10)
        love.graphics.draw(sprites.player, player.x, player.y, mouseAngle(), nil, nil, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)
        for i, zombie in ipairs(zombies) do
            love.graphics.draw(sprites.zombie, zombie.x, zombie.y, zombiePlayerAngle(zombie), nil, nil, sprites.zombie:getWidth() / 2, sprites.zombie:getHeight() / 2)
        end

        for i, bullet in ipairs(bullets) do
            love.graphics.draw(sprites.bullet, bullet.x, bullet.y, nil, 0.5, 0.5, sprites.bullet:getWidth() / 2, sprites.bullet:getHeight() / 2)
        end
    elseif gameState == gameStates.menu then
        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(myFont)
        love.graphics.printf("Click to begin !", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    elseif gameState == gameStates.over then
        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(myFont)
        love.graphics.printf(string.format("Your score is: %d. Click to try once again", player.score), 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end


function love.mousepressed(x, y, source, isTouch)
    if gameState == gameStates.menu or gameState == gameStates.over then
        gameState = gameStates.play
        player.score = 0
        maxTime = 2
    end
    if source == 1 then
        spawnBullet()
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
    bullet.direction = mouseAngle()
    bullet.dead = false
    table.insert( bullets, bullet)
end
