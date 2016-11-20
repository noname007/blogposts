-- 
-- print(getmetatable('hi'))
-- print(getmetatable('hiw'))


local Set = {}
local mt = {}

function Set.new(s)
	local set = {}
	-- ----
	setmetatable(set, mt)
	for _,v in ipairs(s) do
		set[v] = true
	end
	return set
end

-- 并
function Set.union(a,b)
	if getmetatable(a) ~= mt or getmetatable(b) ~= mt then
		error('attemp to "+"  a Set with a non-Set value ',2)
	end
	local res = Set.new{}
	for k,v in pairs(a) do
		res[k] = true
	end
	for k,v in pairs(b) do
		res[k] = true
	end
	return res

end
-- 交
function Set.intersection(a,b)
	-- body
	local res = {	}
	for k,v in  pairs(a) do
		res[k] = b[k]
	end
	return res
end

-- ---------------------------
function Set.tostring(s)
	-- body
	local l = {}
	for k,v in pairs(s) do
		l[#l+1] = k
	end
	return "{" .. table.concat( l, "," ) .."}" 
end

function Set.print(e)
	print(Set.tostring(e))
end

-- 差 a - b
function Set.minus(a,b)
	-- body
	local r = {}
	for k,v in pairs(a) do
		if b[k] == nil then
			r[k] = v
		end
	end
	return r
end

mt.__add = Set.union
mt.__mul = Set.intersection
mt.__sub = Set.minus


-- -------- == < <=
mt.__le = function (a,b)
	for k,v in pairs(a) do
		-- if not b[k] then return false end
		if b[k] == nil then return false end
	end
	return true
end

mt.__lt = function (a,b)
	
	print(type(a),type(b))
	return a <= b and  not (b <= a)

	--todo
end

mt.__eq = function (a,b)
	return a<=b and b<=a
end

-- ---------------------------------------------------------------



s1 = Set.new{1,2,2,3,4,5}
Set.print(s1)
print(getmetatable(s1))
s2 = Set.new{10,20,30,3,4}

Set.print(s2)

Set.print(s1 + s2)
Set.print((s1 + s2 )* s1)

Set.print(Set.minus(s1,s2))
Set.print(s1 - s2)
-- s2 = {1,2,3,4,5}

s2 = Set.new{1,2,3,4,5}

print(s1 < s2)

-- local s3 = s1+8  -- error

