-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.BattlepassService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local BattlepassConfig = require(ReplicatedStorage.Config.BattlepassConfig)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local ConditionHelper = require(ReplicatedStorage.Common.ConditionHelper)
local LocalBattlepassStore = require(script.LocalBattlepassStore)
local t = {
	DataInited = SimpleSignal.new()
}
local t2 = {
	Inited = false,
	Event = t,
	LocalBattlepassStore = LocalBattlepassStore
}
function t2.WaitInit() --[[ WaitInit | Line: 26 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 33 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t2.Claim(p1, p2) --[[ Claim | Line: 41 | Upvalues: LocalBattlepassStore (copy), ResultUtils (copy) ]]
	if LocalBattlepassStore:CanClaim(p1, p2) then
		local v1, v2, v3 = pcall(function() --[[ Line: 45 | Upvalues: p1 (copy), p2 (copy) ]]
			return script.Claim:InvokeServer(p1, p2)
		end)
		if v1 and v2 then
			LocalBattlepassStore:SetClaimed(p1, p2, v3)
			return ResultUtils.success("Claim successfully", v2)
		else
			return ResultUtils.error(v2)
		end
	end
end
function t2.ClaimPremiumReward() --[[ ClaimPremiumReward | Line: 55 | Upvalues: LocalBattlepassStore (copy), BattlepassConfig (copy), ResultUtils (copy) ]]
	local Data = LocalBattlepassStore.Data
	if Data and not Data.PremiumRewardClaimed and Data.Premium then
		local v1 = BattlepassConfig.Seasons[Data.Season]
		if v1 and v1.PremiumReward then
			if (Data.Level or 0) < v1.LevelMax and (Data.Rebirth or 0) < 1 then
			else
				local v2, v3 = pcall(function() --[[ Line: 70 ]]
					return script.ClaimPremiumReward:InvokeServer()
				end)
				if v2 and v3 then
					LocalBattlepassStore.Data.PremiumRewardClaimed = true
					LocalBattlepassStore.Event.DataUpdated:Fire(LocalBattlepassStore, {
						PremiumRewardClaimed = true
					})
					return ResultUtils.success("Claim successfully", v3)
				else
					return ResultUtils.error(v3)
				end
			end
		end
	end
end
function t2.ClaimRebirthReward() --[[ ClaimRebirthReward | Line: 81 | Upvalues: LocalBattlepassStore (copy), ResultUtils (copy) ]]
	if LocalBattlepassStore.Data.RebirthRewardClaimed then
	else
		local v1, v2 = pcall(function() --[[ Line: 85 ]]
			return script.ClaimRebirthReward:InvokeServer()
		end)
		if v1 and v2 then
			LocalBattlepassStore.Data.RebirthRewardClaimed = true
			LocalBattlepassStore.Event.DataUpdated:Fire(LocalBattlepassStore, {
				RebirthRewardClaimed = true
			})
			return ResultUtils.success("Claim successfully", v2)
		else
			return ResultUtils.error(v2)
		end
	end
end
function t2.Rebirth() --[[ Rebirth | Line: 96 | Upvalues: LocalBattlepassStore (copy), ResultUtils (copy) ]]
	local v1, v2 = LocalBattlepassStore:CanRebirth()
	if v1 then
		local v3, v4, v5 = pcall(function() --[[ Line: 110 ]]
			return script.Rebirth:InvokeServer()
		end)
		if v3 then
			if v4 or v5 then
				if v4 then
					LocalBattlepassStore:SetRestrictedReward(v4.Rebirth, v4.Rewards)
					LocalBattlepassStore:Rebirth({
						Server = true
					})
					return ResultUtils.success("Rebirth successfully", v5)
				else
					return ResultUtils.failed("Failed", v5)
				end
			end
		else
			return ResultUtils.error(v4)
		end
	elseif v2 == -1 then
		return ResultUtils.failed("Max Rebirth reached")
	elseif v2 == -2 then
		return ResultUtils.failed("Requires Level 30 to Rebirth!")
	elseif v2 == -3 then
		return ResultUtils.failed("You need to own \"Premium\" first!")
	end
end
function t2.Start() --[[ Start | Line: 127 | Upvalues: LocalBattlepassStore (copy), t2 (copy), t (copy), ConditionHelper (copy), BattlepassConfig (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 128 | Upvalues: LocalBattlepassStore (ref), t2 (ref), t (ref) ]]
		if LocalBattlepassStore.Data or not p2 then
			if LocalBattlepassStore.Data then
				if p1.UpdateSeason then
					LocalBattlepassStore.Data = p1.UpdateSeason
					LocalBattlepassStore.Event.DataUpdated:Fire(LocalBattlepassStore, {
						UpdateSeason = true
					})
				else
					if p1.Update then
						LocalBattlepassStore:Update(p1.Update)
					end
					if p1.SetExpAndLevel then
						LocalBattlepassStore:SetExpAndLevel(p1.SetExpAndLevel.Exp, p1.SetExpAndLevel.Level)
					end
				end
			end
		else
			LocalBattlepassStore.Data = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
	ConditionHelper.RegisterCondition("Battlepass", function(p1) --[[ Line: 152 | Upvalues: LocalBattlepassStore (ref), BattlepassConfig (ref) ]]
		if LocalBattlepassStore.Data then
			local Data = LocalBattlepassStore.Data
			local v1 = BattlepassConfig.Seasons[Data.Season]
			if p1.Premium and not Data.Premium then
				return false
			else
				return not (p1.MaxLevel and Data.Level < v1.LevelMax)
			end
		end
	end)
end
return t2