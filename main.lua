

local module = require("module")
local class  = require("class")
local width,height = math.floor(love.graphics.getWidth()/5),math.floor(love.graphics.getHeight()*0.8)
local grid = setmetatable({},module.meta)
local bricks = setmetatable({},module.meta)
local offset = 50
local a,b = 20,20

function generateGrid()
    for f = 1, math.floor(height/b) do
        for i = 0, math.floor(width/a) - 1 do
            grid({(i * a) + width, (f * b) - (b - offset), false})
        end
    end
end

function newBlock()
    local start = {10,100}
    block = class.rect:new(start[1],start[2],a,b)

    return block
end

function love.load()
    d = 0

    love.graphics.setBackgroundColor(255,128/255,128/255)
    test_rect = class.rect:new(10,10,200,300)
    test_rect:prop("occ",false)

    l_bound = class.rect:new(width - width/4, offset, width/4, height)
    r_bound = class.rect:new(width*2, offset, width/4, height)
    ground = class.rect:new(width - width/4,height + offset,width + width/2,offset)

    generateGrid()
end
function love.update(t) 
    d = d + t
    
    function love.keypressed(k)
        if k == "e" then
            print(grid)
        end
    end

end

function love.draw()
    for f = 1,math.floor(height)/b do
        for i=0,math.floor(width/a)-1 do
            sq = love.graphics.rectangle("line",i*a + width,f*b - (b - offset),a,b) -- make classes with values {x,y,true}
            grid(sq)
        end
    end
    love.graphics.rectangle("line",width,50,width,math.floor(height))
    r_bound:draw("fill")
    l_bound:draw("fill")
    ground:draw("fill")
    newBlock():draw("fill")
end
