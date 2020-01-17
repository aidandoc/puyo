module = require("module")
movement = require("movement")
collisions = require("collisions")
puyo = require("puyos")

grid = setmetatable({},module.meta)
bricks = setmetatable({},module.meta)

offset = 50
sizeX,sizeY = 20,20
width,height = math.floor(love.graphics.getWidth()/5),math.floor(love.graphics.getHeight()*0.8)

down = false
frameFall = 30
position = 200
falling = false
score = 0
colors = {
    {
        r = 255,
        b = 0,
        g = 0
    },
    {
        r = 0,
        b = 255,
        g = 0
    },
    {
        r = 0,
        b = 0,
        g = 255
    },
    {
        r = 255,
        b = 0,
        g = 255
    }
}


function generateGrid() -- check if errors
    for columns = 1, math.floor(height/sizeY) do
        for rows = 0, math.floor(width/sizeX) - 1 do
            local tab = {}
            tab.x = (rows * sizeX) + width
            tab.y = (columns * sizeY) - (sizeX - offset)
            tab.occ = false
            grid({x = tab.x,y = tab.y,occ = tab.occ})
        end
    end
end

function love.load()

    love.graphics.setBackgroundColor(255,128/255,128/255)

    generateGrid()

    puyos = {}
    frames = 0

end

function love.update(dt)
    frames = frames + 1 -- Frame count

    movement.fall()



    function love.keypressed(key)
        if key == "escape" then
            love.event.quit()
        end
        if key == "j" then
            movement.rotate()
        end
        if key == "space" then
            puyo.create()

        end
    end

    if love.keyboard.isDown("down","s") then
        movement.push()
    end

    if love.keyboard.isDown("left","a") then
        movement.left()
    end

    if love.keyboard.isDown("right","d") then
        movement.right()
    end

    function love.keyreleased(key)
        if key == "down" or key == "s" then
            down = false
        end
    end

    for _, v in ipairs(puyos) do
        collisions.borders(v.bot,v.top)
    end


end

function love.draw()

    for columns = 1, math.floor(height/sizeY) do
        for rows = 0, math.floor(width/sizeX) - 1 do
            love.graphics.setColor(255, 97/255, 97/255)
            love.graphics.rectangle("fill",(rows * sizeX) + width,(columns * sizeY) - (sizeX - offset),sizeX,sizeY)
        end
    end

    love.graphics.setColor(255, 97/255, 97/255)

    for i,v in ipairs(puyos) do
        top,bot = v.top,v.bot
        love.graphics.setColor(top.color.r,top.color.g,top.color.b)
        love.graphics.rectangle("fill",top.x,top.y,top.w,top.h)

        love.graphics.setColor(bot.color.r,bot.color.g,bot.color.b)
        love.graphics.rectangle("fill",bot.x,bot.y,bot.w,bot.h)
        
    end

    love.graphics.setColor(1,1,1)
    love.graphics.print("Score: "..score, 30,position)
end
return