local module = require("module")
local f = setmetatable({"e"=1,2,3,4,5},module.meta)
f[nil] = {[1]="red";}

print(f)