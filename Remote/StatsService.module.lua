-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.StatsService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
require(ReplicatedStorage.Config.GachaConfig)
require(ReplicatedStorage.Util.Utils)
require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
require(ReplicatedStorage.Common.ConditionHelper)
require(ReplicatedStorage.Common.RewardHelper)
local LocalStatsStore = require(script.LocalStatsStore)
local t = {
	DataInited = SimpleSignal.new()
}
local t2 = {
	Inited = false,
	Event = LocalStatsStore,
	LocalStatsStore = LocalStatsStore
}
function t2.WaitInit() --[[ WaitInit | Line: 28 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 35 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t2.Start() --[[ Start | Line: 43 | Upvalues: LocalStatsStore (copy), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 44 | Upvalues: LocalStatsStore (ref), t2 (ref), t (ref) ]]
		if LocalStatsStore.Data or not p2 then
			if LocalStatsStore.Data then
				if p1.AddStat then
					local AddStat = p1.AddStat
					LocalStatsStore:AddStat(AddStat.Stat, AddStat.Scope, AddStat.Value)
				end
				if p1.SetStat then
					local SetStat = p1.SetStat
					LocalStatsStore:SetStat(SetStat.Stat, SetStat.Scope, SetStat.Value)
				end
			end
		else
			LocalStatsStore.Data = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
end
return t2