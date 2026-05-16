-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GachaService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
local GachaConfig = require(ReplicatedStorage.Config.GachaConfig)
local Utils = require(ReplicatedStorage.Util.Utils)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local ConditionHelper = require(ReplicatedStorage.Common.ConditionHelper)
local RewardHelper = require(ReplicatedStorage.Common.RewardHelper)
local WeaponService = require(ReplicatedStorage.Remote.WeaponService)
local LocalGachaStore = require(script.LocalGachaStore)
local t = {
	DataInited = SimpleSignal.new(),
	DataUpdated = LocalGachaStore.Event.DataUpdated
}
local t2 = {
	Inited = false,
	Event = t,
	LocalGachaStore = LocalGachaStore,
	GetGachaCount = function(p1) --[[ GetGachaCount | Line: 31 | Upvalues: LocalGachaStore (copy) ]]
		return LocalGachaStore:GetOwned(p1)
	end,
	GetData = function(p1) --[[ GetData | Line: 35 | Upvalues: LocalGachaStore (copy) ]]
		return LocalGachaStore:GetData(p1)
	end,
	GetGachaed = function(p1) --[[ GetGachaed | Line: 39 | Upvalues: LocalGachaStore (copy) ]]
		return LocalGachaStore:GetGachaed(p1)
	end,
	Gacha = function(p1, p2) --[[ Gacha | Line: 43 | Upvalues: GachaConfig (copy), LocalGachaStore (copy), ResultUtils (copy), WeaponService (copy), Constant (copy), ConditionHelper (copy), Utils (copy) ]]
		local v1 = GachaConfig[p1]
		if v1 then
			if LocalGachaStore:GetOwned(p1) < p2 then
				return ResultUtils.failed(("You don\'t have enough \"%s\""):format(v1.Display or p1))
			elseif WeaponService.LocalWeaponStore:HasSpace(p2) then
				local v2 = false
				for v3, v4 in v1.Reward do
					if ConditionHelper.FindTest(v4) then
						v2 = true
						break
					end
				end
				if v2 then
					local v5, v6 = LocalGachaStore:Take(p1, p2, {
						Test = true
					})
					if v5 then
						if Utils.HoldLock(script.Gacha) then
							local v7, v8 = pcall(function() --[[ Line: 78 | Upvalues: p1 (copy), p2 (copy), v6 (copy) ]]
								return script.Gacha:InvokeServer(p1, p2, v6.Keys)
							end)
							Utils.ReleaseLock(script.Gacha)
							if v7 and v8 then
								return ResultUtils.success(nil, v8)
							elseif v7 then
							else
								return ResultUtils.error()
							end
						end
					else
						return ResultUtils.failed(("Your \"%s\" is not enough"):format(v1.Display))
					end
				else
					return ResultUtils.failed(("Your \"%s\" is empty"):format(v1.Display or p1))
				end
			else
				return ResultUtils.failed(Constant.Message.Weapon.InventoryNotEnough)
			end
		end
	end
}
function t2.WaitInit() --[[ WaitInit | Line: 93 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 100 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t2.Start() --[[ Start | Line: 108 | Upvalues: LocalGachaStore (copy), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 109 | Upvalues: LocalGachaStore (ref), t2 (ref), t (ref) ]]
		if LocalGachaStore.Data or not p2 then
			if LocalGachaStore.Data then
				local Gacha = p1.Gacha
				if p1.Add then
					LocalGachaStore:Add(Gacha, p1.Add[1], {
						Keys = p1.Add[2],
						Content = p1.Add[3]
					})
				end
				if p1.Take then
					LocalGachaStore:Take(Gacha, p1.Take[1], {
						Keys = p1.Take[2]
					})
				end
				local Set = p1.Set
				if p1.AddGachaed then
					LocalGachaStore:AddGachaed(Gacha, p1.AddGachaed)
				end
				if p1.Update then
					LocalGachaStore:Update(Gacha, p1.Update)
				end
			end
		else
			LocalGachaStore.Data = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
end
RewardHelper.RegisterValidater("Gacha", function(p1) --[[ Line: 140 | Upvalues: GachaConfig (copy) ]]
	return GachaConfig[p1.Gacha] and true
end)
return t2