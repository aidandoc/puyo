local class = {}

class.meta = {
    __index = function(t,k) 
        return t[k]
    end,
    __tostring = function(t) 
        local string = "{"
        if #t == 0 then return nil end
        for i,v in pairs(t) do
            if i == #t or i < 1 then 
                if type(v) == "table" then -- if another table
                    setmetatable(v,class.meta)
                end
                string = string..tostring(v).."}"
                break
            end

            if type(v) == "table" then
                setmetatable(v,class.meta)
            end
            string = string..tostring(v)..", " 
        end

        return string
    end,
    __newindex = function(t,k,v)
        if not k then return rawset(t,#t+1,v) end
        if type(k) == "string" then return rawset(t,k,v) end
        if k > #t then return rawset(t,#t+1,v) end
        return rawset(t,k,v)
    end,
    __call = function(t,...) -- calling table adds value to end of table
        for i,v in pairs({...}) do
            rawset(t,#t+1,v)
        end
        return t
    end
}

return class