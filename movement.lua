local mod = {}
local collisions = require("collisions")

function drop(...)
    args = {...}
    collisions.radius(...)

    if frames % frameFall == 0 then
        if not down then
            for _, p in pairs(args) do
                p.y = p.y + sizeY/2
            end
        end
    end
end


function move(dir,...)
    args = { ... }
    mult = dir and -1 or 1

    if frames % (frameFall/2) == 0 then
        for _, p in pairs(args) do
            collisions.radiusDir(dir,p)
            p.x = p.x - ( mult * sizeX )
        end
    end
end

function _down(...)
    args = { ... }
    down = true
    collisions.radius(...)

    if frames % math.floor( frameFall/4 ) == 0 then
        for _, p in pairs(args) do
            p.y = p.y + sizeY/2
        end
    end

end

function checkRotate(dir,bot)
    mult = dir and -1 or 1
    for _, b in ipairs(grid) do
        if bot.x + (sizeX*-mult) == b.x and (bot.y == b.y - (sizeY/2) or bot.y == b.y) and not bot.stuck and b.occ then
            return true
        end
    end
end

function checkSurr(bot)
    if checkRotate(false,bot) and checkRotate(true,bot) then
        return true
    end
end

function _rotate(bot,top)
    bot.counter = bot.counter + 1

    if bot.counter > 4 then
        bot.counter = 1
    end

    if bot.counter == 1 then
        if (bot.x + sizeX >= width * 2)  then
            bot.x = width * 2 - sizeX
            top.x = width * 2 - sizeX*2
        elseif checkSurr(bot) then
            return
        elseif checkRotate(true,bot) then
            top.x = top.x - sizeX
        else
            bot.x = bot.x + sizeX
        end
        bot.rotated = false
        bot.y = bot.y + sizeY
        
    elseif bot.counter == 2 then
        if checkSurr(bot) then return end
        bot.x = bot.x - sizeX
        bot.y = bot.y + sizeY
        bot.rotated = true

    elseif bot.counter == 3 then
        if bot.x - sizeX*2 <= width - width/4 then
            bot.x = (width - width/4) + sizeX*2
            top.x = (width - width/4) + sizeX*3

        elseif checkSurr(bot) then
            return
        elseif checkRotate(false,bot) then
            top.x = top.x + sizeX
        else
            bot.x = bot.x - sizeX
        end
        bot.rotated = false
        bot.y = bot.y - sizeY

    elseif bot.counter == 4 then
        if checkSurr(bot) then return end
        bot.x = bot.x + sizeX
        bot.y = bot.y - sizeY
        bot.rotated = true
    end

end

function mod.rotate()
    for _, p in pairs( puyos ) do
        bot,top = p.bot,p.top
        if not bot.stuck then
            _rotate(bot,top)
        end
    end
end

function mod.push()
    down = true
    for _, p in ipairs(puyos) do
        top, bot = p.top, p.bot
        if bot.stuck and not top.stuck then
            _down(top)
        elseif not bot.stuck and top.stuck then
            _down(bot)
        elseif not bot.stuck and not top.stuck then
            _down(bot,top)
        end
    end
end




function mod.right()
    for _, p in ipairs(puyos) do
        top, bot = p.top, p.bot
        top.left,bot.left = true,true
        if bot.stuck and not top.stuck then
            if top.right then
                move(true,top)
            end
        elseif not bot.stuck and top.stuck then
            if bot.right then
                move(true,bot)
            end
        elseif not bot.stuck and not top.stuck then
            if (bot.right and top.right) or bot.rotated then
                move(true,bot,top)
            end
        end
    end
end

function mod.left()
    for _, p in ipairs(puyos) do
        top, bot = p.top, p.bot
        top.right,bot.right = true,true
        if bot.stuck and not top.stuck then
            if top.left then
                move(false,top)
            end
        elseif not bot.stuck and top.stuck then
            if bot.left then
                move(false,bot)
            end
        elseif not bot.stuck and not top.stuck then
            if (bot.left and top.left) or bot.rotated then
                move(false,bot,top)
            end
        end
    end
end



function mod.fall()
    for _, p in ipairs(puyos) do
        top, bot = p.top, p.bot
        if bot.stuck and not top.stuck then
            drop(top)
        elseif not bot.stuck and top.stuck then
            drop(bot)
        elseif not bot.stuck and not top.stuck then
            drop(bot,top)
        end
    end
end

return mod