local class = {}
class.rect = {}
class.rect.__index = class.rect

function class.rect:new(x,y,a,b)
    local this = {}
    setmetatable(this,class.rect)
    this.x,this.y = x,y
    this.a,this.b = a,b
    return this
end

function class.rect:draw(type)
    if not type or (type ~= "line" and type ~= "fill") then type = "line" end
    love.graphics.rectangle(type,self.x,self.y,self.a,self.b)
end

function class.rect:prop(a,b) -- x.rect:prop(a,b)
    if not a or not b then return end
    if type(a) == "string" then
        self[string.lower(a)] = b
    else
        self[a] = b
    end
    return self[a]

end

function class.rect:get(a)
    if not a then return end
    if type(a) == "string" then return self[string.lower(a)] end
    return self[a]
end

function class.rect:set(a,b)
    if not self[a] or not b then return end
    self[a] = b
    return self[a]
end

function class.rect:destroy(a)
    if not a then return end
    if type(a) == "string" then
        if self[string.lower(a)] then
            self[string.lower(a)] = nil
            return nil
        end
    end
end


return class