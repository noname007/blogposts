
-- 类实例化对象的方法，共用
local  instance = 	function(self,o)
	o = o  or {}
	setmetatable(o, self)
	self.__index = function(t,k)
		print(t,k)
		return self[k]
	end
	print(self)
	return o
end


local Bank = {balance = 0}
function Bank:new(o)
		print("=============",self)
		return instance(self,o)
end

function Bank:deposit(v)
	self.balance = self.balance + v
end

function Bank:withdraw( v )
	if v > self.balance then error "insufficient funds" end
	self.balance = self.balance - v
end


local  People = {name = '',age=0,angend='male',birth="8/1"}

function People:new(o)
	return instance(self,o)
end

function People:sayInfo()
	print("my name is ",self.name,", angend",self.angend,", births")
end



a1 = Bank:new()
a2 = Bank:new()
print(a1.balance)
print(a1.balance)
print(a1.balance)

a1:deposit(10)
print(a1.balance)
a2:deposit(100	)
print(a1.balance)
print(a1.balance)
print(a1.balance)
print(a2.balance)



p1 = People:new({name='yzz'})

p1:sayInfo()



function inherit(child, ... )
	-- 继承
	local newClass = child or {}
	local pls = {...} 

	setmetatable(newClass,{__index = function(t,k)
		for i,pl in ipairs(pls) do
			print(i,pl,k)
			if pl[k] ~= nil then
				return pl[k]
			end
		end
		return nil
	end})
	return newClass
end


BankAccount = inherit({},People,Bank)

BankAccount:new()

BankAccount:deposit(1000)
B1 = BankAccount:new()
-- BankAccount:new()
print(B1.balance)



