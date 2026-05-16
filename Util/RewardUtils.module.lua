-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.RewardUtils

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local Builder = require(script.Builder)
require(script.Builder.Rewards)
local Status = require(script.Builder.Status)
local t = {
	builder = function() --[[ builder | Line: 11 | Upvalues: Status (copy) ]]
		return Status:new()
	end,
	status = function(p1, p2, p3) --[[ status | Line: 15 | Upvalues: Status (copy) ]]
		return Status:new():status(p1, p2, p3)
	end
}
function t.coin(p1, p2) --[[ coin | Line: 19 | Upvalues: t (copy), Constant (copy) ]]
	return t.status(Constant.Status.Eco_Coin, p1, p2)
end
function t.gem(p1, p2) --[[ gem | Line: 23 | Upvalues: t (copy), Constant (copy) ]]
	return t.status(Constant.Status.Eco_Gem, p1, p2)
end
function t.weapon(p1, p2, p3, p4) --[[ weapon | Line: 27 | Upvalues: Builder (copy) ]]
	if typeof(p2) == "number" and (p2 < 60 and p2 ~= -1) then
		warn(p2, debug.traceback())
		p2 = nil
	end
	return Builder:new():type("Weapon"):reward({
		Weapon = p1,
		Duration = p2,
		Boosted = p3,
		UniqueId = p4
	})
end
function t.gacha(p1, p2) --[[ gacha | Line: 39 | Upvalues: Builder (copy) ]]
	return Builder:new():type("Gacha"):reward({
		Gacha = p1,
		Count = p2
	})
end
function t.any(...) --[[ any | Line: 43 ]]
	return {
		RewardType = "Any",
		Reward = { ... }
	}
end
function t.all(...) --[[ all | Line: 47 ]]
	return {
		RewardType = "All",
		Reward = { ... }
	}
end
return t