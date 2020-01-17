local mod = {}

function checkLeft(...)
    p = { ... }
    for index, i in ipairs(p) do
        if i.x + sizeX >= width * 2 then -- left bound
            i.x = width * 2 - sizeX
            if not i.top then
                p[index+1].right = false
            end
        end
    end
end

function checkRight(...)
    p = { ... }
    for index, i in ipairs(p) do
        if i.x - sizeX*2 <= width - width/4 then -- left bound
            i.x = (width - width/4) + sizeX*2
            if not i.top then
                p[index+1].left = false
            end
        end
    end
end

function mod.radius(...)
    p = { ... }

    for index, b in ipairs(grid) do
        for _, v in ipairs(p) do 
            if v.y + sizeY == b.y and v.x == b.x and not v.stuck and b.occ then
                v.stuck = true
                for _, i in ipairs(grid) do
                    if i.x == v.x and i.y == v.y then
                        i.occ = true
                    end
                end
            end
        end
    end
end


function mod.radiusDir(dir,...)
    p = { ... }
    mult = dir and -1 or 1
    
    for _, b in ipairs(grid) do
        for _, v in ipairs(p) do
            if v.x + (sizeX*-mult) == b.x and (v.y == b.y - (sizeY/2) or v.y == b.y) and not v.stuck and b.occ then
                v.x = v.x  - (sizeX*-mult)
            end
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


function checkGround(...)
    p = { ... }
    for _, i in ipairs(p) do
        if i.y + sizeY >= height + offset and not i.stuck then
            i.y = height + offset - sizeY
            i.stuck = true
            for _, b in ipairs(grid) do
                if b.x == i.x and b.y == i.y then
                    b.occ = true
                end
            end
        end
    end
end

function mod.borders(...)
    checkLeft(...)
    checkRight(...)
    checkGround(...)
end

return mod