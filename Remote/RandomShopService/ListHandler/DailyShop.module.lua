-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.RandomShopService.ListHandler.DailyShop

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local GachaConfig = require(ReplicatedStorage.Config.GachaConfig)
local Gacha = require(ReplicatedStorage.Config.ShopConfig.Gacha)
local WeaponSellConfig = require(ReplicatedStorage.Config.WeaponSellConfig)
local WeaponConfig = require(ReplicatedStorage.Config.WeaponConfig)
local DailyShop = require(ReplicatedStorage.Config.RandomShopConfig.DailyShop)
require(ReplicatedStorage.Shared.SimpleSignal)
local PermissionService = require(ReplicatedStorage.Remote.PermissionService)
local v1 = require(script.Parent)
local v2 = setmetatable({}, v1)
v2.__index = v2
function v2.GetRewardRaw(p1, p2) --[[ GetRewardRaw | Line: 21 ]]
	local v1 = p1:GetGenerated()
	if v1 then
		return v1.Reward[p2]
	end
end
function v2.GetReward(p1, p2) --[[ GetReward | Line: 29 ]]
	local v1 = p1:GetRewardRaw(p2)
	if v1 then
		return v1, v1
	end
end
function v2.CanObtain(p1, p2) --[[ CanObtain | Line: 38 ]]
	local v1 = p1:GetGenerated()
	return if v1 then not v1.Purchased[tostring(p2)] else v1
end
function v2.IsPurchased(p1, p2) --[[ IsPurchased | Line: 43 ]]
	local v1 = p1:GetGenerated()
	return if v1 then v1.Purchased[tostring(p2)] else v1
end
function v2.GetPrice(p1, p2) --[[ GetPrice | Line: 48 | Upvalues: WeaponConfig (copy), GachaConfig (copy), Gacha (copy), Constant (copy), WeaponSellConfig (copy), DailyShop (copy) ]]
	local v1 = p1:GetRewardRaw(p2)
	if v1 then
		local v2 = WeaponConfig[v1.Reward.Weapon]
		if v2 and GachaConfig[v1._Gacha] then
			local v3 = Gacha[v1._Gacha]
			if v3 then
				if v3.List then
					v3 = v3.List[1]
				end
				local Price = v3.Price
				if Price and Price.Eco ~= Constant.Robux then
					local v4 = WeaponSellConfig.Prices[v2.Name]
					if v4 then
						local v6 = DailyShop.WeaponPriceRate[v2.Rarity or Constant.Rarity.UnCommon]
						if v6 then
							return {
								Eco = Price.Eco,
								Value = v4 * v6
							}
						end
					end
				end
			end
		end
	end
end
function v2.GetRbxPurchaseProduct(p1, p2) --[[ GetRbxPurchaseProduct | Line: 93 | Upvalues: WeaponConfig (copy), GachaConfig (copy), Constant (copy) ]]
	local v1 = p1:GetRewardRaw(p2)
	if v1 then
		local v2 = WeaponConfig[v1.Reward.Weapon]
		if v2 then
			local v3 = GachaConfig[v1._Gacha]
			if v3 then
				return ("DailyShop_Knife_%s_%s"):format(v3.Name, v2.Rarity or Constant.Rarity.UnCommon)
			end
		end
	end
end
function v2.GetRbxGiftProduct(p1, p2) --[[ GetRbxGiftProduct | Line: 114 | Upvalues: WeaponConfig (copy), GachaConfig (copy), Constant (copy) ]]
	local v1 = p1:GetRewardRaw(p2)
	if v1 then
		local v2 = WeaponConfig[v1.Reward.Weapon]
		if v2 then
			local v3 = GachaConfig[v1._Gacha]
			if v3 then
				return ("Gift_DailyShop_Knife_%s_%s"):format(v3.Name, v2.Rarity or Constant.Rarity.UnCommon)
			end
		end
	end
end
function v2.OnUpdate(p1, p2) --[[ OnUpdate | Line: 134 | Upvalues: v1 (copy) ]]
	if p2.Purchased then
		local v12 = p1:GetGenerated()
		if v12 then
			for v2, v3 in p2.Purchased do
				v12.Purchased[v2] = v3
			end
		end
	end
	v1.OnUpdate(p1, p2)
end
function v2.GetRefreshLimit(p1) --[[ GetRefreshLimit | Line: 146 | Upvalues: DailyShop (copy), PermissionService (copy), Constant (copy) ]]
	local Refresh = DailyShop.Refresh
	PermissionService.WaitInit()
	if PermissionService.HasPermission(Constant.Permission.VIP) then
		Refresh = Refresh + DailyShop.VIPRefreshFree
	end
	return Refresh
end
function v2.CanRefresh(p1) --[[ CanRefresh | Line: 155 ]]
	return (p1:GetData().Refreshed or 0) < p1:GetRefreshLimit()
end
function v2.GetRefreshCost(p1) --[[ GetRefreshCost | Line: 164 | Upvalues: PermissionService (copy), Constant (copy), DailyShop (copy) ]]
	local v1 = p1:GetData()
	local sum = v1.Refreshed or 0
	PermissionService.WaitInit()
	if PermissionService.HasPermission(Constant.Permission.VIP) then
		local v2 = v1.VipRefreshed or 0
		if v2 < DailyShop.VIPRefreshFree then
			return
		end
		sum = sum - v2
	end
	return DailyShop.RefreshCost[sum + 1] or -1
end
return v2