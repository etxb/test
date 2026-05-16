-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.PermissionService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local Constant = require(ReplicatedStorage.Constant)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local RewardHelper = require(ReplicatedStorage.Common.RewardHelper)
local ConditionHelper = require(ReplicatedStorage.Common.ConditionHelper)
local t = {
	DataInited = SimpleSignal.new(),
	DataUpdated = SimpleSignal.new()
}
local v1 = nil
local t2 = {
	Inited = false,
	Event = t,
	GetPermissionData = function() --[[ GetPermissionData | Line: 24 | Upvalues: v1 (ref) ]]
		return v1
	end,
	HasPermission = function(p1) --[[ HasPermission | Line: 28 | Upvalues: v1 (ref) ]]
		return v1 and v1[p1]
	end
}
function t2.WaitInit() --[[ WaitInit | Line: 32 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 39 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t2.Start() --[[ Start | Line: 47 | Upvalues: v1 (ref), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 48 | Upvalues: v1 (ref), t2 (ref), t (ref) ]]
		if v1 or not p2 then
			if v1 then
				for v12, v2 in p1 do
					v1[v12] = v2
				end
				t.DataUpdated:Fire(p1)
			end
		else
			v1 = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
end
RewardHelper.RegisterValidater("Permission", function(p1) --[[ Line: 66 | Upvalues: Constant (copy) ]]
	return Constant.Permission[p1.Permission] and true
end)
ConditionHelper.RegisterCondition("Permission", function(p1) --[[ Line: 70 | Upvalues: t2 (copy) ]]
	return t2.HasPermission(p1.Permission)
end)
return t2