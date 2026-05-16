-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.CustomShopService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local t = {
	DataInited = SimpleSignal.new(),
	DataUpdated = SimpleSignal.new(),
	ListRefreshed = SimpleSignal.new()
}
local v1 = nil
local t2 = {
	Inited = false,
	Event = t,
	GetProduct = function() --[[ GetProduct | Line: 20 ]] end
}
function t2.OnInit(p1) --[[ OnInit | Line: 24 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Once(p1)
	end
end
function t2.WaitInit() --[[ WaitInit | Line: 32 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Fire()
	end
	return t2
end
function t2.Purchase() --[[ Purchase | Line: 39 ]] end
task.spawn(function() --[[ Line: 43 | Upvalues: RunService (copy), v1 (ref), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 44 | Upvalues: RunService (ref), v1 (ref), t2 (ref), t (ref) ]]
		if RunService:IsStudio() then
			print("custom shop service update data:", p1)
		end
		if not v1 and p2 then
			v1 = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
end)
return t2