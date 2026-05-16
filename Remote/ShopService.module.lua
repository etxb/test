-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.ShopService

-- https://lua.expert/
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Constant = require(ReplicatedStorage.Constant)
local ShopConfig = require(ReplicatedStorage.Config.ShopConfig)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local RewardHelper = require(ReplicatedStorage.Common.RewardHelper)
require(ReplicatedStorage.Remote.ABTest)
local StatusService = require(ReplicatedStorage.Remote.StatusService)
local LocalShoppingDataStore = require(script.LocalShoppingDataStore)
local t = {
	DataInited = SimpleSignal.new()
}
local t2 = {
	Inited = false,
	Event = t,
	LocalShoppingDataStore = LocalShoppingDataStore,
	GetPurchased = function(p1) --[[ GetPurchased | Line: 33 ]] end
}
local v1 = nil
function t2.ParseProductName(p1) --[[ ParseProductName | Line: 39 | Upvalues: v1 (ref), ReplicatedStorage (copy) ]]
	if not v1 then
		v1 = {}
		local LimitedCaseEvent = ReplicatedStorage.Config.Event:FindFirstChild("LimitedCaseEvent")
		if LimitedCaseEvent then
			v1[require(LimitedCaseEvent).Gacha] = "LimitedCase"
		end
		local LimitedCase2Event = ReplicatedStorage.Config.Event:FindFirstChild("LimitedCase2Event")
		if LimitedCase2Event then
			v1[require(LimitedCase2Event).Gacha] = "LimitedCase2"
		end
		local LimitedCase3Event = ReplicatedStorage.Config.Event:FindFirstChild("LimitedCase3Event")
		if LimitedCase3Event then
			v1[require(LimitedCase3Event).Gacha] = "LimitedCase3"
		end
		local LimitedCase4Event = ReplicatedStorage.Config.Event:FindFirstChild("LimitedCase4Event")
		if LimitedCase4Event then
			v1[require(LimitedCase4Event).Gacha] = "LimitedCase4"
		end
		local LimitedBundleEvent = ReplicatedStorage.Config.Event:FindFirstChild("LimitedBundleEvent")
		if LimitedBundleEvent then
			local v12 = require(LimitedBundleEvent)
			v1[v12.LimitedProduct.Standard] = v12.Product.Standard
			v1[v12.LimitedProduct.ST] = v12.Product.ST
		end
	end
	return v1[p1] or p1
end
local t3 = {}
local t4 = {}
function t2.RegisterPriceProvider(p1, p2) --[[ RegisterPriceProvider | Line: 80 | Upvalues: t3 (copy), t4 (copy) ]]
	t3[p1] = p2
	local v1 = t4[p1]
	if v1 then
		v1:Fire(p2)
	end
end
function t2.GetPriceFromProvider(p1, p2, p3) --[[ GetPriceFromProvider | Line: 88 | Upvalues: t3 (copy), t4 (copy), SimpleSignal (copy) ]]
	local v1 = t3[p1]
	if v1 or p3 then
		if not v1 then
			local v2 = t4[p1]
			if not v2 then
				local v3 = SimpleSignal.new()
				t4[p1] = v3
				v2 = v3
			end
			v1 = v2:Wait()
		end
		return v1(p2)
	end
end
function t2.Purchase(p1, p2) --[[ Purchase | Line: 104 | Upvalues: t2 (copy), ShopConfig (copy), Constant (copy), RunService (copy), MarketplaceService (copy), LocalPlayer (copy), ReplicatedStorage (copy), LocalShoppingDataStore (copy), StatusService (copy), ResultUtils (copy) ]]
	local v1 = 1
	local v2 = t2.ParseProductName(p1)
	local v3 = ShopConfig.GetProductConfig(v2)
	if v3 then
		local Price = v3.Price
		if not Price and Price.PriceProvider then
			Price = t2.GetPriceFromProvider(Price.PriceProvider, v3.Reward)
		end
		if Price and LocalShoppingDataStore:CanPurchase(v2, v1) then
			local Eco = Price.Eco
			if Eco ~= Constant.Robux then
				local v5 = Price.Value * v1
				if not StatusService.Has(Eco, v5) then
					return ResultUtils.ecoNotEnough(Eco, v5)
				end
			end
			local v6 = if Eco == Constant.Robux then Constant.GamePassId[v2] else false
			if v6 then
				local v7, v8 = pcall(function() --[[ Line: 152 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), v6 (copy) ]]
					return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, v6)
				end)
				if v7 and v8 then
					ReplicatedStorage.Remote.Any.VerifyGamePass:FireServer(v6)
					return
				end
			end
			local v9, v10 = pcall(function() --[[ Line: 161 | Upvalues: v2 (ref), v1 (ref) ]]
				return script.Purchase:InvokeServer(v2, v1)
			end)
			if v9 and (v10 and Eco == Constant.Robux) then
				return false
			elseif v9 and v10 then
				return ResultUtils.success(v3.Message)
			else
				return ResultUtils.error(v10)
			end
		end
	elseif Constant.Product[v2] then
		if RunService:IsStudio() then
			warn(("missing shop config: %s, but found in rbx product, prompt purchase..."):format(v2))
		end
		local v11 = Constant.ProductId[v2]
		if v11 and v11 > 0 then
			MarketplaceService:PromptProductPurchase(LocalPlayer, v11)
		else
			ReplicatedStorage.Remote.Any.Purchase:InvokeServer(v2)
		end
	else
		warn("unknown shop product", v2)
	end
end
function t2.Gift(p1, p2) --[[ Gift | Line: 176 | Upvalues: ResultUtils (copy), Constant (copy) ]]
	local v1, v2, v3 = pcall(function() --[[ Line: 177 | Upvalues: p1 (copy), p2 (copy) ]]
		return script.Gift:InvokeServer(p1, p2)
	end)
	if v1 then
		if v2 == -1 then
			return ResultUtils.networkError()
		elseif v2 == -2 then
			return ResultUtils.failed(Constant.Message.Shop.GiftFailedRegionalPricing)
		elseif v2 == -3 then
			if v3 then
				return ResultUtils.failed(Constant.Message.Shop.GiftFailedWithMessage:format(v3))
			else
				return ResultUtils.failed(Constant.Message.Shop.GiftFailed)
			end
		else
			return if v2 then ResultUtils.success() else v2
		end
	else
		return ResultUtils.error(v2)
	end
end
function t2.WaitInit() --[[ WaitInit | Line: 200 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 207 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 215 | Upvalues: LocalShoppingDataStore (copy), t2 (copy), t (copy) ]]
	if LocalShoppingDataStore.Data or not p2 then
		local _ = LocalShoppingDataStore.Data
	else
		LocalShoppingDataStore.Data = p1
		t2.Inited = true
		t.DataInited:Fire()
	end
end)
RewardHelper.RegisterUnwraper("ShopProduct", function(p1) --[[ Line: 227 | Upvalues: ShopConfig (copy) ]]
	local v1 = ShopConfig[p1.Product]
	if v1 then
		return v1.Reward
	end
end)
RewardHelper.RegisterValidater("ShopProduct", function(p1) --[[ Line: 234 | Upvalues: ShopConfig (copy) ]]
	return ShopConfig[p1.Product] and true
end)
return t2