local module = require("module")
local class  = require("class")
local width,height = math.floor(love.graphics.getWidth()/5),math.floor(love.graphics.getHeight()*0.8)
local grid = setmetatable({},module.meta)
local bricks = setmetatable({},module.meta)
local offset = 50
local a,b = 20,20
local bStart = {
    x = width,
    y = 10
}
local frameProp = {
    fall = 120,
    move = 20
}
local stuck = false -- testing purposes
local down = false

function generateGrid()
    for f = 1, math.floor(height/b) do
        for i = 0, math.floor(width/a) - 1 do
            grid({(i * a) + width, (f * b) - (b - offset), false})
        end
    end
end

function newBlock()
    block = class.rect:new(bStart.x,bStart.y,a,b)
    block:prop("stuck",0)
    return block
end

function love.load()
    frames = 0

    love.graphics.setBackgroundColor(255,128/255,128/255)
    test_rect = class.rect:new(10,10,200,300)
    test_rect:prop("occ",0)

    l_bound = class.rect:new(width - width/4, offset, width/4, height)
    r_bound = class.rect:new(width*2, offset, width/4, height)
    ground = class.rect:new(width - width/4,height + offset,width + width/2,offset)

    generateGrid()
end
function love.update(t) 
    frames = frames + 1 -- amount of frames

    if frames % frameProp.fall == 0 then
        if not down then
            if not stuck then
                bStart.y = bStart.y + b 
            end
        end
    end

    
    function love.keypressed(k)
        if k == "escape" then
            love.event.quit()
        end
        if k == "e" then
            print(grid)
        end
        if k == "left" then
            if not stuck then
                bStart.x = bStart.x - a
            end
        end
        if k == "right" then
            if not stuck then
                bStart.x = bStart.x + a
            end
        end
    end

    if love.keyboard.isDown("down") then
        down = true
        bStart.y = bStart.y + 1
    end

    function love.keyreleased(k)
        if k == "down" then
            down = false
        end
    end

    if bStart.y + b >= height+offset then -- ground
        bStart.y = height+offset - b
        stuck = true
    end

    if bStart.x + b >= width*2 then -- left bound
        bStart.x = width*2 - b
    end

    if bStart.x - b <= width - width/4 then -- right bound
        bStart.x = (width - width/4) + b*2
    end

end

function love.draw()
    love.graphics.setColor(1,1,1)

    love.graphics.rectangle("line",width,50,width,math.floor(height))
    r_bound:draw("fill")
    l_bound:draw("fill")
    ground:draw("fill")

    love.graphics.setColor(128/255,128/255,1)
    newBlock(0,0):draw("fill")
end