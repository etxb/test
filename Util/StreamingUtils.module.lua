-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.StreamingUtils

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local t = {}
if RunService:IsServer() then
	local v1 = require(ReplicatedStorage.Util.LoopedId).new()
	function t.Mark(p1) --[[ Mark | Line: 15 | Upvalues: v1 (copy) ]]
		if p1:IsA("BasePart") or p1:IsA("Model") then
			local v12 = p1:GetAttribute("_suid")
			if not (p1:HasTag("_sutils") and v12) then
				v12 = v1:Request()
				p1:AddTag("_sutils")
				p1:SetAttribute("_suid", v12)
				p1.Destroying:Connect(function() --[[ Line: 24 | Upvalues: v1 (ref), v12 (ref) ]]
					v1:Release(v12)
				end)
			end
			return v12
		else
			return p1
		end
	end
	function t.AddPersistentPlayer(p1, p2) --[[ AddPersistentPlayer | Line: 34 ]]
		if p2.Parent and p1:IsA("Model") then
			p1:AddPersistentPlayer(p2)
		end
	end
	function t.RemovePersistentPlayer(p1, p2) --[[ RemovePersistentPlayer | Line: 40 ]]
		if p2.Parent and p1:IsA("Model") then
			p1:RemovePersistentPlayer(p2)
		end
	end
end
if RunService:IsClient() then
	local v2 = TableUtils.AutoTable()
	local t2 = {}
	function t.Fetch(p1, p2) --[[ Fetch | Line: 51 | Upvalues: t2 (copy), v2 (copy) ]]
		if typeof(p1) == "number" then
			local v1 = t2[p1]
			if v1 then
				return v1.Instance
			else
				local v22 = coroutine.running()
				table.insert(v2[p1], {
					Thread = v22,
					Timeout = os.clock() + (p2 or 30)
				})
				return coroutine.yield()
			end
		else
			return p1
		end
	end
	task.spawn(function() --[[ Line: 64 | Upvalues: CollectionService (copy), t2 (copy), v2 (copy) ]]
		CollectionService:GetInstanceAddedSignal("_sutils"):Connect(function(p1) --[[ Line: 65 | Upvalues: t2 (ref), v2 (ref) ]]
			local v1 = p1:GetAttribute("_suid")
			if v1 then
				local v22 = t2[v1]
				if v22 then
					v22.Cn:Disconnect()
				end
				t2[v1] = {
					Instance = p1,
					AtTime = os.clock(),
					Cn = p1.Destroying:Connect(function() --[[ Line: 74 | Upvalues: t2 (ref), v1 (copy) ]]
						t2[v1] = nil
					end)
				}
				p1:RemoveTag("_sutils")
				p1:SetAttribute("_suid")
				local v3 = v2[v1]
				if v3 then
					for v4, v5 in v3 do
						task.spawn(v5.Thread, p1)
					end
					v2[v1] = nil
				end
			end
		end)
	end)
	task.spawn(function() --[[ Line: 91 | Upvalues: v2 (copy) ]]
		while task.wait(1) do
			for v1, v22 in v2 do
				for i = #v22, 1, -1 do
					local v3 = v22[i]
					if os.clock() > v3.Timeout then
						table.remove(v22, i)
						task.spawn(v3.Thread)
					end
				end
				if #v22 == 0 then
					v2[v1] = nil
				end
			end
		end
	end)
end
return t