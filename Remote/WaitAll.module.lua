-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.WaitAll

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return function() --[[ Line: 3 | Upvalues: ReplicatedStorage (copy) ]]
	for v1, v2 in ReplicatedStorage.Remote:GetChildren() do
		if v2:IsA("ModuleScript") and v2 ~= script then
			local v3 = require(v2)
			if v3.WaitInit then
				v3.WaitInit()
			end
		end
	end
end