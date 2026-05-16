-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.LoopedId

-- https://lua.expert/
local t = {}
t.__index = t
function t.new(p1, p2) --[[ new | Line: 4 | Upvalues: t (copy) ]]
	return setmetatable({
		Id = 0,
		IdLimit = p1 or 255,
		Grow = p2 or 2,
		Freed = {},
		Used = {}
	}, t)
end
function t.Request(p1) --[[ Request | Line: 15 ]]
	local Used = p1.Used
	if #Used == p1.IdLimit then
		if p1.IdLimit > 65536 then
			Used = {}
			p1.Used = Used
			p1.Id = 0
			warn("id limited out, force clear")
		else
			warn("id all used", p1.IdLimit, debug.traceback(1))
			p1.IdLimit = p1.IdLimit * p1.Grow
		end
	end
	local Id = p1.Id
	if Id == p1.IdLimit then
		Id = #Used
	end
	repeat
		Id = Id + 1
	until Used[Id]
	Used[Id] = true
	p1.Id = Id
	return Id
end
function t.Release(p1, p2) --[[ Release | Line: 40 ]]
	p1.Used[p2] = nil
end
return t