local Account = {balance = 0}

function Account:new(o)
	o = o  or {}
	setmetatable(o, self)
	self.__index = function(t,k)
		--todo
		print(t,k,v)
		-- os.exit()
		return self[k]
	end
	print(self)
	return o
end

function Account:deposit(v)
	self.balance = self.balance + v
end

function Account:withdraw( v )
	if v > self.balance then error "insufficient funds" end
	self.balance = self.balance - v
end


a1 = Account:new()
a2 = Account:new()
print("a1,a2: ", a1,a2)


a1:deposit(10)

print("a1:",a1.balance)
print("a2:",a2.balance)
