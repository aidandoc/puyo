local mod = {}

function mod.create()
    local bin = {}

    bin.top = {
        x = position,
        y = position,
        h = sizeX,
        w = sizeY,
        stuck = false,
        color = colors[math.random(#colors)],
        top = true,
        right = true,
        left = true,
        rotated = false
    }
    bin.bot = {
        x = position,
        y = position - sizeY,
        h = sizeX,
        w = sizeY,
        stuck = false,
        color = colors[math.random(#colors)],
        counter = 0,
        top = false,
        right = true,
        left = true,
        rotated = false
    }    
    table.insert(puyos,bin)
end


return mod