-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.CareerStatsService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local LocalCareerStatsStore = require(script.LocalCareerStatsStore)
local t = {
	DataInited = SimpleSignal.new()
}
local t2 = {}
function t2.WaitInit() --[[ WaitInit | Line: 13 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 20 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Once(p1)
	end
end
function t2.Start() --[[ Start | Line: 28 | Upvalues: LocalCareerStatsStore (copy), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 30 | Upvalues: LocalCareerStatsStore (ref), t2 (ref), t (ref) ]]
		if LocalCareerStatsStore.Data or not p2 then
			if LocalCareerStatsStore.Data and p1.AddRecord then
				LocalCareerStatsStore:AddRecord(p1.AddRecord)
			end
		else
			LocalCareerStatsStore.Data = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
end
return t2