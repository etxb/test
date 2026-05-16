-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.ItemService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local ItemConfig = require(ReplicatedStorage.Config.ItemConfig)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local RewardHelper = require(ReplicatedStorage.Common.RewardHelper)
local t = {
	DataInited = SimpleSignal.new(),
	DataUpdated = SimpleSignal.new(),
	Expired = SimpleSignal.new()
}
local t2 = {
	Updated = TableUtils.WrapGet({}, SimpleSignal.new)
}
local v1 = nil
local t3 = {
	Inited = false,
	Event = t
}
local function parseItemName(p1) --[[ parseItemName | Line: 32 ]]
	if typeof(p1) == "table" then
		return p1.Name
	else
		return p1
	end
end
function t3.GetItemUpdatedSignal(p1) --[[ GetItemUpdatedSignal | Line: 39 | Upvalues: t2 (copy) ]]
	return t2.Updated.get(if typeof(p1) == "table" then p1.Name else p1)
end
function t3.GetContent() --[[ GetContent | Line: 43 | Upvalues: v1 (ref) ]]
	return if v1 then v1.Content or {} else {}
end
function t3.GetItemCount(p1) --[[ GetItemCount | Line: 47 | Upvalues: ItemConfig (copy), v1 (ref) ]]
	if typeof(p1) == "table" then
		p1 = p1.Name
	end
	local v12 = ItemConfig[p1]
	if v12 and not v12.Disabled then
		local v2 = v1.Content[p1]
		if v2 then
			if (v2.ExpireTime or -1) == -1 or not (workspace:GetServerTimeNow() > v2.ExpireTime) then
				return v2.Count or 1
			end
		else
			return 0
		end
	end
end
local function fireUpdate(p1, p2, p3) --[[ fireUpdate | Line: 63 | Upvalues: t2 (copy), t (copy) ]]
	local v1 = t2.Updated[p1]
	if v1 then
		v1:Fire(p1, p2)
	end
	if p3 then
		t.DataUpdated:Fire({
			Content = {
				[p1] = p2
			}
		})
	end
end
function t3.TryUse(p1, p2, p3) --[[ TryUse | Line: 73 | Upvalues: t3 (copy), fireUpdate (copy) ]]
	local v1 = 1
	if typeof(p1) == "table" then
		p1 = p1.Name
	end
	local v2 = t3.GetContent()[p1]
	if v2 and not (v2.Count < v1) then
		if script.TryUse:InvokeServer(p1, v1, p3) then
			v2.Count = v2.Count - v1
			fireUpdate(p1, v2, true)
			return true
		end
	else
		return -1
	end
end
function t3.Has(p1, p2) --[[ Has | Line: 85 | Upvalues: v1 (ref), t3 (copy) ]]
	if v1 and v1.Content then
		local v12 = t3.GetItemCount(p1)
		return if v12 then (p2 or 1) <= v12 else v12
	end
end
function t3.HasPremanent(p1) --[[ HasPremanent | Line: 93 | Upvalues: v1 (ref) ]]
	if typeof(p1) == "table" then
		p1 = p1.Name
	end
	workspace:GetServerTimeNow()
	local v12 = v1.Content[p1]
	return if v12 then (v12.ExpireTime or -1) == -1 else v12
end
function t3.GetRemainingTime(p1) --[[ GetRemainingTime | Line: 100 | Upvalues: v1 (ref) ]]
	local v12 = workspace:GetServerTimeNow()
	local v2 = v1.Content[p1]
	if v2 and (v2.ExpireTime or -1) == -1 then
		return -1
	elseif v2 and ((v2.ExpireTime or -1) == -1 or not (v2.ExpireTime < v12)) then
		return v2.ExpireTime - v12
	else
		return 0
	end
end
function t3.WaitInit() --[[ WaitInit | Line: 112 | Upvalues: t3 (copy), t (copy) ]]
	if not t3.Inited then
		t.DataInited:Wait()
	end
	return t3
end
function t3.OnInit(p1) --[[ OnInit | Line: 119 | Upvalues: t3 (copy), t (copy) ]]
	if t3.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t3.Start() --[[ Start | Line: 127 | Upvalues: v1 (ref), t3 (copy), t (copy), t2 (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 128 | Upvalues: v1 (ref), t3 (ref), t (ref), t2 (ref) ]]
		if v1 or not p2 then
			if v1 then
				if p1.Content then
					local t4 = {}
					for v12, v2 in p1.Content do
						if not v1.Content[v12] then
							t4[v12] = v2
						end
						v1.Content[v12] = v2
						local v3 = t2.Updated[v12]
						if v3 then
							v3:Fire(v12, v2)
						end
					end
					if next(t4) then
						p1.New = t4
					end
				end
				if p1.Remove then
					for v4, v5 in p1.Remove do
						v1.Content[v5] = nil
					end
				end
				if p1.Expired then
					local t4 = {}
					for v6, v7 in p1.Expired do
						if v1.Content[v7] then
							t4[v7] = v1.Content[v7]
							v1.Content[v7] = nil
							t.Expired:Fire(v7)
						end
					end
					p1.Expired = t4
				end
				t.DataUpdated:Fire(p1)
			end
		else
			v1 = p1
			t3.Inited = true
			t.DataInited:Fire()
		end
	end)
end
t3.OnInit(function() --[[ Line: 178 | Upvalues: v1 (ref), t (copy) ]]
	while task.wait(1) do
		if not next(v1.Content) then
			t.DataUpdated:Wait()
		end
		local v12 = workspace:GetServerTimeNow()
		local t2 = {}
		for v2, v3 in v1.Content do
			if (v3.ExpireTime or -1) ~= -1 and not (v12 < v3.ExpireTime) then
				t2[v2] = v3
				t.Expired:Fire(v2)
				v1.Content[v2] = nil
			end
		end
		if next(t2) then
			t.DataUpdated:Fire({
				Expired = t2
			})
		end
	end
end)
RewardHelper.RegisterValidater("Item", function(p1) --[[ Line: 201 | Upvalues: ItemConfig (copy) ]]
	return ItemConfig[p1.Item] and true
end)
return t3