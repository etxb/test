-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.PrioritySelector

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local t = {
	Value = nil,
	Changed = nil
}
t.__index = t
function t.new() --[[ new | Line: 13 | Upvalues: SimpleSignal (copy), t (copy) ]]
	return setmetatable({
		values = {},
		Changed = SimpleSignal.new()
	}, t)
end
function t.Update(p1) --[[ Update | Line: 21 ]]
	local v1 = nil
	for v2, v3 in p1.values do
		if not v1 or v3.Priority > v1.Priority then
			v1 = v3
		end
	end
	p1.Value = v1
	p1.Changed:Fire()
end
function t.Set(p1, p2, p3, p4) --[[ Set | Line: 32 ]]
	p1.values[p2] = p3 and {
		Name = p2,
		Priority = p3,
		Data = p4
	} or nil
	if (not p3 or p1.Value and not (p1.Value.Priority < p3)) and (p3 or (not p1.Value or p1.Value.Name ~= p2)) then
		return
	end
	p1:Update()
end
function t.Remove(p1, p2) --[[ Remove | Line: 39 ]]
	p1:Set(p2)
end
return t