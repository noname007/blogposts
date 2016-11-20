
local index = {} -- 防止key 冲突
local _mt = {
	__index = function(t,k)
		print('access to element '..tostring(k))
		return t[index][k]
	end,
	__newindex = function(t,k,v)
		error("attemp to update a read-only table")
	end
}

function make_read_only_table(t) 
	local read_only = {}
	read_only[index] = t
	setmetatable(read_only, _mt)
	return read_only
end

a = 'test'

t = make_read_only_table{13,4,6,name='webapp',temp=a}

a = 'dd'
print(t.temp)

-- t.temp = 1111

