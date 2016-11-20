
function declare_global_var(name,initval)
	--todo
	rawset(_G,name,initval or nil)
end

setmetatable(_G, {
	__index = function(...)
		error("attemp to access to read undeclared global variable")
	end,
	__newindex =  function(...)
		error("attemp to write to undeclared global variable", 2)
	end
})



declare_global_var("a",2)

-- local a = 1
print(a)

for k,v in pairs(package.loaded) do
	print(k,v)	
end


