-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.RewardUtils.Builder

-- https://lua.expert/
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 7 ]]
	return setmetatable({}, p1)
end
function t.type(p1, p2) --[[ type | Line: 11 ]]
	p1.RewardType = p2
	return p1
end
function t.reward(p1, p2) --[[ reward | Line: 16 ]]
	p1.Reward = p2
	return p1
end
function t.weight(p1, p2) --[[ weight | Line: 21 ]]
	p1.Weight = p2
	return p1
end
function t.condition(p1, p2) --[[ condition | Line: 26 ]]
	p1.Condition = p2
	return p1
end
function t.setRewardData(p1, p2, p3) --[[ setRewardData | Line: 31 ]]
	p1.Reward[p2] = p3
	return p1
end
function t.setData(p1, p2, p3) --[[ setData | Line: 36 ]]
	p1[p2] = p3
	return p1
end
return t