function make_read_only_table(t) 
	local read_only = {}
	local mt = {
		__index = t,
		__newindex = function (t,k,v)
			error("attemp to update a read-only table")
		end
	}
	setmetatable(read_only, mt)
	return read_only
end

a = 'test'

t = make_read_only_table{13,4,6,name='webapp',temp=a}

a = 'dd'
print(t.temp)

t.temp = 1111

