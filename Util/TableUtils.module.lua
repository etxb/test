-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.TableUtils

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtil = require(ReplicatedStorage.Shared.RbxUtil.TableUtil)
local t = {
	PathGet = function(p1, p2) --[[ PathGet | Line: 7 ]]
		if typeof(p2) == "string" then
			p2 = p2:split(".")
		end
		local v2 = p1
		for v3, v4 in p2 do
			v2 = v2[v4]
			if not v2 or typeof(v2) ~= "table" then
				break
			end
		end
		return v2
	end,
	PathSet = function(p1, p2, p3) --[[ PathSet | Line: 21 ]]
		if typeof(p2) == "string" then
			p2 = p2:split(".")
		end
		local v2 = p1
		for v3, v4 in p2 do
			if v3 == #p2 then
				v2[v4] = p3
				return
			end
			local v5 = v2[v4]
			if v5 == nil then
				v5 = {}
				v2[v4] = v5
			end
			if typeof(v5) ~= "table" then
				break
			end
			v2 = v5
		end
	end
}
local t2 = {
	__index = function() --[[ __index | Line: 44 ]]
		return 0
	end
}
function t.ZeroDefault(p1) --[[ ZeroDefault | Line: 48 | Upvalues: t2 (copy) ]]
	return setmetatable(if p1 then p1 else {}, t2)
end
function t.TwoDimZeroDefault(p1) --[[ TwoDimZeroDefault | Line: 52 | Upvalues: t2 (copy) ]]
	local t = {
		__index = function(p1, p2) --[[ __index | Line: 54 | Upvalues: t2 (ref) ]]
			p1[p2] = setmetatable({}, t2)
			return p1[p2]
		end
	}
	return setmetatable(if p1 then p1 else {}, t)
end
local t3 = {
	__index = function(p1, p2) --[[ __index | Line: 62 ]]
		if p2 == nil then
		else
			local t = {}
			p1[p2] = t
			return t
		end
	end
}
function t.AutoTable(p1, p2) --[[ AutoTable | Line: 71 | Upvalues: t3 (copy) ]]
	if p2 then
		return setmetatable(if p1 then p1 else {}, {
			__index = function(p1, p22) --[[ __index | Line: 74 | Upvalues: p2 (copy) ]]
				if p22 == nil then
				else
					local v1 = p2(p22, p1)
					p1[p22] = v1
					return v1
				end
			end
		})
	else
		return setmetatable(if p1 then p1 else {}, t3)
	end
end
local t4 = {
	__index = function(p1, p2) --[[ __index | Line: 88 | Upvalues: t (copy) ]]
		local v1 = t.AutoTable()
		p1[p2] = v1
		return v1
	end
}
function t.AutoTable2(p1) --[[ AutoTable2 | Line: 94 | Upvalues: t4 (copy) ]]
	return setmetatable(if p1 then p1 else {}, t4)
end
local t5 = {
	__index = function(p1, p2) --[[ __index | Line: 99 ]]
		if typeof(p2) == "number" and #p1 ~= 0 then
			if p2 < 0 then
				p2 = p2 + (#p1 + 1)
			end
			return p1[math.clamp(p2, 1, #p1)]
		elseif p2 == nil then
			return p1[1]
		end
	end
}
function t.BetterIndex(p1) --[[ BetterIndex | Line: 112 | Upvalues: t5 (copy) ]]
	return p1 and setmetatable(p1, t5)
end
local t6 = {
	__index = function(p1, p2) --[[ __index | Line: 117 | Upvalues: t (copy) ]]
		if typeof(p2) == "string" and p2:find("%.") then
			return t.PathGet(p1, p2)
		end
	end,
	__newindex = function(p1, p2, p3) --[[ __newindex | Line: 124 | Upvalues: t (copy) ]]
		if typeof(p2) == "string" and p2:find("%.") then
			t.PathSet(p1, p2, p3)
		else
			rawset(p1, p2, p3)
		end
	end
}
function t.PathTable(p1) --[[ PathTable | Line: 132 | Upvalues: t6 (copy) ]]
	return setmetatable(if p1 then p1 else {}, t6)
end
local function wrapTableToFunction(p1) --[[ wrapTableToFunction | Line: 136 ]]
	return setmetatable({}, {
		__index = function(p12, p2) --[[ __index | Line: 137 | Upvalues: p1 (copy) ]]
			return p1[p2]
		end
	})
end
function t.CombineIndex(p1, ...) --[[ CombineIndex | Line: 142 | Upvalues: wrapTableToFunction (copy) ]]
	local t = {}
	for v1, v2 in { ... } do
		if typeof(v2) == "table" then
			v2 = wrapTableToFunction(v2)
		end
		table.insert(t, v2)
	end
	return function(p1, p2) --[[ Line: 151 | Upvalues: t (copy) ]]
		for v1, v2 in t do
			local v3 = v2(p2)
			if v3 then
				return v3
			end
		end
	end
end
local t7 = {
	__index = table
}
function t.WithFunc(p1) --[[ WithFunc | Line: 165 | Upvalues: t7 (copy) ]]
	return setmetatable(if p1 then p1 else {}, t7)
end
local function treeNext(p1, p2) --[[ treeNext | Line: 170 ]]
	local t = {}
	local t2 = {}
	local v1 = nil
	for i = 1, p2 do
		local v2 = if i == 1 then p1 else t[i - 1]
		if not v2 then
			break
		end
		local v3, v4 = next(v2)
		t2[i] = v3
		t[i] = v4
		if t2[i] == "_key" then
			local v5, v6 = next(v2, t2[i])
			t2[i] = v5
			t[i] = v6
		end
		if i == p2 then
			v1 = t[i]
		end
	end
	local function v7(p12) --[[ nextNode | Line: 189 | Upvalues: p2 (copy), t2 (copy), t (copy), p1 (copy), v7 (copy), v1 (ref) ]]
		if not p12 then
			p12 = p2
		end
		local _2 = t[p12]
		local v3, v4 = next(if p12 == 1 then p1 else t[p12 - 1], t2[p12])
		local v5, v6
		v5 = v3
		if not v3 and p12 > 1 then
			while not v5 do
				local v72, v8 = v7(p12 - 1)
				_ = v72
				if not v8 then
					break
				end
				local v9, v10 = next(v8, v5)
				v5, v6 = v9, v10
			end
		end
		t2[p12] = v5
		t[p12] = v6
		if p12 == p2 then
			v1 = v6
		end
		return v5, v6
	end
	local function v8(p1, p2) --[[ nextElement | Line: 226 | Upvalues: v1 (ref), v7 (copy), v8 (copy) ]]
		if v1 then
			local v12, v2 = next(v1, p2)
			if v12 then
				return v12, v2
			else
				v7()
				return v8()
			end
		else
			return nil
		end
	end
	return v8
end
function t.TreeMap(p1, p2) --[[ TreeMap | Line: 249 | Upvalues: treeNext (copy) ]]
	local function findNode(p1, p22) --[[ findNode | Line: 252 | Upvalues: p2 (copy) ]]
		if typeof(p22) == "string" and not (#p22 <= p2) then
			p22:sub(p2, p2)
		end
	end
	local t = {
		__iter = function(p1) --[[ __iter | Line: 261 | Upvalues: treeNext (ref), p2 (copy) ]]
			return treeNext(p1, p2), p1
		end,
		__index = function(p1, p22) --[[ __index | Line: 264 | Upvalues: p2 (copy) ]]
			if typeof(p22) == "string" and not (#p22 <= p2) then
				p22:sub(p2, p2)
			end
			local v1 = nil
			if v1 then
				return v1[p22]
			else
				return nil
			end
		end,
		__newindex = function(p1, p22, p3) --[[ __newindex | Line: 271 | Upvalues: p2 (copy) ]]
			if typeof(p22) == "string" and not (#p22 <= p2) then
				p22:sub(p2, p2)
			end
			local v1 = nil
			if v1 then
				v1[p22] = p3
			end
		end
	}
	return setmetatable(if p1 then p1 else {}, t)
end
function t.Set(p1, p2, p3) --[[ Set | Line: 282 ]]
	local v1 = p1[p2]
	p1[p2] = p3
	return v1
end
function t.Remove(p1, p2) --[[ Remove | Line: 288 | Upvalues: t (copy) ]]
	return t.Set(p1, p2, nil)
end
local t8 = {
	OnAdded = function(p1, p2, p3) --[[ OnAdded | Line: 293 ]] end,
	OnRemoved = function(p1, p2, p3) --[[ OnRemoved | Line: 296 ]] end
}
local function clearDict(p1) --[[ clearDict | Line: 301 ]]
	table.clear(p1._items)
	p1._count = 0
end
local t9 = {
	__index = function(p1, p2) --[[ __index | Line: 308 | Upvalues: clearDict (copy) ]]
		if p2 == "_keys" then
			local t = {}
			for v1, v2 in p1._items do
				table.insert(t, v1)
			end
			rawset(p1, p2, t)
			return t
		elseif p2 == "clear" then
			return clearDict
		else
			return p1._items[p2]
		end
	end,
	__newindex = function(p1, p2, p3) --[[ __newindex | Line: 322 | Upvalues: t8 (copy) ]]
		if t8[p2] then
			rawset(p1, p2, p3)
		else
			local _items = p1._items
			local v1 = _items[p2]
			_items[p2] = p3
			if v1 == nil and p3 ~= nil then
				p1._count = p1._count + 1
				if p1.OnAdded then
					p1.OnAdded(p1, p2, p3)
				end
				local v2 = rawget(p1, "_keys")
				if v2 then
					table.insert(v2, p2)
				end
			else
				if v1 == nil or p3 ~= nil then
					return
				end
				p1._count = p1._count - 1
				if p1.OnRemoved then
					p1.OnRemoved(p1, p2, v1)
				end
				rawset(p1, "_keys", nil)
			end
		end
	end,
	__iter = function(p1) --[[ __iter | Line: 350 ]]
		return next, p1._items
	end,
	__len = function(p1) --[[ __len | Line: 353 ]]
		return p1._count
	end
}
function t.NewDict() --[[ NewDict | Line: 358 | Upvalues: t9 (copy) ]]
	return setmetatable({
		_count = 0,
		OnAdded = false,
		OnRemoved = false,
		_items = {}
	}, t9)
end
function t.NewQueue() --[[ NewQueue | Line: 369 ]] end
function t.NewStack() --[[ NewStack | Line: 373 ]] end
function t.ForEach(p1, p2, p3) --[[ ForEach | Line: 377 ]]
	for v1, v2 in p1 do
		if not p3 or p3(v2) then
			p2(v1, v2)
		end
	end
end
function t.Map(p1, p2) --[[ Map | Line: 385 ]]
	local t = {}
	for v1, v2 in p1 do
		t[v1] = p2(v2)
	end
	return t
end
function t.Merge(p1, p2) --[[ Merge | Line: 393 | Upvalues: t (copy) ]]
	local t2 = {}
	for v1, v2 in p2 do
		if typeof(p1[v1]) == "table" then
			if typeof(p1[v2]) == "table" then
				local _, v5 = t.Merge(p1[v1], v2)
				t2[v1] = v5
			end
			continue
		end
		local v6 = p1[v1]
		p1[v1] = v2
		if typeof(v2) == "number" then
			t2[v1] = v2 - (v6 or 0)
		end
		t2[v1] = v2
	end
	return p1
end
function t.Same(p1, p2) --[[ Same | Line: 413 ]]
	if #p1 == #p2 then
		for v1, v2 in p1 do
			if p1[v1] ~= p2[v1] then
				return false
			end
		end
		for v3, v4 in p2 do
			if p2[v3] ~= p1[v3] then
				return false
			end
		end
		return true
	else
		return false
	end
end
function t.Bid(p1, p2) --[[ Bid | Line: 430 ]]
	if p2 then
		local t = {}
		for v1, v2 in p1 do
			t[v2] = v1
		end
		t.__index = t
		setmetatable(p1, t)
	else
		for v3, v4 in table.clone(p1) do
			p1[v4] = v3
		end
	end
	return p1
end
t.Array = {
	InstancesToDict = function(p1) --[[ InstancesToDict | Line: 448 ]]
		local t = {}
		for i = 1, #p1 do
			local v1 = p1[i]
			t[v1.Name] = v1
		end
		return t
	end,
	Shuffle = function(p1) --[[ Shuffle | Line: 457 ]]
		if not (#p1 < 2) and #p1 == 2 then
			if math.random() > 0.5 then
				local v2 = p1[1]
				p1[1] = p1[2]
				p1[2] = v2
			end
		elseif not (#p1 < 2) then
			for i = #p1, 3, -1 do
				local v3 = math.random(i - 1)
				local v5 = p1[i]
				p1[i] = p1[v3]
				p1[v3] = v5
			end
		end
		return p1
	end,
	Filter = function(p1, p2) --[[ Filter | Line: 474 ]]
		for i = #p1, 1, -1 do
			if not p2(p1[i]) then
				table.remove(p1, i)
			end
		end
		return p1
	end,
	AddAll = function(p1, ...) --[[ AddAll | Line: 483 ]]
		for v1, v2 in { ... } do
			table.insert(p1, v2)
		end
		return p1
	end,
	Random = function(p1) --[[ Random | Line: 491 ]]
		if #p1 == 0 then
			return nil
		else
			return p1[math.random(#p1)]
		end
	end
}
function t.SwapKV(p1) --[[ SwapKV | Line: 501 ]]
	local t = {}
	for v1, v2 in p1 do
		t[v2] = v1
	end
	return t
end
local t10 = {}
setmetatable(t10, {
	__newindex = function(p1, p2, p3) --[[ __newindex | Line: 510 ]]
		warn("table not allow new index!", p2, "->", p3)
	end
})
t.EMPTY = t10
function t.OrEmpty(p1, p2) --[[ OrEmpty | Line: 515 | Upvalues: t10 (copy) ]]
	if p1 == false then
		return p1
	elseif p1 == t10 and p2 then
		return {}
	else
		return if p1 then p1 else p2 and {} or t10
	end
end
function t.empty() --[[ empty | Line: 525 | Upvalues: t10 (copy) ]]
	return t10
end
function t.new() --[[ new | Line: 529 ]]
	return {}
end
function t.IsEmpty(p1) --[[ IsEmpty | Line: 533 ]]
	return if p1 then not next(p1) and true else true
end
function t.ContainsKeys(p1, p2) --[[ ContainsKeys | Line: 537 ]]
	for v1, v2 in p2 do
		if not p1[v2] then
			return false
		end
	end
	return true
end
function t.ContainsKeysAny(p1, p2) --[[ ContainsKeysAny | Line: 546 ]]
	for v1, v2 in p2 do
		if p1[v2] then
			return true
		end
	end
	return false
end
local v1 = newproxy(true)
getmetatable(v1).__tostring = function() --[[ Line: 556 ]]
	return "warpped_get"
end
function t.WrapGet(p1, p2) --[[ WrapGet | Line: 559 | Upvalues: v1 (copy) ]]
	local v2 = p1 or {}
	local t = {}
	local t2 = {
		[v1] = true,
		GetOrCreate = function(p1) --[[ GetOrCreate | Line: 566 | Upvalues: v2 (ref), p2 (copy), t (copy) ]]
			local v1 = v2[p1]
			if not v1 then
				local v22 = p2(p1, v2)
				v2[p1] = v22
				v1 = v22
				for v3, v4 in t do
					v4(p1, v22)
				end
			end
			return v1
		end
	}
	t2.get = t2.GetOrCreate
	function t2.OnAdded(p1) --[[ OnAdded | Line: 579 | Upvalues: t (copy) ]]
		table.insert(t, p1)
	end
	local v3 = v2
	return setmetatable(v3, {
		__index = t2
	})
end
function t.IsWrappedGet(p1) --[[ IsWrappedGet | Line: 588 | Upvalues: v1 (copy) ]]
	return p1[v1] and p1
end
function t.Extends(p1, p2) --[[ Extends | Line: 592 | Upvalues: t (copy) ]]
	for v1, v2 in p1 do
		local v3 = rawget(p2, v1)
		if typeof(v2) == "table" and (typeof(v3) == "table" and not getmetatable(v2)) then
			t.Extends(v2, v3)
		end
	end
	setmetatable(p1, {
		__index = p2
	})
	return p1
end
function t.Protect(p1) --[[ Protect | Line: 603 ]]
	local t = {}
	local t2 = {
		__index = function(p12, p2) --[[ __index | Line: 606 | Upvalues: p1 (copy), t (copy) ]]
			return p1[p2] or t[p2]
		end,
		__newindex = function(p1, p2, p3) --[[ __newindex | Line: 609 | Upvalues: t (copy) ]]
			t[p2] = p3
		end
	}
	local v1 = table.freeze((setmetatable({}, t2)))
	t2.__metatable = "protected"
	return v1
end
function t.TypeFilter(p1, p2) --[[ TypeFilter | Line: 618 ]]
	for v1, v2 in p1 do
		local v3 = p2[v1]
		if not v3 or typeof(v2) ~= v3 and (typeof(v3) ~= "function" or not v3(v2)) then
			p1[v1] = nil
		end
	end
	return p1
end
function t.StringConstant(p1) --[[ StringConstant | Line: 628 ]]
	for v1, v2 in p1 do
		if typeof(v2) == "string" and #v2 == 0 then
			p1[v1] = v1
		end
	end
	return p1
end
function t.ToArray(p1) --[[ ToArray | Line: 657 ]]
	local t = {}
	for v1, v2 in p1 do
		table.insert(t, v2)
	end
	return t
end
function t.Reconcile(p1, p2, p3) --[[ Reconcile | Line: 665 | Upvalues: TableUtil (copy), t (copy) ]]
	local v1 = if p3 then TableUtil.Copy(p1, true) else p1
	for v3, v4 in p2 do
		local v5 = p1[v3]
		if v5 == nil then
			if typeof(v4) == "table" then
				v1[v3] = TableUtil.Copy(v4, true)
			end
			v1[v3] = v4
		end
		if typeof(v5) == "table" then
			if typeof(v4) == "table" then
				v1[v3] = t.Reconcile(v5, v4, p3)
			end
			if p3 then
				v1[v3] = TableUtil.Copy(v5, true)
			end
			v1[v3] = v5
		end
	end
	return v1
end
t.StringConstantDefiner = require(script.StringConstantDefiner)
return t.Protect(t)