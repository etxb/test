-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.InventoryQueryService

-- https://lua.expert/
local Players = game:GetService("Players")
local t = {}
local t2 = {}
local function queryInventory(p1) --[[ queryInventory | Line: 7 | Upvalues: t (copy) ]]
	local v1, v2 = pcall(function() --[[ Line: 8 | Upvalues: p1 (copy) ]]
		return script.Query:InvokeServer(p1)
	end)
	if v1 and v2 then
		t[p1] = v2
		return v2
	end
end
function t2.RemoveCache(p1) --[[ RemoveCache | Line: 18 | Upvalues: t (copy) ]]
	t[p1.UserId] = nil
end
function t2.Query(p1) --[[ Query | Line: 22 | Upvalues: t (copy) ]]
	if p1 then
		local v1 = t[p1]
		if not v1 then
			local v2, v3 = pcall(function() --[[ Line: 8 | Upvalues: p1 (copy) ]]
				return script.Query:InvokeServer(p1)
			end)
			if v2 and v3 then
				t[p1] = v3
				v1 = v3
			else
				v1 = nil
			end
		end
		if v1 and (not v1.Quering and workspace:GetServerTimeNow() > v1.NextRequest) then
			v1.Quering = true
			task.spawn(function() --[[ Line: 32 | Upvalues: p1 (copy), t (ref), v1 (ref) ]]
				local v12 = p1
				local v2, v3 = pcall(function() --[[ Line: 8 | Upvalues: v12 (copy) ]]
					return script.Query:InvokeServer(v12)
				end)
				if v2 and v3 then
					t[v12] = v3
				end
				v1.Quering = false
			end)
		end
		return v1
	end
end
Players.PlayerAdded:Connect(function(p1) --[[ Line: 40 | Upvalues: t (copy) ]]
	t[p1.UserId] = nil
end)
Players.PlayerRemoving:Connect(function(p1) --[[ Line: 43 | Upvalues: t (copy) ]]
	t[p1.UserId] = nil
end)
return t2