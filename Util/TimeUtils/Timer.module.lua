-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.TimeUtils.Timer

-- https://lua.expert/
local t = {}
t.__index = t
function t.new(p1, p2) --[[ new | Line: 6 ]]
	return setmetatable({
		Fn = p2
	}, p1)
end
function t.tickOnRender(p1, p2) --[[ tickOnRender | Line: 10 ]]
	p1.tickOnRender = p2
	return p1
end
function t.delay(p1, p2) --[[ delay | Line: 15 ]]
	local tickOnRender = p1.tickOnRender
end
return t