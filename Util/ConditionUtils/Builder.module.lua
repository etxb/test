-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.ConditionUtils.Builder

-- https://lua.expert/
local t = {}
t.__index = t
function t.new() --[[ new | Line: 6 | Upvalues: t (copy) ]]
	return setmetatable({}, t)
end
function t.type(p1, p2) --[[ type | Line: 10 ]]
	p1.ConditionType = p2
	return p1
end
function t.condition(p1, p2) --[[ condition | Line: 15 ]]
	p1.Condition = p2
	return p1
end
function t.setNot(p1, p2) --[[ setNot | Line: 20 ]]
	if p2 == false then
		p1.Not = nil
	else
		p1.Not = true
	end
	return p1
end
return t