function proxy(t)
	--todo

	local  _t = t
	local _mt = {
		__index = function(t,k)
			print('access to element'..tostring(k))
			return _t[k]
		end,
		__newindex = function(t,k,v)
			print("update  element "..tostring(k).."to"..tostring(v))
			_t[k] = v
		end
	}

	setmetatable(t, _mt)
	t = {}
	return t
end


t = proxy{}
t.k = 111
print(t.k)
-- 统计每个变量访问，设置的次数