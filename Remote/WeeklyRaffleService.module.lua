-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.WeeklyRaffleService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local WeeklyRaffleConfig = require(ReplicatedStorage.Config.WeeklyRaffleConfig)
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
	Pools = {},
	PoolsById = {},
	PoolHistory = {}
}
function t2.WaitInit() --[[ WaitInit | Line: 31 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 38 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Once(p1)
	end
end
function t2.Join(p1, p2, p3) --[[ Join | Line: 46 | Upvalues: StatusService (copy), Constant (copy), WeeklyRaffleConfig (copy) ]]
	if p3 then
		if not StatusService.Has(Constant.Status.Eco_TradeToken, p2 * WeeklyRaffleConfig.TradeTokenRate) then
			return -1
		end
	elseif not StatusService.Has(Constant.Status.RaffleTicket, p2) then
		return -1
	end
	local v1, v2 = pcall(function() --[[ Line: 56 | Upvalues: p1 (copy), p2 (copy), p3 (copy) ]]
		return script.Join:InvokeServer(p1, p2, p3)
	end)
	return v1 and v2
end
function t2.Start() --[[ Start | Line: 62 | Upvalues: LocalRaffleStore (copy), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 64 | Upvalues: LocalRaffleStore (ref), t2 (ref), t (ref) ]]
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
	script.UpdatePoolData.OnClientEvent:Connect(function(p1) --[[ Line: 81 | Upvalues: t2 (ref), t (ref) ]]
		if p1.Pools then
			local t3 = {}
			for v1, v2 in p1.Pools do
				t3[v2.PoolId] = v2
			end
			t2.Pools = p1.Pools
			t2.PoolsById = t3
			t.PoolUpdated:Fire()
		end
		if p1.PoolHistory then
			t2.PoolHistory = p1.PoolHistory
			t.PoolHistoryUpdated:Fire()
		end
		if p1.SetPoolJoined and t2.PoolsById then
			local v3 = t2.PoolsById[p1.SetPoolJoined[1]]
			if not v3 then
				return
			end
			v3.Joined = p1.SetPoolJoined[2]
			t.PoolUpdated:Fire(v3.PoolId)
		end
	end)
end
return t2