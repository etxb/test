-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.ShopConfig.Gacha

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
local GachaConfig = require(ReplicatedStorage.Config.GachaConfig)
local RewardUtils = require(ReplicatedStorage.Util.RewardUtils)
local t = {}
local t2 = { 1, 3, 10 }
local function createGachaProdcut(p1, p2, p3, p4) --[[ createGachaProdcut | Line: 17 | Upvalues: t2 (copy), GachaConfig (copy), Constant (copy), RunService (copy), RewardUtils (copy), t (copy) ]]
	local v1 = if p4 then p4 else {}
	local v2 = v1.Custom or {}
	local v3 = v1.PurchaseCount or t2
	local v4
	if typeof(p1) == "table" then
		v4 = p1.Product
		p1 = p1.Gacha
	else
		v4 = nil
	end
	if not v4 then
		v4 = p1
	end
	local v5 = GachaConfig[p1]
	if v5 and (p2 or p3) then
		v6 = v1
		v7 = {}
		for v9, v10 in v3 do
			local v8
			local v11 = if v10 < 1 then true else false
			local v12 = math.abs(v10)
			local v13 = ("%s_x%d"):format(v4, v12)
			local v14 = v5.Display or p1
			if v12 > 1 then
				v14, v8 = ("%s x%d"):format(v14, v12), v12
			else
				v8 = v12
			end
			if p3 == Constant.Robux and not Constant.Product[v13] then
				if RunService:IsStudio() then
					warn("\230\156\170\229\136\155\229\187\186\230\138\189\229\165\150\228\186\167\229\147\129", v13)
				end
				continue
			end
			local t3 = {
				Display = v14
			}
			t3.Reward = v2[v9] or RewardUtils.gacha(p1, v8)
			local t4 = {}
			t4.Eco = if p3 then p3 else Constant.Status.Eco_Coin
			t4.Value = p2 and p2 * v8 or v6.Price and v6.Price[v9]
			t3.Price = t4
			t3.Count = v8
			t3.Deprecate = v6.Deprecate or v11
			t[v13] = t3
			if not v11 then
				table.insert(v7, t3)
			end
		end
		if #v7 == 0 then
		else
			local t3 = {
				ProductGroup = true,
				Reward = RewardUtils.gacha(p1),
				List = v7
			}
			t[v4] = t3
			return t3
		end
	end
end
createGachaProdcut("ReleaseCase", 1000)
createGachaProdcut("StrikeCase", 1000)
createGachaProdcut({
	Product = "ReleaseCase_Premium",
	Gacha = "ReleaseCase_Premium"
}, 19800)
createGachaProdcut({
	Product = "ReleaseCase_Mystic",
	Gacha = "ReleaseCase_Mystic"
}, 56800)
createGachaProdcut({
	Product = "StrikeCase_Premium",
	Gacha = "StrikeCase_Premium"
}, 19800)
createGachaProdcut({
	Product = "StrikeCase_Mystic",
	Gacha = "StrikeCase_Mystic"
}, 56800)
createGachaProdcut("SecretCase", nil, Constant.Robux, {
	PurchaseCount = { 1, 3, 10, -23 },
	Custom = {
		nil,
		nil,
		RewardUtils.all(RewardUtils.gacha("SecretCase", 10), RewardUtils.gacha("SecretCase_Guaranteed")),
		RewardUtils.all(RewardUtils.gacha("SecretCase", 22), RewardUtils.gacha("SecretCase_Guaranteed"))
	}
})
createGachaProdcut({
	Product = "SecretCase_TradeToken",
	Gacha = "SecretCase"
}, nil, Constant.Status.Eco_TradeToken, {
	PurchaseCount = { 1, 3, 10, -23 },
	Price = { 2490, 7450, 24790, 49500 },
	Custom = {
		nil,
		nil,
		RewardUtils.all(RewardUtils.gacha("SecretCase", 10), RewardUtils.gacha("SecretCase_Guaranteed")),
		RewardUtils.all(RewardUtils.gacha("SecretCase", 22), RewardUtils.gacha("SecretCase_Guaranteed"))
	}
})
local LimitedCaseEvent = ReplicatedStorage.Config.Event:FindFirstChild("LimitedCaseEvent")
if LimitedCaseEvent then
	local v1 = require(LimitedCaseEvent)
	local v2 = v1.StartTime or 0
	local v3 = v1.Timeout or 0
	local v4 = createGachaProdcut({
		Product = "LimitedCase",
		Gacha = v1.Gacha
	}, nil, Constant.Robux)
	v4.StartTime = v2
	v4.Timeout = v3
	for v5, v6 in v4.List do
		v6.StartTime = v2
		v6.Timeout = v3
	end
	local v7 = createGachaProdcut({
		Product = "LimitedCase_TradeToken",
		Gacha = v1.Gacha
	}, nil, Constant.Status.Eco_TradeToken, {
		Price = { 990, 2970, 9900 }
	})
	v7.StartTime = v2
	v7.Timeout = v3
	for v8, v9 in v4.List do
		v9.StartTime = v2
		v9.Timeout = v3
	end
end
local LimitedCase2Event = ReplicatedStorage.Config.Event:FindFirstChild("LimitedCase2Event")
if LimitedCase2Event then
	local v10 = require(LimitedCase2Event)
	local v11 = v10.StartTime or 0
	local v12 = v10.Timeout or 0
	local v13 = createGachaProdcut({
		Product = "LimitedCase2",
		Gacha = v10.Gacha
	}, nil, Constant.Robux)
	v13.StartTime = v11
	v13.Timeout = v12
	for v14, v15 in v13.List do
		v15.StartTime = v11
		v15.Timeout = v12
	end
	local v16 = createGachaProdcut({
		Product = "LimitedCase2_TradeToken",
		Gacha = v10.Gacha
	}, nil, Constant.Status.Eco_TradeToken, {
		Price = { 990, 2970, 9900 }
	})
	v16.StartTime = v11
	v16.Timeout = v12
	for v17, v18 in v13.List do
		v18.StartTime = v11
		v18.Timeout = v12
	end
end
local LimitedCase3Event = ReplicatedStorage.Config.Event:FindFirstChild("LimitedCase3Event")
if LimitedCase3Event then
	local v19 = require(LimitedCase3Event)
	local v20 = v19.StartTime or 0
	local v21 = v19.Timeout or 0
	local v22 = createGachaProdcut({
		Product = "LimitedCase3",
		Gacha = v19.Gacha
	}, nil, Constant.Robux)
	v22.StartTime = v20
	v22.Timeout = v21
	for v23, v24 in v22.List do
		v24.StartTime = v20
		v24.Timeout = v21
	end
	local v25 = createGachaProdcut({
		Product = "LimitedCase3_TradeToken",
		Gacha = v19.Gacha
	}, nil, Constant.Status.Eco_TradeToken, {
		Price = { 990, 2970, 9900 }
	})
	v25.StartTime = v20
	v25.Timeout = v21
	for v26, v27 in v22.List do
		v27.StartTime = v20
		v27.Timeout = v21
	end
end
local LimitedCase4Event = ReplicatedStorage.Config.Event:FindFirstChild("LimitedCase4Event")
if LimitedCase4Event then
	local v28 = require(LimitedCase4Event)
	local v29 = v28.StartTime or 0
	local v30 = v28.Timeout or 0
	local v31 = createGachaProdcut({
		Product = "LimitedCase4",
		Gacha = v28.Gacha
	}, nil, Constant.Robux)
	v31.StartTime = v29
	v31.Timeout = v30
	for v32, v33 in v31.List do
		v33.StartTime = v29
		v33.Timeout = v30
	end
	local v34 = createGachaProdcut({
		Product = "LimitedCase4_TradeToken",
		Gacha = v28.Gacha
	}, nil, Constant.Status.Eco_TradeToken, {
		Price = { 990, 2970, 9900 }
	})
	v34.StartTime = v29
	v34.Timeout = v30
	for v35, v36 in v31.List do
		v36.StartTime = v29
		v36.Timeout = v30
	end
end
return t