-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.DebugUtils

-- https://lua.expert/
local Debris = game:GetService("Debris")
return {
	TempPart = function(p1, p2) --[[ TempPart | Line: 5 | Upvalues: Debris (copy) ]]
		local v1 = script.TempPart:Clone()
		if p2 then
			v1.Color = p2
		end
		if typeof(p1) == "Vector3" then
			v1.Position = p1
		else
			v1.CFrame = p1
		end
		v1.Parent = workspace._Temp
		Debris:AddItem(v1, 10)
		return v1
	end
}