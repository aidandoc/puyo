module = require("module")

grid = setmetatable({},module.meta)
bricks = setmetatable({},module.meta)

offset = 50
sizeX,sizeY = 20,20
width,height = math.floor(love.graphics.getWidth()/5),math.floor(love.graphics.getHeight()*0.8)

down = false
frameFall = 30
position = 50
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

function newPuyo() -- put in class/module?
    rect = {}
    rect.x = position
    rect.y = position
    rect.width = sizeX
    rect.height = sizeY
    rect.stuck = false
    rect.color = colors[math.random(#colors)]
    rect.puyoTwo = {}
    rect.puyoTwo.x = rect.x
    rect.puyoTwo.y = rect.y - 50
    rect.puyoTwo.width = sizeX
    rect.puyoTwo.height = sizeY
    rect.puyoTwo.stuck = false
    rect.puyoTwo.color = colors[math.random(#colors)]

    table.insert(puyos, rect)
end

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

function lookDir(dir)
    for i,v in ipairs(grid) do
        for _,p in ipairs(puyos) do
            if dir then -- right
                if p.x + p.width == v.x and (p.y == v.y - (sizeY/2) or p.y == v.y) and not p.stuck and v.occ then
                    p.x = p.x - p.width
                end
            else -- left
                if p.x - p.width == v.x and (p.y == v.y - (sizeY/2) or p.y == v.y) and not p.stuck and v.occ then
                    p.x = p.x + p.width
                end
            end
        end
    end
end

function lookRadius()
    for i,v in ipairs(grid) do
        for _, puyo in ipairs(puyos) do
            if puyo.y + puyo.height == v.y and puyo.x == v.x and v.occ and not puyo.stuck then
                puyo.stuck = true
                falling = false
                for _, bricks in ipairs(grid) do
                    if bricks.x == puyo.x and (bricks.y == puyo.y or bricks.y == puyo.y - sizeY) then
                        bricks.occ = true
                    end
                end
            end
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
    frames = frames + 1

    for i,v in ipairs(puyos) do
        if not v.stuck then
            if frames % frameFall == 0 then
                if not down then
                    v.y = v.y + sizeY/2
                    lookRadius()
                end
            end
        end
    end

    if not falling then
        falling = true
        newPuyo()
    end


    function love.keypressed(key)
        if key == "escape" then
            love.event.quit()
        end
    end

    if love.keyboard.isDown("down","s") then
        down = true
        for i,v in ipairs(puyos) do
            if not v.stuck then
                if frames % math.floor(frameFall/4) == 0 then
                    v.y = v.y + sizeY/2
                    lookRadius()
                end
            end
        end
    end

    if love.keyboard.isDown("left","a") then
        for i,v in ipairs(puyos) do
            if not v.stuck then
                if frames % (frameFall/2) == 0 then
                    lookDir(false)
                    v.x = v.x - (sizeX)
                end
            end
        end
    end

    if love.keyboard.isDown("right","d") then
        for i,v in ipairs(puyos) do
            if not v.stuck then
                if frames % (frameFall/2) == 0 then
                    lookDir(true)
                    v.x = v.x + sizeX
                end
                
            end
        end
    end

    function love.keyreleased(key)
        if key == "down" or key == "s" then
            down = false
        end
    end

    -- borders
    for i,v in ipairs(puyos) do
        if v.y + sizeY >= height + offset and not v.stuck then -- ground
            v.y = height + offset - sizeY
            v.stuck = true
            falling = false
            for _,b in ipairs(grid) do
                if b.x == v.x and (b.y == v.y or b.y == v.y - sizeY) then
                    b.occ = true
                end
            end
        end
    end

    for i,v in ipairs(puyos) do
        if v.x + sizeX >= width * 2 then -- left bound
            v.x = width * 2 - sizeX
        end
    end

    for i,v in ipairs(puyos) do
        if v.x - sizeX <= width - width/4 then -- right bound
            v.x = (width - width/4) + sizeX * 2
        end
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
        love.graphics.setColor(v.color.r,v.color.g,v.color.b)
        love.graphics.rectangle("fill",v.x,v.y,v.width,v.height)
        love.graphics.setColor(v.puyoTwo.color.r,v.puyoTwo.color.g,v.puyoTwo.color.b)
	love.graphics.rectangle("fill",v.x,v.y-sizeY,v.puyoTwo.width,v.puyoTwo.height)
    end

    love.graphics.setColor(1,1,1)
    love.graphics.print("Score: "..score, 30,position)
end
