-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.LimitedProductService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local ConditionHelper = require(ReplicatedStorage.Common.ConditionHelper)
local t = {
	DataInited = SimpleSignal.new(),
	DataUpdated = SimpleSignal.new()
}
local v1 = nil
local t2 = {
	Inited = false,
	Event = t,
	GetRemaining = function(p1) --[[ GetRemaining | Line: 22 | Upvalues: Config (copy), v1 (ref) ]]
		if Config.LimitedProduct[p1] then
			return math.max(Config.LimitedProduct[p1] - (v1[p1] and v1[p1].Sold or 0), 0)
		else
			return -1
		end
	end
}
function t2.WaitInit() --[[ WaitInit | Line: 30 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 37 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t2.Start() --[[ Start | Line: 45 | Upvalues: v1 (ref), t2 (copy), t (copy), ConditionHelper (copy), Config (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 46 | Upvalues: v1 (ref), t2 (ref), t (ref) ]]
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
	ConditionHelper.RegisterCondition("LimitedProduct", function(p1) --[[ Line: 63 | Upvalues: Config (ref), t2 (ref) ]]
		local Product = p1.Product
		if Config.LimitedProduct[Product] then
			return t2.GetRemaining(Product) > 0
		else
			return true
		end
	end)
end
return t2