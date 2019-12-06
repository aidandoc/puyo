module = require("module")
class  = require("class")

grid = setmetatable({},module.meta)
bricks = setmetatable({},module.meta)

offset = 50
sizeX,sizeY = 20,20
width,height = math.floor(love.graphics.getWidth()/5),math.floor(love.graphics.getHeight()*0.8)

down = false
frameFall = 120
position = {
    x = width,
    y = 10
}

function newPuyo()
    rect = {}
    rect.x = position.x
    rect.y = position.y
    rect.width = sizeX
    rect.height = sizeY
    rect.stuck = false

    table.insert(puyos, rect)
end


function generateGrid() -- check if errors
    for columns = 1, math.floor(height/sizeY) do
        for rows = 0, math.floor(width/sizeX) - 1 do
            props = {}
            props.x = (columns * sizeX) + width
            props.y = (rows * sizeY) - (sizeX - offset)
            props.occ = false
            grid(props)
        end
    end
end

function love.load()

    love.graphics.setBackgroundColor(255,128/255,128/255)
    l_bound = class.rect:new(width - width/4, offset, width/4, height)
    r_bound = class.rect:new(width*2, offset, width/4, height)
    ground = class.rect:new(width - width/4,height + offset,width + width/2,offset)


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
                end
            end
        end
    end


    function love.keypressed(key)
        if key == "escape" then
            love.event.quit()
        end
        if key == "left" then -- check for blocks
            for i,v in ipairs(puyos) do
                if not v.stuck then
                    v.x = v.x - sizeX
                end
            end
        end
        if key == "right" then
            for i,v in ipairs(puyos) do
                if not v.stuck then
                    v.x = v.x + sizeX
                end
            end
        end
        if key == "space" then
            newPuyo()
        end
    end

    if love.keyboard.isDown("down") then
        down = true
        for i,v in ipairs(puyos) do
            if not v.stuck then
                v.y = v.y + 1
            end
        end
    end

    function love.keyreleased(key)
        if key == "down" then
            down = false
        end
    end

    -- borders
    for i,v in ipairs(puyos) do
        if v.y + sizeY >= height + offset then -- ground
            v.y = height + offset - sizeY
            v.stuck = true
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

    love.graphics.setColor(1,1,1)

    r_bound:draw("line")
    l_bound:draw("line")
    ground:draw("line")

    love.graphics.setColor(128/255,128/255,255)

    for i,v in ipairs(puyos) do
        love.graphics.rectangle("fill",v.x,v.y,v.width,v.height)
    end
end