-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.Config.Level

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Util.TableUtils)
return {
	Max = 200,
	Costs = require(script.LevelCost),
	GetCost = function(p1, p2) --[[ GetCost | Line: 8 ]]
		if p1.Max <= p2 then
		else
			return p1.Costs[p2]
		end
	end,
	GetCoinReward = function(p1, p2) --[[ GetCoinReward | Line: 15 ]]
		return (p2 - 1) * 5 + 50
	end,
	Cases = { "ReleaseCase", "StrikeCase" },
	GetCaseReward = function(p1, p2) --[[ GetCaseReward | Line: 22 ]]
		return p1.Cases[(p2 - 1) % #p1.Cases + 1]
	end
}