-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.RandomShopService.ListHandler

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.SimpleSignal)
local API = require(script.Parent.API)
local t = {}
t.__index = t
function t.GetData(p1) --[[ GetData | Line: 12 | Upvalues: API (copy) ]]
	return API.GetData().List[p1.Name]
end
function t.GetGenerated(p1) --[[ GetGenerated | Line: 17 ]]
	local v1 = p1:GetData()
	return if v1 then v1.Generated else v1
end
function t.GetRewardRaw(p1, p2) --[[ GetRewardRaw | Line: 22 ]] end
function t.GetReward(p1, p2) --[[ GetReward | Line: 26 ]] end
function t.CanObtain(p1, p2) --[[ CanObtain | Line: 30 ]] end
function t.GetPrice(p1, p2) --[[ GetPrice | Line: 34 ]] end
function t.OnPurchased(p1, p2, p3, p4) --[[ OnPurchased | Line: 38 ]] end
function t.OnUpdate(p1, p2) --[[ OnUpdate | Line: 42 ]]
	local v1 = p1:GetData()
	if v1 then
		if p2.Refreshed then
			v1.Refreshed = p2.Refreshed
		end
		if p2.VipRefreshed then
			v1.VipRefreshed = p2.VipRefreshed
		end
	end
end
function t.CanRefresh(p1) --[[ CanRefresh | Line: 55 ]] end
function t.GetRefreshCost(p1) --[[ GetRefreshCost | Line: 59 ]] end
return t