-- function set_default(t,default)
-- 	--todo
-- 	local mt = {
-- 		__index = function()
-- 			return default
-- 		end
-- 	}
-- 	setmetatable(t, mt)
-- end

-- tab = {x = 1,y = 2}

-- print(tab.x,tab.y)
-- set_default(tab,0)
-- print(tab.x,tab.y,tab.z)
-- local mt = {
-- 	__index = function(t,key)
-- 		return t.___
-- 	end
-- }
-- function set_default(t,default)
-- 	t.___ = default
-- 	setmetatable(t, mt)
-- end

-- tab = {x = 1,y = 2}

-- print(tab.x,tab.y)
-- set_default(tab,0)
-- print(tab.x,tab.y,tab.z)



local key = {} ---- 防止索引冲突
local mt = {
    __index = function(t)
        return t[key]
    end
}
function set_default(t,default)
    t[key] = default
    setmetatable(t, mt)
end

tab = {x = 1,y = 2}

print(tab.x,tab.y)
set_default(tab,0)
print(tab.x,tab.y,tab.z)



