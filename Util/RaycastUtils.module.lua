-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.RaycastUtils

-- https://lua.expert/
return {
	Raycast = function(p1, p2, p3) --[[ Raycast | Line: 3 ]]
		local Magnitude = p2.Magnitude
		if Magnitude < 1023 then
			return workspace:Raycast(p1, p2, p3)
		else
			local Unit = p2.Unit
			local sum = 0
			while Magnitude > 0 do
				local v1 = math.min(Magnitude, 1023)
				local v2 = workspace:Raycast(p1, Unit * v1, p3)
				if v2 then
					return {
						Position = v2.Position,
						Instance = v2.Instance,
						Distance = v2.Distance + sum,
						Material = v2.Material,
						Normal = v2.Normal
					}
				end
				Magnitude = Magnitude - v1
				p1 = p1 + Unit * v1
				sum = sum + v1
			end
		end
	end
}