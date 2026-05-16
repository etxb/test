-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.RandomShopService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Util.TimeUtils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local ConditionHelper = require(ReplicatedStorage.Common.ConditionHelper)
local ShopService = require(ReplicatedStorage.Remote.ShopService)
local StatusService = require(ReplicatedStorage.Remote.StatusService)
local API = require(script.API)
local v1 = InstanceUtils.LoadModuleScripts(script.ListHandler, {
	OnlyChild = true
})
for v2, v3 in v1 do
	v3.Name = v2
end
local t = {
	ListRefreshed = TableUtils.WrapGet({}, SimpleSignal.new),
	ListDataUpdated = TableUtils.WrapGet({}, SimpleSignal.new),
	Purchased = TableUtils.WrapGet({}, SimpleSignal.new)
}
local t2 = {
	DataInited = SimpleSignal.new(),
	DataUpdated = SimpleSignal.new(),
	ListRefreshed = SimpleSignal.new(),
	Purchased = SimpleSignal.new()
}
local v4 = nil
function API.GetData() --[[ GetData | Line: 43 | Upvalues: v4 (ref) ]]
	return v4
end
local t3 = {
	Inited = false,
	Event = t2,
	Signal = t,
	GetListHandler = function(p1) --[[ GetListHandler | Line: 55 | Upvalues: v1 (copy), RunService (copy) ]]
		local v12 = v1[p1]
		if not v12 and RunService:IsStudio() then
			error("\230\156\170\229\136\155\229\187\186\233\154\143\230\156\186\229\149\134\229\186\151\229\164\132\231\144\134\229\153\168", p1)
		elseif not v12 then
			error("random shop handler not created yet", p1)
		end
		return v12
	end
}
function t3.GetListData(p1) --[[ GetListData | Line: 67 | Upvalues: t3 (copy) ]]
	return t3.GetListHandler(p1):GetData(p1)
end
function t3.OnInit(p1) --[[ OnInit | Line: 72 | Upvalues: t3 (copy), t2 (copy) ]]
	if t3.Inited then
		p1()
	else
		t2.DataInited:Once(p1)
	end
end
function t3.WaitInit() --[[ WaitInit | Line: 80 | Upvalues: t3 (copy), t2 (copy) ]]
	if not t3.Inited then
		t2.DataInited:Fire()
	end
	return t3
end
function t3.Refresh(p1) --[[ Refresh | Line: 87 | Upvalues: t3 (copy), StatusService (copy), Constant (copy), ResultUtils (copy) ]]
	local v1 = t3.GetListHandler(p1)
	if v1:CanRefresh() then
		local v2 = v1:GetRefreshCost()
		if v2 == -1 then
		elseif v2 and not StatusService.Has(Constant.Status.Eco_Coin, v2) then
			return ResultUtils.ecoNotEnough(Constant.Status.Eco_Coin, v2)
		else
			local v3, v4 = pcall(function() --[[ Line: 100 | Upvalues: p1 (copy) ]]
				return script.Refresh:InvokeServer(workspace:GetServerTimeNow(), p1)
			end)
			if v3 then
				return if v4 then ResultUtils.success("Refresh Successfully") else v4
			else
				return ResultUtils.error(v4)
			end
		end
	end
end
function t3.Purchase(p1, p2, p3) --[[ Purchase | Line: 109 | Upvalues: t3 (copy), Constant (copy), StatusService (copy), ResultUtils (copy) ]]
	local v1 = t3.GetListHandler(p1)
	if v1:CanObtain(p2) then
		local v2 = v1:GetPrice(p2)
		if v2 then
			if v2.Eco == Constant.Robux then
				p3 = true
			end
			if p3 or StatusService.Has(v2.Eco, v2.Value) then
				local v3, v4 = pcall(function() --[[ Line: 129 | Upvalues: p1 (copy), p2 (copy), p3 (ref) ]]
					return script.Purchase:InvokeServer(workspace:GetServerTimeNow(), p1, p2, p3)
				end)
				if v3 then
					if v4 == -1 then
						return ResultUtils.error()
					else
						return if v4 then ResultUtils.success() else v4
					end
				else
					return ResultUtils.error(v4)
				end
			else
				return ResultUtils.ecoNotEnough(v2.Eco, v2.Value)
			end
		end
	end
end
function t3.Gift(p1, p2) --[[ Gift | Line: 141 | Upvalues: t3 (copy), ResultUtils (copy) ]]
	local v1 = t3.GetListHandler(p1)
	if v1 and v1:GetRbxGiftProduct(p2) then
		local v2, v3 = pcall(function() --[[ Line: 150 | Upvalues: p1 (copy), p2 (copy) ]]
			return script.Gift:InvokeServer(workspace:GetServerTimeNow(), p1, p2)
		end)
		if v2 then
			return if v3 then ResultUtils.success() else v3
		else
			return ResultUtils.error(v3)
		end
	end
end
task.spawn(function() --[[ Line: 159 | Upvalues: ConditionHelper (copy), v1 (copy), ShopService (copy), RunService (copy), v4 (ref), t3 (copy), t2 (copy), t (copy) ]]
	ConditionHelper.RegisterCondition("RandomShop", function(p1, p2) --[[ Line: 160 | Upvalues: v1 (ref) ]]
		local v12 = v1[p1.List]
		if v12 and p1.Index then
			return v12:CanObtain(p1.Index)
		end
	end)
	ShopService.RegisterPriceProvider("RandomShop", function(p1) --[[ Line: 168 | Upvalues: v1 (ref) ]]
		if p1.RewardType == "RandomShop" then
			local v12 = v1[p1.Reward.List]
			return if v12 then v12:GetRewardShopPrice(p1.Reward.Index) else v12
		end
	end)
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 176 | Upvalues: RunService (ref), v4 (ref), t3 (ref), t2 (ref), t (ref), v1 (ref) ]]
		if RunService:IsStudio() then
			print("shop random service update data:", p1)
		end
		if v4 or not p2 then
			if v4 then
				if p1.RefreshList then
					for v12, v2 in p1.RefreshList do
						v4.List[v12] = v2
						t2.ListRefreshed:Fire(v12)
						local v3 = t.ListRefreshed[v12]
						if v3 then
							v3:Fire()
						end
						t2.DataUpdated:Fire(v12)
						local v42 = t.ListDataUpdated[v12]
						if v42 then
							v42:Fire()
						end
					end
				end
				if p1.UpdateList then
					for v5, v6 in p1.UpdateList do
						local v7 = v1[v5]
						if v7 then
							v7:OnUpdate(v6)
						end
						t2.DataUpdated:Fire(v5, v6)
						local v8 = t.ListDataUpdated[v5]
						if v8 then
							v8:Fire(v6)
						end
					end
				end
			end
		else
			v4 = {
				List = p1
			}
			t3.Inited = true
			t2.DataInited:Fire()
		end
	end)
	script.Purchased.OnClientEvent:Connect(function(p1, p2, p3, p4) --[[ Line: 221 | Upvalues: v1 (ref), t2 (ref), t (ref) ]]
		local v12 = v1[p1]
		if v12 then
			v12:OnPurchased(p2, p3, p4)
		end
		t2.Purchased:Fire(p1, p2, p3, p4)
		local v2 = t.Purchased[p1]
		if v2 then
			v2:Fire(p2, p3, p4)
		end
	end)
end)
return t3