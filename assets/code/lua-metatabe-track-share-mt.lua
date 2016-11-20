local index = {} -- 防止key 冲突
local _mt = {
	__index = function(t,k)
		print('access to element '..tostring(k))
		return t[index][k]
	end,
	__newindex = function(t,k,v)
		print("update  element "..tostring(k).." to "..tostring(v))
		t[index][k] = v
	end
}

function proxy(t)
	--todo
	local  proxy = {}
	proxy[index] = t
	setmetatable(proxy, _mt)
	print(type(t),t)

    -- t = proxy -- 方便 t = proxy(t),proxy(t)两种形式的调用 --- error  已经是局部变量t,外围看不到，受到名字的影响
	print(type(t),t)
	return proxy
end

t = {1,255,3}
-- t= proxy(t)
	print(type(t),t)

proxy(t)
print(type(t),t)

t.k = 111
print(t.k,t[2])
-- 统计每个变量访问，设置的次数