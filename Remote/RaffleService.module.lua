-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.RaffleService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local RaffleConfig = require(ReplicatedStorage.Config.RaffleConfig)
require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local StatusService = require(ReplicatedStorage.Remote.StatusService)
local LocalRaffleStore = require(script.LocalRaffleStore)
local t = {
	DataInited = SimpleSignal.new(),
	PoolUpdated = SimpleSignal.new(),
	PoolHistoryUpdated = SimpleSignal.new()
}
local t2 = {
	Inited = false,
	Event = t,
	LocalRaffleStore = LocalRaffleStore,
	Pools = {}
}
for v1, v2 in RaffleConfig.Pools do
	if not v2.Disabled then
		t2.Pools[v1] = {
			Instances = {},
			InstancesById = {},
			History = {}
		}
	end
end
function t2.WaitInit() --[[ WaitInit | Line: 40 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 47 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Once(p1)
	end
end
function t2.Join(p1, p2, p3, p4) --[[ Join | Line: 55 | Upvalues: StatusService (copy), Constant (copy), RaffleConfig (copy) ]]
	if p4 then
		if not StatusService.Has(Constant.Status.Eco_TradeToken, p3 * RaffleConfig.TradeTokenRate) then
			return -1
		end
	elseif not StatusService.Has(Constant.Status.RaffleTicket, p3) then
		return -1
	end
	local v1, v2 = pcall(function() --[[ Line: 65 | Upvalues: p1 (copy), p2 (copy), p3 (copy), p4 (copy) ]]
		return script.Join:InvokeServer(p1, p2, p3, p4)
	end)
	return v1 and v2
end
function t2.Start() --[[ Start | Line: 71 | Upvalues: LocalRaffleStore (copy), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 73 | Upvalues: LocalRaffleStore (ref), t2 (ref), t (ref) ]]
		if LocalRaffleStore.Data or not p2 then
			if LocalRaffleStore.Data and p1.SetJoined then
				LocalRaffleStore:SetJoined(p1.SetJoined[1], p1.SetJoined[2])
			end
		else
			LocalRaffleStore.Data = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
	script.UpdatePoolData.OnClientEvent:Connect(function(p1) --[[ Line: 90 | Upvalues: t2 (ref), t (ref) ]]
		if p1.Pools then
			for v1, v2 in p1.Pools do
				local v3 = t2.Pools[v1]
				local t3 = {}
				for v4, v5 in v2 do
					t3[v5.PoolId] = v5
				end
				v3.Instances = v2
				v3.InstancesById = t3
				t.PoolUpdated:Fire(v1)
			end
		end
		if p1.PoolHistory then
			for v6, v7 in p1.PoolHistory do
				t2.Pools[v6].History = v7
				t.PoolHistoryUpdated:Fire(v6)
			end
		end
		if p1.SetPoolJoined then
			local v8 = t2.Pools[p1.SetPoolJoined[1]].InstancesById[p1.SetPoolJoined[2]]
			if not v8 then
				return
			end
			v8.Joined = p1.SetPoolJoined[3]
			t.PoolUpdated:Fire(p1.SetPoolJoined[1], v8.PoolId)
		end
	end)
end
return t2