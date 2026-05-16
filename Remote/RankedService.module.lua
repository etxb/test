-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.RankedService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.RankingConfig)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local LocalRankedStore = require(script.LocalRankedStore)
local t = {
	DataInited = SimpleSignal.new()
}
local t2 = {
	Inited = false,
	Event = t,
	LocalRankedStore = LocalRankedStore
}
function t2.WaitInit() --[[ WaitInit | Line: 25 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 32 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t2.GetModeData(p1) --[[ GetModeData | Line: 40 | Upvalues: LocalRankedStore (copy) ]]
	return LocalRankedStore:GetModeData(p1)
end
function t2.GetRating(p1) --[[ GetRating | Line: 44 | Upvalues: LocalRankedStore (copy) ]]
	return LocalRankedStore:GetRating(p1)
end
function t2.ClaimReward(p1, p2) --[[ ClaimReward | Line: 48 | Upvalues: LocalRankedStore (copy), ResultUtils (copy) ]]
	if LocalRankedStore:SetTierRewardClaimed(p1, p2, {
		Test = true
	}) then
		local v1, v2 = pcall(function() --[[ Line: 52 | Upvalues: p1 (copy), p2 (copy) ]]
			return script.ClaimReward:InvokeServer(p1, p2)
		end)
		if v1 then
			if v2 then
				LocalRankedStore:SetTierRewardClaimed(p1, p2)
				return ResultUtils.success("Claim successfully!")
			else
				return ResultUtils.failed("Claim Failed", v2)
			end
		else
			return ResultUtils.error(v2)
		end
	else
		return ResultUtils.failed("Already claimed!")
	end
end
function t2.Start() --[[ Start | Line: 65 | Upvalues: LocalRankedStore (copy), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 66 | Upvalues: LocalRankedStore (ref), t2 (ref), t (ref) ]]
		if LocalRankedStore.Data or not p2 then
			if LocalRankedStore.Data then
				if p1.SetRating then
					LocalRankedStore:SetRating(p1.SetRating.Mode, p1.SetRating.Rating, p1.SetRating.Tier)
				elseif p1.SetModeData then
					LocalRankedStore:SetModeData(p1.SetModeData.Mode, p1.SetModeData.Data)
				end
			end
		else
			LocalRankedStore.Data = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
end
return t2