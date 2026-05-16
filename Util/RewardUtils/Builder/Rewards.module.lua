-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.RewardUtils.Builder.Rewards

-- https://lua.expert/
local v1 = require(script.Parent)
local v2 = setmetatable({}, v1)
v2.__index = v2
function v2.new(p1) --[[ new | Line: 7 | Upvalues: v1 (copy) ]]
	return v1.new(p1):reward({})
end
function v2.reward(p1, p2) --[[ reward | Line: 11 ]]
	table.insert(p1.Reward, p2)
	return p1
end
function v2.addReward(p1, p2) --[[ addReward | Line: 16 ]]
	table.insert(p1.Reward, p2)
	return p1
end
return v2