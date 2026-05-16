-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.PlayerMarketService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local StallSkinConfig = require(ReplicatedStorage.Config.StallSkinConfig)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local StatusService = require(ReplicatedStorage.Remote.StatusService)
local LocalPlayerMarketStore = require(script.LocalPlayerMarketStore)
local t = {}
local t2 = {
	MarketChanged = SimpleSignal.new(),
	DataInited = SimpleSignal.new(),
	ListingsLoaded = SimpleSignal.new()
}
local t3 = {
	Inited = false,
	Event = t2,
	LocalPlayerMarketStore = LocalPlayerMarketStore
}
function t3.WaitInit() --[[ WaitInit | Line: 35 | Upvalues: t3 (copy), t2 (copy) ]]
	if not t3.Inited then
		t2.DataInited:Wait()
	end
	return t3
end
function t3.OnInit(p1) --[[ OnInit | Line: 42 | Upvalues: t3 (copy), t2 (copy) ]]
	if t3.Inited then
		p1()
	else
		t2.DataInited:Once(p1)
	end
end
local t4 = {}
function t3.SetProductHandler(p1, p2) --[[ SetProductHandler | Line: 52 | Upvalues: t4 (copy) ]]
	if t4[p1] then
		error("handler duplicated")
	end
	if not p2.Disabled then
		t4[p1] = p2
	end
end
function t3.Search(p1, p2) --[[ Search | Line: 69 | Upvalues: t4 (copy) ]]
	local v1 = t4[p1]
	if v1 and v1.OnSearch then
		return v1.OnSearch(p2)
	end
end
function t3.QueryData(p1) --[[ QueryData | Line: 76 | Upvalues: t4 (copy) ]]
	local v1 = t4[p1.Type]
	if v1 and v1.OnQuery then
		return v1.OnQuery(p1)
	end
end
function t3.LoadListed(p1) --[[ LoadListed | Line: 83 | Upvalues: LocalPlayerMarketStore (copy), t4 (copy), t2 (copy) ]]
	if not LocalPlayerMarketStore.Loaded and script.LoadListed:InvokeServer(p1) then
		LocalPlayerMarketStore.Loaded = true
		if p1 then
			local t = {}
			for v1, v2 in LocalPlayerMarketStore:GetListings() do
				local v3 = t4[v2.Type]
				if not (v3 and v3.OnListing(v2)) then
					table.insert(t, v1)
				end
			end
			for v4, v5 in t do
				LocalPlayerMarketStore:RemoveListing(v5)
			end
		else
			LocalPlayerMarketStore:ClearListing({
				Silent = true
			})
		end
		t2.ListingsLoaded:Fire()
	end
end
function t3.AddListing(p1, p2, p3) --[[ AddListing | Line: 110 | Upvalues: LocalPlayerMarketStore (copy), Config (copy), t4 (copy) ]]
	if LocalPlayerMarketStore:GetListingCount() >= Config.PlayerMarket.MaxListings then
	else
		local v1 = t4[p2]
		if v1 then
			if v1.OnListingPre and not v1.OnListingPre(p3) then
			else
				return script.AddListing:InvokeServer(p1, p2, p3)
			end
		end
	end
end
function t3.SetLock(p1, p2, p3) --[[ SetLock | Line: 126 | Upvalues: ResultUtils (copy) ]]
	if p1 then
		local v1, v2 = pcall(function() --[[ Line: 130 | Upvalues: p1 (copy), p2 (copy), p3 (copy) ]]
			return script.SetLock:InvokeServer(p1, p2, p3)
		end)
		if v1 then
			if v2 then
				return true
			end
		else
			return ResultUtils.error(v2)
		end
	end
end
function t3.SetPrice(p1, p2, p3) --[[ SetPrice | Line: 142 | Upvalues: Config (copy), ResultUtils (copy) ]]
	if p1 and (type(p2) == "number" and (p2 == p2 and (p2 == math.floor(p2) and not (p2 < Config.PlayerMarket.Price.Min or Config.PlayerMarket.Price.Max < p2)))) then
		local v1, v2 = pcall(function() --[[ Line: 149 | Upvalues: p1 (copy), p2 (copy), p3 (copy) ]]
			return script.SetPrice:InvokeServer(p1, p2, p3)
		end)
		if v1 then
			if v2 then
				return true
			end
		else
			return ResultUtils.error(v2)
		end
	end
end
function t3.PurchaseListing(p1, p2) --[[ PurchaseListing | Line: 162 | Upvalues: t (copy), StatusService (copy), Constant (copy), ResultUtils (copy), t4 (copy) ]]
	local v1 = t[p1]
	if v1 == true then
		v1 = nil
	end
	local v2 = if v1 then v1[p2] else v1
	if v2 then
		if StatusService.Has(Constant.Status.Eco_TradeToken, v2.Price) then
			local v3 = t4[v2.Type]
			if v3 then
				if v3.OnPurchasePre then
					local v4, v5 = v3.OnPurchasePre(p1, v2)
					if not v4 then
						if not v5 then
							v5 = "Purchase be blocked for some reason"
						end
						return ResultUtils.failed(v5)
					end
				end
				local v6, v7 = pcall(function() --[[ Line: 189 | Upvalues: p1 (copy), p2 (copy) ]]
					return script.Purchase:InvokeServer(p1, p2)
				end)
				if v6 then
					if v7 then
						return ResultUtils.success("Purchase Successfully")
					else
						return ResultUtils.failed("Purchase failed (Server Cancelled)")
					end
				else
					return ResultUtils.error(v7)
				end
			end
		else
			return ResultUtils.ecoNotEnough(Constant.Status.Eco_TradeToken, v2.Price)
		end
	end
end
function t3.QueryRecord(p1) --[[ QueryRecord | Line: 201 ]]
	if p1 then
		local v1 = script.QueryRecord:InvokeServer(p1)
		if p1.Parent and v1 then
			return v1
		end
	end
end
function t3.QueryLock(p1) --[[ QueryLock | Line: 216 | Upvalues: LocalPlayer (copy) ]]
	if p1 and p1 ~= LocalPlayer then
		local v1 = script.QueryLock:InvokeServer(p1)
		if p1.Parent and v1 then
			return v1
		end
	end
end
function t3.QueryListings(p1) --[[ QueryListings | Line: 232 | Upvalues: LocalPlayer (copy), t (copy) ]]
	if p1 and p1 ~= LocalPlayer then
		if t[p1] then
			return t[p1]
		else
			local v1 = script.Query:InvokeServer(p1)
			if p1.Parent and v1 then
				t[p1] = v1
				return v1
			end
		end
	end
end
function t3.SetSkin(p1) --[[ SetSkin | Line: 252 | Upvalues: StallSkinConfig (copy) ]]
	local _ = StallSkinConfig[p1]
	if p1 then
		return script.SetSkin:InvokeServer(p1)
	end
end
Players.PlayerRemoving:Connect(function(p1) --[[ Line: 260 | Upvalues: t (copy) ]]
	t[p1] = nil
end)
function t3.SearchIndex(p1, p2) --[[ SearchIndex | Line: 264 | Upvalues: LocalPlayer (copy) ]]
	if type(p1) == "string" and #p1 ~= 0 then
		local v1, v2 = pcall(function() --[[ Line: 268 | Upvalues: p1 (copy), p2 (copy) ]]
			return script.SearchIndex:InvokeServer(p1, p2)
		end)
		if v1 then
			if v2 and v2.SellerUserId == LocalPlayer.UserId then
				v2 = false
			end
			if v2 and v2.JobId == game.JobId then
				v2.JobId = nil
			end
			return v2
		else
			warn(v2)
		end
	end
end
function t3.Start() --[[ Start | Line: 284 | Upvalues: t (copy), t2 (copy), t3 (copy), LocalPlayerMarketStore (copy), t4 (copy) ]]
	script._Changed.OnClientEvent:Connect(function(p1, p2) --[[ Line: 285 | Upvalues: t (ref), t2 (ref) ]]
		if p1 and p1.Parent then
			t[p1] = nil
			t2.MarketChanged:Fire(p1, p2)
		end
	end)
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 292 | Upvalues: t3 (ref), LocalPlayerMarketStore (ref), t2 (ref) ]]
		if t3.Inited or not p2 then
			if t3.Inited then
				if p1.Add then
					for v1, v2 in p1.Add do
						LocalPlayerMarketStore:AddListing(v1, v2)
					end
				end
				if p1.Remove then
					for v3, v4 in p1.Remove do
						LocalPlayerMarketStore:RemoveListing(v4, {
							Remote = true
						})
					end
				end
				if p1.Update then
					LocalPlayerMarketStore:SetPrice(p1.Update[1], p1.Update[2])
				end
				if p1.AddSkin then
					LocalPlayerMarketStore:AddSkin(p1.AddSkin.Skin)
				end
				if p1.SetSkin then
					LocalPlayerMarketStore:SetSkin(p1.SetSkin.Skin)
				end
			end
		else
			LocalPlayerMarketStore:SetData(p1)
			if not t3.Inited then
				t3.Inited = true
				t2.DataInited:Fire()
			end
		end
	end)
	LocalPlayerMarketStore.Event.DataUpdated:ConnectEarly(function(p1, p2) --[[ Line: 326 | Upvalues: t4 (ref) ]]
		if p2.Add then
			for v1, v2 in p2.Add do
				local v3 = t4[v2.Type]
				if v3 and v3.OnListing then
					v3.OnListing(v2)
				end
			end
		end
		if p2.Remove then
			for v4, v5 in p2.Remove do
				local v6 = t4[v5.Type]
				if v6 and v6.OnListingRemove then
					v6.OnListingRemove(v5)
				end
			end
		end
	end)
end
return t3