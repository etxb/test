-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.TableUtils.StringConstantDefiner

-- https://lua.expert/
local t = {}
function t.new(p1, p2) --[[ new | Line: 6 | Upvalues: t (copy) ]]
	local v1 = 0
	local v2 = p2(function() --[[ Line: 8 | Upvalues: v1 (ref) ]]
		v1 = v1 + 1
		return v1
	end)
	local t2 = {}
	local t3 = {}
	for v3, v4 in v2 do
		t2[v4] = v3
		t3[v3] = v4
		v2[v3] = v3
	end
	local t4 = {
		__index = function(p1, p2) --[[ __index | Line: 21 | Upvalues: t2 (copy), t3 (copy), t (ref) ]]
			if p2 == "_ordered" then
				return t2
			elseif p2 == "_orderedReverse" then
				return t3
			else
				return t[p2]
			end
		end,
		__len = function() --[[ __len | Line: 30 | Upvalues: t2 (copy) ]]
			return #t2
		end
	}
	return setmetatable(v2, t4)
end
function t.ordered(p1) --[[ ordered | Line: 36 ]]
	return p1._ordered
end
function t.orderedReverse(p1) --[[ orderedReverse | Line: 40 ]]
	return p1._orderedReverse
end
function t.extends(p1, p2) --[[ extends | Line: 44 ]]
	local v1 = p1:ordered()
	local v2 = p1:orderedReverse()
	local v3 = #v1
	for v4, v5 in p2(function() --[[ Line: 49 | Upvalues: v3 (ref) ]]
		v3 = v3 + 1
		return v3
	end) do
		if v2[v4] then
			warn("string constant duplicated", v4)
		end
		v1[v5] = v4
		v2[v4] = v5
		p1[v4] = v4
	end
	return p1
end
function t.cloneAndExtends(p1, p2) --[[ cloneAndExtends | Line: 66 ]]
	return p1:clone():extends(p2)
end
function t.clone(p1) --[[ clone | Line: 70 | Upvalues: t (copy) ]]
	local v1 = table.clone(p1)
	local v2 = table.clone(p1:ordered())
	local v3 = table.clone(p1:orderedReverse())
	local t2 = {
		__index = function(p1, p2) --[[ __index | Line: 75 | Upvalues: v2 (copy), v3 (copy), t (ref) ]]
			if p2 == "_ordered" then
				return v2
			elseif p2 == "_orderedReverse" then
				return v3
			else
				return t[p2]
			end
		end,
		__length = function() --[[ __length | Line: 84 | Upvalues: v2 (copy) ]]
			return #v2
		end
	}
	return setmetatable(v1, t2)
end
return t