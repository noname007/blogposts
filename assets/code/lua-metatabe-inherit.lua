-- inherit

-- 属性的继承

Window = {}   -- 名字空间

Window.prototype = {x = 0,y = 0,width = 300,height = 400}

Window.mt = {}

function Window.new(o)
	-- body
	setmetatable(o, Window.mt)
	return o
end


Window.mt.__index = function(tabel,key)
	print(key)
	return Window.prototype[key]
end

w = Window.new{10,20}

print(w.height)