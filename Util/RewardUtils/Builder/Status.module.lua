-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.RewardUtils.Builder.Status

-- https://lua.expert/
local v1 = require(script.Parent)
local v2 = setmetatable({}, v1)
v2.__index = v2
function v2.new(p1) --[[ new | Line: 7 | Upvalues: v1 (copy) ]]
	return v1.new(p1):type("Status"):reward({})
end
function v2.status(p1, p2, p3, p4) --[[ status | Line: 11 ]]
	p1.Reward.Status = p2
	if p3 then
		p1.Reward.Value = p3
	end
	if p4 then
		p1.Reward.Analytics = p4
		local TransType = p4.TransType
		if TransType and typeof(TransType) ~= "string" then
			local v1
			if typeof(TransType) == "EnumItem" then
				v1 = TransType.Name
			else
				warn("trans type error", TransType)
				v1 = tostring(TransType)
			end
			p4.TransType = v1
		end
	end
	return p1
end
function v2.value(p1, p2) --[[ value | Line: 34 ]]
	p1.Reward.Value = p2
	return p1
end
function v2.analytics(p1, p2) --[[ analytics | Line: 39 ]]
	p1.Reward.Analytics = p2
	return p1
end
return v2